---
name: Tow123 Billing Automation (Towbook scraper)
client: Tow123
status: active
codebase: /Users/ali/Documents/flatout-solutions/tow123-org/tow123-billing-automation
deployment: AWS Lambda (per-environment), EventBridge schedules, DynamoDB, Secrets Manager
tech_stack: TypeScript, Node 20, AWS Lambda, EventBridge, SQS, DynamoDB, Secrets Manager, SNS, axios, axios-cookiejar-support, tough-cookie, cheerio, user-agents, Pulumi (TypeScript), SendGrid, esbuild
target_market: Tow123 internal finance/ops, billing analytics
---

# Tow123 Billing Automation

A serverless **AWS Lambda** pipeline that automates the part of Towbook (the dominant towing-management SaaS) that Towbook itself doesn't expose well: **invoice and billing extraction, normalization, and downstream analytics**.

## What It Does

- Logs into Towbook with credentials from **AWS Secrets Manager** using a cookie-jar HTTP session (`axios-cookiejar-support` + `tough-cookie`), with **rotating user agents** (`user-agents`) to keep the session stable.
- Scrapes invoice / billing pages with `axios` + `cheerio`.
- **Normalizes invoice data** (`automation/invoiceData.ts`) into a consistent typed schema (Zod 4).
- Writes normalized rows to **DynamoDB** for the billing analytics layer to query.
- Pushes failure / threshold alerts to **SendGrid** (email) and an **SNS** topic for downstream subscribers.
- Runs on **EventBridge** schedules — multiple lambdas keyed by hour-of-day for region/timezone-aware execution.

## Architecture

```
EventBridge (cron) ──► billing-automation Lambda
                             │
                             ▼
                       Secrets Manager (Towbook creds)
                             │
                             ▼
                       Towbook web UI ── (axios + cookie jar + cheerio)
                             │
                             ▼
                       invoiceData.ts (normalize + Zod-validate)
                             │
                  ┌──────────┴──────────┐
                  ▼                     ▼
              DynamoDB             SQS / SNS
              (analytics store)    (alerts, downstream)
                                        │
                                        ▼
                                   SendGrid (email alerts)
```

Two lambdas (legacy naming):
- **`billing-automation`** — the actual scrape + normalize + persist worker.
- **`billing-automation-initiator`** — fan-out lambda that enqueues per-tenant or per-period jobs into SQS.

## Repo Layout

```
tow123-billing-automation/
├── automation/
│   ├── invoiceData.ts          ← normalization + typed schema (Zod 4)
│   ├── lambda/                 ← Lambda entry points
│   ├── services/               ← Towbook session + scraping services
│   ├── helper/                 ← scraping helpers (cheerio selectors, parsers)
│   ├── utils/                  ← retry, backoff, user-agent rotation
│   ├── config/                 ← env + per-tenant config
│   ├── types/                  ← shared types
│   ├── scripts/                ← build (esbuild bundling per-lambda)
│   └── package.json
└── infra/
    ├── platform/               ← Pulumi: stack-level resources
    ├── protected/              ← Pulumi: protected resources (DLQ, SNS topics)
    └── package.json
```

## Tech Stack (Detailed)

**Lambdas (`automation/`)**
- TypeScript + Node 20+
- **AWS SDK v3**: `@aws-sdk/client-dynamodb`, `@aws-sdk/util-dynamodb`, `@aws-sdk/client-sqs`, `@aws-sdk/client-sts`, `@aws-sdk/client-secrets-manager`
- **Scraping**: `axios` 1.12, `axios-cookiejar-support` 6, `tough-cookie` 5, `cheerio` 1.1, `user-agents` 1.1
- **Validation**: Zod 4
- **Email alerts**: `@sendgrid/mail` 8
- **Build**: `esbuild` 0.25 — per-lambda bundles, output to `dist/`
- **Tooling**: TypeScript 5.9, Husky 8, lint-staged 15, Prettier 3.5

**Infra (`infra/`)**
- Pulumi (TypeScript) — same patterns as the [Tow123 infra](../infra/README.md): GitHub OIDC roles, Parameter Store secrets, EventBridge rules, SNS topics, DynamoDB tables, IAM roles per lambda.
- Deploys to dev (`dev` branch push) and prod stacks.

## Operational Details

- **Secrets** — Towbook credentials in AWS Secrets Manager, fetched at lambda cold-start and cached.
- **Schedules** — EventBridge rules keyed per `hour` parameter (0–23) so different timezones are handled by separate scheduled invocations.
- **Alerts** — failures fan out to an SNS topic (subscribed by SendGrid email + an internal Slack webhook).
- **CloudWatch logs** — `/aws/lambda/billing-automation-*` and `/aws/lambda/habit-*` (the lambda also handles habit-streak / reminder workloads — multi-purpose deployment).
- **CI/CD** — GitHub Actions on push to `dev` deploys via OIDC role; required secrets: `PULUMI_ACCESS_TOKEN`, `MONGODB_URI`, AWS access keys.

## Notable Engineering Highlights

- **Cookie-jar Towbook scraping** — survives session expiration, CSRF tokens, and rate-limiting via UA rotation + adaptive backoff.
- **Zod 4-validated invoice normalization** — invoice rows are typed end-to-end; downstream consumers don't have to defensively parse.
- **Per-hour EventBridge fan-out** — each timezone gets its own scheduled run rather than one monster job.
- **Pulumi `protected/` stack** — DLQ + SNS topics are in a separate Pulumi project so they survive recreation of the lambda stack.
- **Same governance pattern** as the rest of the Tow123 ecosystem — runs in its own AWS account under the Tow123 organization with Identity Center + OIDC.

## Notes for Pitching

- For **AWS / serverless** pitches: lead with the scraper resilience patterns (cookie jars, UA rotation, schedule fan-out, Zod normalization) — this is a small, focused, real-world example of "scrape a SaaS that doesn't have a clean API, ship to analytics."
- For **DevOps / IaC** pitches: lead with the Pulumi stack split (platform + protected) and the per-environment OIDC deploy roles.
- It's intentionally narrow — most of the AI / dispatch work is in the dispatcher repo, not here.
