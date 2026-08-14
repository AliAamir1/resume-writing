---
name: Freight Operations Portal
employer: unconfirmed
dates: unconfirmed
tech_used: Next.js 15 | TypeScript | TanStack Query | Zod | Tailwind | Vercel
url: none
tags: nextjs, frontend, tanstack-query, forms, auth, vercel, logistics
gaps: dates, employer or engagement type, daily active operators
---

# Freight Operations Portal

Production internal operations portal for freight forwarding staff: job management across freight modes, sales and purchase invoicing, address book, and fleet.

## Bullets

- *Next.js Application Development*: Built the production internal operations portal in Next.js 15 App Router, roughly 16,600 lines across 105 files, covering job management by freight mode, invoicing, address maintenance, and fleet.
- *API Client Architecture*: Layered a per-domain service module paired with a TanStack Query hook so components consume hooks rather than raw HTTP calls, keeping data access centrally testable.
- *Authentication Flow*: Centralized auth in a single Axios instance injecting Bearer tokens on request and clearing session cookies plus redirecting to sign-in on any 401 response.
- *Route Protection*: Gated every non-public route at the Next.js server middleware layer rather than relying on client-side checks.
- *Form Validation*: Built form-heavy CRUD across jobs, invoices, addresses, drivers, and vehicles with React Hook Form and Zod resolvers.
- *Production Deployment*: Deployed on Vercel with rewrites proxying the API path to the backend host so browser calls stay same-origin and avoid CORS entirely.
