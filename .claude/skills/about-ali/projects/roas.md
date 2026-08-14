---
name: ROAS
employer: FlatOut Solutions
dates: unconfirmed
tech_used: NestJS 10 | Next.js 15 | MongoDB | Pulumi | AWS | Stripe
url: app.roas.ai
tags: nestjs, marketing-analytics, attribution, oauth, stripe, iac, multi-tenant
gaps: dates, live customer count, ad spend tracked
---

# ROAS

Multi-tenant marketing analytics SaaS closing the loop between Meta ad spend and GoHighLevel CRM revenue.

## Bullets

- *Marketing Attribution*: Built a multi-tenant analytics platform computing first-touch and last-touch attribution between Meta ad spend and GoHighLevel CRM outcomes, tying each campaign directly to the leads and revenue it produced.
- *Third-Party API Integration*: Integrated the Meta Marketing API and GoHighLevel API over OAuth, syncing campaigns, adsets, ads, spend, contacts, and opportunities into one schema.
- *NestJS Backend Development*: Delivered 14 NestJS domain modules over MongoDB with Passport authentication across local, Google, Facebook, and Apple strategies.
- *Scheduled Data Sync*: Wrote an hourly campaign cron with a re-entrancy lock and per-ad-account error isolation so one expired token cannot stall the whole sync.
- *Stripe Subscription Billing*: Gated analytics, OAuth-init, and embeddable widget endpoints behind a Stripe-backed subscription guard.
- *Multi-Tenant Onboarding*: Modeled a server-driven onboarding state machine over business accounts with per-stream sync status, removing the need for client-side state duplication.
- *Infrastructure as Code*: Provisioned AWS, MongoDB Atlas, Cloudflare, and Route53 through a two-stack Pulumi split consuming a shared component library, deployed by GitHub Actions over OIDC.
