# Kollaborative AI: Resume Bullet Bank

22 bullets. Every number traces to code in this repo. Pick 3 to 5 per resume.

---

## Project Header Lines

- **Kollaborative AI** | TypeScript, Next.js 15, React 19, Convex, Clerk, AWS ECS Fargate, Pulumi
- **MCP Proxy** | TypeScript, Cloudflare Workers, OAuth 2.0
- **CCCollab MCP Proxy** | TypeScript, Cloudflare Workers, Vitest

---

## AI and Retrieval

- **Model Cost Benchmarking:** Benchmarked summarization models and shipped one 12x cheaper than Claude Haiku 4.5 with 5x the context window.
- **Batch Embedding Design:** Rewrote reindexing into a single batched call after finding a per-message loop wasted 99% of the 1000-input budget.
- **Contextual Embeddings:** Embedded conversation chunks as one group so the model contextualizes across messages instead of isolating each.
- **Crash-Safe Reindexing:** Ordered embedding before deletion so a failed reindex leaves existing vectors intact and safely re-runnable.
- **Multi-Provider Streaming:** Streamed responses from OpenAI, Anthropic, and Google behind one interface, flushing partial output every 150ms.
- **Silent-Failure Prevention:** Emitted a greppable truncation warning when reindexing hits its page cap, rather than under-indexing quietly.
- **Per-Task Model Routing:** Selected the best model per task across all providers, independent of which API keys the customer configured.

---

## Reliability

- **Timeout Recovery:** Scheduled a 9.5-minute guardian that force-completes messages the platform's 10-minute action limit would otherwise strand forever.
- **Stale Job Reclamation:** Ran a 5-minute cron recovering messages stuck in progress past 10 minutes.
- **Rate-Limit Honesty:** Documented that job staggering gives no rate-limit protection under a shared API key, and scoped the real fix.

---

## Protocol and Integration

- **MCP OAuth Server:** Implemented a full OAuth 2.0 authorization server for Model Context Protocol, covering clients, codes, tokens, and flows.
- **Edge Proxy:** Deployed a Cloudflare Worker proxying MCP traffic onto the product's own domain.
- **Identity Reconciliation:** Built account-merge logic collapsing duplicate users while preserving the highest role each held.

---

## Data Model and Access Control

- **Schema Design:** Modeled 41 tables with 178 indexes spanning organizations, spaces, teams, threads, and per-resource access grants.
- **Vector Search:** Added vector and full-text indexes powering retrieval across Kollaborator and Space knowledge bases.
- **Multi-Tenant Permissions:** Enforced organization, space, team, thread, and conversation grants inside every backend function, not the UI.

---

## Infrastructure and CI

- **Path-Filtered CI:** Split the pipeline on change detection so frontend and backend deploy independently instead of together.
- **Keyless Cloud Auth:** Authenticated CI to AWS over OIDC with zero long-lived credentials in the repository.
- **Container Deployment:** Shipped a multi-stage Docker build to ECS Fargate behind an ALB, provisioned entirely in Pulumi.
- **Secret Synchronization:** Automated pushing environment secrets to the backend as a deploy stage.

---

## Testing

- **Test Suite Scale:** Wrote 2,701 test cases across 246 files covering backend functions and React components.
- **Pre-Commit Enforcement:** Gated every commit on format, lint, and type checks through Husky.

---

## Skills Keyword Bank

**Languages:** TypeScript, JavaScript, SQL

**Frontend:** React 19, Next.js 15, App Router, Tailwind CSS, shadcn/ui, Radix, React Hook Form, Zod

**Backend:** Convex, serverless functions, real-time subscriptions, cron scheduling, webhooks, REST

**AI:** OpenAI, Anthropic Claude, Google Gemini, OpenRouter, RAG, vector search, embeddings, contextual retrieval, streaming inference, prompt engineering, Model Context Protocol

**Auth and Security:** Clerk, OAuth 2.0 authorization server, RBAC, multi-tenant access control, API key encryption

**Cloud and Infra:** AWS ECS Fargate, ALB, ECR, Route53, SES, Pulumi, Infrastructure as Code, Docker, Cloudflare Workers, Wrangler

**DevOps:** GitHub Actions, OIDC, path-filtered CI, monorepo, Yarn, Volta, Husky

**Testing:** Vitest, Playwright, React Testing Library

---

## Report

**Strongest 5.** Each names a decision with a measured consequence, which is what a reader cannot get from a job title.

1. **Batch Embedding Design** - 99% waste found and eliminated. A measured before and after on a non-obvious bug.
2. **Model Cost Benchmarking** - 12x cost delta with the context tradeoff named. Shows cost ownership, not just API usage.
3. **Timeout Recovery** - 9.5 against a 10-minute platform ceiling. Demonstrates reading the platform's limits and engineering inside them.
4. **MCP OAuth Server** - implementing an OAuth authorization server is rare and currently in demand.
5. **Test Suite Scale** - 2,701 tests is a hard number most candidates cannot produce.

**Resting on scope, drop these first when space is tight.** Container Deployment, Keyless Cloud Auth, Secret Synchronization, Schema Design, Multi-Tenant Permissions, Pre-Commit Enforcement, Edge Proxy. All describe what exists rather than what changed.

**Could not verify.** No runtime metrics exist anywhere in the repo: no user counts, revenue, latency percentiles, or uptime. The pricing tiers quoted in the old skill file came from the marketing site, not this code. Nothing here supports a claim about adoption or business outcome.
