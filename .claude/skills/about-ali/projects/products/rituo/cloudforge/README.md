---
name: CloudForge
parent: Rituo (FlatOut Ventures) — but reused across the FlatOut portfolio
status: active (v0.3.0)
codebase: /Users/ali/Documents/flatout-solutions/rituo-org/CloudForge
distribution: Git-SSH dependency (`git+ssh://git@github.com/rituo-org/cloudforge.git`) — **not** published to npm
tech_stack: Pulumi 3.174.0, @pulumi/aws 6.82.1, @pulumi/awsx 2.21.1, @pulumi/cloudflare 6.2.0, TypeScript 5, Yarn, ESLint 9 + Prettier
node_requirement: ">=20.0.0"
consumed_by: Rituo (app infra), Kollaborative AI, MTH Equities Platform, and other FlatOut workloads
---

# CloudForge — Reusable Pulumi Component Library

Opinionated **TypeScript-first** Pulumi component library that abstracts common AWS (and a bit of Cloudflare) infrastructure patterns into reusable, composable components. Used across the entire FlatOut portfolio — when Ali says "we use Pulumi," CloudForge is what's actually doing the heavy lifting at the app-stack layer.

Lives inside the Rituo monorepo for historical reasons but is **portfolio-wide infrastructure.**

## Components Exposed

11 components under `src/`:

| Component | What it provisions |
|---|---|
| **VPC** | Multi-AZ VPC (10.0.0.0/16, 2 AZs), optional VPC endpoints — ECR API/Docker, S3 Gateway, CloudWatch Logs Interface — for private-subnet isolation without NAT cost |
| **EcsCluster** | Fargate cluster |
| **EcsService** | Fully provisioned Fargate service: ALB target groups, Route53 DNS, **dual IAM roles** (execution vs. task), Secrets Manager injection, env var support |
| **ApplicationLoadBalancer** | ALB with ACM certificate provisioning, HTTPS-only listener, security group ingress on 443 from 0.0.0.0/0, supports apex + wildcard subdomains via listener rules |
| **S3Bucket** | S3 + CloudFront CDN (origin access identity), CORS, versioning always on, optional lifecycle rules, AES256 server-side encryption, 1-day default TTL / 1-year max TTL |
| **Ses** / **SesWithRoute53** | Domain identity, email identity, **DKIM** setup, Route53 verification records |
| **HostedZone** | Route53 hosted zone + alias records for ECS services and SES verification |
| **EcrRepository** | ECR repo with image scanning on push, lifecycle policy (currently `tagStatus: 'untagged'` — see [incidents/ecr-lifecycle-rca.md](../incidents/ecr-lifecycle-rca.md) for the story), helpers for latest-image and tag-based URI lookup |
| **AmplifyApp** | AWS Amplify app with GitHub CI/CD wiring, Next.js SSR framework defaults, branch config, domain association |
| **CloudflareNameserver** | Delegate subdomains from Cloudflare → Route53 via NS records |
| **Secret** | AWS Secrets Manager wrapper with multi-key JSON support and Pulumi Output interpolation |
| **Image** | Docker image reference utilities |

## Tech Stack

- **Pulumi 3.174.0** (mature, stable)
- **AWS provider** `@pulumi/aws` 6.82.1, `@pulumi/awsx` 2.21.1
- **Cloudflare provider** `@pulumi/cloudflare` 6.2.0
- **TypeScript 5.0.0**, strict mode
- **Build:** `tsc` → `dist/` with `.d.ts` + sourcemaps
- **Package manager:** Yarn (Yarn Classic, post-Berry-incident — see ECR RCA)
- **Linting:** ESLint 9.27.0 + Prettier
- **Tests:** **None** (`"test": "echo 'No tests yet'"`). Strict TS + ESLint stand in.
- **Node:** `>=20.0.0`

## Architecture

