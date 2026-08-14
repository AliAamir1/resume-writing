---
client: Tow123 (operated by Flatout Solutions)
relationship: founding engineer / build partner — Ali built and continues to maintain the entire technical stack
domain: Roadside assistance, towing, fleet dispatch, motor-club integration
project_count: 5
status: active
codebase_root: /Users/ali/Documents/flatout-solutions/tow123-org
deployment: https://tow123.app/
---

# Tow123 — Client / Product Overview

**Tow123** is a roadside-assistance and towing platform plus a suite of operator-side automation tools that Ali builds for the towing industry through **Flatout Solutions**. What started as a two-app consumer marketplace ("Uber for towing") has evolved into a multi-product ecosystem covering the full operational lifecycle of a towing company:

1. **The marketplace** — consumer + provider apps for booking and fulfilling roadside services.
2. **The AI dispatcher** — a real-time dispatching console that talks to drivers, customers, motor clubs, and Towbook, with LLM-driven decisioning and human-in-the-loop approval.
3. **The AI voice agent** — a productized service Flatout sells to **other towing companies**, offering 24/7 AI phone answering, intake, dispatching, and ETA updates over the phone.
4. **Billing automation** — a serverless scraper/automation layer on top of **Towbook** (the dominant towing-management SaaS) that pulls invoice/billing data for analytics and downstream actions.
5. **AWS platform / IaC** — a Pulumi-based multi-account AWS organization that hosts everything above, with GitHub OIDC, Identity Center, SCPs, and StackSet-driven CI/CD.

## What I Built

### 1. [Tow123 Marketplace Platform](platform/) — the consumer-facing product
The original product: **dual apps** (rider/consumer + provider) connecting end-users to towing, fuel delivery, and flat-tire repair in real time. Provider side supports a **multi-location org hierarchy** (managers → dispatchers → drivers) with role-based access, real-time geolocation matching and tracking, and Stripe-powered payments. Stack: **Node.js + Express + MongoDB + Redis** backend, **React Native** mobile (rider) + **React/Vite** provider web app + **Socket.IO** for real-time. Live at https://tow123.app/.

### 2. [Dispatcher (AI Dispatch Console)](dispatcher/) — the operator brain
A Convex-backed real-time dispatching console where AI agents handle driver and customer SMS/voice conversations, monitor ETAs across active calls, auto-assign trucks, sync with **Towbook** (industry SMS-of-record), and integrate with motor clubs (e.g. **Bringg**). LLM-routed via **OpenRouter / Gemini / Anthropic** with **`@convex-dev/agent`**, agent-response approval gating, allowlists for outbound texting, and a deterministic **ETA engine** (deadhead drive time, true ETA, status-time-remaining). Has its own simulator for replaying Towbook + Bringg events.

### 3. [AI Voice Agent](voice-agent/) — productized service for other tow companies
A standalone service Flatout offers to **other towing companies**: a 24/7 AI phone receptionist that answers calls, qualifies intake (caller, location, vehicle, service type), dispatches the closest available truck, and sends customer ETA updates over the phone — replacing or augmenting in-house dispatchers. Built on **Twilio (voice + SMS)** + **LLM agents** (Anthropic / Google / OpenRouter via the Vercel AI SDK), shares the dispatcher's tool-calling layer (`conversationTools`, `driverConversationTools`, `locationAgent`, `vehicleIntelligence`) and Convex backend so a single call can read fleet state, pick the right driver, and write back to Towbook.

### 4. [Billing Automation](billing-automation/) — Towbook scraper & invoice ETL
Serverless **AWS Lambda** pipeline (TypeScript + esbuild) that logs into **Towbook** with cookie-based session auth, scrapes invoice/billing data via `axios` + `cheerio`, normalizes it, and writes it into DynamoDB / downstream services. Runs on EventBridge schedules with secrets in **AWS Secrets Manager**. Used to feed billing analytics and reconciliation flows that Towbook's UI doesn't expose cleanly.

### 5. [Infra](infra/) — Pulumi/AWS multi-account governance
A Pulumi (TypeScript) project that provisions the **AWS Organization** Tow123 runs on: hierarchical OUs (Workloads / Client Projects / Internal / Legacy), **Identity Center (SSO)** groups + permission sets (`AdministratorAccess`, `DeployAccess`, `ReadOnlyAccess`), **GitHub OIDC** + **CloudFormation StackSets** for parameterized per-repo CI/CD roles, and **two SCPs** — DevOps Platform Guardrails (prevent manual modification of CI/CD infra) and Sensitive Data Restrictions (block prod-secret reads). Same pattern Ali later applied at MTH Equities. The Tow123 server itself runs on **ECS Fargate** behind an **ALB** with **Parameter Store**-managed secrets, deployed via GitHub Actions OIDC.

