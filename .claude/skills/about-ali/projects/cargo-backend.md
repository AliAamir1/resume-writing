---
name: Freight Forwarding Operations API
employer: unconfirmed
dates: unconfirmed
tech_used: Express | TypeScript | Prisma | PostgreSQL | Puppeteer | AWS EC2
url: none
tags: rest-api, prisma, postgresql, multi-tenant, pdf, logistics, swagger, modular-monolith
gaps: dates, employer or engagement type, shipments or invoices processed, users
---

# Freight Forwarding Operations API

Production API for a UAE freight forwarder handling air, sea, road, and UAE-domestic cargo, covering shipments, fleet, address book, and VAT-aware multi-currency invoicing.

## Bullets

- *REST API Development*: Built a production Express and TypeScript API as a modular monolith of 13 domain modules, each layered into controller, service, repository, validator, and routes.
- *Database Schema Design*: Modeled 18 Prisma entities over PostgreSQL including a polymorphic shipment record with one-to-one specializations for air, sea, road, and domestic freight modes, plus child records for multi-segment cargo and an eight-type polymorphic address book.
- *Multi-Currency Invoicing*: Implemented sale, purchase, and credit-note invoice types with per-invoice foreign currency and exchange rate, per-company VAT rates applied at line-item level, and a proforma-to-processed state machine.
- *PDF Generation*: Built server-side invoice rendering with Handlebars templates and headless Puppeteer, including custom date, currency, and VAT computation helpers.
- *Multi-Tenancy*: Enforced company-scoped isolation by resolving the tenant from the JWT on every request, making cross-tenant access impossible by construction.
- *Logging and Observability*: Configured Winston with status-aware severity mapping 5xx to error, 4xx to warn, and 2xx to info, with per-request timing and daily-rotating log files.
- *API Documentation*: Auto-generated Swagger from route JSDoc and served interactive docs so the frontend team worked against a concrete contract.
- *CI/CD Pipeline*: Automated deploys to AWS EC2 through GitHub Actions running build, Prisma migrate deploy, and a zero-downtime PM2 reload.
