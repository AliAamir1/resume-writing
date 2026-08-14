---
name: MTH Equities Platform
client: MTH Equities
status: active
codebase: /Users/ali/Documents/flatout-solutions/mthequities/mthequities-platform
deployment: AWS management account (us-east-2), single Pulumi stack ("management")
tech_stack: Pulumi (TypeScript), Node 22, @pulumi/aws ^5, AWS Organizations, IAM Identity Center, IAM, CloudFormation StackSets, S3, KMS, GitHub OIDC
target_market: Internal — IaC foundation for the other three MTH projects
---

# MTH Equities Platform

Pure Infrastructure-as-Code. This is the **foundation layer** the other three MTH workloads (Equities Map, Property Data Enrichment, SNF Explorer) deploy *into* — not an application, no runtime services of its own.

Provisions a multi-account AWS governance platform: AWS Organizations, Identity Center (SSO), IAM with GitHub OIDC trust, CloudFormation StackSets for parameterized CI/CD role provisioning, and a KMS-encrypted S3 bucket for cross-account Pulumi state.

## Tech Stack

- **Language:** TypeScript on Node 22.13.0 (Volta-pinned).
- **IaC:** Pulumi (`@pulumi/pulumi ^3`, `@pulumi/aws ^5`).
- **Stack:** single management-account stack — `Pulumi.management.yaml`, region `us-east-2`.
- **Secrets provider:** `awskms://alias/pulumi-state?region=us-east-2`.

No application code, no shared libraries — pure declarative infra.

## What It Provisions

| File | Resource |
|---|---|
| `src/organization.ts` | AWS Organization root, OUs, **two SCPs** (DevOps Platform Guardrails + Sensitive Data Restrictions) |
| `src/identityCenter.ts` | IAM Identity Center groups, permission sets, account assignments |
| `src/iam.ts` | GitHub OIDC provider (with thumbprint), `github-preview` and `github-deploy` roles, managed policies |
| `src/stackSet.ts` | Service-managed **CloudFormation StackSet** with template parameters (RepoName, BranchName, EnvironmentName) — instantiated per child account |
| `src/pulumiState.ts` | S3 `pulumi-state-*` bucket + KMS key + cross-account access policies |
| `src/components/project.ts` | **Reusable `Project` ComponentResource** — provisions project OU, environment accounts, product-engineer Identity Center group, and StackSetInstances for each environment |
| `src/components/teamMember.ts` | Team-member ComponentResource — creates Identity Center users |

## Hierarchy

```
AWS Organization
└── Workloads OU
    └── Project OU (one per workload, e.g. mthequities-propertydataenrichment)
        └── Environment OUs (dev, qa, prod)
            └── AWS Accounts
                └── StackSetInstance — provisions GitHub OIDC roles parameterized by repo + branch
```

Environment names + branch names live as constants in `src/config.ts` (`DEV`, `QA`, `PROD`, `MAIN`).

## Confirmed Workload

**`mthequities-propertydataenrichment`** is explicitly registered as a Project in `src/index.ts` (lines 46–63), with `repoName: "mthequities-propertydataenrichment"`. The other workloads (Map, SNF) presumably deploy into accounts created by this platform via the same OIDC trust, but are not directly referenced here.

**No StackReferences** — the platform exposes outputs (`pulumiStateBucketName`, `pulumiSecretsProvider`, etc.) for downstream stacks to consume, but the dependency direction is purely "downstream stacks read management outputs."

## Notable Engineering

- **Reusable `Project` ComponentResource** — encapsulates the full account + permissions hierarchy for a single workload; new workloads onboard by adding ~10 lines to `src/index.ts`.
- **Two SCPs as code:**
  - **DevOps Platform Guardrails** (`organization.ts:29–95`) — prevents unauthorized mutation of CI/CD roles/policies except via StackSet execution.
  - **Sensitive Data Restrictions** (`organization.ts:118–242`) — blocks non-admin access to QA/prod secrets, SSM parameters, KMS keys, RDS data.
- **Parameterized StackSet template** — same template instantiated across N projects with `RepoName` / `BranchName` / `EnvironmentName` parameters; no template duplication.
- **Keyless GitHub Actions auth** — OIDC trust policy restricts role assumption by branch and environment; no long-lived AWS keys in CI.
- **KMS-encrypted Pulumi state** with explicit cross-account access in the key policy (`pulumiState.ts:71`).

## Stats

- ~9 source files (+ 2 component files), ~650 lines of IaC.
- 5 Pulumi outputs exported (state bucket, KMS key, backend URL, secrets provider, etc.).
- Single runtime stack.

## Notes

- This is the answer to "tell me about your AWS / DevOps / governance experience" — multi-account org design, SCPs, StackSets, OIDC, KMS, and componentized Pulumi.
- Notably **missing from this repo** (intentionally): RDS, Lambda, SQS, ECS, CloudFront. Those are application infra and live in the workload repos. Don't conflate.
