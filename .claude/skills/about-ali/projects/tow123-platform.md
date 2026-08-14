# Tow123 Platform Suite: Resume Bullets

11 bullets. A consumer roadside assistance marketplace: a customer web app that quotes and books a tow, an API server that matches the job to nearby providers in real time, a provider web app that accepts and completes jobs, a driver mobile app on iOS and Android, and a serverless pipeline that bills completed jobs to third-party insurers.

Use when the posting is marketplace, real-time systems, consumer product, field service, or payments.

---

## Project Header Lines

**Tow123 API Server** | Node.js, Express, TypeScript, MongoDB, Socket.IO, Stripe, Docker, AWS

**Tow123 Customer Web App** | React, TypeScript, Vite, Stripe Elements, Google Maps, S3, CloudFront

**Tow123 Provider Web App** | React, TypeScript, Socket.IO, Firebase Cloud Messaging, Google Maps

**Tow123 Driver Mobile App** | React Native, Expo, Zustand, React Native Maps, iOS and Android

**Tow123 Insurance Billing** | TypeScript, AWS Lambda, SQS, DynamoDB, Secrets Manager, Pulumi

---

## Marketplace and Dispatch

- **Roadside Service Marketplace:** Built the full stack connecting stranded drivers to tow providers across web and mobile.
- **Provider Matching Engine:** Offers each job to the nearest providers in expanding 20-mile rings across 3 rounds, auto-declining on timeout and cancelling if none accept.
- **Provider Payout Split:** Quotes each provider 56% of the discounted customer price automatically per job.
- **Live Job Dispatch:** Per-user WebSocket channels push offers, status changes and provider presence with no polling, falling back to push and email when a provider is offline.

## Insurance Billing

- **Insurance Billing Automation:** Automated invoice submission to third-party insurer portals, replacing manual per-job entry for every completed tow.
- **Invoice Reconciliation:** Matches every dispatch line item to its insurer equivalent and refuses to submit when the two totals disagree.

## Customer Product

- **Database-Driven Intake:** Rendered the entire booking flow from database config: 121 questions, 46 steps, six service types, no code change per service.
- **Live Price Quoting:** The quote updates as the customer answers, adding tow mileage, vehicle surcharges, and membership discounts.

## Payments

- **Card Payments and Memberships:** Integrated Stripe for one-time job payment, saved cards, and recurring membership plans with discounts carried to provider payout.

## Provider and Driver Product

- **Driver Mobile App:** Shipped a React Native app on iOS and Android for drivers to take, navigate, and close jobs.
- **Proof of Service Capture:** Providers capture a customer signature and vehicle photos in the browser to close out a job.

---

## Skills Keyword Bank

**Languages** TypeScript, JavaScript, Node.js, SCSS

**Frontend** React, Vite, React Router, React Hook Form, Emotion, Tailwind CSS, TanStack Query, Yup and Zod validation, responsive UI, multi-step forms, dynamic form rendering

**Mobile** React Native, Expo, EAS Build, React Navigation, Zustand, React Native Maps, iOS and Android release builds, geolocation, camera and signature capture

**Backend** Express, REST API design, Socket.IO namespaces, JWT authentication, bcrypt, Mongoose, cron scheduling, file upload handling, database migrations

**Serverless** AWS Lambda, SQS, DynamoDB, EventBridge, Secrets Manager, event-driven architecture, queue workers, partial batch failure handling, retry and dead-letter design

**Data** MongoDB, schema modeling, aggregation pipelines, relational document design, DynamoDB single-table design, Zod schema validation

**Payments** Stripe payment intents, saved payment methods, subscriptions, webhooks

**Cloud / DevOps** AWS ECS and ECR, EKS manifests, S3, CloudFront, Docker, nginx, GitHub Actions, multi-environment deploys, Pulumi, Infrastructure as Code

**Integrations** Google Maps Geocoding, Distance Matrix and Directions, Firebase Cloud Messaging, SendGrid, Nodemailer, AWS S3, insurance partner portal automation, HTTP session handling

**Domain** Roadside assistance, towing marketplace, two-sided marketplace matching, service dispatch, field service operations, insurance invoice reconciliation, accounts receivable automation

---

## Selection guidance

Strongest openers, in order: Provider Matching Engine, Database-Driven Intake, Invoice Reconciliation, Provider Payout Split.

Provider Matching Engine and Database-Driven Intake are the two with real specifics: expanding rings across 3 rounds, and 121 questions across 46 steps. Both describe a system, not a feature.

Invoice Reconciliation is the one a finance-minded reader stops on: a system that refuses to submit when the money does not match.

Resting on scope. Drop first: Roadside Service Marketplace, Driver Mobile App, Proof of Service Capture.

---

## Confirm before sending

- **Insurance billing was authorized integration work**: the client's own portal account, their own credentials, their own invoices, at their request. Never describe it as reverse-engineering or scraping.
- **No marketplace metrics exist.** Jobs dispatched, providers onboarded, gross bookings, or match rate would each outrank every bullet above. If any are recoverable, get them.
- **56%, 20 miles, 3 rounds, 121 questions, 46 steps** are configuration values, not outcomes. Good as detail, never as the lead.
