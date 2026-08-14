---
name: 121 ASC Cargo Backend
client: 121 Air Sea Cargo
status: active production
codebase: /Users/ali/Documents/web-projects/cargo/cargo-backend
deployment: AWS EC2 (16.16.106.129:8000) via PM2; PostgreSQL; GitHub Actions SSH deploy on push to `dev`
tech_stack: Express 4.21 · TypeScript 5 · Prisma 6.12 · PostgreSQL · JWT + bcrypt · Zod · Puppeteer Core 24 + Handlebars 4.7 (PDF) · Winston (daily-rotate) · Swagger · Jest + Supertest · Docker Compose (local PG)
target_market: Internal — backs the production ops portal at https://121asc-frontend (Vercel)
---

# 121 ASC Cargo Backend (`cargo-backend`)

The production API powering 121 Air Sea Cargo's operations stack. Express + TypeScript + **Prisma + PostgreSQL** modular monolith. Owns the entire domain: shipments (across 4 freight modes), companies, addresses, drivers, vehicles, invoices, advance payments, VAT rates, and server-side PDF generation.

## Service Surface

REST under `/api`. Swagger at `/api-docs` (auto-generated from JSDoc).

13 route groups:

| Group | Purpose |
|---|---|
| `/auth` | Sign-up, sign-in (JWT issued) |
| `/user` | Employee CRUD |
| `/companies` | Tenant boundary — owns jobs, vehicles, drivers, invoices, VAT rates |
| `/addresses` | 8-type polymorphic address book (customer / supplier / shipper / consignee / warehouse / haulier / agent / consignor) |
| `/jobs` | Master shipment CRUD, polymorphic across air / sea / road / UAE |
| `/drivers` | Driver roster |
| `/vehicles` | Company fleet |
| `/invoice` | SALE / SALE_CREDIT / PURCHASE / PURCHASE_CREDIT, multi-currency, line items, processing state machine |
| `/invoice-pdf` | Server-side PDF generation (proforma + processed variants) |
| `/service-items` | Reusable billing component library |
| `/vat-rates` | Per-company VAT configurations (T0, T1, T2…) |
| `/advance` | Advance / prepayment tracking against jobs |
| `/suppliers` | Supplier directory |

## Module Layout (`src/modules/`)

Each domain module follows the same shape: `controller.ts` / `service.ts` / `repository.ts` / `validator.ts` / `routes.ts`. Clean DDD-ish layering inside Express.

```
src/
├── config/             # env validation (Zod), JWT secrets, invoice static data
├── middlewares/        # JWT service, auth verification, global error handler
├── modules/
│   ├── auth/           ├── user/         ├── company/
│   ├── address/        ├── job/          ├── driver/        ├── vehicle/
│   ├── invoice/        ├── invoice-pdf/  ├── advance_payment/
│   ├── service_item/   ├── vatRate/      ├── supplier/      └── uploads/
├── routes/             # router aggregator → mounts modules under /api
├── utils/              # auth helpers, validation, error handling, Swagger spec, logging
└── types/              # Express augmentation, invoice enums, domain interfaces
```

## Domain Model — 18 Prisma Models

`prisma/schema.prisma`. The interesting bits:

### Multi-tenant boundary

- **`User`** — employee login.
- **`Company`** — tenant. Owns jobs, vehicles, drivers, invoices, VAT rates. Every query is filtered on `company_id` resolved from the JWT user.

### Polymorphic Address

- **`Address`** — 8-enum type: `CUSTOMER | SUPPLIER | SHIPPER | CONSIGNEE | WAREHOUSE | HAULIER | AGENT | CONSIGNOR`. Per-address credit terms, banking details, dual registration/operations addresses.

### Polymorphic Job (the core of the system)

- **`Job`** — master shipment record. Carries the cross-mode metadata, then has **1:1 specialization** to one of:
  - **`AirJob`** — airline, flight, MAWB / HAWB, AWB.
  - **`SeaJob`** — vessel, voyage, BL / HBL, container types.
  - **`RoadJob`** — truck, manifest, vehicle.
  - **`UAEJob`** — UAE-domestic, mixed load (container / LCL / break-bulk).
