---
name: Client-Side Invoice Generator
employer: unconfirmed
dates: unconfirmed
tech_used: Next.js | TypeScript | Zod | jsPDF | React Hook Form
url: none
tags: typescript, zod, pdf, frontend, type-safety, logistics
gaps: dates, employer or engagement type
---

# Client-Side Invoice Generator

Standalone tool generating shipping invoices as PDFs entirely in the browser, with per-freight-mode type safety. Deliberate counterpart to the server-side PDF flow in the main API.

## Bullets

- *Type-Safe Schema Design*: Modeled road, air, and sea invoices as a Zod discriminated union so mode-specific fields such as master air waybill or bill of lading are unrepresentable on the wrong invoice type at compile time.
- *Client-Side PDF Generation*: Rendered invoices fully in browser through a DOM-to-image and jsPDF pipeline with no backend and no persistence, trading visual fidelity for offline capability and zero round-trip.
- *Data-Driven UI*: Built a dynamic field renderer walking a configuration map to produce the right inputs per selected freight mode instead of duplicating markup per mode.
- *Cross-Field Validation*: Enforced business rules such as single-currency charge lines through Zod refinements, with VAT computed into template totals.
