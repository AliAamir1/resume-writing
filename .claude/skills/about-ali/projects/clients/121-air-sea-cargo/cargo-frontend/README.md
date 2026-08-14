---
name: 121 ASC Cargo Frontend (early prototype)
client: 121 Air Sea Cargo
status: prototype / superseded
codebase: /Users/ali/Documents/web-projects/cargo/cargo-frontend
deployment: none in production — superseded by [ops-portal](../ops-portal/README.md)
tech_stack: Next.js 15.1 (App Router) · TypeScript · Shadcn/ui (Radix wrappers) · Tailwind 3.4 · TanStack React Table · Recharts · React Hook Form + Zod · Lucide · sonner · cmdk · next-themes
target_market: N/A — internal prototype, never reached production
---

# `cargo-frontend` (early prototype iteration)

An **earlier iteration** of the operations dashboard for 121 Air Sea Cargo. Lives in the same monorepo as [the production ops portal](../ops-portal/README.md) but represents a separate, earlier exploration of the UI/UX and form architecture.

**This is NOT the production surface.** Don't pitch it as live. The production surface is `121asc-frontend` (the [ops-portal](../ops-portal/README.md)).

## Why Keep It Documented

- **UX / feature reference** — the multi-step job-creation wizard and the dashboard KPI/chart layout are richer than what currently exists in the production portal. Worth harvesting when those features are reintroduced.
- **Honest framing in interviews** — having two iterations of the same surface in the monorepo is *deliberate* and shows iteration discipline. Better to flag explicitly than to be caught conflating it with production.

## What Exists

- **Multi-step job creation wizard** (`components/job-creation-form.tsx`, ~301 lines, 3 steps):
  1. **Basic job info** — customer, shipper, consignee, dates, route.
  2. **Mode-specific details** — conditional rendering of truck / airline / vessel sub-forms (containerization, cargo type, driver / flight / vessel info).
  3. **Costing & invoicing** — purchase + sales line-item arrays via `useFieldArray`, auto-computed totals + profit margins via `useEffect` watchers.
- **Job management table** — TanStack React Table: TCN, customer, shipper, ports, status badges, sortable, filterable, paginated, with row actions (view / edit / delete).
- **Dashboard** — KPI cards (job counts by mode: sea / air / road), fleet stats (vehicles, drivers), monthly revenue charts (`TotalJobsChart`, `RevenueRateChart`), contact counts.
- **Reusable data-table primitive** at `components/ui/data-table` with toolbar, column visibility, search, pagination.

## Tech Stack

- **Next.js 15.1.0** (App Router, full SSR/SSG)
- **TypeScript 5**
- **Shadcn/ui** wrapping Radix primitives (avatar, dialog, dropdown, select, checkbox, switch, tooltip, popover)
- **Tailwind 3.4.17** + Tailwind Animate
- **React Hook Form** (`useForm`, `useFieldArray`, `FormProvider`)
- **TanStack React Table** for the job table
- **Recharts** for dashboard analytics
- **Zod** + `@hookform/resolvers` for validation
- `lucide-react`, `class-variance-authority`, `cmdk` (command palette), `sonner` (toast), `next-themes`, `date-fns`

## Why It's "Prototype"

Concrete reasons it's not production-ready:

1. **No backend integration.** Form submission `console.log`s and shows an alert (`job-creation-form.tsx:209`). Hardcoded mock data (4 sample `Job` records in `job-tables.tsx`).
2. **No auth.** Navbar shows hardcoded "Admin" (`admin@121airseacargo.com`). Dropdown items (Profile / Settings / Log out) are stubs. No login page, no token handling, no middleware guards.
3. **Most routes don't exist.** `config/nav.tsx` references `/jobs/import`, `/jobs/export`, `/jobs/uae-delivery`, `/vehicles`, `/drivers`, `/invoicing` — but only `/dashboard` and `/jobs` are implemented.
4. **No deployment config** — no Dockerfile, no `vercel.json`, no env files. Works locally with `next dev`; nothing wired beyond that.

## Notable (despite being a prototype)

The form architecture is **the strongest piece**: 7 nested Zod schemas (`basicInfoSchema`, `truckDetailsSchema`, `airlineDetailsSchema`, `vesselDetailsSchema`, `purchaseInvoiceSchema`, `salesInvoiceSchema`, `invoicingSchema`) compose into a fully typed multi-step form with field arrays and reactive total computation. That pattern is worth describing on its own when discussing form-heavy UI work.

## Notes

- Compared to [ops-portal](../ops-portal/README.md): same tech family, very different maturity. The ops-portal has 105+ files, real auth, real backend wiring, Vercel deployment. This one is ~maybe a quarter of that.
- If asked "did you build the frontend for 121 ASC?" — the answer is **yes, the production one is `121asc-frontend`**. This is an earlier iteration kept in the monorepo.

## Key Files

- `cargo-frontend/package.json`
- `cargo-frontend/components/job-creation-form.tsx` — 3-step wizard
- `cargo-frontend/components/job-tables.tsx` — mock data + TanStack Table
- `cargo-frontend/components/dashboard/` — KPI cards + Recharts
- `cargo-frontend/components/ui/data-table/` — reusable table primitive
- `cargo-frontend/lib/` — Zod schemas
- `cargo-frontend/config/nav.tsx` — intended route map
