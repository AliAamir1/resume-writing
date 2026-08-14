---
name: Rituo
owner: FlatOut Ventures LLC
status: active
domain: Wellness, mindfulness, journaling, ritual-building
codebase: /Users/ali/Documents/flatout-solutions/rituo-org
deployment: AWS (ECS Fargate via Pulumi); iOS + Android via Expo / EAS
components: 3 (App · Platform IaC · CloudForge component library)
tech_stack_summary: Expo / React Native (mobile) + Next.js 15 admin (web) + NestJS 10 API (backend) + Pulumi multi-account AWS governance + custom CloudForge IaC component lib + Firebase FCM + multi-provider AI (Vercel AI SDK) + ElevenLabs TTS + MongoDB
---

# Rituo

A wellness and mindfulness product that helps users build positive **daily rituals** and **journaling habits** through AI-driven voice coaching, mood tracking, and personalized recommendations. **Mobile-first** (Expo / React Native iOS + Android) with a Next.js admin dashboard for the internal team and a NestJS API tying it all together.

Owned by **FlatOut Ventures LLC**.

## What Lives Here

This is a multi-component product, organized into three deep-dive subfolders plus a postmortem archive:

| Subfolder | What it covers |
|---|---|
| **[app/](app/README.md)** | The actual product: Expo mobile app, Next.js admin, NestJS backend, AI voice coaches (journal + ritual), Firebase FCM, MongoDB, ElevenLabs TTS, OAuth + JWT auth |
| **[platform/](platform/README.md)** | Pulumi multi-account AWS governance — AWS Organizations, Identity Center, GitHub OIDC, KMS-encrypted Pulumi state in S3, two SCPs, CloudFormation StackSets |
| **[cloudforge/](cloudforge/README.md)** | The reusable Pulumi/TypeScript component library shared across **all** FlatOut projects (Rituo, Kollaborative AI, MTH Equities Platform). Lives in this repo, exported via Git-SSH |
| **[incidents/](incidents/ecr-lifecycle-rca.md)** | Production postmortems — currently: the 2026-04-15 ECR-lifecycle / `CannotPullContainerError` RCA |

**Read the subfolder before quoting specifics.** Don't conflate the app with the platform with the component library — they're three distinct codebases with different audiences.

## Architecture (high level)

```
                     ┌──────────────────────────────────┐
                     │  CloudForge component library    │
                     │  (Pulumi/TS, ~11 components)     │
                     │  Git-SSH dep: @rituo/cloudforge  │
                     └─────────────────┬────────────────┘
                                       │ consumed by
            ┌──────────────────────────┼─────────────────────────┐
            ▼                          ▼                         ▼
   ┌────────────────────┐  ┌──────────────────────┐   (also used by Kollaborative AI
   │  Rituo Platform    │  │  Rituo App infra     │    and MTH Equities Platform)
   │  (multi-account    │  │  (per-project AWS    │
   │   AWS governance)  │  │   resources for app) │
   │  Pulumi · OIDC ·   │  │  ECS · ECR · S3 ·    │
   │  StackSets · KMS · │  │  ALB · Route53 · …   │
   │  SCPs · IdC        │  │                      │
   └────────────────────┘  └──────────┬───────────┘
                                      │ deploys
                                      ▼
   ┌────────────────────────────────────────────────────────────┐
   │  Rituo App                                                 │
   │   Mobile (Expo / React Native) — primary user surface      │
   │   Web admin (Next.js 15) — internal CMS / analytics        │
   │   Backend (NestJS 10 + Mongoose) — REST + WebSocket        │
   │   Firebase FCM — push only (no Auth, no Firestore)         │
   │   MongoDB · S3 · Secrets Manager · ElevenLabs · SendGrid   │
   │   Multi-provider AI via Vercel `ai` SDK                    │
   └────────────────────────────────────────────────────────────┘
```

## Headline Tech Stack

