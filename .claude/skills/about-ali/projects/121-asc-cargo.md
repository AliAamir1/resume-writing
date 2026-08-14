# Resume Bullets

Every figure traces to code, schema, migrations, or CI config in this repo. Nothing estimated.

Filter applied: anything a competent developer finishes in an afternoon was cut, regardless of how good the sentence sounded. What remains is work whose difficulty comes from domain surface area or sustained production evolution, not from the implementation itself.

---

## Project Header Lines

**121 ASC Freight Platform (API)** | Node.js, Express, TypeScript, Prisma, PostgreSQL, AWS EC2, PM2

**121 ASC Freight Platform (Web)** | Next.js 15, React 19, TypeScript, TanStack Query, React Hook Form, Zod, Tailwind

---

## Domain and Data Architecture

- **Freight Domain Modeling:** Modeled air, road, sea, and UAE trucking shipments as four typed tables under one parent job record.
- **Live Schema Evolution:** Shipped 48 Prisma migrations across six months against a running 18 table freight database.
- **Unified Address Book:** Collapsed customer, supplier, shipper, consignee, haulier, and agent records into one table carrying 8 role types.

## Backend Engineering

- **Nested Partial Updates:** Built one endpoint that diffs a job, its freight type record, and its vehicle and cargo collections, then creates, updates, and deletes each by ID.

## Frontend Architecture

- **Config Driven Forms:** Replaced four near duplicate freight job forms with one multi step modal engine driven by declarative step configs.

## Document Generation

- **Multi Mode Invoice PDFs:** Built one invoice template that reshapes its cargo, vessel, and vehicle sections depending on the freight mode.

---

## Skills Keyword Bank

**Languages:** TypeScript, JavaScript, SQL, HTML, CSS

**Frontend:** Next.js 15, React 19, React Hook Form, TanStack Query, Tailwind CSS, Radix UI, shadcn/ui, Zod, Axios

**Backend:** Node.js, Express, Prisma ORM, REST API design, JWT authentication, Zod validation, Swagger / OpenAPI, Winston logging, Handlebars, Puppeteer

**Data:** PostgreSQL, schema design, database migrations, relational modeling, indexing, transactions

**Cloud:** AWS EC2, PM2, Docker Compose, Vercel

**DevOps:** GitHub Actions, CI/CD, automated migrations, ESLint, Prettier

**Domain:** Freight forwarding, logistics, air / sea / road freight, invoicing, VAT and tax codes, credit terms, multi currency accounting, multi tenant SaaS
