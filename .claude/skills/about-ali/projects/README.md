# Projects Index

One file per project. Open the file before quoting details — frontmatter and the description hold the source of truth.

## How to Use This Index

- **Filter by audience?** Scan the `Target Market` column.
- **Filter by tech?** Scan the `Tech Stack` column or grep the directory: `grep -l -i "react native" deployed/*.md`.
- **Pick highlights for a pitch?** Don't guess from this table — open the 2–3 candidate files and read them.
- **Multi-project client engagements** live under [clients/](clients/) — each client has its own README plus per-project subfolders. Read the client README first when discussing any project from that engagement.

## Client Engagements (Multi-Project)

| Client | Folder | Projects | Stack Highlights |
|---|---|---|---|
| **MTH Equities** | [clients/mth-equities/](clients/mth-equities/README.md) | Equities Map · Property Data Enrichment · SNF Explorer · Platform (IaC) | Maplibre GL · Gemini · ScrapingBee · AWS Lambda · Pulumi (multi-account org) · MongoDB · Fly.io |
| **Tow123 (Flatout)** | [clients/tow123/](clients/tow123/README.md) | Marketplace · Dispatcher · **AI Voice Agent** · Billing Automation · Platform (IaC) | Convex · `@convex-dev/agent` · Vercel AI SDK · Twilio (voice + SMS) · Anthropic / Google / OpenRouter · Towbook + Bringg · ECS Fargate · Pulumi (multi-account org) · React Native + React 19 |
| **121 Air Sea Cargo** (UAE freight forwarder) | [clients/121-air-sea-cargo/](clients/121-air-sea-cargo/README.md) | Backend (Express + Prisma) · Ops Portal · Prototype Dashboard · Invoice Generator | Express + TypeScript · Prisma + PostgreSQL · Puppeteer + Handlebars (PDF) · Next.js 15 · TanStack Query · Axios · Radix · Vercel · AWS EC2 + PM2 |

## FlatOut Products (Multi-Component)

| Product | Folder | Components | Stack Highlights |
|---|---|---|---|
| **Rituo** | [products/rituo/](products/rituo/README.md) | App (mobile + admin + API) · Platform (IaC) · CloudForge (component lib) · Incidents | Expo · Next.js 15 · NestJS 10 · MongoDB · multi-provider AI · ElevenLabs · Firebase FCM · Pulumi multi-account · CloudForge |

> **CloudForge is portfolio-wide.** Lives at [products/rituo/cloudforge/](products/rituo/cloudforge/README.md) but is consumed by Rituo, [Kollaborative AI](deployed/kollaborative-ai.md), and the [MTH Equities Platform](clients/mth-equities/platform/README.md).

## Deployed (Live / Public)