| Layer | Tools |
|---|---|
| Mobile | **Expo SDK 54**, React Native 0.81.5, Redux Toolkit, React Navigation, `@react-native-firebase/messaging`, Expo IAP, Expo Updates (OTA), Sentry |
| Web admin | Next.js 15, React 19, TypeScript, Tailwind 4, shadcn/ui, React Hook Form + Zod |
| Backend | **NestJS 10**, Node 22, Mongoose 9.x, MongoDB 8.8, Passport.js (Google/Facebook/Apple), JWT (access + refresh), Socket.IO, Pino |
| AI | **Vercel `ai` SDK** with multi-provider factory — OpenAI, Anthropic, Google, Mistral, Groq, XAI, Azure |
| Voice | **ElevenLabs** (TTS), Expo Audio (recording) |
| Push | **Firebase Admin SDK 13.6** for FCM (single + multicast + topics) — Firebase used **only for push**, not auth or DB |
| Email | SendGrid (transactional) |
| Storage / secrets | AWS S3 (files), AWS Secrets Manager (runtime credentials) |
| IaC | Pulumi (TypeScript) on AWS, custom **CloudForge** component library |
| CI/CD | GitHub Actions with **OIDC** auth to AWS, EAS for mobile builds |

## Product Surface (one-liners)

- **Voice journaling** — record audio, AI transcribes + analyzes, recommends reflection prompts.
- **Voice ritual coaching** — AI-driven guided rituals tailored to user goals, with TTS playback via ElevenLabs.
- **Mood tracking** — emotional-state logging across time.
- **Streak tracking** — encourages habit consistency.
- **Multi-provider AI** — runtime LLM-provider switching via factory pattern (`/backend/src/ai/factory`); OpenAI, Anthropic, Google, Mistral, Groq, XAI, Azure all callable through one interface.
- **Real-time** via Socket.IO (live coaching sessions).
- **In-app purchases** (Apple App Store) for subscriptions via Expo IAP.
- **OTA updates** via Expo Updates — ship app changes without App Store resubmission.
- **Admin dashboard** — Next.js CMS for content, users, analytics.

## Notable Engineering Decisions (cross-cutting)

1. **Firebase used purely for FCM push, not core infra** — MongoDB + JWT handle data + auth. Reduces vendor lock-in versus a typical "all-in on Firebase" mobile stack.
2. **Multi-provider AI factory** — provider switching at runtime via Vercel `ai` SDK; cost optimization + model switching without code changes.
3. **Hub-and-spoke OIDC** for CI/CD — management account holds the deploy roles; member accounts trust *those* roles, not GitHub directly. (See [platform/README.md](platform/README.md) for detail.)
4. **Pulumi state on self-managed S3 + KMS**, migrated off Pulumi Cloud — full migration documented in `MIGRATION_GUIDE.md` (3-part stack-name format `organization/<project>/<stack>`).
5. **CloudForge as a Git-SSH dependency** — pinned to commit SHAs in consumers for reproducibility, especially after the ECR lifecycle incident (see [incidents/](incidents/ecr-lifecycle-rca.md)).
6. **Yarn Classic + Volta pinning** — defensive after a Yarn Berry auto-upgrade incident silently rewrote `yarn.lock` into incompatible v2 format.

## Repo Layout

```
rituo-org/
├── rituo/                       # the application (mobile + admin + backend + per-project infra)
├── platform/                    # multi-account AWS governance (Pulumi)
├── CloudForge/                  # reusable Pulumi component library
├── app-deployment-workflows/    # GitHub Actions templates for app deploys
├── backups/
├── deploy-platform.yaml         # the platform CI workflow file
├── MIGRATION_GUIDE.md           # Pulumi Cloud → S3 backend migration steps
├── ECR_LIFECYCLE_RCA.md         # incident postmortem (mirrored at incidents/)
├── platform-changes.md
└── rituo-58118-firebase-adminsdk-…json   # Firebase service account (FCM only)
```

## Key Files (verifiable)

- `/Users/ali/Documents/flatout-solutions/rituo-org/MIGRATION_GUIDE.md`
- `/Users/ali/Documents/flatout-solutions/rituo-org/ECR_LIFECYCLE_RCA.md`
- `/Users/ali/Documents/flatout-solutions/rituo-org/deploy-platform.yaml`
- `/Users/ali/Documents/flatout-solutions/rituo-org/platform/src/index.ts`
- `/Users/ali/Documents/flatout-solutions/rituo-org/CloudForge/src/index.ts`
- `/Users/ali/Documents/flatout-solutions/rituo-org/rituo/backend/src/ai/factory`
- `/Users/ali/Documents/flatout-solutions/rituo-org/rituo/backend/src/firebase/firebase.service.ts`
