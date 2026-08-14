---
name: 121 ASC Operations Portal
client: 121 Air Sea Cargo
status: active production
codebase: /Users/ali/Documents/web-projects/cargo/121asc-frontend
deployment: Vercel; rewrites `/api/*` → http://16.16.106.129:8000/api (cargo-backend on EC2)
tech_stack: Next.js 15.2 (App Router) · TypeScript · React Hook Form 7.54 + Zod 3.24 · TanStack React Query 5.68 · Axios 1.8 (with auth interceptors) · Radix UI · Tailwind CSS 4 · Lucide · date-fns · react-toastify · react-spinners · server-side middleware for protected-route gating
target_market: Internal staff at 121 Air Sea Cargo — operators, customer service, managers
---

# 121 ASC Operations Portal (`121asc-frontend`)

The **production** internal operations portal for 121 Air Sea Cargo staff. Despite the name `121asc-frontend`, this is **not** the public marketing site — it's the internal employee dashboard wired to [cargo-backend](../backend/README.md) for managing the entire freight-forwarding workflow.

~16,631 lines of TypeScript/TSX across ~105 files. This is the surface real users hit.

## What Users Do Here

- **Authenticate** via `/sign-in` (email + password → JWT in cookies).
- **Job management** — full CRUD over jobs, segmented by mode: `/job-management/export`, `/job-management/import`, `/job-management/uae-delivery`. Filters on status, type, driver, date ranges.
- **Invoicing** — `/invoicing/sales` and `/invoicing/purchase`. Proforma → processed lifecycle. Linked sales/purchase item creation, bulk un-processing, PDF download (proforma + processed variants).
- **Address book** — `/address-maintenance/customer | supplier | consignee` with full CRUD.
- **Fleet** — `/driver-management`, `/vehicle-management/trucks`.
- **Dashboard** — `/dashboard` (placeholder/minimal in current iteration).

## Architecture

Next.js App Router. Protected-route gating via **server-side `src/middleware.ts`** — unauthenticated requests to anything other than `/sign-in` redirect.

```
src/
├── app/
│   ├── sign-in/                     # public auth route
│   ├── dashboard/
│   ├── job-management/{export,import,uae-delivery}/
│   ├── invoicing/{sales,purchase}/
│   ├── driver-management/
│   ├── vehicle-management/trucks/
│   └── address-maintenance/{customer,supplier,consignee}/
├── components/                      # Radix + Tailwind, domain widgets
├── services/                        # API layer
│   ├── apiClient.ts                 # Axios instance with auth interceptors
│   ├── authService.ts
│   ├── jobService.ts
│   ├── addressService.ts
│   └── invoicePdfService.ts
├── queries/                         # React Query hooks
│   ├── jobs.query.ts
│   ├── invoices.query.ts
│   └── address.query.ts
├── providers/                       # QueryProvider (TanStack Query setup), AuthContext
├── middleware.ts                    # protected-route gating
└── lib/                             # utilities
```

## Notable Engineering

1. **Service layer + React Query hooks per domain** — every backend resource has a `…Service.ts` (Axios calls) and a paired `…query.ts` (React Query hooks). Components consume hooks, never raw Axios. Cleanly testable.
2. **Axios auth interceptor** in `apiClient.ts`:
   - Request interceptor injects Bearer token from cookies.
   - Response interceptor catches `401`, clears cookies, redirects to `/sign-in`.
   - Same client used by every service — auth handling is centralized.
3. **Vercel `vercel.json` rewrites** `/api/*` to the backend EC2 IP (`http://16.16.106.129:8000/api`). Lets the frontend call same-origin URLs and avoids CORS in production.
4. **`NEXT_PUBLIC_API_URL`** env switches between `http://localhost:8000/api` (dev) and the production rewrite path. Single config knob.
5. **Server-side middleware route gating** — protects everything except `/sign-in` at the Next.js middleware layer, not just the client.
6. **`NPM_CONFIG_LEGACY_PEER_DEPS=true`** in build config — pragmatic resolution for the React 19 / Radix peer-dep churn.

## Backend Endpoints It Calls

(Verified in services layer)

- `POST /auth/signin`
- `GET / POST / PATCH / DELETE /jobs`
- `GET / POST /invoice/items`, `/invoice/linked-items`, `POST /invoice/process`
- `GET /invoice-pdf/proforma`, `GET /invoice-pdf/processed`
- `GET / POST / PATCH / DELETE /addresses`, `/drivers`, `/vehicles`, `/suppliers`

## Notes

- **Don't confuse with [cargo-frontend](../cargo-frontend/README.md)** — that's the earlier prototype with mock data and no real auth. *This* (`121asc-frontend`) is the production surface.
- **Don't confuse with the public site at [121asc.com](https://121asc.com)** — that's the company's own marketing site, not built by us. This portal is internal-only.
- The `metadata` block in `layout.tsx` is still the Next.js boilerplate ("Create Next App") — not user-facing because it's an authenticated portal, but worth tidying.

## Key Files (verifiable)

- `121asc-frontend/package.json`
- `121asc-frontend/src/middleware.ts` — auth route gate
- `121asc-frontend/src/services/apiClient.ts` — Axios + auth interceptors
- `121asc-frontend/src/services/{auth,job,address,invoicePdf}Service.ts`
- `121asc-frontend/src/queries/{jobs,invoices,address}.query.ts`
- `121asc-frontend/vercel.json` — `/api/*` → backend rewrite
- `121asc-frontend/.env.example`
