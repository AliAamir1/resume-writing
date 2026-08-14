---
name: Tow123 Roadside Marketplace
employer: FlatOut Solutions
dates: unconfirmed
tech_used: Node.js | Express | MongoDB | Redis | Socket.IO | React Native | Stripe
url: tow123.app
tags: marketplace, real-time, mobile, react-native, stripe, redis, migration, ecs
gaps: dates, jobs completed, active providers, migration downtime achieved
---

# Tow123 Roadside Marketplace

Two-sided marketplace connecting consumers to towing, fuel delivery, lockout, and tire repair providers, with a multi-location operator hierarchy on the provider side.

## Bullets

- *Two-Sided Marketplace*: Built a real-time roadside assistance marketplace across a React Native consumer app and a React provider web app covering booking, driver assignment, live tracking, and payment.
- *Multi-Tenant Org Hierarchy*: Modeled provider organizations with multiple locations, each with its own managers, dispatchers, and drivers, routing jobs by geolocation and service area with role-scoped permissions at every level.
- *Real-Time Systems*: Scaled the realtime layer horizontally with Socket.IO over a Redis adapter, backed by a Redis proximity index matching incoming requests to nearby available drivers.
- *Payment Integration*: Implemented Stripe per-job charges and provider payouts.
- *Cloud Migration*: Migrated the platform from a hand-provisioned ECS deployment to fully automated Pulumi infrastructure-as-code through a three-phase parallel-deploy, DNS-cutover, and cleanup plan documented as a runbook.
- *Secrets Management*: Moved all production configuration out of .env files into KMS-encrypted AWS SSM Parameter Store, resolved by the ECS task execution role at task start.
