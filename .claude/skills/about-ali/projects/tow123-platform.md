---
name: Tow123 AWS Platform
employer: FlatOut Solutions
dates: unconfirmed
tech_used: Pulumi | TypeScript | AWS Organizations | ECS Fargate | CloudFormation StackSets
url: none
tags: iac, pulumi, aws, governance, scp, oidc, ecs, devops, multi-account
gaps: dates, accounts and workloads under management
---

# Tow123 AWS Platform

The AWS organization and per-app infrastructure every Tow123 workload deploys into: marketplace, dispatcher, voice agent, and billing automation.

## Bullets

- *AWS Multi-Account Architecture*: Designed the AWS Organization hosting every workload, with Workloads, Client Projects, Internal, and Legacy organizational units and dedicated accounts per project and environment.
- *Security Policy as Code*: Wrote guardrail service control policies preventing manual edits to CI/CD roles and blocking production secret, KMS, SSM, and RDS data access for non-administrators.
- *Single Sign-On*: Configured IAM Identity Center groups and permission sets so engineers hold deploy access in dev and read-only in qa and prod, with production deploys running only through CI.
- *Keyless CI/CD*: Provisioned GitHub OIDC providers and per-repository preview and deploy roles through CloudFormation StackSets, removing every long-lived AWS key from CI.
- *Container Orchestration*: Ran the application on ECS Fargate behind an ALB with CPU and request-count autoscaling, health checks, and per-environment CloudWatch dashboards.
- *Reusable IaC Abstractions*: Built Project and TeamMember Pulumi component resources turning new-project onboarding into a ten-line code change instead of a console clickthrough.
