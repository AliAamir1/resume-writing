---
name: Tow123 / Flatout AI Voice Agent for Towing Companies
client: Tow123 (sold by Flatout Solutions to other towing operators)
status: active (productized service)
codebase: shares `convex/` agent layer with /Users/ali/Documents/flatout-solutions/tow123-org/dispatcher
deployment: Twilio voice numbers per-customer, Convex backend
tech_stack: Twilio (voice + SMS), @convex-dev/agent, Vercel AI SDK (ai v6), @ai-sdk/anthropic, @ai-sdk/google, @openrouter/ai-sdk-provider, Zod 4, Convex, Resend, Towbook integration, plate-to-VIN APIs, Google Maps Services
target_market: Independent towing companies (50+ truck fleets and small/mid operators) who can't staff 24/7 dispatchers, motor-club preferred-vendors, roadside service providers
---

# AI Voice Agent for Towing Companies

A productized service Flatout Solutions sells to **other towing companies** (not just Tow123 itself): a 24/7 AI phone agent that answers the company's main intake line, handles new-call qualification, dispatches the closest available truck, and proactively sends ETA updates to customers — all over the phone, with optional SMS + email follow-ups.

This is the part of the Tow123 stack we **commercialize externally**. The dispatcher is the internal operator console; the voice agent is what an operator's *customer* hears when they call in.

## What It Does

When a stranded driver (or a motor-club agent) calls the operator's number:

