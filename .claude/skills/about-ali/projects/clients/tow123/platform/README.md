---
name: Tow123 Marketplace Platform
client: Tow123
status: deployed
codebase: /Users/ali/Documents/flatout-solutions/tow123-org/tow123 (current) and /tow123-legacy (older iteration)
deployment: https://tow123.app/
tech_stack: Node.js, Express, MongoDB, Mongoose, Redis (ioredis), Socket.IO, Stripe, React Native (rider), React + Vite (provider web), TypeScript, Puppeteer, AWS S3, SendGrid, Firebase, ECS Fargate
target_market: Roadside-assistance consumers, towing/fuel/tire providers, multi-location provider businesses with managers/dispatchers/drivers
---

# Tow123 Marketplace Platform

The original Tow123 product: a real-time, two-sided marketplace for roadside services — towing, fuel delivery, flat tire repair, lockouts, jump-starts. Consumers book service from a mobile app; providers fulfill from a provider web app and a driver app, with a multi-location org hierarchy on the operator side.

## Apps

- **Consumer / rider app** (`tow123-app/` legacy, now `tow123/app/`) — React Native (older Vite/React shell + RN modules). Stripe payments, Google Maps, real-time job tracking via Socket.IO.
- **Provider web app** (`tow123-provider/` legacy, now `tow123/provider/`) — Vite + React 18 + TypeScript + Tailwind + shadcn/Radix + React Hook Form + Zod. Used by managers, dispatchers, and drivers in towing/fuel companies. Includes signature canvas, dropzone uploads, webcam capture for damage photos, Echarts dashboards.
- **Backend** (`tow123-server/` legacy, now `tow123/server/`) — Express 4 + TypeScript + Node 20 + Mongoose 7 + MongoDB. Handles auth (JWT + bcrypt), Stripe payments, Socket.IO + Redis adapter for cross-instance real-time, SendGrid for email, expo-server-sdk for push, and Puppeteer for any server-side scraping or PDF generation.

## Key Architectural Pieces

- **Multi-location provider hierarchy** — a single provider org can have multiple locations, each with its own managers, dispatchers, and drivers. Permissions and routing respect this nesting; jobs route to the right location based on geolocation + service area.
- **Real-time geolocation matching** — Redis-backed proximity index for matching incoming requests to available drivers. Socket.IO + `@socket.io/redis-adapter` for horizontal scalability of the realtime layer.
- **Stripe payments** — one-time charges per job + provider payouts.
- **Push + email** — `expo-server-sdk` for mobile push, SendGrid + Nodemailer for transactional email.

## Migration Story

The marketplace started as a manual ECS deployment (the legacy folder). Ali migrated it to a fully automated **Pulumi/IaC + GitHub-Actions-OIDC + Parameter-Store** deployment under the new Tow123 AWS organization (see [infra](../infra/README.md)). The migration was done in three phases — parallel deployment, DNS cutover, cleanup — documented in `TOW123-IaC-Setup-Guide.md`. Required parameters (`MONGO_URI`, `SECRET_KEY`, `STRIPE_SECRET_KEY`, Firebase config, Google Maps API key, etc.) all moved out of `.env` files and into AWS SSM Parameter Store with KMS encryption.

## Tech Stack (Detailed)

**Backend (`tow123/server`)**
- Express 4.18, TypeScript, Node 20+
- Mongoose 7.5, MongoDB 6.18
- Socket.IO 4.7 + `@socket.io/redis-adapter` 8.3
- Redis (ioredis 5.4)
- Stripe 14.25
- bcrypt, jsonwebtoken
- AWS SDK v2 (S3 uploads)
- SendGrid Mail 8.1, Nodemailer 6.9
- Expo server SDK 3.15 (push notifications)
- Puppeteer 24 (server-side scraping/PDF)
- Google Maps Services 3.4
- date-fns / dayjs / luxon / moment (heavy date handling for ETA + scheduling)
- Cron 3.1 for scheduled jobs

**Provider web (`tow123/provider`)**
- Vite 5 + React 18 + TypeScript
- TailwindCSS + shadcn/ui (Radix UI dialog/popover/accordion/switch/label)
- React Hook Form 7 + Zod
- @react-google-maps/api for maps + autocomplete
- TanStack React Query 5
- React Table 7 + `@table-library/react-table-library`
- React Day Picker, React Select, Echarts 5
- React Webcam, React Signature Canvas, React Dropzone
- Firebase 10 (notifications / auth-related)

**Consumer app (`tow123/app`)** — React Native + Vite shell + Tailwind + shadcn

**Hosting**
- AWS ECS Fargate behind an ALB
- ECR for container images
- Parameter Store for secrets
- S3 for file uploads
- CloudWatch for logs/monitoring/dashboards
- VPC with public/private subnets

## Notable Files / Locations

- `tow123/server/src/` — domain logic (jobs, drivers, providers, payments, sockets)
- `tow123/server/Dockerfile` — production image
- `tow123/server/tow123-server.yml` + `cert-ssl.yml` — deployment configs
- `tow123/provider/src/pages/` — provider dashboard, job board, fleet management
- `tow123/app/src/` — rider app screens
- `TOW123-IaC-Setup-Guide.md` — the cutover runbook

## Notes for Pitching

- Lead with **multi-location provider hierarchy** when the audience asks about marketplaces — this is the real differentiator vs naive Uber-clones.
- Lead with **Redis + Socket.IO realtime** when the audience cares about scaling realtime infra.
- Lead with **the ECS-Fargate + Pulumi migration** when the audience cares about DevOps maturity (manual → fully automated, with secrets, OIDC, Parameter Store, zero-downtime).
- The customer-facing product is now intentionally smaller than the operator-side surface area — most new build is happening in the dispatcher and voice agent.
