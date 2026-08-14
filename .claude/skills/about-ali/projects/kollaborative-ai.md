# Kollaborative AI: Resume Bullet Bank

25 bullets. Every number traces to code in this repo. Pick 3 to 5 per resume.

The product: a team AI workspace. People share chats, build searchable knowledge bases from their conversations, connect outside AI tools to it, and get billed per seat.

---

## Project Header Lines

- **Kollaborative AI** | TypeScript, Next.js 15, React 19, Convex, Clerk, Cloudflare Pages
- **Agent API and OAuth Server** | TypeScript, Model Context Protocol, OAuth 2.1, PKCE
- **Edge Proxies** | TypeScript, Cloudflare Workers, Wrangler

---

## Money

- **AI Cost Cut:** Benchmarked summarization models and switched to one 12x cheaper with 5x the context window.
- **1,000x Fewer Vendor Calls:** Rebuilt knowledge-base indexing to send 1,000 messages per AI call instead of one.
- **Unbilled AI Spend:** Closed a hole letting background jobs run paid AI calls with nobody on the hook for the bill.
- **Open Wallet Endpoint:** Shut down a public page forwarding unlimited-length prompts to two paid AI vendors with no login.
- **Runaway Agent Loop:** Stopped two AI agents emoji ping-ponging forever, each round trip billed as a paid call.
- **Spend Cap Before Download:** Blocked over-budget accounts before file download, since one 240KB attachment bills 134 embeddings.

---

## Search and AI Pipeline

- **Silent Search Data Loss:** Found pasted documents keeping only their last 2,000 characters, while the rebuild reported success.
- **Safe Rebuild Ordering:** Built the new search index before deleting the old one, so failures never empty a knowledge base.
- **Silent Model Downgrade:** Caught conversations pinned to a premium AI model quietly answering on a cheaper, weaker one.
- **Four Providers, One Interface:** Streamed 15 chat models and 6 image models from OpenAI, Anthropic, Google and OpenRouter.

---

## Reliability

- **Hung Chat Recovery:** AI replies killed mid-generation hung forever; added a watchdog clearing them within 30 seconds.
- **15-Minute Retry Budget:** Gave every indexing job 15 minutes of automatic retries through vendor rate limits before giving up.
- **Self-Healing Billing:** Six background jobs re-converge seat counts and subscriptions after any failed call to the billing provider.

---

## Permissions and Data Correctness

- **Share Dialog Read Blowout:** Capped participant lists at 50 after large organizations pushed the share dialog past the database's read limit.
- **No Fake Zeros:** Showed a dash, not "0 members", when a guest lacks permission to see an organization's real numbers.
- **Duplicate Account Merge:** Collapsed one person's multiple logins into a single account across 29 tables, dry run first.
- **43-Table Permission Model:** Designed organizations, spaces, teams and threads with per-resource sharing across 43 tables and 188 indexes.

---

## Integrations

- **Killed Pasted API Keys:** Built an OAuth server so people connect outside tools by signing in, not pasting permanent secrets.
- **Agent API:** Exposed 16 tools letting outside AI agents read and write conversations, spaces and knowledge bases.
- **Hid the Backend Address:** Put the real-time backend behind an edge proxy so its address never shipped in a public npm package.

---

## Infrastructure

- **Split Deploy Pipeline:** Backend, frontend and two edge workers now ship separately instead of all four on every push.
- **Fail Before Shipping Broken:** Made the build fail on a missing secret that would have silently disabled every rate limit.

---

## Testing

- **3,802 Tests:** Wrote 3,802 automated tests across 334 files covering backend logic and React components.
- **Tests Written in English:** Drove browser tests with plain-English instructions, so UI refactors stop breaking the test suite.
- **Real-Browser Layout Test:** Replaced a CSS-class assertion with a real-browser test catching actual mobile scroll breakage.

---

## Skills Keyword Bank

**Languages:** TypeScript, JavaScript, Bash

**Frontend:** React 19, Next.js 15, App Router, Tailwind CSS, shadcn/ui, Radix UI, React Hook Form, Zod, TanStack Table, Framer Motion

**Backend:** Convex, serverless functions, real-time subscriptions, cron scheduling, webhooks, HTTP actions, pagination

**AI:** OpenAI, Anthropic Claude, Google Gemini, OpenRouter, Voyage AI, RAG, vector search, contextualized embeddings, reranking, streaming inference, tool calling, Model Context Protocol

**Auth and Security:** Clerk, OAuth 2.1, PKCE, dynamic client registration, RBAC, multi-tenant access control, AES-256-GCM, token hashing, secrets encrypted at rest

**Cloud and Infra:** Cloudflare Pages, Cloudflare Workers, Wrangler, edge runtime, WebSocket proxying

**DevOps:** GitHub Actions, path-filtered CI, monorepo, Yarn, Volta, Husky, LaunchDarkly, git worktrees

**Testing:** Vitest, React Testing Library, convex-test, Playwright, Stagehand

**Domain:** Multi-tenant SaaS, per-seat billing, bring-your-own-key plans, usage metering, spend caps, rate limiting

---

## Report

### Strongest 5

1. **AI Cost Cut.** 12x is a number a hiring manager can convert to money without knowing anything about the codebase.
2. **1,000x Fewer Vendor Calls.** Same reason, bigger number, and it names the thing that got cheaper.
3. **Open Wallet Endpoint.** Anyone reading it immediately pictures the damage: strangers spending your company's money.
4. **Hung Chat Recovery.** A user-visible failure with a stated recovery time. Product sense plus engineering.
5. **3,802 Tests.** A hard count most candidates cannot produce.

Notice what these five share: a non-technical reader knows what went wrong and what it was worth. Any bullet that needs a paragraph of setup before it means anything is a weak bullet, no matter how hard the work was.

### Resting on scope, not a number

Drop these first when space is tight. They describe what exists rather than what changed:

- 43-Table Permission Model
- Agent API
- Four Providers, One Interface
- Self-Healing Billing
- Split Deploy Pipeline
- Hid the Backend Address

### Verification notes

- **3,802 tests / 334 files** is a static count of `it(` and `test(` call sites, not a runner tally. `vitest list` needs generated Convex types that are gitignored, so it cannot run on a clean checkout.
- **12x, 1,000x, 2,000 characters, 240KB / 134 embeddings** come from engineering comments written by the authors of those changes. No independent benchmark exists in this repo.
- **1,000x is a ceiling, not an average.** Indexing packs up to 1,000 messages into one vendor call; the old path sent one call per message. A 40-message knowledge base sees 40x, not 1,000x. Say "up to" if asked.
- **No runtime or business metrics exist anywhere in this repo.** No user counts, revenue, latency percentiles, uptime, or adoption. No bullet claims any.
- **The previous version of this file claimed AWS ECS Fargate, ALB, ECR, Route53, SES and Pulumi.** None are in this repo. Deploy targets are Convex and Cloudflare.
- **This repo has 12 contributors and 224 merged PRs.** These describe the codebase, not your share of it. Claim only what you did.
- **Nothing here says how the code was written.** A resume sells what you built and what it was worth, not your tooling. Anything describing your development process was cut on purpose; do not add it back.
