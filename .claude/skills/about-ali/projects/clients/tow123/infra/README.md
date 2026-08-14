---
name: Tow123 / Flatout AWS Platform (Pulumi IaC)
client: Tow123 / Flatout Solutions
status: active
codebase: /Users/ali/Documents/flatout-solutions/tow123-org/platform (organization-level) and /tow123/infra (Tow123-app-level)
deployment: AWS (multiple accounts), Pulumi Cloud state
tech_stack: Pulumi (TypeScript), @pulumi/aws, AWS Organizations, AWS Identity Center (SSO), CloudFormation StackSets, AWS IAM, GitHub OIDC, KMS, ECS Fargate, ALB, ECR, Parameter Store, S3, VPC, Service Control Policies (SCPs)
target_market: internal (governance + CI/CD foundation for all Tow123 / Flatout workloads)
---

# Tow123 / Flatout AWS Platform

The IaC foundation that **every Tow123 workload** (marketplace, dispatcher, voice agent, billing automation) deploys into. Two layers:

1. **Organization-level platform** (`platform/`) — AWS Organizations, OUs, SCPs, Identity Center, GitHub OIDC, CloudFormation StackSets. The tenant model.
2. **App-level infra** (`tow123/infra/`) — the Tow123 marketplace's own Pulumi project that uses the platform's primitives to spin up its **VPC + ECS Fargate cluster + ALB + ECR + Parameter Store + S3 + CloudWatch** in dev and prod accounts.

This is the same governance pattern Ali later replicated for the [MTH Equities Platform](../../mth-equities/platform/README.md).

## Organization Layer (`platform/`)

### Organization Structure

```
Root Organization
├── Workloads OU
│   ├── Client Projects OU
│   │   ├── Tow123 OU
│   │   │   ├── Tow123 | Dev OU      → AWS Account
│   │   │   ├── Tow123 | QA OU       → AWS Account
│   │   │   └── Tow123 | Prod OU     → AWS Account
│   │   ├── Billing Automation OU
│   │   │   └── ... (dev / prod accounts)
│   │   └── Dispatcher OU
│   │       └── ... (dev / prod accounts)
│   └── Internal OU
│       └── ... (Flatout internal tooling accounts)
└── Legacy OU
    └── Legacy AWS Accounts (pre-IaC tow123 server)
```

### Service Control Policies (SCPs)

Two organization-wide SCPs:

1. **DevOps Platform Guardrails** — prevents manual modification of CI/CD roles/policies. Anything tagged `Classification: DevOpsPlatform` can only be changed via the StackSet execution role. Closes the "engineer accidentally edited the deploy role" failure mode.
2. **Sensitive Data Restrictions** — blocks reading prod secrets, prod KMS keys, prod SSM parameters, and prod RDS data. Engineers in `prod` accounts get **read-only on resources, zero-access on data**.

### Identity Center (SSO)

- **Groups**: `Administrators`, `Platform Engineers`, `Read-only Users`, plus per-project `[Project] Product Engineers`.
- **Permission Sets**: `AdministratorAccess` (AWS-managed), `DeployAccess` (custom — minimum perms to run Pulumi), `ReadOnlyAccess` (AWS-managed).
- **Environment-based access**: engineers get `DeployAccess` in dev, `ReadOnlyAccess` in qa/prod. Operators run prod deploys via GitHub Actions OIDC, not local CLI.

### GitHub OIDC + StackSets

CloudFormation StackSets deploy a standard set of IAM resources into every account:

- **GitHub OIDC Provider** — `token.actions.githubusercontent.com`.
- **`github-preview` role** — assumed on PRs, read-only.
- **`github-deploy` role** — assumed on `main` / `prod` pushes, full deploy permissions.
- **`DeployAccess` policy** — the actual permission boundary.

Result: zero long-lived AWS credentials in GitHub. Every deploy is a per-PR ephemeral session.

### Project Component (`src/components/project.ts`)

