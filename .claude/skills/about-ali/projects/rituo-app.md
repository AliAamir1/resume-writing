---
name: Rituo
employer: FlatOut Ventures LLC
dates: unconfirmed
tech_used: Expo | React Native | NestJS 10 | Next.js 15 | MongoDB | AWS ECS
url: none
tags: react-native, mobile, llm, multi-provider, voice, nestjs, push, iap
gaps: dates, app store downloads, MAU, subscription conversion
---

# Rituo

Wellness product for building daily rituals and journaling habits through AI voice coaching, mood tracking, and personalized recommendations. Mobile-first on iOS and Android.

## Bullets

- *React Native Development*: Built the iOS and Android app on Expo SDK 54 and React Native 0.81 with Redux Toolkit, offline persistence, biometric auth, and Expo IAP subscriptions.
- *Multi-Provider AI Architecture*: Designed a provider factory over the Vercel AI SDK routing OpenAI, Anthropic, Google, Mistral, Groq, XAI, and Azure through one interface, switchable at runtime for cost tuning and model A/B testing without code changes.
- *Voice AI Features*: Shipped voice journaling and voice-guided ritual coaching using Expo Audio capture, AI transcription and analysis, and ElevenLabs text-to-speech playback.
- *NestJS API Development*: Built the REST and Socket.IO backend on NestJS 10 and MongoDB with JWT access and refresh tokens, Passport OAuth for Google, Facebook, and Apple, email OTP verification, and RBAC claims.
- *Push Notifications*: Integrated Firebase Cloud Messaging for single, multicast, and topic broadcasts while keeping auth and data on MongoDB and JWT to limit vendor lock-in.
- *Mobile Release Engineering*: Shipped over-the-air updates through Expo Updates so logic, copy, and AI prompt changes reach users in hours without App Store resubmission.
- *Containerized Deployment*: Deployed backend and admin as multi-stage Docker images to AWS ECS Fargate through Pulumi and GitHub Actions OIDC.