1. **Twilio** routes the call to the voice agent.
2. The agent identifies caller, location (street + landmarks + safety check), vehicle (with **plate-to-VIN auto-fill** when the caller doesn't know their make/model), and **service type** (tow, jump, fuel, lockout, tire change).
3. The agent runs the same **deterministic dispatch logic** as the dispatcher — `etaEngine/` selects the best truck given current fleet state, dead-head, and active calls.
4. The agent confirms ETA with the caller in natural language ("I've got Truck 7 about 18 minutes out, does that work?") and creates the call record in Convex (and **Towbook**, if the operator uses it).
5. The driver-side agent texts the assigned driver, monitors status, and **proactively calls or texts the customer** with ETA changes.
6. If the agent can't handle a request (escalation triggers, customer asks for a human, ambiguous intake), it **transfers to the human dispatcher** and hands off the conversation context.

## Why Operators Buy It

- **24/7 coverage without staffing.** A 10-truck operator can't justify a night dispatcher; the AI runs through the night.
- **Faster answer times = more booked jobs.** Calls that go to voicemail get lost to the next-up tow truck. The AI answers in 2 rings.
- **Consistent intake.** Every call captures the same fields the dispatcher needs (location safety, vehicle, service, payer/PO, motor-club fields).
- **Towbook-native.** For operators already on Towbook, the call appears in their existing system without changing their workflow.
- **Human-in-the-loop guardrails during onboarding** so the agent can be turned on call-by-call until the operator trusts it.

## Architecture

The voice agent is **not a separate codebase** — it's a thin **Twilio voice/SMS layer** on top of the same **Convex agent layer** the [dispatcher](../dispatcher/README.md) uses. The benefit of this is that **a single conversation can flow across SMS, voice, and human takeover** without context loss.

```
Caller dials operator's Twilio number
         │
         ▼
Twilio Voice ─────────► Convex http.ts webhook
(real-time voice                    │
 streaming, ASR,                    ▼
 TTS, barge-in)              modelProvider.ts ─► (Anthropic | Google | OpenRouter)
                                    │
                                    ▼
                       customerConversations.ts
                       customerConversationPrompt.ts
                       conversationTools.ts
                       (locate-me, confirm-vehicle,
                        change-service, request-eta,
                        request-driver-update,
                        transfer-to-human)
                                    │
                       ┌────────────┼────────────┐
                       ▼            ▼            ▼
                  etaEngine/   vehicleIntelligence/   towbook/
                  driverSelection plate→VIN           sync (call create + ETA push)
                                                      bringg/ (motor club)
                                    │
                                    ▼
                       pendingActions/  (HITL approval if enabled)
                                    │
                                    ▼
                       sms/send → customer / driver
                       (or twilio outbound voice for proactive ETA calls)
```

## Conversation Tooling Reused from Dispatcher

The voice agent's prompt + tools are the same `convex/conversationTools.ts` and `convex/customerConversationPrompt.ts` the dispatcher uses for inbound SMS. This means:

- **Plate-to-VIN** lookups during voice intake (`vehicleIntelligence/`).
- **Location-safety** guardrails (`sms/locationSafety.ts`) — the agent flags interstates, dark side-streets, accident scenes for human handoff.
- **Cross-call linking** (`sms/crossCallConversations.ts`) so a customer who calls back about the same job lands in the same conversation thread.
- **Scene assessment** (`calls/sceneAssessment.ts`) — the driver-side agent collects scene photos + structured assessment over SMS once the truck arrives, billed back to the original voice intake.
- **Initial-ETA + ETA-update** flows (`sms/customerInitialEta.ts`, `sms/customerInitialEtaHelpers.ts`) — used both for inbound SMS confirmations and for proactive outbound voice/SMS.

## Approval / Onboarding Mode

Same toggles as the dispatcher (in `dispatcher-config.json`):

- `customerConversationsEnabled` — turns the AI customer-side agent on/off.
- `conversationApprovalEnabled` + `conversationAgentResponseApprovalEnabled` — every AI utterance lands in the **pending actions** queue for human approval before it goes out over voice/SMS.
- `conversationListMode: allowlist` — during onboarding, only specific phone numbers receive AI-generated comms; everything else gets a human transfer.

This is how operators try the voice agent on **their own personal phone first**, then a few trusted customers, then progressively widen the allowlist until they're comfortable flipping it to "everyone."

## Tech Stack

- **Twilio** — Voice (Programmable Voice + Media Streams for low-latency ASR/TTS), Phone Numbers, SMS. Inbound webhook signature verification (`sms/twilioAuth.ts`).
- **Vercel AI SDK 6** + **`@convex-dev/agent`** for agent orchestration.
- **LLM providers** — Anthropic (Claude), Google (Gemini), OpenRouter; switchable at runtime per-deployment via `MODEL_PROVIDER`.
- **Convex** — backend, database, scheduling, HTTP routing.
- **Zod 4** for tool schemas / structured outputs (so call summaries land in the database with typed fields, not unstructured strings).
- **Resend** for transactional email follow-ups (receipts, dispatch confirmations).
- **Towbook + Bringg** integrations inherited from dispatcher.
- **OpenTelemetry** for tracing voice-call latency across ASR → LLM → TTS → Twilio.

## What Makes This Hard

- **Voice latency budget.** Customers expect <1s response. The agent uses streaming LLM responses, partial TTS, and provider-side switching to stay under budget.
- **Voice intake is messier than SMS.** People give addresses as cross-streets, landmarks, "the Shell on the corner of…" — `locationAgent.ts` handles disambiguation; integration with Google Maps Services for autocomplete + reverse geocoding.
- **Safety-critical handoff.** If a caller is on the shoulder of an interstate, the agent has to escalate immediately rather than continue qualification. This is one reason the dispatcher's location-safety helpers are reused as-is.
- **Per-operator brand + persona.** Each customer of the service gets their own Twilio number, system prompt, fleet, service-type catalog, and pricing rules — multi-tenancy lives in Convex schema and `settings.ts`.
- **Compliance.** SMS allowlisting + opt-out handling + Twilio compliance fields are baked in (`textMessageAllowlistNumbers`, `textMessageListMode`).

## Pricing / Productization Model

The voice agent is sold to towing companies as a **per-seat or per-call SaaS subscription** with onboarding. The onboarding workflow uses the allowlist + approval modes so the operator can validate quality on real calls before flipping the agent to "answer everything."

## Notes for Pitching

- This is the **clearest commercial AI product** in the Tow123 stack — most prospects in towing have never seen a working voice agent answer their own intake line, and the demo is dramatic.
- For **AI / voice / Twilio** pitches: lead with the latency budget + multi-provider routing + reused tool layer — same tools work over voice and SMS.
- For **vertical-SaaS** pitches: lead with the multi-tenant, Towbook-native nature — this is software that fits into operators' existing workflow, not a rip-and-replace.
- Useful framing: "We use the same AI dispatcher Tow123 uses internally and license it as a 24/7 phone agent to other towing companies."
- Codebase note: voice agent is not a separate repo — it's the `convex/calls/` + `convex/customerConversations.ts` + `sms/` + Twilio webhook surface inside the **dispatcher** repo, plus per-customer Convex deployments.