| Project | File | Deployment | Tech Stack | Target Market |
|---|---|---|---|---|
| TSKR | [tskr.md](deployed/tskr.md) | https://tskr-black.vercel.app/auth/login | Next.js, MongoDB, Socket.IO | Freelancers, Startups, Agencies |
| joinpangia | [joinpangia.md](deployed/joinpangia.md) | https://joinpangia.com/ | LangChain, Python, FastAPI, Node.js, Firebase, GCP, SvelteJS, OpenAI | Journalists, news consumers |
| SIMuSPACE | [simuspace.md](deployed/simuspace.md) | https://172.24.0.112/ (internal) | Next.js, Java, Python | Companies with large data |
| REHQ | [rehq.md](deployed/rehq.md) | (Loom only) | — | — |
| Kollaborative AI | [kollaborative-ai.md](deployed/kollaborative-ai.md) | https://kollaborativeai.com/ | Next.js 15, React 19, Convex (real-time), Clerk, OpenAI (GPT-5 family) + Anthropic (Claude 4.6) + Google (Gemini 3), MCP, Pulumi, AWS (ECS Fargate, ALB, ECR, Route53, SES) | Teams replacing 6.7-tool sprawl with one multi-provider AI workspace — real-time collab, custom @mention experts, dynamic RBAC |
| Alvanda | [alvanda.md](deployed/alvanda.md) | https://alvanda.com/ | React, Redis, Socket.IO, MongoDB, Express, Node.js, TypeScript | B2B, business process automation |
| Startir.AI | [startir-ai.md](deployed/startir-ai.md) | https://startir.ai | OpenAI API, FastAPI, MySQL, Next.js, ShadCN | AI edtech, students |
| Omnilocal | [omnilocal.md](deployed/omnilocal.md) | https://www.omnilocal.com/ | Next.js, ETL, Prisma, AWS, GCP, Convex, Clerk, MySQL, Shadcn | Real estate, scraping |
| Convify | [convify.md](deployed/convify.md) | https://conv-main.picreel.bid/ | Next.js, NextAuth, Docker, GH Actions, Redux, MySQL, Prisma, Shadcn, Craft.js | Growing startups, marketing groups |
| PerigonAi | [perigon-ai.md](deployed/perigon-ai.md) | https://dev.d3hvlop6nn9b37.amplifyapp.com/ | React, AWS Amplify, MapBox, Tailwind | Storytelling, real estate |
| Crypto Chart CLI | [crypto-chart-cli.md](deployed/crypto-chart-cli.md) | https://antematter-demo.vercel.app/ | Next.js, Firebase Storage, Vercel, Tailwind, hookState | Crypto market |
| GGMS CMS | [ggms-cms.md](deployed/ggms-cms.md) | https://mergestack-com.site-dev.ggms.com/listings/ | Vanilla JS, Docker, AWS (EC2/ECR), GH Actions, GCP Maps, PHP, WordPress | Real estate |
| GGMS Marketing Suite | [ggms-marketing-suite.md](deployed/ggms-marketing-suite.md) | https://ggms-plus.ggms.com/ | MERN + TS, AWS (EC2/ECR), Docker, GH Actions, scraping | Real estate agents, lead gen |
| Career Coach | [career-coach.md](deployed/career-coach.md) | https://beta.verdax.co.uk/ | OpenAI Assistants API (file_search + threads), Next.js 14, NextAuth, Node.js, Express, MongoDB, Cloudinary, TypeScript, Tailwind, Radix/Shadcn | AI edtech, students, career-changers |
| Organyz | [organyz.md](deployed/organyz.md) | https://app.organyz.com/app | FastAPI, LangGraph, AWS (Sagemaker, Bedrock, RDS), HuggingFace, OpenAI | AI asset management |
| ROAS | [roas.md](deployed/roas.md) | https://app.roas.ai (configured) · https://dev.roas.flatout.solutions | NestJS 10, Next.js 15, MongoDB Atlas, Pulumi (CloudForge two-stack), AWS ECS, Stripe, Meta Marketing API, GoHighLevel API, SendGrid | Performance marketers, Meta-ads agencies, GHL users — closed-loop spend↔CRM attribution |

## Internal / HTTP-only / Demo

| Project | File | Deployment | Tech Stack | Target Market |
|---|---|---|---|---|
| Jarvis | [jarvis.md](internal/jarvis.md) | http://3.17.28.83:3000 | OpenAI API, Twilio, React, FastAPI | Sales / lead management |
| PhotoMentor | [photomentor.md](internal/photomentor.md) | http://100.25.153.104:3000/ | OpenAI API, FastAPI, React, TypeScript | Photographers learning |
| LandscapeAI | [landscape-ai.md](internal/landscape-ai.md) | http://100.25.153.104:3000/ | HuggingFace, React, FastAPI, TypeScript | Designers, ideation |

## Quick Filters (Common Asks)

