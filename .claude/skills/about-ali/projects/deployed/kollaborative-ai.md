---
name: Kollaborative AI
status: deployed
deployment: https://kollaborativeai.com/
loom: https://www.loom.com/share/8c4e51483f5a45a2bcbee950e00c9ec0
target_market: Teams that want a single multi-provider AI workspace with real-time collaboration, custom expert agents, and org-level governance — replacing the 6.7-tool-per-team status quo
tech_stack: Next.js 15, React 19, TypeScript, Tailwind 4, shadcn/ui, Convex (DB + real-time + actions), Clerk (auth), OpenAI (GPT-5/5.1/5.2/Mini/Nano/Codex/Pro), Anthropic (Claude 4.5/4.6 — Opus, Sonnet, Haiku), Google (Gemini 2.5, 3 Flash, 3 Pro), MCP, Pulumi (TypeScript), AWS (ECR, ECS Fargate, ALB, Route53, SES), CloudForge, GitHub Actions OIDC
codebase: /Users/ali/Documents/flatout-solutions/kollaborativeai
legal_entity: FlatOut Ventures LLC
tagline: "One Workspace, Every Model, Your AI Experts"
---

# Kollaborative AI

The AI workspace built for **teams**, not individuals. One unified surface for **GPT, Claude, and Gemini** with **mid-conversation model switching**, **real-time team chat collaboration** (the headline feature), **custom AI experts** ("Kollaborators") your whole team can `@mention`, **dynamic RBAC**, and **MCP** support.

Tagline: *"One Workspace, Every Model, Your AI Experts."*

Owned by **FlatOut Ventures LLC**.

> **Note on currency:** The deep-dive below merges (a) the live product surface from kollaborativeai.com and (b) what the local repo at `/Users/ali/Documents/flatout-solutions/kollaborativeai` actually contained when last read. Some live-product features — multi-provider, Kollaborators, MCP, 4-tier RBAC — are recent and may not all be visible in the older code snapshot. **Re-read the repo before quoting implementation details.**

## What Makes It Different (vs. ChatGPT / Claude / Gemini)

| Capability | Kollaborative | ChatGPT | Claude | Gemini |
|---|---|---|---|---|
| Real-time team collaboration | ✅ | ❌ | ❌ | ❌ |
| Custom AI agents (`@mention`) | ✅ | ❌ | ❌ | ❌ |
| Multiple models, one workspace | ✅ | ❌ | ❌ | ❌ |
| **Switch models mid-conversation** | ✅ | ❌ | ❌ | ❌ |
| Space-level context inheritance | ✅ | ❌ | ❌ | ❌ |
| Org-level system prompts | ✅ | ❌ | ❌ | ❌ |
| Centralized API key management | ✅ | ❌ | ❌ | ❌ |
| Team & role management | ✅ | ❌ | ❌ | ❌ |

The pitch: today's AI tools were built for individuals. Kollaborative is the team-native layer — context shared, models interchangeable, governance centralized.

## Models Supported

- **OpenAI:** GPT-5, 5.1, 5.2, Mini, Nano, **Codex** variants, Pro models
- **Anthropic:** Claude 4.5 / **4.6** — Opus 4.6 with **adaptive thinking**, Sonnet, Haiku, with extended thinking and deep reasoning
- **Google:** Gemini 2.5, **3 Flash**, **3 Pro** — massive context windows
- **MCP** support for tool/data integrations

**Model switch mid-conversation preserves the entire history** — no platform lock-in, no lost context. This is the core technical claim.

## Headline Features

### 1. Real-time Team Collaboration (the biggest feature)
The whole platform is built real-time-first — that's *why* it was built. Multiple teammates work on the same conversations and Spaces simultaneously, share context, and stay in sync via Convex's subscription model. "Stop sending AI screenshots in Slack. Start actually collaborating."

### 2. Kollaborators — Custom AI Experts (`@mention`)
Create specialized AI agents trained on your domain — DevOps, legal, product, anything. **`@mention` them from any conversation** to pull in expert answers. RAG-backed, learn and improve with every interaction. Domain experts as first-class entities, not "custom GPTs" hidden in a sidebar.

### 3. Switch Models Mid-Conversation, Keep Everything
GPT for drafting → Claude for reasoning → Gemini for long-context analysis — all in the same thread, history preserved across providers.