- **`RoadVehicle` / `UAEJobCargo` / `SeaJobCargo`** — child records for multi-segment / multi-cargo shipments.
- Hazardous cargo fields tracked across modes — UN numbers, hazard classes, package types.

### Fleet

- **`Driver`** — operator; linked to jobs.
- **`Vehicle`** — company fleet (some companies don't run their own).

### Billing

- **`Invoice`** — `SALE | SALE_CREDIT | PURCHASE | PURCHASE_CREDIT`. Multi-currency with foreign-currency + exchange-rate fields. State `PROFORMA → PROCESSED`.
- **`InvoiceItem`** — line items, classified `OWN | THIRD_PARTY`.
- **`AdvancePayment`** — job-linked prepayments.
- **`ServiceItem`** — reusable billing components (templated charge lines).
- **`CompanyVATRate`** — per-company T0, T1, T2 etc., applied at line-item level.

## Notable Engineering

1. **Server-side PDF rendering pipeline.** Handlebars HTML template (`src/modules/invoice-pdf/templates/invoice-template.html`) + custom helpers (date formatting, currency, VAT calc) → Puppeteer Core headless render → PDF written to `src/modules/uploads/invoices/`. Synchronous in current implementation — flagging as a queue candidate when load grows.
2. **Multi-currency at the invoice level** — foreign currency + exchange rate fields per invoice; default USD, per-invoice override.
3. **VAT rates as data, not code** — each company configures its own T0/T1/T2/… rates and applies them per line item.
4. **Standardized response envelope** — `ApiResponse<T>` wrapper across every endpoint with a global error-handler middleware mapping thrown errors to status + payload.
5. **Status-aware Winston logging** — 5xx → error, 4xx → warn, 2xx → info. Request/response timing per call, daily-rotating files. Makes triage cheap.
6. **Zod everywhere** — env validation in `config/`, request body validation per module via dedicated validators.
7. **Auto-generated Swagger** — `swagger-jsdoc` reads route JSDoc; UI served at `/api-docs`. Useful for handing the frontend team something concrete.

## Auth & Multi-Tenancy

- **JWT Bearer** issued on sign-in; verified by `src/middlewares/auth.middleware.ts`.
- **Company-scoped access** — JWT resolves a `userId`; per request, the user's `company_id` is looked up and used to filter every query. Cross-company access is impossible by construction.
- **No formal RBAC model** — auth is "are you an authenticated employee of this company?" Permission checks (e.g. on VAT rate access) are ad-hoc in services. Flag as a hardening target if asked.

## What's NOT Wired In

Concrete gaps — useful to know before claiming features:

- **No payment gateway** (no Stripe / PayPal / Razorpay).
- **No email/SMS** (no SendGrid / Twilio / Mailgun).
- **No AWS S3, Firebase, or third-party shipping carriers** (FedEx / DHL / UPS).
- **No background jobs / queues** — PDF generation is synchronous.

The system is intentionally self-contained — payments + notifications are out-of-band today.

## Deployment & Ops

- **AWS EC2** at `16.16.106.129:8000`, behind PM2 process manager.
- **PostgreSQL** — Docker Compose locally; managed PG in production.
- **CI/CD** — `.github/workflows/deploy.yml` triggers on push to `dev`. SSHs to EC2, runs `npm run build`, `prisma migrate deploy`, `pm2 reload cargo-backend`.
- **Entry point** — compiled `dist/src/server.js`.

## Key Files (verifiable)

- `cargo-backend/package.json`
- `cargo-backend/prisma/schema.prisma` — 18-model data model
- `cargo-backend/src/server.ts` — Express setup + Prisma connection
- `cargo-backend/src/routes/routes.ts` — route aggregation
- `cargo-backend/src/modules/invoice-pdf/helpers/pdf-generator.ts` — Puppeteer + Handlebars
- `cargo-backend/src/modules/invoice-pdf/templates/invoice-template.html`
- `cargo-backend/.github/workflows/deploy.yml`
- `cargo-backend/docker-compose.yml`