## How They Fit Together

```
                ┌──────────────────────────────────────────┐
                │  Tow123 / Flatout AWS Platform (Pulumi)  │
                │  AWS Orgs · Identity Center · OIDC ·     │
                │  StackSets · SCPs · KMS Pulumi state     │
                └──────────────────┬───────────────────────┘
                       deploys into │
        ┌───────────────────┬───────┴────────┬──────────────────────┐
        ▼                   ▼                ▼                      ▼
┌───────────────┐  ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│ Marketplace   │  │ Dispatcher       │ │ Voice Agent      │ │ Billing          │
│ (ECS Fargate) │  │ (Convex + Vite)  │ │ (Twilio + LLMs   │ │ Automation       │
│               │  │                  │ │  + Convex)       │ │ (Lambda + EB)    │
│ Node/Express  │  │ React 19 +       │ │                  │ │                  │
│ MongoDB       │  │ Convex Agent     │ │ Voice/SMS        │ │ Towbook scraper  │
│ Redis         │  │ Twilio · Pusher  │ │ pipelines        │ │ DynamoDB/SQS     │
│ Stripe        │  │ Towbook · Bringg │ │ shared tooling   │ │ SendGrid alerts  │
│ Socket.IO     │  │ ETA engine       │ │ with dispatcher  │ │                  │
│ React Native  │  │ Event-relay      │ │                  │ │                  │
└───────┬───────┘  └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘
        │                   │                    │                    │
        └────── Towbook ◄───┴────────────────────┘                    │
                  │                                                   │
                  └────────────── feeds ──────────────────────────────┘
```

- **Marketplace ↔ Dispatcher**: when a job comes in via the consumer app or a motor-club integration, the dispatcher takes over operator-side workflow — assigning the truck, texting the driver, updating the customer.
- **Dispatcher ↔ Voice Agent**: the voice agent is a thin call-handling front-end that reuses the dispatcher's Convex tools and conversation prompts (`customerConversationPrompt.ts`, `conversationTools.ts`, `driverConversationTools.ts`, `locationAgent.ts`). Voice transcripts become the same conversation messages an SMS thread would.
- **All three ↔ Towbook**: Towbook is the system-of-record for many tow operators. Dispatcher, voice agent, and billing automation each integrate with it differently — dispatcher does **bidirectional realtime sync** with isOurWrite-style loop guards, billing does **scrape-only ETL**.
- **All four ↔ Platform**: every workload runs in its own AWS account under the Tow123 organization, deployed via GitHub OIDC with no long-lived credentials.

## Unified Tech Stack (across all 5 projects)

| Layer | Tools |
|---|---|
| Frontend (web) | React 19, TypeScript, Vite, TailwindCSS 4, shadcn/ui (Radix), Leaflet/React-Leaflet, Echarts, React Hook Form + Zod |
| Frontend (mobile) | React Native (consumer rider app) |
| Backend (apps) | Express 4, TypeScript, Node 20+, **Convex** (dispatcher + voice agent), Mongoose 7/9 + MongoDB, JWT auth, **Socket.IO** (legacy real-time), **Pusher** (newer real-time), **Redis (ioredis)** |
| Backend (serverless) | AWS Lambda, EventBridge, SQS, Secrets Manager, DynamoDB, SNS, CloudWatch |
| AI / Agents | **Vercel AI SDK** (`ai` v6), `@convex-dev/agent`, `@ai-sdk/anthropic`, `@ai-sdk/google`, `@openrouter/ai-sdk-provider`, Zod 4 tool-calling schemas |
| Voice / SMS | **Twilio (voice + SMS)**, custom Twilio-auth verification, **Resend** (transactional email), allowlist-based approval gating |
| Integrations | **Towbook** (scrape + bidirectional sync), **Bringg** (motor-club / Okta-OTP auth), **Stripe**, Google Maps Services, plate-to-VIN APIs, Firebase (legacy), SendGrid (legacy) |
| ETL & utilities | `tsx` runtime, `cheerio` (HTML scraping), `axios-cookiejar-support` + `tough-cookie` (session scraping), `puppeteer` (legacy), `nanoid`, `user-agents` |
| IaC | **Pulumi (TypeScript)** — AWS Organizations, Identity Center, IAM, CloudFormation StackSets, KMS, S3, Parameter Store |
| CI/CD | GitHub Actions with **OIDC keyless auth**, parameterized per-repo via StackSet |
| Hosting | **AWS ECS Fargate + ALB** (marketplace), **Convex** (dispatcher + voice agent backend), **Fly.io** (event-relay sidecar), AWS Lambda (billing), MongoDB Atlas |
| Testing | Vitest 4, `convex-test`, `@langwatch/scenario` (LLM scenario tests), integration + scenario configs, fixture-PII linter |