The reusable abstraction Ali uses to spin up a new Tow123-org project:

```ts
const dispatcher = new Project("dispatcher", {
  parentOu: clientProjectsOu,
  name: "Dispatcher",
  googleGroupName: "dispatcher",
  repoName: "dispatcher",
  environments: [
    { name: DEV, branch: "main" },
    { name: PROD, branch: "prod" },
  ],
  teamMembers: [aliAhmad, ...],
});
```

Creates: project OU, environment OUs + accounts, product-engineers SSO group, OIDC trust per-account, deploy/preview roles, environment-specific permission-set assignments.

## App Layer (`tow123/infra/`)

The **per-environment** infra for the Tow123 marketplace itself:

### Architecture

```
GitHub Actions (OIDC) → AWS Account (Dev/Prod)
                          ├── VPC (public + private subnets, NAT, IGW)
                          ├── ALB (public)
                          ├── ECS Fargate Cluster (private)
                          │   └── tow123-service (Node/Express server)
                          ├── ECR Repository
                          ├── Parameter Store (/tow123/<env>/*)
                          ├── S3 Bucket (file uploads)
                          └── CloudWatch (logs, alarms, dashboards)
```

### Deploy Flow

1. **PR → main** triggers `pulumi preview` in dev via `github-preview` role.
2. **Push to main** triggers `pulumi up --yes` + `aws ecs update-service --force-new-deployment` against the dev account.
3. **Push to prod** does the same against the prod account, gated by environment protection rules + required reviewers.
4. **Initial image** is pushed manually to ECR; subsequent images come from CI builds.

### Secrets

All `.env` values for the marketplace (`MONGO_URI`, `SECRET_KEY`, `STRIPE_SECRET_KEY`, `SENDGRID_API_KEY`, `GOOGLE_MAPS_API_KEY`, all Firebase vars) are in **SSM Parameter Store** under `/tow123/<env>/`, encrypted with KMS, fetched by the ECS task execution role at task start.

### Auto-scaling + Health

- ECS service auto-scales on CPU + ALB request count.
- ALB health check: `/health` every 30 s, 2 healthy / 3 unhealthy thresholds.
- CloudWatch dashboards per environment (`tow123-dev`, `tow123-prod`).

## Tech Stack

- **Pulumi** (TypeScript), `@pulumi/pulumi` 3.x, `@pulumi/aws` 5.x
- AWS: Organizations, Identity Center, IAM, KMS, S3, CloudFormation StackSets, ECS Fargate, ECR, ALB, VPC, EventBridge, CloudWatch, Secrets Manager, SSM Parameter Store
- GitHub Actions for CI/CD (OIDC keyless)

## Notable Engineering Highlights

- **Reusable `Project` and `TeamMember` Pulumi components** — adding a new project to the org is a ~10-line code change, not a console click-through.
- **SCP-enforced separation of CI/CD and product code** — DevOps Platform Guardrails prevent the most common multi-account governance failure (someone hand-edits the deploy role).
- **Identity Center–driven access** — engineers SSO in once, get scoped per-project per-environment access; no per-account IAM users.
- **OIDC-only CI auth** — no `aws_access_key_id` / `aws_secret_access_key` anywhere in repo secrets.
- **Parameter Store as the secret plane** for the Tow123 server — no `.env` in production, no Vault dependency.
- **Same governance pattern reused at MTH Equities** — proves the pattern is general-purpose, not Tow123-specific.

## Notes for Pitching

- This is Ali's **canonical AWS multi-account governance pattern** — it's the same shape at MTH Equities and lined up to be the same at future client orgs.
- For **DevOps / Platform Engineering** pitches: lead with the SCP design, the `Project` component abstraction, and the OIDC-only CI auth — these are the parts most teams *want* but haven't built.
- For **migration** stories: pair this with the `TOW123-IaC-Setup-Guide.md` runbook — manual ECS → fully automated IaC + zero-downtime cutover, three-phase migration plan.
