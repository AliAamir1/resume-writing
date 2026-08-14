# Tow123 Dispatcher: Resume Bullet Bank

23 bullets. Every number traces to code or a ticket-referenced comment in this repo. Pick 3 to 5 per resume.

---

## Project Header Lines

- **Tow123 AI Dispatch Console** | TypeScript, React 19, Convex, Vercel AI SDK, Twilio, Anthropic, Google, OpenRouter
- **Event Relay Sidecar** | TypeScript, Node, Fly.io, Pusher, Socket.IO

---

## Database and Query Performance

- **Query Optimization:** Cut a call-list query reading 1,019 documents and 10.39 MB, which blew past the 1 second platform limit at 1.8 seconds.
- **Index Range Scans:** Replaced a full-table filter with index range queries that skip completed and cancelled calls entirely.
- **Data Integrity Bug:** Found 64% of active-thread flags pointing at already-finished calls, inflating routing scans past the 16 MB read ceiling.
- **Concurrency Fix:** Removed sequential awaits inside a loop that were the dominant cause of timeout spikes on the conversations dashboard.

---

## Cost and Tuning

- **API Cost Reduction:** Cut routing API spend by widening the ETA recalculation interval from 2 minutes to 5.
- **Alert Tuning from Field Data:** Retuned GPS freshness thresholds from 30 seconds to 2 minutes after real pings every 10 to 30 seconds tripped warnings on every dispatch.
- **LLM Round-Trip Elimination:** Inlined static data into the prompt so the agent stops calling a tool, removing token cost from a hot path.

---

## AI Agents

- **Multi-Provider LLM Routing:** Routed agent inference across Anthropic, Google, and OpenRouter, switchable per deployment without a redeploy.
- **Two-Sided Conversational Agents:** Built separate customer and driver AI agents sharing one message store across SMS, voice, and human takeover.
- **Deterministic Decision Split:** Kept ETA and driver selection as pure functions so the model proposes and the engine decides, leaving dispatch auditable.
- **Autonomy Graduation Gate:** Gated an operator's move to full autonomy on a 90% approve-as-is rate over their approval history.
- **Accuracy Monitoring:** Alerted when 7-day dispatch accuracy fell below 70%, tuned upward as operators built trust.
- **Human-in-the-Loop Approval:** Queued every AI-proposed message for approval with per-channel toggles and phone allowlists during onboarding.

---

## Integrations

- **Bidirectional Vendor Sync:** Synced calls, drivers, trucks, and ETAs both ways with the industry system of record, using a write-origin guard to stop echo loops.
- **Webhook Latency Budget:** Held inbound webhook handlers inside Twilio's 15-second response window.
- **Motor Club Integration:** Integrated a motor-club dispatch platform behind Okta single sign-on with TOTP.
- **Legacy Bridge:** Shipped a Fly.io sidecar bridging Pusher to Socket.IO so legacy clients consume the new event stream without a rewrite.

---

## ETA Engine

- **Stall Detection:** Flagged jobs as stalled after 10 minutes without driver movement and auto-stopped monitoring at 4 hours.
- **Notification Throttling:** Notified customers only on 5-minute ETA swings, with a 10-minute cooldown between messages.
- **Stale Data Guard:** Suppressed customer notifications for ETAs over 3 hours, which in practice only came from bad upstream data.

---

## Testing

- **Test Suite Scale:** Wrote 25,856 test cases across 1,007 test files covering agents, ETA math, sync, and dispatch decisions.
- **LLM Scenario Testing:** Replayed full fixture conversations offline to catch agent regressions before deploy.
- **PII Linting:** Gated test fixtures with a linter blocking real customer data from entering the repository.

---

## Skills Keyword Bank

**Languages:** TypeScript, JavaScript

**Frontend:** React 19, Vite, Tailwind CSS, shadcn/ui, Leaflet, React Leaflet

**Backend:** Convex, serverless functions, real-time subscriptions, cron scheduling, webhooks, HTTP actions

**AI:** Vercel AI SDK, Anthropic Claude, Google Gemini, OpenRouter, agent orchestration, tool calling, structured output, Zod schemas, prompt engineering, LLM evaluation, scenario testing

**Voice and Messaging:** Twilio Voice, Twilio SMS, webhook signature verification, Pusher, Socket.IO

**Data:** schema design, index design, query optimization, range queries, read-limit tuning, bidirectional sync, reconciliation

**Observability:** OpenTelemetry, distributed tracing, structured logging, alert thresholds

**Cloud:** Fly.io, Docker, GitHub Actions

**Domain:** dispatch, fleet routing, ETA modeling, roadside assistance, motor club integration

---

## Report

**Strongest 5.** Each has a measured before and after, or a rare scale number.

1. **Query Optimization** - 1,019 docs, 10.39 MB, 1.8s against a 1s ceiling. Fully specified performance work.
2. **Data Integrity Bug** - 64% of flags wrong, with the 16 MB consequence named. Shows debugging at the data layer, not the symptom.
3. **Test Suite Scale** - 25,856 tests is an outlier number and the single most credible rigor signal in the portfolio.
4. **Alert Tuning from Field Data** - changed a threshold because reality disagreed with the default. Judgment, not code.
5. **API Cost Reduction** - names the tradeoff taken to cut spend.

**Resting on scope, drop these first.** Two-Sided Conversational Agents, Human-in-the-Loop Approval, Motor Club Integration, Legacy Bridge, Multi-Provider LLM Routing, PII Linting. All describe what exists rather than what changed.

**Could not verify.** No production volume anywhere in the repo: no calls handled, operators live, revenue, or uptime. The ETA thresholds are configured defaults, not measured outcomes, so do not phrase them as results. Test counts come from counting `it` and `test` blocks and include the sidecar.
