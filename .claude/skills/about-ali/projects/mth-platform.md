---
name: MTH Equities AWS Platform
employer: FlatOut Solutions
dates: unconfirmed
tech_used: Pulumi | TypeScript | AWS Organizations | IAM Identity Center | CloudFormation StackSets
url: none
tags: iac, pulumi, aws, governance, scp, oidc, multi-account, devops
gaps: dates, accounts under management
---

# MTH Equities AWS Platform

Pure infrastructure-as-code foundation the client's three application workloads deploy into. No runtime services of its own.

## Bullets

- *Infrastructure as Code*: Provisioned a complete multi-account AWS governance platform in roughly 650 lines of Pulumi TypeScript running from a single management stack.
- *AWS Organizations Design*: Built a Workloads, Project, and Environment organizational unit hierarchy with dedicated dev, qa, and prod accounts created per workload.
- *Security Policy as Code*: Authored two service control policies blocking unauthorized mutation of CI/CD roles outside the StackSet execution path and denying non-admin access to upper-environment secrets, SSM parameters, KMS keys, and RDS data.
- *CloudFormation StackSets*: Instantiated one parameterized template across every child account using repository, branch, and environment parameters instead of duplicating templates per account.
- *Encrypted State Management*: Stored Pulumi state in a KMS-encrypted S3 bucket with explicit cross-account key policies for downstream stacks.
- *Keyless GitHub Actions*: Scoped OIDC trust policies by branch and environment with no wildcard branches and no static AWS credentials in CI.
- *Reusable IaC Abstractions*: Built a Project component resource so onboarding a new workload takes roughly ten lines in the entrypoint.
