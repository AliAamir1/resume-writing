---
client: 121 Air Sea Cargo
public_site: https://121asc.com
domain: Freight forwarding & logistics — air, sea, road, UAE domestic
location: UAE
relationship: contractor / build partner
project_count: 4 components (1 production backend · 1 production ops portal · 1 prototype dashboard · 1 standalone invoice generator)
status: active
---

# 121 Air Sea Cargo — Client Overview

**121 Air Sea Cargo** ([121asc.com](https://121asc.com)) is a UAE-based freight forwarder handling **air, sea, road, and UAE-domestic** cargo movements. Ali built (and continues to build) their internal operations stack: a multi-modal job/shipment management system with VAT-aware multi-currency invoicing, server-side PDF generation, polymorphic address book, fleet (drivers + vehicles), and a closed-loop sales/purchase invoice flow.

## What I Built

Four codebases in the same monorepo at `/Users/ali/Documents/web-projects/cargo/`:

1. **[backend/](backend/README.md)** — `cargo-backend` — the production Express + TypeScript + **Prisma + PostgreSQL** API. **18 Prisma models**, 13 domain modules, polymorphic Job model with 1:1 specializations for AirJob / RoadJob / SeaJob / UAEJob. Server-side **Puppeteer + Handlebars** invoice PDF generation, multi-currency, VAT-aware. JWT + company-scoped multi-tenancy. Deployed to AWS EC2 via PM2 + GitHub Actions SSH deploy.
2. **[ops-portal/](ops-portal/README.md)** — `121asc-frontend` — the **production internal operations portal** (Next.js 15 App Router, ~16K LOC). Fully wired to the backend at `16.16.106.129:8000/api`. TanStack Query, Axios with Bearer-token interceptors and 401-redirect, React Hook Form + Zod, services layer per domain (auth, jobs, addresses, invoice-pdf). Deployed on Vercel.
3. **[cargo-frontend/](cargo-frontend/README.md)** — `cargo-frontend` — an **earlier iteration** of the operator dashboard (Next.js 15 + Shadcn + TanStack Table + Recharts). Mock data only, no backend wiring, no real auth. Useful as a UX/feature reference but not the production surface. Treat as prototype unless explicitly told otherwise.
4. **[invoice-generator/](invoice-generator/README.md)** — `invoice-generator` — a **standalone Next.js tool** for client-side invoice PDF generation. Discriminated-union Zod schema across ROAD / AIR / SEA invoice types. **jsPDF + dom-to-image**-based render. Independent of the backend's server-side PDF flow.

(There's also `express-typescript-sequelize-boilerplate/` in the monorepo — it's empty scaffolding, not a real artifact. Ignore.)

## How They Fit Together

```
   ┌──────────────────────────────────────────┐
   │   ops-portal (121asc-frontend)           │
   │   Next.js 15 · TanStack Query · Axios    │  ← production user surface
   │   Vercel (rewrites /api → backend IP)    │
   └────────────────────┬─────────────────────┘
                        │ Bearer JWT, /api/* (Axios interceptor)
                        ▼
   ┌──────────────────────────────────────────┐
   │   backend (cargo-backend)                │
   │   Express + TypeScript + Prisma          │
   │   PostgreSQL · Puppeteer + Handlebars    │
   │   Swagger at /api-docs                   │
   │   AWS EC2 + PM2, GitHub Actions deploy   │
   └──────────────────────────────────────────┘

   cargo-frontend (prototype)        invoice-generator (standalone)
   no live wiring · mock data       client-side jsPDF tool
```

The **production path is `ops-portal ↔ backend`.** Everything else is satellite work.

## Unified Tech Stack

| Layer | Tools |
|---|---|
| Backend | **Express 4.21** · **TypeScript 5** · **Prisma 6.12** · **PostgreSQL** (Docker locally) · **JWT** + bcrypt · **Zod** · **Winston** (daily-rotate) · **Swagger** (jsdoc + ui) · **Jest + Supertest** |
| PDF (server) | **Puppeteer Core 24** · **Handlebars 4.7** (HTML-template → headless render) |
| Frontend (production ops portal) | **Next.js 15.2** · **React Hook Form + Zod** · **TanStack React Query 5.68** · **Axios 1.8** · **Radix UI + Tailwind 4** · **react-toastify** · `date-fns` |
| Frontend (prototype) | Next.js 15.1 · **Shadcn/ui** · **TanStack Table** · **Recharts** · React Hook Form + Zod |
| PDF (client) | **jsPDF** · **dom-to-image** (DOM → PNG → PDF) |
| Hosting | **AWS EC2 + PM2** (backend), **Vercel** (ops portal), Docker Compose for local Postgres |
| CI/CD | GitHub Actions → SSH deploy → `npm run build` → Prisma migrate → `pm2 reload` |

## Domain Highlights

- **Polymorphic Job model.** Single `Job` master record with **1:1** specializations: `AirJob` (airline, flight, MAWB), `SeaJob` (vessel, BL/HBL, container), `RoadJob` (truck, manifest), `UAEJob` (mixed: container / LCL / break-bulk). Plus child records `RoadVehicle`, `UAEJobCargo`, `SeaJobCargo` for multi-segment shipments.
- **Polymorphic Address book** — 8-enum `Address` model serving customer / supplier / shipper / consignee / warehouse / haulier / agent / consignor, with credit terms, banking, and dual registration/operations addresses.
- **Multi-currency invoicing** — foreign currency + exchange-rate fields per invoice; default USD with override. Invoice types: `SALE`, `SALE_CREDIT`, `PURCHASE`, `PURCHASE_CREDIT`. Line items split `OWN` vs `THIRD_PARTY`. State machine `PROFORMA → PROCESSED`.
- **Per-company VAT rates** (`CompanyVATRate` — T0, T1, T2 etc.) applied at line-item level.
- **Hazardous cargo** — UN numbers, hazard classes, package types tracked across all job modes.
- **Server-side PDF rendering** — Handlebars template at `cargo-backend/src/modules/invoice-pdf/templates/invoice-template.html` → Puppeteer → PDF in `uploads/invoices/`. Synchronous (no queue).
- **Company-scoped multi-tenancy** — every query filters on `company_id` from the JWT-resolved user.

## Notable Engineering

1. **Modular monolith** — 13 domain modules under `cargo-backend/src/modules/`, each with `controller / service / repo / validator / routes`. Clean DDD-ish layering inside an Express app.
2. **Standardized API envelope** — `ApiResponse<T>` wrapper across every endpoint, with a global error handler middleware.
3. **Logging discipline** — Winston with **status-aware severity** (5xx → error, 4xx → warn, 2xx → info), request/response timing, daily-rotating files.
4. **Auto-generated Swagger** — `swagger-jsdoc` + `swagger-ui-express` at `/api-docs`, generated from JSDoc on routes.
5. **Two PDF strategies in one project** — Puppeteer + Handlebars on the server (real production flow), jsPDF + dom-to-image on the client (the standalone invoice-generator). Different tradeoffs: server-side gets reproducible rendering and is auditable; client-side is faster and works offline.
6. **Discriminated-union schema** in the invoice-generator (Zod) — encodes type-specific fields per freight mode at the type level, so impossible states are unrepresentable.
7. **Two-frontend evolution** — keeping the prototype (`cargo-frontend/`) and the production ops portal (`121asc-frontend/`) side-by-side in the monorepo means we can compare iterations and harvest UX patterns. Worth flagging in conversation as deliberate, not accidental sprawl.

## What's NOT In Scope (yet)

The agent deep-dive found **none of**: Stripe / payment gateway integration, Twilio / SMS, SendGrid / email, AWS S3 upload, Firebase, FedEx / DHL / UPS carrier APIs, background jobs / queues. The system is intentionally self-contained operations software — payments and notifications are handled out-of-band today. Good to know if a conversation goes there.

## Per-Component Deep Dives

- [backend](backend/README.md) — Express + Prisma API, full domain model
- [ops-portal](ops-portal/README.md) — production Next.js operator portal
- [cargo-frontend](cargo-frontend/README.md) — earlier prototype iteration (mock data)
- [invoice-generator](invoice-generator/README.md) — standalone client-side PDF tool
