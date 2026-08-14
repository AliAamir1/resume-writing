---
name: Tow123 Dispatcher (AI Dispatch Console)
client: Tow123
status: active (production + ongoing build-out)
codebase: /Users/ali/Documents/flatout-solutions/tow123-org/dispatcher
deployment: Convex (backend), Fly.io (event-relay sidecar), private dispatcher console
tech_stack: React 19, Vite, TypeScript, Convex, @convex-dev/agent, Vercel AI SDK (ai v6), @ai-sdk/anthropic, @ai-sdk/google, @openrouter/ai-sdk-provider, Twilio (voice + SMS), Pusher, Resend, Leaflet, Zod 4, Vitest 4, @langwatch/scenario, OpenTelemetry
target_market: Towing operators (in-house dispatchers, fleet managers) and motor-club integrators
---

# Tow123 Dispatcher

The operator-side brain of the Tow123 ecosystem: a real-time dispatching console where AI agents and human dispatchers co-pilot the lifecycle of every active call — from intake through driver assignment, ETA tracking, customer comms, and post-job sync.

## What It Does

- Surfaces every **active call** with state, location, vehicle, driver assignment, and ETA in real time.
- Runs **two-sided AI conversations** — one for the **customer** (intake, ETA updates, location safety questions) and one for the **driver** (status nudges, location requests, scene-assessment prompts) — over **SMS** *and* **voice**, with a single Convex-backed event/message store.
- **Auto-dispatches** jobs to the best truck using a deterministic ETA + selection engine (`convex/etaEngine/`), then asks an AI agent or human to confirm before texting the driver.
- **Bidirectionally syncs** with **Towbook** (the de-facto towing-management SaaS) — call/driver/truck/eta/dispatch/waypoint events flow both ways, with an `isOurWrite` loop-guard to prevent echo storms.
- Integrates with **motor clubs** (e.g. Bringg, with Okta + OTP auth) so calls dispatched via a motor club land in the same console as direct calls.
- Supports **scenario replay + simulation** — `simulateDispatch.ts`, `simulateDriverSelection.ts`, plus `@langwatch/scenario` tests — so dispatch logic can be exercised offline against fixture conversations.

## Architecture

```
Twilio (voice + SMS)  ─┐
Towbook webhooks       ├─►  Convex backend  ◄──►  React/Vite frontend (dispatcher console)
Bringg / motor club    │     ├─ events/                      Leaflet map of fleet
Pusher (realtime)      │     ├─ etaEngine/                   per-call AI conversation views
                       │     ├─ dispatching/                 approval gates for outbound msgs
                       │     ├─ towbook/                     fleet/driver/truck panels
                       │     ├─ sms/  (twilioAuth, send,     cross-call conversations
                       │     │       routing, locationSafety)
                       │     ├─ calls/  (sceneAssessment)
                       │     ├─ vehicleIntelligence/  (plate→VIN)
                       │     ├─ rulesEngine/
                       │     └─ pendingActions/  (HITL approval queue)
                       │
                       └──►  event-relay (Fly.io, tsx) — bridges Pusher ↔ socket.io-client
                                                        for legacy clients / Towbook stream
```

## Convex Backend (Detailed)

The `convex/` directory is where almost all the interesting logic lives. Highlights:

