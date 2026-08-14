# Tow123 Dispatcher: Resume Bullets

An autonomous AI dispatcher for a roadside assistance and towing operation. It ingests live job
and fleet events from two third-party dispatch platforms, talks to customers and drivers over SMS,
decides which truck and driver to send, and executes the dispatch either through a human approval
queue or fully on its own.

---

## Project Header Lines

**Tow123 AI Dispatcher** | TypeScript, Convex, React 19, Vercel AI SDK, Google Gemini, Twilio, Stripe

**Event Relay Service** | Node.js, Pusher WebSockets, Fly.io, Docker

**Outpost API Interceptor** | Node.js, Hono, Server-Sent Events

---

## Autonomous Dispatch

- **Autonomous AI Dispatcher:** Built the system that decides which truck and driver to send on every tow, without a human.
- **Staged Autonomy Rollout:** Graduated the dispatcher through three gated phases: silent scoring, human approval, then full autonomy.
- **Self-Reverting Safety Net:** Daily job demotes the dispatcher to human approval when its 30-day approval rate falls below 85%.
- **Decision Accuracy Scoring:** Scored the algorithm's driver pick against the human dispatcher's daily, alerting when 7-day accuracy dropped below 70%.
- **Truck Eligibility Rules Engine:** Encoded nine rule families covering vehicle weight, drive type, exotics, tires, motorcycles, and location.
- **Replayable Decision Records:** Every dispatch saves a full fleet snapshot, so any pick can be replayed and explained weeks later.
- **Fairness and Coverage Guards:** Balanced job counts across drivers and blocked draining the last truck out of a high-demand area.

## AI Agents and Customer Communication

- **Customer-Facing AI Agent:** Shipped an SMS agent that collects location, vehicle, and service details from stranded customers.
- **Driver-Facing AI Agent:** Built a second SMS agent that accepts jobs, checks drivers in and out, and requests extra equipment.
- **Tool-Using Agents:** Gave the agents 31 typed tools so they write real dispatch records instead of only replying.
- **Human Approval Queue:** Routed every AI-triggered text, dispatch, and third-party write through a dispatcher review queue.
- **Frustration Escalation:** Detects an angry or stuck customer mid-conversation and hands the thread to a human dispatcher.
- **Photo Understanding:** The agent reads a photo of a customer's motor club card and a photo of the roadside scene.
- **High-Value Vehicle Guard:** AI estimates market value with live web search and auto-cancels vehicles worth over $250,000.

## Scale and Performance

- **Query Timeout Fix:** Cut a 1.8-second dashboard query under 1 second by replacing a full table read with indexed ranges.
- **Production Crash Elimination:** Bounded runaway database reads that were crashing dispatch, SMS routing, and the inbound webhook.
- **Full Table Scan Removal:** Replaced every remaining table scan with indexed queries across 79 tables and 165 indexes.

## Cost Engineering

- **$237-a-Day Bill Stopped:** Traced a $237 single-day Google Maps bill to redundant driver ETA lookups and capped the fan-out.
- **Routing Call Collapse:** A per-job cooldown cut routing API batches from over 15 an hour down to 1 to 3.
- **Cheaper Routing Path:** Moved single-driver ETA lookups onto an API call costing 75% less than the batch call it replaced.
- **Geocoding Cache:** Cached driver address lookups by map cell, cutting Google Geocoding spend by about 90%.

## Reliability and Safety

- **Dead Man's Switch:** A minute-by-minute watchdog emails alerts when the live event feed stops sending heartbeats.
- **Infinite Loop Guard:** Stopped a write-then-webhook feedback loop from re-dispatching the same job forever.
- **Three-Layer SMS Kill Switch:** A global switch, a recipient allowlist, and the approval queue prevent accidental texts to real customers.
- **Data Drift Reconciliation:** 24 scheduled jobs repair fleet and job data when third-party events go missing.
- **Internal Event Bus:** Built a publish-subscribe layer where 78 always-on subscribers react to 27 business events.

## Testing and Quality

- **25,800 Automated Tests:** Grew the suite to roughly 25,800 tests across unit, integration, and browser tiers.
- **Mutation Testing:** Ran mutation testing to find tests that passed while missing real bugs, then closed those gaps.
- **249 Job Simulations:** Authored 249 multi-actor simulations that replay full tow jobs against both a fake and a live backend.
- **Vendor API Mock Server:** Built a local interceptor service that captures and replays third-party traffic during tests.
- **Contract Drift Alerts:** 73 schemas validate every live third-party response and email the team the moment a field changes.

## Integrations and Operator Tools

- **Reverse-Engineered Two Platforms:** Integrated two dispatch systems that publish no public API, by decoding their web traffic.
- **Motor Club Auto-Accept:** Automatically accepts or denies incoming insurance jobs against ETA and price thresholds.
- **Dispatch Comparison Screen:** Built a replay screen putting the algorithm's pick beside the dispatcher's, with both routes on a map.
- **Simulator Suite:** Shipped driver GPS, customer text, and dispatch simulators so staff test flows without touching production.

---

## Skills Keyword Bank

**Languages** TypeScript, JavaScript, SQL, HogQL

**AI / ML** Vercel AI SDK, Google Gemini, OpenRouter, LLM tool calling, agentic workflows, prompt engineering, retrieval grounding, LLM evaluation, human-in-the-loop review, AI observability

**Backend** Convex, Node.js, Hono, serverless functions, event-driven architecture, publish-subscribe, workflow orchestration, cron scheduling, webhooks, WebSockets, REST, Zod validation, optimistic concurrency control

**Frontend** React 19, Vite, Tailwind CSS, Leaflet, real-time UI, data-heavy dashboards

**Data** Schema design, index design, query optimization, denormalization, pagination, data reconciliation, retention policies

**Cloud / DevOps** Convex Cloud, Cloudflare Pages, Fly.io, Docker, GitHub Actions, CI sharding, change-based deploys, secret rotation, feature flags, PostHog, Sentry-style error alerting

**Testing** Vitest, mutation testing (Stryker), contract testing, integration testing, scenario testing, Playwright, LLM scenario evaluation

**Integrations** Twilio SMS and MMS, Google Maps Routes and Geocoding, Mapbox, Stripe, Resend, Firebase, Okta SSO with TOTP, Pusher

**Domain** Towing and roadside assistance, dispatch operations, fleet management, ETA prediction, motor club billing, insurance job intake
