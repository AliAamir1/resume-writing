---
name: Tow123 AI Dispatch Console
employer: FlatOut Solutions
dates: unconfirmed
tech_used: React 19 | Convex | Vercel AI SDK | Twilio | TypeScript
url: none
tags: agentic, llm, real-time, integrations, convex, testing, eval, dispatch
gaps: dates, active calls per day, dispatch decisions automated, human takeover rate
---

# Tow123 AI Dispatch Console

Operator-side console where AI agents and human dispatchers co-pilot every active roadside call, from intake through driver assignment, ETA tracking, and post-job sync.

## Bullets

- *AI Agent Orchestration*: Built a real-time dispatch console where customer-side and driver-side AI agents run SMS and voice conversations over a single event store, with human dispatchers able to take over any thread mid-conversation.
- *Bidirectional API Sync*: Implemented two-way sync with Towbook, the towing industry system of record, using a write-origin loop guard that tags self-originated events so webhook echoes never trigger reconciliation storms, plus scheduled drift reconciliation.
- *Deterministic Decision Engine*: Separated dispatch math into pure unit-tested functions covering deadhead drive time, true ETA, status time remaining, driver selection, and routing, so the LLM proposes and the engine prices, keeping every dispatch decision auditable.
- *Third-Party Integrations*: Integrated Twilio voice and SMS, Bringg motor-club dispatch behind Okta OTP authentication, plate-to-VIN vehicle lookup, and Google Maps geocoding.
- *LLM Testing and Evaluation*: Built scenario replay tests over fixture conversations with Vitest and a scenario framework, plus a fixture PII linter gating real customer data out of the repository, so agent regressions are caught before deploy.
- *Real-Time Event Architecture*: Shipped a relay sidecar bridging Pusher to socket.io-client so legacy clients and vendor event streams consume the new backend without a rewrite.
- *Rules Engine*: Built a declarative rules layer over call state, for example escalating to a human when a customer has not replied within a threshold.
