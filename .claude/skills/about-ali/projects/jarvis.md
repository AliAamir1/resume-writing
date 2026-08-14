# Resume Bullets — JARVIS

AI lead-outreach platform for an insurance agency. Autonomous SMS and email campaigns, GPT-driven conversations, sentiment-based lead qualification, and a role-gated admin console.

---

## Project Header Lines

**JARVIS Campaign Engine** | Python, FastAPI, SQLAlchemy, PostgreSQL, Agentic AI, OpenAI API, Gmail API, Twilio

**JARVIS Admin Console** | React 18, TypeScript, Vite, TanStack Query, Tailwind CSS

---

## AI Pipeline

- **Agentic AI Suite:** Built nine AI agents covering outreach copy, live replies, sentiment scoring, and agent handoff.
- **Sentiment-Driven Lead Routing:** A three-label classifier moves every lead between five campaign states with no human review.
- **LLM Output Hardening:** Wrote a fallback parser that recovers a usable label when the classifier returns prose, not a number.
- **Prompt Guardrails:** Blocked price quotes, emojis, and over-1550-character replies across every customer-facing insurance prompt.
- **Bilingual Handoff:** Tagged every agent handoff summary as Spanish or English, read from the lead's own messages.

## Autonomous Campaign Engine

- **Always-On Orchestration:** Ran six background services that send, poll for replies, score sentiment, and page managers continuously.
- **Two-Channel State Machine:** One lead lifecycle drives both SMS and Gmail campaigns from first touch to booked appointment.
- **Gmail Thread Continuity:** Threaded every AI reply into the lead's original conversation using In-Reply-To and References headers.
- **Manager Escalation:** Texted sales agents a GPT summary of each interested lead, throttled to one batch every 15 minutes.

## Compliance and Data Ingestion

- **Opt-Out Enforcement:** Matched 19 stop-word and regex patterns including STOP, DNC, UNSUB, and CANCEL to halt outreach immediately.
- **Inbox Lead Scraper:** Parsed inbound vendor lead emails into structured records across two incompatible email layouts.
- **Bulk CSV Upload:** Validated uploads row by row and returned the exact row number, field, and reason for every failure.

## Access Control and Delivery

- **Granular Permission System:** Shipped 29 permissions across 8 roles gating 19 of 24 application routes.
- **Full-Stack Delivery:** Wrote half of 185 frontend commits across 17 reviewed pull requests on a seven-person team.

---

## Skills Keyword Bank

**Languages:** Python, TypeScript, JavaScript, SQL, HTML, CSS

**Frontend:** React 18, Vite, TanStack Query, React Hook Form, Zod, Tailwind CSS, React Router, code splitting, optimistic updates

**Backend:** FastAPI, SQLAlchemy, Pydantic, Uvicorn, REST API design, JWT authentication, bcrypt, background workers, threading

**Data:** PostgreSQL, relational schema design, many-to-many association tables, server-side pagination, CSV ingestion, database seeding

**AI:** Agentic AI, LLM agents, autonomous agent orchestration, OpenAI API, prompt engineering, system prompts, sentiment classification, conversation summarization, chat history windowing, LLM output validation, AI guardrails

**Cloud and Integrations:** Gmail API, Google OAuth 2.0, Twilio SMS, MIME email threading

**DevOps:** Git, GitHub pull request workflow, feature branching, environment configuration

**Domain:** Insurance lead generation, marketing campaign automation, CRM workflows, TCPA-style opt-out compliance, role-based access control