```
src/
├── alb/                # ApplicationLoadBalancer
├── amplify/            # AmplifyApp + IAM role/policy for domain assoc
├── cloudflare/         # CloudflareNameserver (NS delegation)
├── ecr/                # EcrRepository + lifecycle policy
├── ecs/                # EcsCluster, EcsService, IAM roles (execution + task)
├── image/              # Docker image utilities
├── route53/            # HostedZone, alias records, verification
├── s3/                 # S3Bucket + CloudFront + IAM
├── secret/             # AWS Secrets Manager wrapper
├── ses/                # Ses, SesWithRoute53, DKIM, email identity
├── utils/
│   ├── addEnvSuffix.ts        # auto-suffix all resources with stack name
│   ├── commonTags.ts          # Project, Environment, ManagedBy=Pulumi
│   ├── context.ts             # singleton stack/project/region/isProduction
│   ├── domain.ts              # domain helpers
│   ├── environment.ts         # Environment enum
│   └── mapToNameValuePairs.ts # object → ECS env var format
└── index.ts            # barrel export
```

Each component follows the same shape: `component.ts` (main class) · `types.ts` (interfaces) · `iam.ts` (policy factories) · `service.ts` (helpers).

## Distribution Model

**Git-SSH dependency, not npm.** Consumers add it via:

```bash
yarn add git+ssh://git@github.com/rituo-org/cloudforge.git#<commit-sha>
```

A **`postinstall` hook** runs `yarn build` automatically so consumers get compiled JS + `.d.ts` types after install.

**Pinning:** After the [ECR lifecycle incident](../incidents/ecr-lifecycle-rca.md), consumers started pinning to explicit commit SHAs (`#6ced3e986c…`) for reproducibility. Renovate/Dependabot is on the followup-hardening list to automate bumps.

## Opinionated Defaults (the value)

1. **Execution vs. task IAM separation** (`src/ecs/iam.ts`) — execution role pulls secrets and writes logs; task role gets app-level permissions (S3, SES, etc.). Secrets Manager attaches to the *execution* role only.
2. **2-AZ VPCs** by default — high availability without configuration.
3. **VPC endpoints over NAT gateway** when possible — cost-conscious default.
4. **Environment-suffixed resource names** (`addEnvSuffix`) — prevents accidental collisions when running multiple stacks in the same AWS account.
5. **Universal tagging** (`commonTags`) — every resource gets `Project`, `Environment`, `ManagedBy=Pulumi`. Cost tracking + governance for free.
6. **Singleton `context`** — stack/project/region/isProduction resolved once from Pulumi config, shared across all components without re-lookup.
7. **Least-privilege IAM factories** — `attachS3PolicyToRole`, `attachSesPolicyToRole`, etc. Build inline policies dynamically; accept `Output<string>` bucket names for interpolation-time resolution.
8. **Multi-domain ALB** — apex + wildcard subdomains on a single ALB via listener rules.
9. **S3 sane defaults** — versioning always on, AES256 encryption, optional lifecycle, CloudFront 1-day default TTL with 1-year max.

## Consumers (Cross-Portfolio)

- [Rituo App](../app/README.md) — ECS, ECR, S3, ALB, Route53, SES, Secrets
- [Kollaborative AI](../../../deployed/kollaborative-ai.md) — ECS, ALB, ECR, Route53, SES (`infra/protected/` + `infra/platform/` stacks)
- [MTH Equities Platform](../../../clients/mth-equities/platform/README.md) — used at app-scope (workloads), while the platform itself uses raw `@pulumi/aws`

When asked "what's your AWS / IaC stack?" — CloudForge is a strong answer because it shows **library-design thinking** layered on top of Pulumi, not just IaC usage.

## Known Gaps / Followups

- **No tests.** Strict TS + ESLint catch most things; integration tests would catch IAM-policy regressions.
- **`tagStatus: 'any'` ECR lifecycle bug** caused a production outage on 2026-04-15; fixed to `tagStatus: 'untagged'` in commit `6ced3e986c…`. Full RCA at [../incidents/ecr-lifecycle-rca.md](../incidents/ecr-lifecycle-rca.md).
- **SSH dep URL format** — current URL uses `git+ssh://git@github.com:` (colon) which triggers Node's `DEP0170` deprecation warning. Fix is `git@github.com/` (slash).
- **No CloudForge bumps automated** — Renovate/Dependabot recommended.

## Key Files (verifiable)

- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/package.json`
- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/src/index.ts`
- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/src/ecs/iam.ts`
- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/src/ecr/component.ts`
- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/src/utils/{addEnvSuffix,commonTags,context}.ts`
