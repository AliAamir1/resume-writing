---
name: Rituo App
parent: Rituo (FlatOut Ventures)
status: active
codebase: /Users/ali/Documents/flatout-solutions/rituo-org/rituo
deployment: AWS ECS Fargate (backend + admin); Expo / EAS for mobile
tech_stack: Expo SDK 54, React Native 0.81.5, Next.js 15, React 19, NestJS 10, Node 22, MongoDB 8.8, Mongoose, Vercel `ai` SDK (multi-provider), ElevenLabs, Firebase Admin SDK 13.6 (FCM only), Passport.js (Google/Facebook/Apple OAuth), JWT, Socket.IO, Redis, Sentry, Expo IAP, Expo Updates, SendGrid, AWS S3, AWS Secrets Manager
target_market: Individuals building daily ritual + journaling habits — wellness, mindfulness, personal growth
---

# Rituo — App (Mobile + Web Admin + Backend)

The user-facing product. **Three-tier monorepo** under `rituo/` with clear separation: mobile (`mobile/`), web admin (`admin/`), backend (`backend/`).

## Tier 1 — Mobile (`rituo/mobile`)

**Primary user surface** — iOS and Android via Expo / React Native.

- **Expo SDK 54** · React Native 0.81.5 · TypeScript
- **Redux Toolkit** + Redux Persist for state + offline support
- **React Navigation** for routing
- **`@react-native-firebase/app`** + **`@react-native-firebase/messaging`** for FCM device-side token registration
- **Expo Audio** — voice journaling recording
- **ElevenLabs** (server-side TTS, streamed to device) — voice-guided rituals
- **Expo IAP** — Apple App Store subscription purchases
- **Expo Updates** — OTA app updates without App Store resubmission
- **Sentry** — crash reporting
- Biometric auth, async-storage offline cache
- **EAS** (Expo Application Services) for managed builds (preview + production branches)

## Tier 2 — Web Admin (`rituo/admin`)

Internal CMS / analytics surface for the FlatOut team.

- Next.js 15 (App Router) · React 19 · TypeScript
- Tailwind 4 · shadcn/ui
- React Hook Form + Zod
- Multi-stage Docker build → ECS Fargate (port 3000)

## Tier 3 — Backend (`rituo/backend`)

NestJS REST API + WebSocket gateway, port 3001.

- **NestJS 10** · Node 22 · TypeScript
- **MongoDB 8.8** + **Mongoose** ODM (typed schemas: users, journals, rituals, goals, moods, subscriptions)
- **Passport.js** strategies — Google / Facebook / Apple OAuth
- **JWT** (access + refresh) — cookies for web, secure storage for mobile
- **Email/password** with bcrypt + email-OTP verification
- **RBAC** in JWT payload
- **Socket.IO** for live coaching sessions
- **Pino** structured logging
- **Multi-stage Docker build** → ECS Fargate

### AI Layer (`rituo/backend/src/ai`)

The interesting bit. **Multi-provider** AI via Vercel's `ai` SDK with a factory pattern:

- Providers: **OpenAI · Anthropic (Claude) · Google · Mistral · Groq · XAI · Azure**
- All AI calls flow through `factory/` → runtime provider switching via config, no code changes
- **`journal-voice-coach`** — generates AI-driven guidance from journal entries
- **`ritual-voice-coach`** — coaches users through their personalized rituals with TTS playback (ElevenLabs)
- **`journal-recommendation`** — suggests reflection prompts based on entry analysis
- **`ritual-recommendation`** — suggests rituals aligned with user goals
- **`user-ai-profile`** — tracks per-user preferences + learning style for model personalization

Reason for the abstraction: cost optimization, model A/B testing, and avoiding vendor lock-in for the AI tier.

### Firebase (FCM only)

- Service account `rituo-58118-firebase-adminsdk-fbsvc-b8b92bdd69.json` at repo root.
- `backend/src/firebase/firebase.service.ts` — single + multicast + topic-based notifications.
- Mobile registers FCM tokens on login; backend updates them.
- Topics for broadcasts ("all-users", "premium-users").
- **No Firestore. No Firebase Auth.** Just messaging.

### External Services

- **AWS S3** — file storage
- **AWS Secrets Manager** — runtime credentials (API keys, DB strings)
- **ElevenLabs** — TTS for voice-guided rituals
- **SendGrid** — transactional email

## Data Model (high level)

MongoDB collections via Mongoose schemas: `users`, `journals`, `rituals`, `goals`, `moods`, `subscriptions`. RBAC roles in JWT.

## Realtime

Socket.IO gateway in NestJS for live coaching sessions and any feature that benefits from server push.

## Deployment & CI/CD

- **Backend + Admin** — multi-stage Alpine Docker builds → ECS Fargate via Pulumi (using **CloudForge** components: ECS, ALB, Route53, S3, ECR).
- **Mobile** — EAS managed builds; Expo Updates handles OTA after App Store / Play Store releases.
- **GitHub Actions** workflows: `dev.yml`, `qa.yml`, `prod.yml`, `infra-deploy.yml`. AWS auth via **OIDC** (no static credentials).

## Notable Engineering Decisions

1. **Firebase only for FCM** — MongoDB + JWT for everything else. Reduces vendor lock-in vs. a typical "all-in on Firebase" mobile stack.
2. **Multi-provider AI factory** — runtime provider switching, lets the team optimize per-task (Claude for reasoning, GPT for drafting, etc.) without code changes.
3. **JWT + refresh-token + secure-storage** — gives mobile the offline-friendly session story without leaking auth state to insecure storage.
4. **OTA updates via Expo Updates** — ship JS changes (logic, copy, AI prompts) in hours, not days.
5. **Yarn workspaces monorepo** — shared dependencies + types across web, mobile, backend.

## Key Files (verifiable)

- `rituo/backend/src/ai/factory/` — multi-provider AI abstraction
- `rituo/backend/src/firebase/firebase.service.ts` — FCM client
- `rituo/backend/Dockerfile` — multi-stage Alpine build
- `rituo/admin/Dockerfile`
- `rituo/.github/workflows/{dev,qa,prod,infra-deploy}.yml`
- `rituo/mobile/app.json` (Expo config), `eas.json`

## Notes

- Don't conflate this with `rituo-org/platform/` — that's the **organization-level** AWS governance IaC ([../platform/](../platform/README.md)). This (`rituo-org/rituo/`) is the application + per-project infra that *deploys into* accounts created by the platform.
- Don't conflate with `rituo-org/CloudForge/` — that's the [reusable component library](../cloudforge/README.md) that this project's infra consumes.
