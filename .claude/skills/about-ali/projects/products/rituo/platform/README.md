---
name: Rituo Platform (IaC)
parent: Rituo (FlatOut Ventures)
status: active
codebase: /Users/ali/Documents/flatout-solutions/rituo-org/platform
deployment: AWS management account (us-east-1), single Pulumi stack `organization/platform/management`
tech_stack: Pulumi (TypeScript), Node 22, @pulumi/pulumi ^3, @pulumi/aws ^5, AWS Organizations, IAM Identity Center, IAM, CloudFormation StackSets, S3 (Pulumi state), KMS, GitHub Actions OIDC
target_market: Internal — IaC foundation for the Rituo app, with the same pattern reusable across other FlatOut workloads
---

# Rituo Platform — Multi-Account AWS Governance

Pure Infrastructure-as-Code. **Foundation layer** that the Rituo app deploys into — no runtime application services, just AWS Organizations governance, identity, secrets, and CI/CD plumbing.

Same architectural pattern as the [MTH Equities Platform](../../../clients/mth-equities/platform/README.md), with one notable difference: **Rituo's platform self-hosts Pulumi state on S3 + KMS** (migrated off Pulumi Cloud) — see `MIGRATION_GUIDE.md` in the repo root.

## What It Provisions

| Source file | Resources |
|---|---|
| `src/organization.ts` | AWS Organization root, OUs (Workloads OU, Project OUs, Environment OUs), AWS accounts (per project × per environment), **two SCPs** (`DevOpsPlatformGuardrails`, `SensitiveDataGuardrails`) |
| `src/identityCenter.ts` | IdC groups (`Administrators`, `PlatformEngineers`, `ProductEngineers`, `ReadOnlyUsers`), **permission sets** (`DeployAccess`, `UpperEnvironmentAccess`, `AdministratorAccess`, `ReadOnlyAccess`), group memberships, account assignments |
| `src/iam.ts` | GitHub OIDC provider (with thumbprint), `github-preview` (PRs) and `github-deploy` (main) roles, `pulumi-state-deploy` role, `DeployAccess` / `UpperEnvironmentSecretsManagement` / `PulumiStateAccess` policies |
| `src/pulumiState.ts` | **KMS key** (`alias/pulumi-state`, rotation enabled, 30-day deletion window) + **S3 bucket** (`pulumi-state-rituo-542800011628`) with versioning, server-side KMS encryption, lifecycle (90-day version retention, 30-day STANDARD_IA transition, 7-day incomplete-upload cleanup), public-access blocked, bucket policy enforcing TLS + KMS + cross-account org-level access |
| `src/stackSet.ts` | **Service-managed CloudFormation StackSet** (auto-deploy on), instantiated per environment OU; provisions per-account deploy roles parameterized by repo + branch |
| `src/components/project.ts` | **`Project` ComponentResource** — encapsulates project OU + per-environment AWS accounts + product-engineer IdC group + StackSetInstances. Onboarding a new workload = ~10 lines in `src/index.ts` |
| `src/components/teamMember.ts` | IdC user wrapper |
| `src/awsIdentity.ts` | Resolves the management-account ID at runtime |

## Hierarchy

```
AWS Organization
└── Workloads OU
    └── Project OU (e.g. rituo)
        └── Environment OUs (dev, qa, prod)
            └── AWS Accounts
                └── StackSetInstance — provisions per-account deploy roles
                    parameterized by repo + branch
```

`src/config.ts` exports the constants — `DEV`, `QA`, `PROD`, `MAIN`, region `us-east-1`, GitHub org/repo, SSO instance ARN, identity store ID.

## Stack Strategy

**Single Pulumi stack:** `organization/platform/management` — runs in the management account only. Environment separation is achieved by **separate AWS accounts**, not separate stacks. Three accounts (dev / qa / prod) per project.

**Backend:** S3 at `s3://pulumi-state-rituo-542800011628?region=us-east-1`. **No PULUMI_ACCESS_TOKEN** in CI — auth is OIDC + AWS credentials all the way down.

## Pulumi Cloud → S3 Migration (significant)

Documented in `/Users/ali/Documents/flatout-solutions/rituo-org/MIGRATION_GUIDE.md`. The platform was originally on Pulumi Cloud; it was migrated to a self-managed S3 backend with KMS-encrypted state and OIDC-based CI auth. Key gotchas:

1. S3 backends require a **3-part** stack name: `organization/<project>/<stack>`. `organization/management` (2-part) silently fails with a misleading error.
2. `pulumi stack change-secrets-provider` rewrites `Pulumi.management.yaml` and **wipes the config block** — must back up and merge back.
3. Cross-account org access is allowed via `aws:PrincipalOrgID` condition in the bucket policy.
4. The IAM refactor went hub-and-spoke: management account holds `pulumi-state-deploy`; member-account deploy roles trust *that* role, not GitHub directly.

## Notable Engineering

1. **Two SCPs as code:**
   - **DevOps Platform Guardrails** (`organization.ts:29–94`) — prevents manual mutation of CI/CD roles/policies except via the StackSet execution path. Stops accidental platform breakage.
   - **Sensitive Data Restrictions** (`organization.ts:116–227`) — denies non-admin team members and GitHub pipelines from reading qa/prod secrets, SSM parameters, KMS keys, RDS data. Resource-tag–scoped (`Environment: qa|prod`).
2. **Hub-and-spoke OIDC** — management account is the only place trusting GitHub. Member-account roles trust the management account's `pulumi-state-deploy` role. Reduces blast radius of GitHub OIDC trust-policy mistakes.
3. **Trust policy specificity** — `repo:rituo-org/platform:ref:refs/heads/main` for deploy, `repo:rituo-org/platform:pull_request` for preview. No wildcard branches.
4. **Pulumi state bucket policy** — denies unencrypted uploads, denies non-TLS access, enforces KMS encryption on writes. Versioning + lifecycle (STANDARD_IA after 30 days, expire versions after 90 days).
5. **Reusable `Project` component** — same shape used here as in MTH Equities Platform; new workload = 10 lines in `index.ts`.

## CI/CD

`.github/workflows/deploy.yaml`:

- **Preview job** (PRs): Node 22, `yarn install --immutable`, OIDC → `github-preview` role → `pulumi preview`, comments on PR.
- **Deploy job** (main pushes): OIDC → `github-deploy` role → `pulumi up`.
- `PULUMI_BACKEND_URL: s3://pulumi-state-…?region=us-east-1` at workflow level. **No `PULUMI_ACCESS_TOKEN`.**

## Stats

- ~9 source files (+ 2 component files), ~600 lines of IaC.
- Single runtime stack. Multiple AWS accounts (dev/qa/prod per project) created from it.

## Notes

- This project uses CloudForge for **its app-layer counterparts**, but the platform itself uses raw `@pulumi/aws` resources — by design (CloudForge is for application infra; platform IaC is at the org/account level).
- Cross-reference: [MTH Equities Platform](../../../clients/mth-equities/platform/README.md) is structurally the same pattern; the `Project` ComponentResource was almost certainly extracted from one and reused in the other.
- See `platform-changes.md` (repo root) for the patch-level diff of the Pulumi Cloud → S3 migration + IAM refactor.
