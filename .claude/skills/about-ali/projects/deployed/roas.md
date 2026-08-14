---
name: ROAS
status: deployed
deployment: https://app.roas.ai (prod domain configured) · https://dev.roas.flatout.solutions (dev)
loom: none
target_market: Performance marketers, Meta-ads-running agencies, DTC brands, GoHighLevel users, founders tracking attribution
tech_stack: NestJS 10, MongoDB, Mongoose, Next.js 15, React 19, TypeScript, Tailwind 4, ShadCN, React Hook Form, Zod, Pulumi, AWS (ECS, S3, Secrets Manager), CloudForge, Cloudflare, MongoDB Atlas, Route53, Stripe, Meta Marketing API, GoHighLevel API, SendGrid, Passport (JWT/Google/Facebook/Apple), @nestjs/schedule, GitHub Actions OIDC
---

# ROAS

## Description

A multi-tenant marketing analytics SaaS that closes the loop between **Meta ad spend** and **GoHighLevel CRM outcomes**. Users connect their Facebook ad accounts and their GHL sub-account via OAuth; ROAS pulls campaigns / adsets / ads + spend on an hourly cron, syncs GHL contacts and opportunities, and computes **first-touch and last-touch attribution** so a campaign can be tied directly to leads and revenue. The reporting endpoints (`/analytics/spend`, `/analytics/sales`, `/analytics/leads`, `/analytics/roas`) feed a Next.js dashboard that lets agencies prove what ad dollars actually produced pipeline.

The product is built around the concept of a **Business Account** — an organisation entity owned by a user that holds the Meta OAuth, the GHL OAuth, and the sync state machine (`onboardingStep`: `not_started → meta → ghl → finished`; per-stream `SyncStatus` for contacts and opportunities). One user can run multiple business accounts, each with multiple ad accounts. Stripe + a `SubscriptionGuard` gate access to the analytics, OAuth-init, and widget endpoints, so the whole thing is pay-to-play. There's also an **embeddable widget** module — branded snippets a customer can drop into their own site, scoped per business account.

Owned by **FlatOut Solutions** (repo: `flatoutsolutions/roas`). Built on the same NestJS + Next.js + Pulumi + CloudForge foundation as Rituo and Kollaborative AI, with the same two-stack infra split (`platform/` for the AWS hosted zone + secrets, `protected/` for app resources) and Git-SSH-pinned CloudForge components.

## Tech Stack

- **Backend:** NestJS 10, Mongoose 8 / MongoDB, JWT + Passport (local + Google + Facebook + Apple), `nestjs-pino`, `@nestjs/schedule`, `class-validator` + `class-transformer`, OpenAPI/Swagger
- **Frontend:** Next.js 15 (App Router, Turbopack), React 19, TypeScript 5, Tailwind 4, ShadCN/Radix, React Hook Form + Zod, `@tanstack/react-table`, Sonner, `next-themes`, `@t3-oss/env-nextjs`
- **AI / data sources:** Meta Marketing API (OAuth + campaigns/adsets/ads + spend); GoHighLevel API (OAuth + contacts + opportunities); attribution computed in-app (first/last touch arrays on the Campaign schema)
- **Billing:** Stripe (`stripe` SDK + dedicated `subscription` module, gated by `SubscriptionGuard`)
- **Email:** SendGrid (transactional)
- **Storage / secrets:** AWS S3, AWS Secrets Manager (Mongo URI + backend secrets resolved at runtime via `SecretsManagerService`)
- **IaC:** Pulumi (TypeScript), two-stack split — `infra/platform/` (Route53 hosted zone, Cloudflare nameservers, backend Secret) + `infra/protected/` — consuming **CloudForge** (`@dopetech/cloudforge` via Git-SSH) for Route53 / S3 / Secret / Cloudflare components
- **DNS / CDN:** Route53 hosted zone with optional Cloudflare nameserver migration
- **Database:** MongoDB Atlas (Pulumi-provisioned)
- **CI/CD:** GitHub Actions with **AWS OIDC** (no long-lived keys), per-env workflows (`dev.yml`, `prod.yml`, `deploy-protected-{dev,prod}.yaml`, `infra-deploy.yml`); SSH-agent for the private CloudForge dependency
- **Tooling:** Yarn, Husky, ESLint + Prettier, Jest (backend), Docker

## Target Market

- **Meta-ads-buying agencies** that need to report "you spent $X, here's $Y in pipeline" per client
- **DTC and lead-gen brands** running Facebook/Instagram ads with GoHighLevel as the CRM
- **GHL agencies** ('SaaS-mode' GHL operators) wanting an attribution layer their existing platform doesn't natively give
- **Founders / fractional CMOs** who need ROAS dashboards without standing up a custom data warehouse + BI stack

## Links

- Repo: `git@github.com:flatoutsolutions/roas.git`
- Codebase: `/Users/ali/Documents/flatout-solutions/roas/`
- Production domain (configured): https://app.roas.ai
- Dev: https://dev.roas.flatout.solutions

## Notes

- **Two integrations, one closed loop.** Meta gives spend; GHL gives outcomes; the attribution arrays on the `Campaign` schema (`firstAttributionContacts`, `firstAttributionOpportunities`, `lastAttributionContacts`, `lastAttributionOpportunities`) are how ROAS gets computed without a separate data pipeline. This is the product's whole pitch — every other ROAS dashboard either reads only Meta or only GHL.
- **Hourly background sync.** `CampaignCron` (in `backend/src/campaigns/campaign.cron.ts`) walks every business account → every connected Meta ad account → syncs campaigns/adsets/ads, with per-account success accounting and a re-entrancy lock (`isRunning`). Failures are isolated per ad account so one bad token doesn't tank the whole job.
- **Same FlatOut platform pattern as Rituo / Kollaborative AI.** Two-stack Pulumi split, CloudForge Git-SSH dep, GitHub Actions OIDC into AWS, secrets fetched from Secrets Manager at boot. If the conversation goes deeper than "we use Pulumi," that's the connective tissue across Ali's FlatOut work — same ergonomics across products.
- **Backend `package.json` is named `thrive-backend` and the frontend is `boiler-plate-next`.** These are leftovers from the boilerplate fork (the original NestJS template was at `AgencyBox/boiler-plate-nest`); the README still describes the repo as a "monorepo template." That's misleading — the source tree has 14 NestJS modules of real product logic (analytics, business-accounts, campaigns, contacts, ghl, meta, opportunities, stripe, subscription, widget, etc.). When pitching, treat the README as historical and quote from the modules.
- **Multi-tenant onboarding state machine.** `BusinessAccount.onboardingStep` (`not_started → meta → ghl → finished`) plus per-stream `SyncStatus` enums (`not_started | in_progress | completed | failed`) drive the frontend onboarding flow under `frontend/src/app/(onboarding)/`. Clean, server-driven — no client state machine to keep in sync.
- **What to highlight when pitching:** the closed-loop attribution model (most "ROAS dashboards" are just Meta repackaged), the multi-tenant sync architecture with per-account isolation, and the production-grade FlatOut infra (OIDC-only AWS, two-stack Pulumi, Cloudflare + Route53, MongoDB Atlas all IaC). De-emphasise the boilerplate naming — the product name is **ROAS** and the brand domain is `roas.ai`.
- **Status caveat (2026-04-29):** repo and infra are live, prod domain is configured in `Pulumi.prod.yaml` (`app.roas.ai`), prod workflow exists. Public availability of `app.roas.ai` was not verified at the time of writing — confirm before quoting "live customers."
