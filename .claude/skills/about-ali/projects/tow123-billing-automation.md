---
name: Towbook Billing Automation Pipeline
employer: FlatOut Solutions
dates: unconfirmed
tech_used: TypeScript | AWS Lambda | EventBridge | SQS | DynamoDB | Pulumi
url: none
tags: serverless, aws-lambda, etl, scraping, event-driven, zod, iac
gaps: dates, invoices processed per run, pipeline reliability rate
---

# Towbook Billing Automation Pipeline

Serverless pipeline extracting invoice and billing data out of Towbook for analytics the vendor UI does not expose.

## Bullets

- *Serverless Data Pipeline*: Built an AWS Lambda pipeline that authenticates against a third-party SaaS, extracts invoice and billing data, normalizes it, and loads it to DynamoDB for downstream billing analytics and reconciliation.
- *Web Scraping at Scale*: Maintained authenticated sessions with cookie jars, rotating user agents, and adaptive backoff to survive session expiry, CSRF tokens, and rate limiting.
- *Event-Driven Architecture*: Fanned work out through SQS with per-hour EventBridge schedules so each timezone runs its own scheduled job instead of one monolithic batch.
- *Data Validation*: Typed invoice normalization end to end with Zod so downstream consumers never defensively parse.
- *Alerting and Monitoring*: Routed failures to an SNS topic with email and Slack subscribers, and isolated dead-letter queues and topics in a separate Pulumi stack so they survive recreation of the compute stack.
- *Secrets Management*: Pulled credentials from AWS Secrets Manager at cold start with module-scope caching across warm invocations.
