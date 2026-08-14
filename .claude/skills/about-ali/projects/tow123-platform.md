# Tow123 Platform Suite: Resume Bullets

The consumer-facing roadside assistance marketplace: a customer web app that quotes and books a
tow, an API server that matches the job to nearby providers in real time, a provider web app that
accepts and completes jobs, and a driver mobile app shipped to iOS and Android.

---

## Project Header Lines

**Tow123 API Server** | Node.js, Express, TypeScript, MongoDB, Socket.IO, Stripe, Docker, AWS

**Tow123 Customer Web App** | React, TypeScript, Vite, Stripe Elements, Google Maps, S3, CloudFront

**Tow123 Provider Web App** | React, TypeScript, Socket.IO, Firebase Cloud Messaging, Google Maps

**Tow123 Driver Mobile App** | React Native, Expo, Zustand, React Native Maps, iOS and Android

---

## Marketplace and Dispatch

- **Roadside Service Marketplace:** Built the full stack connecting stranded drivers to tow providers across web and mobile.
- **Provider Matching Engine:** Offers each job to the nearest providers in expanding 20-mile rings across 3 escalation rounds.
- **Auto-Cancel on Exhaustion:** Cancels the job and notifies the customer when no provider accepts after every round.
- **Provider Payout Split:** Quotes each provider 56% of the discounted customer price automatically per job.
- **Job Acceptance Countdown:** Providers see a live countdown on each offer that declines it automatically on expiry.

## Real-Time Systems

- **Live Job Offers:** Per-user WebSocket channels push new jobs, status changes, and cancellations with no polling.
- **Push Notifications:** Firebase push plus transactional email reaches providers who are offline when a job arrives.
- **Presence Tracking:** Provider online status flips on socket connect and disconnect, giving dispatch a live view of who is reachable.

## Customer Product

- **Database-Driven Intake:** The whole booking flow renders from a question set in the database, needing no code change per service.
- **Conditional Follow-Up Questions:** 121 questions across 46 steps branch on prior answers to collect only what a given job needs.
- **Live Price Quoting:** The quote updates as the customer answers, adding tow mileage, vehicle surcharges, and membership discounts.
- **Six Service Types:** Shipped tow, winch, battery, fuel, tire, and lockout as independently configurable service catalogs.
- **Route Preview Maps:** The customer sees pickup, drop-off, and the driver's route on a map before paying.

## Payments

- **Card Payments and Memberships:** Integrated Stripe for one-time job payment, saved cards, and recurring membership plans.
- **Membership Discounts:** Applies a subscriber's discount to the live quote and carries it through to the provider payout.

## Provider and Driver Product

- **Proof of Service Capture:** Providers capture a customer signature and vehicle photos in the browser to close out a job.
- **Driver Mobile App:** Shipped a React Native app on iOS and Android for drivers to take, navigate, and close jobs.
- **Truck Inspection Flow:** Drivers complete a photo-backed truck inspection in the app before starting a shift.
- **In-App Routing:** The driver map draws a live route from their GPS position to the pickup address.

## Infrastructure

- **Containerized API Deployment:** Ships the API to AWS as a Docker image on every merge, front ends to CloudFront.
- **Separate QA and Production Pipelines:** Each app deploys to its own environment with environment-scoped secrets and config.

---

## Skills Keyword Bank

**Languages** TypeScript, JavaScript, Node.js, SCSS

**Frontend** React, Vite, React Router, React Hook Form, Emotion, Tailwind CSS, TanStack Query, Yup and Zod validation, responsive UI, multi-step forms, dynamic form rendering

**Mobile** React Native, Expo, EAS Build, React Navigation, Zustand, React Native Maps, iOS and Android release builds, geolocation, camera and signature capture

**Backend** Express, REST API design, Socket.IO namespaces, JWT authentication, bcrypt, Mongoose, cron scheduling, file upload handling, database migrations

**Data** MongoDB, schema modeling, aggregation pipelines, relational document design

**Payments** Stripe payment intents, saved payment methods, subscriptions, webhooks

**Cloud / DevOps** AWS ECS and ECR, EKS manifests, S3, CloudFront, Docker, nginx, GitHub Actions, multi-environment deploys

**Integrations** Google Maps Geocoding, Distance Matrix and Directions, Firebase Cloud Messaging, SendGrid, Nodemailer, AWS S3

**Domain** Roadside assistance, towing marketplace, two-sided marketplace matching, service dispatch, field service operations
