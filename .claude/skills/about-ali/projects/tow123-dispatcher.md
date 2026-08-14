# Tow123 Dispatcher: Resume Bullets

21 bullets. An autonomous AI dispatcher for a roadside assistance and towing operation. It ingests live job and fleet events from two third-party dispatch platforms, talks to customers and drivers over SMS, decides which truck and driver to send, and executes the dispatch either through a human approval queue or fully on its own.

Use when the posting is agentic AI, autonomous systems, real-time operations, or AI safety. The deepest file in the folder on shipping autonomy responsibly.

---

## Project Header Lines

**Tow123 AI Dispatcher** | TypeScript, Convex, React 19, Vercel AI SDK, Google Gemini, Twilio, Stripe

**Event Relay Service** | Node.js, Pusher WebSockets, Fly.io, Docker

**Outpost API Interceptor** | Node.js, Hono, Server-Sent Events

---

## Autonomous Dispatch

- **Autonomous AI Dispatcher:** Built the system that decides which truck and driver to send on every tow, without a human.
- **Staged Autonomy Rollout:** Graduated the dispatcher through three gated phases: silent scoring, human approval, then full autonomy.
- **Self-Reverting Safety Net:** Scored every AI pick against the human dispatcher's and auto-demoted the system to human approval when accuracy slipped.
- **Truck Eligibility Rules Engine:** Encoded nine rule families covering vehicle weight, drive type, exotics, tires, motorcycles, and location.
- **Replayable Decision Records:** Every dispatch saves a full fleet snapshot, so any pick can be replayed and explained weeks later.
- **Fairness and Coverage Guards:** Balanced job counts across drivers and blocked draining the last truck out of a high-demand area.

## AI Agents

- **Tool-Using Agents:** Gave the agents 31 typed tools so they write real dispatch records instead of only replying.
- **Customer and Driver SMS Agents:** Two agents collect job details from stranded customers and handle driver acceptance, check-in, and equipment requests.
- **High-Value Vehicle Guard:** AI estimates market value with live web search and auto-cancels vehicles worth over $250,000.
- **Frustration Escalation:** Detects an angry or stuck customer mid-conversation and hands the thread to a human dispatcher.
- **Photo Understanding:** The agent reads a photo of a customer's motor club card and a photo of the roadside scene.

## Safety and Reliability

- **Three-Layer SMS Kill Switch:** A global switch, a recipient allowlist, and the approval queue prevent accidental texts to real customers.
- **Human Approval Queue:** Routed every AI-triggered text, dispatch, and third-party write through a dispatcher review queue.
- **Dead Man's Switch:** A minute-by-minute watchdog emails alerts when the live event feed stops sending heartbeats.
- **Data Drift Reconciliation:** 24 scheduled jobs repair fleet and job data when third-party events go missing.

## Cost Engineering

- **$237-a-Day Bill Stopped:** Traced a $237 single-day Google Maps bill to redundant driver ETA lookups and capped the fan-out.
- **Mapping Spend Reduction:** Cached geocoding by map cell and moved ETA lookups to a cheaper call, cutting that spend around 90%.

## Scale and Performance

- **Production Crash Elimination:** Bounded runaway database reads that were crashing dispatch, SMS routing, and the inbound webhook.
- **Full Table Scan Removal:** Replaced every remaining table scan with indexed queries across 79 tables and 165 indexes.

## Integrations

- **Platform Integration Without APIs:** Integrated two third-party dispatch platforms that publish no public API, so live job and fleet events flow in automatically.
- **Motor Club Auto-Accept:** Automatically accepts or denies incoming insurance jobs against ETA and price thresholds.
- **Contract Drift Alerts:** 73 schemas validate every live third-party response and email the team the moment a field changes.

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

---

## Selection guidance

Strongest openers, in order: Autonomous AI Dispatcher, Staged Autonomy Rollout, $237-a-Day Bill Stopped, High-Value Vehicle Guard, Self-Reverting Safety Net.

Staged Autonomy Rollout and Self-Reverting Safety Net are the pair that separate this from every other AI project. Anyone can ship an agent. Shipping one that grades itself and revokes its own permissions is the part a serious reader will want to discuss.

High-Value Vehicle Guard is the most memorable single sentence: an AI that refuses to tow a $250,000 car.

Resting on scope. Drop first: Photo Understanding, Data Drift Reconciliation, Motor Club Auto-Accept.

---

## Confirm before sending

- **Platform integration was authorized client work**, connecting the towing company's own accounts on dispatch platforms they already paid for. Never write "reverse-engineered" or "decoded their traffic" as the headline. The technical detail is fine in conversation.
- **Self-Reverting Safety Net dropped its thresholds** (85% approval over 30 days, 70% accuracy over 7 days) because two sets of numbers in one bullet obscured the idea. Bring them back if a posting is metrics-heavy.
- **Never claim a test count or mutation testing.** 25,800 tests, 249 simulations, and the mock server were cut on purpose: a resume sells what you built, not how the code was written.
- **$237, $250,000, 31 tools, 79 tables, 165 indexes, 73 schemas, 24 jobs** are all real. Know the source of each before an interview.
- **No dispatch volume metrics exist.** Jobs auto-dispatched per day, or the share running without human approval, would outrank every bullet above.