- **AI / LLM projects:** joinpangia, Startir.AI, Career Coach, Organyz, Jarvis, PhotoMentor, LandscapeAI, **Kollaborative AI** (multi-provider — GPT-5/Claude 4.6/Gemini 3 — mid-conversation switching, MCP, RAG-backed `@mention` agents), **MTH Property Data Enrichment** (Gemini), **Rituo** (Vercel `ai` SDK with OpenAI/Anthropic/Google/Mistral/Groq/XAI/Azure factory)
- **Multi-provider LLM / model-routing:** **Kollaborative AI**, **Rituo** (Vercel `ai` SDK factory)
- **MCP integrations:** **Kollaborative AI**
- **NestJS backends:** **Rituo**, **ROAS**
- **Marketing analytics / ad attribution:** **ROAS** (Meta Marketing API + GoHighLevel; first-touch & last-touch attribution; hourly campaign sync)
- **Stripe / SaaS billing:** **ROAS** (Stripe + `SubscriptionGuard` gating analytics, OAuth-init, widgets)
- **Third-party OAuth integrations:** **ROAS** (Meta + GoHighLevel), **Kollaborative AI** (Clerk-mediated)
- **Reusable Pulumi component libraries:** **CloudForge** (used in Rituo, Kollaborative AI, MTH Platform)
- **Production incident postmortems / RCAs:** [Rituo ECR Lifecycle 2026-04-15](products/rituo/incidents/ecr-lifecycle-rca.md)
- **Real estate:** Omnilocal, GGMS CMS, GGMS Marketing Suite, PerigonAi, **MTH Equities Map**, **MTH SNF Explorer**, **MTH Property Data Enrichment**
- **B2B SaaS / workflow:** Alvanda, SIMuSPACE, Convify, TSKR, **121 Air Sea Cargo Ops Portal** (freight ops + multi-currency invoicing)
- **Logistics / freight / supply chain:** **121 Air Sea Cargo** (air, sea, road, UAE-domestic; 18-model Prisma schema; polymorphic Job model)
- **Express + Prisma backends:** **121 Air Sea Cargo** (modular monolith · 13 domain modules · `controller/service/repo/validator/routes` per module · Swagger auto-generated)
- **PDF generation (server-side):** **121 Air Sea Cargo Backend** (Puppeteer + Handlebars HTML template), **MTH Property Data Enrichment** (Gemini-rendered docs)
- **PDF generation (client-side):** **121 ASC Invoice Generator** (jsPDF + dom-to-image)
- **Multi-currency / VAT / accounting:** **121 Air Sea Cargo** (per-company VAT rates, exchange-rate per invoice, SALE/PURCHASE × CREDIT variants, OWN/THIRD_PARTY line items)
- **Marketplaces / two-sided:** TSKR, Tow123
- **Mobile (React Native):** Tow123, **Rituo** (Expo SDK 54 · React Native 0.81 · Expo IAP · Expo Updates OTA)
- **Wellness / consumer mobile / habit-building:** **Rituo**
- **Heavy infra (AWS / GCP):** Omnilocal, GGMS Marketing Suite, GGMS CMS, Organyz, PerigonAi, **MTH Property Data Enrichment**, **MTH Platform**, **Kollaborative AI** (Pulumi · ECS Fargate · ALB · Route53 · SES · GitHub OIDC), **ROAS** (Pulumi · CloudForge · ECS · Route53 · Cloudflare · MongoDB Atlas · GitHub OIDC)
- **Geospatial / mapping:** PerigonAi (MapBox), GGMS CMS (Google Maps), **MTH Equities Map** (Maplibre GL + PMTiles + Tippecanoe), **MTH SNF Explorer** (Maplibre GL + clustering)
- **Infrastructure-as-Code:** **MTH Platform** (Pulumi · AWS Organizations · SCPs · Identity Center · GitHub OIDC · CloudFormation StackSets), **Kollaborative AI** (Pulumi · two-stack split · CloudForge component lib · OIDC-only CI auth), **ROAS** (Pulumi two-stack `platform/` + `protected/` · CloudForge · MongoDB Atlas provider · Cloudflare provider)
- **Convex / serverless DB:** **Kollaborative AI**
- **Real-time multi-user collaboration:** **Kollaborative AI**, **MTH Equities Map** (Pusher), Alvanda (Socket.IO)
- **AWS Lambda / serverless:** **MTH Property Data Enrichment** (5 lambdas, SQS, DLQ redrive, EventBridge, API Gateway)
- **Multi-account / governance:** **MTH Platform**