### 4. Spaces with Shared Context
Spaces hold system prompts that **apply to every conversation inside them**. Teams inherit the right context automatically — no re-explaining the project on every chat.

### 5. Dynamic RBAC — Org Governance
Four-tier roles: **Owner / Manager / Member / Guest**. System prompts settable at **org / space / user** levels. **Centralized API key management** at the org. Granular sharing (conversations, Spaces). Compliance-friendly auditing of who's using what.

### 6. MCP Support
First-class **Model Context Protocol** integration so teams can plug in tools/data sources without bespoke glue.

### 7. Power User Features
Adjustable **thinking / reasoning levels** (none → high), **web search**, file & image uploads, drag-and-drop, paste screenshots, edit sent messages, stop streaming responses anytime.

## Architecture

```
   ┌────────────────────────────┐
   │  Next.js 15 (App Router)   │  Tailwind 4, shadcn/ui, React 19
   │  Hosted: ECS Fargate + ALB │  Domain: app.kollaborativeai.com (Route53 → ALB)
   └──────────────┬─────────────┘
                  │ Convex client SDK — real-time subscriptions, mutations, streaming actions
   ┌──────────────▼──────────────┐
   │  Convex (managed serverless)│  Users · orgs · teams · spaces · conversations
   │  • DB · queries · mutations │  · messages · invites · access grants · Kollaborators
   │  • Real-time subscriptions  │  · system prompts · `_storage` (files)
   │  • `actions` (server-only)  │
   └──────────────┬──────────────┘
        ┌─────────┼─────────────┬───────────────┐
        ▼         ▼             ▼               ▼
   ┌────────┐ ┌────────┐  ┌──────────────┐ ┌──────────┐
   │ Clerk  │ │ OpenAI │  │  Anthropic   │ │  Google  │
   │  auth  │ │  GPT-5 │  │  Claude 4.6  │ │  Gemini  │
   │ +hooks │ │  + …   │  │  + Opus/etc. │ │   3 Pro  │
   └────────┘ └────────┘  └──────────────┘ └──────────┘
                  │             │               │
                  └──────┬──────┴────────┬──────┘
                         ▼               ▼
                   Streaming Responses    MCP servers
                   (reasoning + content)  (tools / data)

   Email: AWS SES (invites)        Webhooks: Svix (optional)
```

There is **no bespoke backend service.** Convex is DB + queries + mutations + actions; Clerk is auth; provider SDKs handle inference; SES handles email. The "backend" is composed.

## Tech Stack (Detailed)

### Frontend (`frontend/`)
- **Next.js 15.3.1** (App Router), **React 19**, **TypeScript**
- **Tailwind CSS v4**, **shadcn/ui**, `lucide-react`, `sonner`
- **Convex** `^1.24.8` — DB client, real-time subscriptions, server functions
- **Clerk** `@clerk/nextjs ^6.22` — auth UI + session management
- **OpenAI** `^5.12.2` — Responses API streaming (verified in `frontend/src/convex/openAi.ts`)
- **Anthropic SDK** + **Google Gemini SDK** for the multi-provider expansion (live product feature; check current repo for exact wiring)
- **MCP** client integration (live product; verify in current repo)
- `react-hook-form`, `zod`, `react-markdown`, `svix`
- Dockerized — multi-stage build, runs on port 3000

### Infrastructure (`infra/`)
- **Pulumi** (TypeScript), AWS provider, custom **CloudForge** library
- **Two independent Pulumi stacks:**
  - `protected/` — Route53 hosted zone + optional Cloudflare nameserver mirroring; runs once, shared across environments
  - `platform/` — Docker image build → **ECR** → **ECS Fargate** services behind **ALB**, **SES** verification, Route53 A records
- **Stacks / environments:** `dev`, `staging`, `prod` (Pulumi YAML configs + matching GH Actions triggers)

### CI/CD (`.github/workflows/`)
- `prod.yml` — push to `main` (or `workflow_dispatch`) → calls reusable workflow
- `infra-deploy.yml` — reusable: detects what changed (frontend / infra / backend), builds the Next.js image, runs `pulumi up`. **OIDC-only AWS auth** — no static keys

## Auth & Data Model

