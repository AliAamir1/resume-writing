---
name: AI Voice Agent for Towing Operators
employer: FlatOut Solutions
dates: unconfirmed
tech_used: Twilio | Convex | Vercel AI SDK | Anthropic | TypeScript
url: tow123.app
tags: voice-ai, agentic, llm-routing, twilio, multi-tenant, vertical-saas, hitl
gaps: dates, operators live, calls handled per month, percent resolved without human, measured latency
---

# AI Voice Agent for Towing Operators

Productized 24/7 AI phone receptionist sold to towing companies that cannot staff night dispatchers. Answers the intake line, qualifies the job, dispatches the closest truck, and pushes ETA updates.

## Bullets

- *AI Voice Agent Development*: Built a 24/7 Twilio voice agent that answers roadside intake calls, qualifies caller, location, vehicle, and service type, dispatches the closest available truck, and confirms ETA with the caller in natural language.
- *Multi-Provider LLM Routing*: Routed agent inference across Anthropic, Google, and OpenRouter behind an environment-controlled provider switch, enabling model A/B testing per deployment without a redeploy.
- *Voice Latency Optimization*: Held a sub-second response budget using streaming LLM responses, partial text-to-speech, and OpenTelemetry tracing across the speech recognition, LLM, text-to-speech, and Twilio hops.
- *Agentic Tool Calling*: Built a Zod-typed tool layer shared across voice, SMS, and human takeover so one customer conversation survives channel switches without losing context.
- *Human-in-the-Loop Safety*: Shipped per-channel approval gating and phone-number allowlists so operators validate AI output call by call before full autonomy, with automatic escalation to a human when a caller is stranded somewhere unsafe.
- *Multi-Tenant SaaS*: Productized the agent per operator with its own Twilio number, system prompt, fleet, service catalog, and pricing rules, sold as a per-seat or per-call subscription.
- *Webhook Security*: Verified inbound Twilio request signatures so adversarial calls cannot enter the agent loop.