## Notable Engineering Highlights

- **Bidirectional Towbook sync** with a custom **`isOurWrite`** loop-guard — Convex tracks events the system itself just wrote so they don't trigger a reconciliation echo when Towbook's webhook fires back. Reconciliation jobs reconcile drift on a schedule.
- **`@convex-dev/agent` + Vercel AI SDK** with **per-call provider routing** (OpenRouter / Anthropic / Google) controlled by a `MODEL_PROVIDER` env, so the same agent code can A/B providers without redeploying.
- **Human-in-the-loop approval gating** for outbound customer SMS, driver SMS, and AI agent responses — separate `*ApprovalEnabled` toggles for SMS, conversations, and agent responses, with **allowlist mode** during onboarding so only whitelisted phone numbers receive AI-generated text.
- **Deterministic ETA engine** (`convex/etaEngine/`) — `deadheadDriveTime`, `trueEta`, `statusTimeRemaining`, `driverSelection`, `routing` — separated from LLM logic so dispatch decisions remain auditable; the LLM proposes, the engine prices, the dispatcher (or human) confirms.
- **Auto-dispatch + simulation**: `simulateDispatch.ts`, `simulateDriverSelection.ts`, scenario tests (`@langwatch/scenario`) replay full call flows offline before they hit production.
- **Twilio-auth verification** (`sms/twilioAuth.ts`) — request signature validation on inbound webhooks to keep adversarial calls out of the agent loop.
- **Event-relay sidecar** — a small Node.js (`tsx`) service on Fly.io that bridges **Pusher → socket.io-client** so legacy clients (and Towbook event streams) can speak to the new Convex-backed dispatcher without a full rewrite.
- **Vehicle intelligence** (`convex/vehicleIntelligence/`) — plate-to-VIN lookup integrated into the agent's toolchain so customer voice intake auto-fills vehicle metadata.
- **Multi-account AWS governance** (same pattern as MTH Equities) with two SCPs — DevOps guardrails + sensitive-data restrictions — and Identity Center permission sets scoped per environment so engineers get deploy access in dev, read-only in prod.
- **Fixture-PII linter** (`scripts/check-fixture-pii.ts`) — gates test fixtures so real customer data never lands in the repo.
- **Towbook session-scraping** (billing automation) — cookie jars + axios + rotating user-agents to keep an authenticated session against Towbook's web UI for invoice extraction.

## Per-Project Deep Dives

- [Marketplace Platform](platform/README.md) — the consumer marketplace + provider operations (legacy MERN monolith → IaC migration).
- [Dispatcher](dispatcher/README.md) — Convex + AI agent dispatching console with Towbook + Bringg integration.
- [Voice Agent](voice-agent/README.md) — productized 24/7 AI phone receptionist sold to other towing companies.
- [Billing Automation](billing-automation/README.md) — serverless Towbook invoice scraper.
- [Infra](infra/README.md) — Pulumi AWS multi-account org + ECS Fargate deployment pattern.

## Notes on Pitching

- For **founding-engineer / 0→1** pitches: lead with the dispatcher + voice agent — those are the parts where Ali is closest to product, model selection, and operator workflow design.
- For **infra / DevOps / platform** pitches: lead with the AWS Pulumi platform + ECS Fargate migration; the Tow123 platform repo is the same governance pattern Ali later reused at MTH Equities.
- For **AI / agents / Twilio / voice** pitches: voice agent + dispatcher (Convex Agent + Vercel AI SDK + multi-provider routing + human-in-the-loop approval).
- For **two-sided marketplace / mobile** pitches: the original platform (React Native consumer + role-based provider hierarchy + Redis-backed real-time geolocation).
- "Uber for towing" is a useful analogy only at the consumer-app layer — the operator-side product (dispatcher + voice agent + Towbook integration) is where the real complexity lives, and is the part most prospects haven't seen built before.