- **`auth.ts` / `otp.ts` / `users/`** — Convex Auth + OTP-based dispatcher login (with TOTP via `otpauth` for Bringg's Okta MFA flow).
- **`autoDispatch.ts` + `dispatching/`** — auto-dispatch decisioning (`reDispatch`, `simulateDispatchDecision`, `retryDispatchOnAddress`, `refreshAutoDispatchPreviews`, `scheduleAutoDispatchRefresh`) with snapshot utilities for deterministic replays.
- **`etaEngine/`** — `deadheadDriveTime`, `trueEta`, `statusTimeRemaining`, `driverSelection`, `routing`, `service` — pure functions, fully unit-tested.
- **`etaMonitoring/` + `etaUpdateHelpers.ts` + `etaConstants.ts`** — recurring ETA recompute + customer/driver notification thresholds.
- **`customerConversations.ts` + `customerConversationPrompt.ts` + `conversationTools.ts`** — the **customer-side AI agent**: prompt, tool definitions (locate-me, confirm-vehicle, change-service, cancel, ETA-question), with approval gating.
- **`driverConversations.ts` + `driverConversationTools.ts`** — the **driver-side AI agent**: location request, status update, scene assessment, photo intake.
- **`sms/`** — full SMS subsystem: `twilioAuth` (signature verification), `send`, `routing`, `phoneUtils`, `humanMessage` + `driverHumanMessage` (when a human dispatcher takes over a thread), `locationSafety` + `locationSafetyUtils` (PII / unsafe-location guardrails), `customerInitialEta` + `customerInitialEtaHelpers`, `unattendedVehicle`, `crossCallConversations`, `templateUtils`, `timeouts`, `base64`.
- **`calls/sceneAssessment.ts`** — when a driver arrives, the agent asks a structured scene-assessment series; results feed back into pricing + safety flags.
- **`towbook/`** — `client`, `auth`, `sync`, `reconciliation`, `events`, `callEvents`, `driverEvents`, `truckEvents`, `etaUpdate`, `dispatchUpdate`, `waypointUpdate`, `callFieldSync` + `callFieldSyncHelpers`, `motorClubDetection`, `unattendedTowbookSync` + `unattendedNoteHelpers`, `isOurWrite`, `handlers/`. Bidirectional sync with strong loop-guard.
- **`bringg/`** — motor-club integration with Okta-backed login (`bringgOktaUsername` / `bringgOktaPassword` / `oktaOtpSecret`).
- **`pendingActions.ts` + `pendingActions/`** — the HITL approval queue: every AI-proposed customer/driver message (or dispatch decision) lands here when approval is enabled.
- **`vehicleIntelligence/`** + **`vehicles/`** — plate-to-VIN lookup (using a third-party plate API) + cached vehicle metadata so the agent's tool-calls auto-fill make/model/year.
- **`fleet/` + `trucks.ts` + `drivers.ts`** — fleet state.
- **`rulesEngine/`** — declarative rules over events/state (e.g. "if customer hasn't replied in 5 min, escalate to human").
- **`scenarios/` + `simulator/` + `testing/`** — deterministic replay + scenario fixtures. Vitest 4 + `convex-test` + `@langwatch/scenario`.
- **`migrations/`** — schema migrations.
- **`crons.ts`** — scheduled Convex actions (ETA recompute, reconciliation, dispatch refresh).
- **`http.ts`** — webhook surface for Twilio, Towbook, simulator endpoints.
- **`modelProvider.ts`** — runtime selection between OpenRouter / Anthropic / Google AI providers.

## AI / Agent Stack

- **`@convex-dev/agent` (alpha)** for agent orchestration inside Convex.
- **Vercel AI SDK 6** (`ai`) — message format, tool calls, streaming.
- **Providers**: `@ai-sdk/anthropic`, `@ai-sdk/google`, `@openrouter/ai-sdk-provider`. Provider switched at runtime via `MODEL_PROVIDER` env (`google`, `anthropic`, `openrouter`).
- **Zod 4** for tool schemas — uniform validation between agent calls and HTTP webhooks.
- **OpenTelemetry** (`@opentelemetry/api`, `@opentelemetry/sdk-node`) for distributed tracing across Convex + event-relay + frontend.
- **`@langwatch/scenario`** for end-to-end scenario tests — replay a fixture call, assert agent decisions, check final Towbook state.

## Approval / Safety Model

Per `dispatcher-config.json`, every outbound channel has independent toggles:

```
customerCommunication:
  customerConversationsEnabled: true
  conversationApprovalEnabled: true
  conversationAgentResponseApprovalEnabled: true
  conversationListMode: allowlist
  conversationAllowlistNumbers: [whitelisted phones during onboarding]
  textMessagesEnabled: false (during onboarding)

driverCommunication:
  driverConversationsEnabled: true
  conversationApprovalEnabled: true
  conversationAgentResponseApprovalEnabled: true
  conversationAllowlistEnabled: true
```

Allowlist mode lets a new tow operator onboard with **only their own phones** receiving AI-generated messages until they're confident in the agent.

## Frontend

- **React 19 + Vite 7 + TypeScript 5.9**
- **TailwindCSS 4** (with `@tailwindcss/vite`)
- **Leaflet + React Leaflet 5** for the dispatcher map (truck pins + active-call routes)
- **`pusher-js` + `socket.io-client`** for realtime event ingestion (the dispatcher subscribes to the same channels the event-relay republishes)
- Convex React hooks + Convex Auth for everything else

## Event-Relay Sidecar

- Tiny Node 22 / `tsx` service (`event-relay/`) on Fly.io that bridges **Pusher** (used by newer services) ↔ **socket.io-client** (used by Towbook event streams + legacy provider app).
- Shipped as a Docker image with `esbuild` bundling.

## Testing

- `vitest run` — unit tests
- `vitest --config vitest.integration.config.ts` — integration
- `vitest --config vitest.scenario.config.ts` — scenario tests
- `npx tsx scripts/scenario-runner.ts` — CLI scenario runner
- `npx tsx scripts/check-fixture-pii.ts` — fixture PII linter (gates real customer data out of fixtures)
- Husky pre-commit + lint-staged + Prettier across `convex/`, `frontend/`, `event-relay/`, `.agents/skills/`

## Other Integrations

- **Twilio** voice + SMS (account `AC29ec…`, phone `+18334395360` in dev)
- **Towbook** (company `171615` in dev) — credential-based scrape + event sync
- **Bringg** with Okta SSO (TOTP via `otpauth`)
- **Resend** for transactional email
- **Plate-to-VIN** API (`PLATE_TO_VIN_API_KEY`)
- **Google Maps** for geocoding / route preview

## Notable Engineering Highlights

- **`isOurWrite` loop-guard** for bidirectional Towbook sync.
- **Provider-agnostic agent layer** — same code, three LLM providers, switchable at runtime per-deployment.
- **Hard separation between deterministic ETA logic and LLM-suggested actions** — the agent proposes, the engine prices, the operator (or auto-dispatch policy) confirms.
- **HITL approval queue + per-channel allowlists** so onboarding new operators doesn't risk a misfired AI text.
- **Scenario tests with `@langwatch/scenario`** — agent regressions get caught before deploy.
- **Single Convex schema** (`schema.ts` + per-module schemas) covering events, conversations, calls, drivers, trucks, dispatch decisions, pending actions, sync state — schema is the source of truth, not the database.

## Notes

- The dispatcher is the **active growth area** of the Tow123 ecosystem and the surface most adjacent to the AI voice agent product.
- Filepaths to remember: `convex/`, `frontend/src/`, `event-relay/src/`, `dispatcher-config.json`, `Motor Club ETA Updates.md`, `Creating Fixture Sequences.md`.
- Repo lives at `/Users/ali/Documents/flatout-solutions/tow123-org/dispatcher`.
