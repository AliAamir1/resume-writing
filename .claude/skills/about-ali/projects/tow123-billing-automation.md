# Tow123 Billing Automation: Resume Bullets

A serverless pipeline that bills completed tow jobs to an insurer's partner portal. It pulls the
finished invoice out of the towing company's dispatch software, rebuilds it in the insurer's
required shape, proves the two totals match, and submits it. Runs nightly per account and also
rotates the portal credentials on its own.

---

## Project Header Lines

**Tow123 Billing Automation** | TypeScript, AWS Lambda, SQS, DynamoDB, Secrets Manager, Pulumi, Zod

---

## Revenue Automation

- **Insurance Billing Automation:** Automated submitting completed tow invoices to an insurer's partner portal, replacing per-job manual entry.
- **Invoice Reconciliation:** Matches every dispatch line item to its insurer equivalent and refuses to submit when the two totals disagree.
- **Mileage and Time Math:** Converts flat dollar charges into the billable hours, days, and free-mile amounts the portal expects.
- **Per-Account Billing Rules:** Each towing company configures its own charge mappings and non-billable items without a code change.
- **Daily Billing Report:** Emails each company a per-invoice summary of what was billed and what needs a human.

## Reliability and Correctness

- **Manual-Review Escape Hatch:** An unmappable charge stops that one invoice and emails the exact reason instead of guessing a number.
- **Nightly Fan-Out:** A midnight job queues every account so invoices process independently, one account per worker.
- **Partial Batch Retry:** Failed invoices go back on the queue for up to 3 attempts while successful ones stay done.
- **Per-Invoice Isolation:** One bad invoice cannot fail the batch, so the rest of the night's billing still goes out.

## Security and Credentials

- **Automated Password Rotation:** Rotates the insurer portal password every 10 days and reconciles the new one into the dispatch software.
- **Policy-Compliant Password Generator:** Generates passwords with cryptographic randomness that satisfy the portal's rules and the support desk's phone-suffix convention.
- **Least-Privilege Roles:** Each function gets only the queue, table, and secret permissions it actually uses.

## Infrastructure

- **Infrastructure as Code:** Defined every queue, table, schedule, and IAM role in Pulumi across development and production stacks.
- **Reverse-Engineered Portal Login:** Reproduced the insurer's browser login, verification tokens, and cookie flow to run headless in Lambda.

---

## Skills Keyword Bank

**Languages** TypeScript, JavaScript, Node.js

**Cloud / Serverless** AWS Lambda, SQS, DynamoDB, EventBridge, Secrets Manager, STS, CloudWatch, IAM least privilege

**Infrastructure as Code** Pulumi, multi-stack environments, MongoDB Atlas provisioning, Cloudflare provisioning

**Backend** Event-driven architecture, queue workers, partial batch failure handling, retry and dead-letter design, scheduled jobs, esbuild bundling

**Data** Zod schema validation, DynamoDB single-table design, global secondary indexes, point-in-time recovery

**Integrations** Insurance partner portal automation, HTTP session and cookie handling, HTML token extraction, SendGrid transactional email

**Security** Credential rotation, CSPRNG password generation, secrets management, encrypted data at rest

**DevOps** GitHub Actions, environment-scoped deploys, Prettier and lint-staged pre-commit gates

**Domain** Towing and roadside billing, insurance invoice reconciliation, accounts receivable automation
