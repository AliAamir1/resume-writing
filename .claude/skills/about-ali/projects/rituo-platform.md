---
name: Rituo AWS Platform
employer: FlatOut Ventures LLC
dates: unconfirmed
tech_used: Pulumi | TypeScript | AWS Organizations | IAM Identity Center | KMS | GitHub OIDC
url: none
tags: iac, pulumi, aws, governance, scp, oidc, multi-account, devops
gaps: dates, number of accounts and workloads under management
---

# Rituo AWS Platform

Pure infrastructure-as-code foundation the Rituo app deploys into. AWS Organizations governance, identity, secrets, and CI/CD plumbing, no runtime services.

## Bullets

- *Multi-Account AWS Governance*: Designed an AWS Organizations hierarchy with per-project and per-environment OUs and dedicated dev, qa, and prod accounts, provisioned entirely in Pulumi TypeScript.
- *Security Policy as Code*: Authored two organization-wide service control policies, one blocking manual mutation of CI/CD roles outside the StackSet execution path and one denying non-admin reads of qa and prod secrets, SSM parameters, KMS keys, and RDS data, scoped by resource tag.
- *Identity and Access Management*: Configured IAM Identity Center groups and permission sets granting engineers deploy access in dev and read-only in upper environments, with no per-account IAM users.
- *Keyless CI/CD*: Implemented hub-and-spoke GitHub OIDC where only the management account trusts GitHub and member accounts trust its deploy role, reducing the blast radius of a trust-policy mistake.
- *State Management Migration*: Migrated Pulumi state off Pulumi Cloud onto a self-managed S3 backend with KMS encryption, versioning, tiering and expiry lifecycle rules, and a bucket policy denying non-TLS and unencrypted writes.
- *Reusable Infrastructure Components*: Built a Project component resource encapsulating OU, accounts, SSO group, and StackSet instances, cutting new-workload onboarding to roughly ten lines of code.