- **Clerk webhook** → `frontend/src/convex/clerk.webhook.ts` syncs user lifecycle events into Convex.
- **Permissions** enforced in Convex functions (`conversationAccess.ts`, `spaceTeamAccess.ts`, etc.). **Dynamic 4-tier RBAC** — Owner / Manager / Member / Guest — with team-membership inheritance.
- **System prompts** settable at **org / space / user** levels and inherited downward.
- **Per-org BYOK** — orgs configure their own provider keys (centralized management); also supports the platform-managed key with usage allowances.

## Pricing & Business Model

| Tier | Price | What you get |
|---|---|---|
| **Free** | $0 | Managed AI · $1 usage cap · all models (GPT-5, Claude, Gemini) · real-time collaboration · 50 MB Knowledge Base · **no Teams** |
| **BYOK** | **$5/user/month** ($50/yr) | Bring your own keys · unlimited usage on your keys · Teams & sharing · 500 MB Knowledge Base · centralized key management |
| **Pro** *(recommended)* | **$25/user/month** ($250/yr) | Managed AI · **$20/seat monthly allowance pooled** · all models · Teams & sharing · 2 GB Knowledge Base · pay-per-use after allowance |
| **Enterprise** | Custom | Custom limits · invoice billing · dedicated support + SLA · **SSO/SAML** · **on-prem deployment option** |

## Headline Stats (from landing page)

- **3–5 hours saved** per person weekly
- **6.7 → 1** tools consolidated
- **100% context** preserved across models
- **85%** of companies haven't achieved mature collaboration

## Notable Engineering

1. **No bespoke backend** — Convex + Clerk + provider SDKs compose the entire server side. Ops surface = "Next.js container + managed services."
2. **Mid-conversation model switching with full history transfer** — the technical core of the product. Hard problem because each provider has its own message format, tool-use schema, and reasoning representation.
3. **Real-time-first architecture** — the product was built around Convex subscriptions specifically *because* live team collaboration is the headline feature.
4. **Multi-level system-prompt inheritance** (org → space → user) implemented at the data layer, not just as UI sugar.
5. **Two-stack Pulumi separation** — DNS in long-lived `protected`, ephemeral compute in `platform`. `pulumi destroy` on platform never touches the hosted zone.
6. **CloudForge component library** — reusable VPC / ECS / ALB / SES abstractions across FlatOut's projects. Full writeup at [products/rituo/cloudforge/README.md](../products/rituo/cloudforge/README.md). Same library powers Rituo and the MTH Equities app infra.
7. **OIDC-only AWS auth in CI** — no static AWS credentials anywhere.
8. **Dynamic RBAC** with four roles + per-conversation / per-space sharing grants, enforced inside Convex functions.

## Key File Paths (verified at last repo read; structure may have moved)

- `/Users/ali/Documents/flatout-solutions/kollaborativeai/README.md`
- `frontend/package.json`
- `frontend/src/convex/openAi.ts` — streaming OpenAI Responses-API action
- `frontend/src/convex/conversations.ts` — conversation CRUD + permission checks
- `frontend/src/convex/clerk.webhook.ts` — Clerk → Convex user sync
- `frontend/Dockerfile` — multi-stage build for Fargate
- `infra/package.json` — Pulumi + CloudForge + AWS SDKs
- `infra/protected/` — Route53 + Cloudflare NS stack
- `infra/platform/` — ECR + ECS + ALB + SES stack
- `.github/workflows/prod.yml` · `.github/workflows/infra-deploy.yml`

## Notes

- "Collaborative" here = **real-time multi-user team workspaces**. That is the **biggest feature** and the reason the platform exists. Lead with it in any pitch.
- Multi-provider model-switching is the second pillar. Together they're the moat: collaboration + portability.
- Kollaborators (RAG-backed `@mention` agents) is the third pillar — closer to "custom GPTs" but team-shared and cross-conversation.
- MCP support is part of the current pitch — confirm it's wired in the current repo before discussing implementation.
- Same Pulumi-on-AWS pattern as the [MTH Equities Platform](../clients/mth-equities/platform/README.md), but applied at app-stack scope (ECS/ALB) rather than org-governance scope.
- Loom walkthrough: https://www.loom.com/share/8c4e51483f5a45a2bcbee950e00c9ec0
