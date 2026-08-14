---
name: CloudForge
employer: FlatOut Ventures LLC
dates: unconfirmed
tech_used: Pulumi | TypeScript | AWS | Cloudflare
url: none
tags: iac, pulumi, library-design, aws, iam, incident-response, rca, devops
gaps: dates, number of consuming stacks, adoption beyond FlatOut
---

# CloudForge

Reusable Pulumi component library abstracting AWS and Cloudflare infrastructure patterns. Consumed across the FlatOut portfolio including Rituo, Kollaborative AI, and the MTH Equities platform.

## Bullets

- *Infrastructure Component Library*: Designed and shipped an 11-component Pulumi and TypeScript library covering VPC, ECS cluster and service, ALB with ACM, S3 with CloudFront, SES with DKIM, Route53, ECR, Amplify, Secrets Manager, and Cloudflare delegation, consumed by three production AWS stacks.
- *Least-Privilege IAM Design*: Separated ECS execution and task roles so secret-pulling and log-writing stay isolated from application permissions, with per-service policy factories accepting Pulumi outputs for interpolation-time resolution.
- *Cloud Cost Optimization*: Defaulted to VPC interface and gateway endpoints over NAT gateways and to universal Project, Environment, and ManagedBy tagging so cost attribution and governance come for free.
- *Incident Response and Root Cause Analysis*: Root-caused a service outage where an ECR lifecycle rule scoped to any tag with a two-image retention limit evicted an image still referenced by a live ECS task definition, surfacing as CannotPullContainerError roughly 42 minutes after the eviction.
- *Production Remediation*: Fixed the lifecycle scope to untagged images only, pinned consumers to the fix commit SHA to make infrastructure builds reproducible, and published a postmortem with follow-up hardening covering immutable tags, cache-tag expiry, and a deploy-time image-existence guard.
- *Library Distribution*: Distributed over Git-SSH with a postinstall build hook so consumers receive compiled JavaScript and type declarations on install.
