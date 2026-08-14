---
incident: ECR lifecycle policy evicted in-use image → ECS CannotPullContainerError
date: 2026-04-15
severity: Dev environment outage
status: Resolved
component: CloudForge `EcrRepository` component (consumed by Rituo app infra)
fix_commit: 6ced3e986c32e40096f21625544f0dceb9d4760c (CloudForge/main)
deploy_commit: 0c53b93 on rituo/infra (Dev Deployment #495)
source_doc: /Users/ali/Documents/flatout-solutions/rituo-org/ECR_LIFECYCLE_RCA.md
---

# Postmortem — ECR Lifecycle Eviction (2026-04-15)

A real production-class incident on Rituo's dev environment. Worth keeping in this skill because it's a **strong portfolio piece for root-cause analysis discipline** — Ali isn't just shipping features, he's documenting failure modes and fixing them at the library layer.

## TL;DR

- **What broke:** ECS service `app-api-alt-dev-3d37bd24` couldn't start tasks: `CannotPullContainerError — image not found`.
- **Why:** CloudForge's `EcrRepository` defaulted to a lifecycle rule with `tagStatus: 'any'` and `maxImages: 2`. Every 3rd push silently evicted the oldest image — **including images still referenced by live ECS task definitions**.
- **Triggering scenario:** Per-commit SHA tags + buildx cache tags (`cache-dev`) all competed for the same 2-image quota. The image still in use by the running task def was evicted; ECS surfaced the error only at task restart.
- **Fix:** Change CloudForge `EcrRepository` lifecycle rule scope to `tagStatus: 'untagged'`. Pin the consumer (`rituo/infra/package.json`) to the fix commit. Re-deploy.
- **Bonus:** Yarn Berry side-quest. Volta silently shimmed Yarn 4 over Yarn Classic on the engineer's machine, rewriting `yarn.lock` to v2. Fixed by pinning Node + Yarn Classic in `volta` and gitignoring Berry artifacts.

## What Was Misconfigured

`CloudForge/src/ecr/component.ts` (before fix):

```ts
new ecr.LifecyclePolicy(`${name}-lifecycle-policy`, {
  repository: this.repository.name,
  policy: JSON.stringify({
    rules: [{
      rulePriority: 1,
      description: `Retain only ${maxImages} most recent images`,
      selection: {
        tagStatus: 'any',            // ← deletes ANY image, tagged or not
        countType: 'imageCountMoreThan',
        countNumber: maxImages,      // ← default 2
      },
      action: { type: 'expire' },
    }],
  }),
})
```

With `maxImages = 2` and `tagStatus: 'any'`, every 3rd push evicted the oldest image. SHA-tagged deploy images and `cache-dev` buildx cache tags shared the 2-slot quota, so a few CI runs were enough to delete the image still referenced by a live task definition.

ECS task defs cache the image **digest** at creation; they don't fail until the next task restart, which is when the missing-image error actually surfaced. ~42 minutes elapsed between eviction and visible failure.

## The Fix

**One-line change** in `CloudForge/src/ecr/component.ts:51`:

```diff
  selection: {
-   tagStatus: 'any',
+   tagStatus: 'untagged',
    countType: 'imageCountMoreThan',
    countNumber: maxImages,
  },
```

The lifecycle rule now only expires **untagged** images (orphaned layers, dangling manifests). Tagged images — every per-commit SHA-tagged deploy image and the `cache-*` buildx cache tags — are protected.

Commit: `6ced3e986c32e40096f21625544f0dceb9d4760c` on `CloudForge/main`.

**Consumer-side propagation** (`rituo/infra/package.json`):

```diff
- "@rituo/cloudforge": "git+ssh://git@github.com:rituo-org/cloudforge.git",
+ "@rituo/cloudforge": "git+ssh://git@github.com:rituo-org/cloudforge.git#6ced3e986c32e40096f21625544f0dceb9d4760c",
```

Pinning to a SHA forces `yarn install` to re-resolve and gets the fix into CI on next deploy. Bonus: infra builds become reproducible.

**Deploy:** Pushing `rituo/infra` `0c53b93` triggered Dev Deployment #495, which (a) built and pushed a fresh SHA-tagged image, (b) `pulumi up` updated the ECR lifecycle policy to `tagStatus: 'untagged'`, (c) updated the ECS task def to the new image URI. Single workflow simultaneously fixed the root cause and recovered the stuck service.

## Yarn Berry Side-Quest

While applying the fix locally, a latent `~/.volta` install on the engineer's machine **silently shimmed Yarn 4.12.0 over Yarn Classic**. The first `yarn install` rewrote `yarn.lock` into Berry v2 format and created `.yarn/`, `.pnp.cjs`, `.pnp.loader.mjs` — incompatible with CI's Yarn Classic.

Mitigations committed alongside the ECR fix:

- Pinned Node + Yarn Classic in `rituo/infra/package.json`:
  ```json
  "volta": { "node": "20.20.2", "yarn": "1.22.22" }
  ```
- `rituo/infra/.gitignore` guards against Berry artifacts (`.yarn/`, `.pnp.*`).

CI was unaffected because GitHub-hosted runners ship Yarn Classic by default.

## Followup Hardening (Not Yet Done)

Documented in the original RCA. Worth noting in any "what would you improve next?" conversation:

1. **Second lifecycle rule for buildx cache tags** — expire `cache-*` after 7 days so cache tags don't accumulate:
   ```ts
   {
     rulePriority: 2,
     description: 'Expire buildx cache tags after 7 days',
     selection: {
       tagStatus: 'tagged',
       tagPrefixList: ['cache-'],
       countType: 'sinceImagePushed',
       countUnit: 'days',
       countNumber: 7,
     },
     action: { type: 'expire' },
   }
   ```
2. **Make ECR tags immutable** (`imageTagMutability: 'IMMUTABLE'`) so a git-SHA tag can never silently move off its digest.
3. **Deploy-time image-existence guard** — after `pulumi up`, call `aws ecr describe-images` for the referenced digest; fail the job if absent. Catches orphaned task defs *before* runtime.
4. **Fix the SSH URL format** — `git+ssh://git@github.com/...` (slash) instead of `git+ssh://git@github.com:...` (colon) to silence Node's `DEP0170` deprecation.
5. **Automate CloudForge bumps** via Renovate/Dependabot so consumers don't silently run stale versions.

## Why This Is Worth Keeping

Three takeaways that translate to reusable engineering judgment:

1. **`tagStatus: 'any'` is almost never what you want on an ECR lifecycle rule.** If you're garbage-collecting orphaned layers, use `'untagged'`. If retaining recent deploys, scope with `tagPrefixList`.
2. **Tiny defaults on reusable components are production-outage waiting to happen.** A library default of `maxImages: 2` combined with a broad rule (`'any'`) caused a multi-project failure mode. Defaults on shared libraries deserve the same scrutiny as production config.
3. **Toolchain drift bites silently.** Volta auto-installing Yarn Berry rewrote a lockfile in a way that worked locally but would have broken CI. Pin Node + package-manager versions explicitly per project, every time.

## Verification (after fix)

```bash
aws ecr get-lifecycle-policy --repository-name rituo-backend --region us-east-1 \
  --query 'lifecyclePolicyText' --output text | jq '.rules[0].selection.tagStatus'
# → "untagged"

aws ecs describe-services --cluster <cluster> --services app-api-alt-dev-3d37bd24 \
  --region us-east-1 --query 'services[0].{desired:desiredCount,running:runningCount}'
# → running == desired
```

## Source

Full original RCA at `/Users/ali/Documents/flatout-solutions/rituo-org/ECR_LIFECYCLE_RCA.md`. This file is a portfolio-shaped extract.
