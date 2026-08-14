# Kollaborative AI: Resume Bullet Bank

12 bullets. Every number traces to code in this repo. Pick 3 to 5 per resume, matched to the posting.

The product: a team AI workspace. People share chats, build searchable knowledge bases from their conversations, connect outside AI tools to it, and get billed per seat.

Sections are the selection surface. Match the posting's emphasis to a section, then take the strongest 3 to 5 across it.

---

## Project Header Lines

- **Kollaborative AI** | TypeScript, Next.js 15, React 19, Convex, Clerk, Cloudflare Pages
- **Agent API and OAuth Server** | TypeScript, Model Context Protocol, OAuth 2.1, PKCE
- **Edge Proxies** | TypeScript, Cloudflare Workers, Wrangler

---

## Money

- **AI Cost Cut:** Benchmarked summarization models and switched to one 12x cheaper with 5x the context window.
- **1,000x Fewer Vendor Calls:** Rebuilt knowledge-base indexing to send 1,000 messages per AI call instead of one.
- **AI Spend Leaks:** Closed four paths billing AI calls with no cap or owner: public prompts, background jobs, looping agents, over-budget downloads.

---

## Search and AI Pipeline

- **Silent Search Data Loss:** Found pasted documents keeping only their last 2,000 characters, while the rebuild reported success.
- **Silent Model Downgrade:** Caught conversations pinned to a premium AI model quietly answering on a cheaper, weaker one.
- **Four Providers, One Interface:** Streamed 15 chat models and 6 image models from OpenAI, Anthropic, Google and OpenRouter.

---

## Reliability

- **Hung Chat Recovery:** AI replies killed mid-generation hung forever; added a watchdog clearing them within 30 seconds.
- **Self-Healing Billing:** Six background jobs re-converge seat counts and subscriptions after any failed call to the billing provider.

---

## Permissions and Data Correctness

- **Duplicate Account Merge:** Collapsed one person's multiple logins into a single account across 29 tables, dry run first.
- **43-Table Permission Model:** Designed organizations, spaces, teams and threads with per-resource sharing across 43 tables and 188 indexes.

---

## Integrations

- **Killed Pasted API Keys:** Built an OAuth server so people connect outside tools by signing in, not pasting permanent secrets.
- **Agent API:** Exposed 16 tools letting outside AI agents read and write conversations, spaces and knowledge bases.

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

## Selection guidance

Strongest openers, in order: AI Cost Cut, 1,000x Fewer Vendor Calls, AI Spend Leaks, Silent Model Downgrade, Silent Search Data Loss. Each lets a non-technical reader picture what went wrong and what it was worth.

Resting on scope rather than a number. Drop these first: 43-Table Permission Model, Agent API, Four Providers One Interface, Self-Healing Billing. Keep them only when the posting names that exact thing, where they become the best match in the file.

---

## Confirm before sending

- **1,000x is a ceiling, not an average.** Indexing packs up to 1,000 messages per call; the old path sent one per message. A 40-message knowledge base sees 40x. Say "up to" if asked.
- **12x, 1,000x, and 2,000 characters** come from engineering comments by the authors of those changes. No independent benchmark exists.
- **This repo has 12 contributors and 224 merged PRs.** Those describe the codebase, not your share. Claim only what you did.
- **No runtime or business metrics exist here.** No user counts, revenue, latency percentiles, uptime, or adoption. Never add one.
- **Never describe how the code was written.** A resume sells what you built and what it was worth, not your tooling or process.
