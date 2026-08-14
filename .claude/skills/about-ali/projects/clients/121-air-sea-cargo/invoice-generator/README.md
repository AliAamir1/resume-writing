---
name: 121 ASC Invoice Generator (standalone)
client: 121 Air Sea Cargo
status: standalone tool
codebase: /Users/ali/Documents/web-projects/cargo/invoice-generator
deployment: standalone Next.js app — runs locally / can be Vercel-deployed
tech_stack: Next.js 14.2 (React 18, SSR) · TypeScript 5 · Zod · React Hook Form + @hookform/resolvers · jsPDF + dom-to-image · Radix UI · Tailwind 3.4 + Tailwind Merge/Animate · Recharts
target_market: Internal — quick-fire invoice creation outside the main ops portal
---

# 121 ASC Invoice Generator (`invoice-generator`)

A **standalone Next.js tool** for generating shipping invoices as PDFs entirely on the **client side**. Independent of [the backend's server-side PDF flow](../backend/README.md#notable-engineering) — different tradeoffs, different use case.

Sits alongside the rest of the cargo monorepo but doesn't share auth, backend, or routing with the [ops-portal](../ops-portal/README.md). Think of it as a "quick invoice" surface vs. the full lifecycle the backend handles.

## What It Does

- Operator picks an invoice **type** (ROAD / AIR / SEA).
- Form renders **type-specific fields** (e.g. air invoices want airline + MAWB + HAWB; sea wants vessel + bill of lading + voyage; road wants vehicle type + TCN job ref).
- Operator fills consignor / consignee, charges (multi-line), and totals.
- App **generates the PDF in-browser** via `dom-to-image` → PNG → `jsPDF` → download.

No backend. No persistence. PDF lives wherever the user saves it.

## Tech Stack

- **Next.js 14.2.16** (React 18 SSR)
- **TypeScript 5**
- **Zod** with **discriminated unions** for type-safe per-mode invoice schemas
- **React Hook Form** + `@hookform/resolvers`
- **jsPDF** + **dom-to-image** for client-side PDF rendering
- **Radix UI** primitives (accordion, button, form, select, dialog, etc.)
- **Tailwind 3.4.17** + Tailwind Merge / Animate
- **Recharts 2.15** (charting — present, lightly used)

## Architecture

```
app/
└── page.tsx                       # entry → renders <InvoiceForm/>
components/
├── InvoiceForm.tsx                # main form orchestrator (watches type → conditional fields)
└── renderFormFields.tsx           # dynamic field renderer
lib/
└── pdfGenerator.tsx               # <InvoicePDF/> render + <InvoicePDFWithDownload/> ref-exposed handler
hooks/
└── use-dom-to-pdf.tsx             # useDomPDF() — DOM → PNG → PDF via jsPDF
validators/
└── invoices.tsx                   # Zod schemas: ROAD / AIR / SEA discriminated union
constants/
└── invoiceConfig.ts               # field defs, defaults, type-specific field maps
```

## Notable Engineering

1. **Discriminated-union Zod schema** — three invoice types as a typed union, each with its own `additionalInfo` payload. Impossible states (e.g. `MAWB` on a sea invoice) are unrepresentable at compile time.
   - Road: `vehicle_type`, `tcn_job_ref`
   - Air: `airline`, `mawb`, `hawb`
   - Sea: `bill_of_landing_no`, `voyage`
2. **Cross-field validation** — Zod refines enforce e.g. "all charges must be in the same currency."
3. **5% VAT calculation** baked into the template totals.
4. **Dynamic field renderer** — `renderFormFields.tsx` walks `invoiceConfig` to produce the right inputs per selected mode. Data-driven; no per-mode JSX duplication.
5. **Imperative download API** — `<InvoicePDFWithDownload ref={...} />` exposes a download handler via React ref so the form can trigger PDF export programmatically without re-rendering the layout.

## Why Two PDF Strategies in One Project?

[Backend](../backend/README.md) does **server-side** rendering: Handlebars HTML template + headless Puppeteer. Reproducible, auditable, runs without a browser.

This tool does **client-side** rendering: real DOM → `dom-to-image` → `jsPDF`. Faster, no server round-trip, works offline. Trade-off: visual fidelity depends on the user's browser / fonts.

Both are valid; they serve different ops needs.

## Notes

- Sample data only — no backend wiring.
- The empty `express-typescript-sequelize-boilerplate/` sibling in the monorepo is **not** a project — it's empty scaffolding (no `package.json`, no source). Ignore.

## Key Files

- `invoice-generator/package.json`
- `invoice-generator/app/page.tsx`
- `invoice-generator/components/InvoiceForm.tsx`
- `invoice-generator/components/renderFormFields.tsx`
- `invoice-generator/lib/pdfGenerator.tsx`
- `invoice-generator/hooks/use-dom-to-pdf.tsx`
- `invoice-generator/validators/invoices.tsx` — discriminated-union Zod schema
- `invoice-generator/constants/invoiceConfig.ts`
