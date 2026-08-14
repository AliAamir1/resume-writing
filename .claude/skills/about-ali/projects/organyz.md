# Organyz: Resume Bullet Bank

8 bullets. Pick 3 to 4 per resume.

The product: a cloud storage platform. Organyz already had the storage; this work was the AI layer on top of it, delivered as a single microservice, that reads a user's files and organizes them for them.

Use when the posting is agentic AI, MCP, document AI, or data lifecycle. Against a posting that wants measured outcomes, files with real numbers win the slot.

---

## Project Header Lines

- **Organyz AI Layer** | Python, LangGraph, Model Context Protocol, AWS

---

## Classification and Organization

- **Automatic File Classification:** Classified and tagged every file in a user's storage, including new uploads at the moment they landed.
- **AI-Generated Directory Structure:** Proposed a full folder hierarchy from file content, so a user reorganized an entire disk in one action.

## Cleanup and Lifecycle

- **Near-Duplicate Detection:** Flagged files that were similar but not byte-identical, the case exact-hash deduplication silently misses.
- **Stale File Detection:** Surfaced files left untouched long enough to be dead weight and proposed them as deletion candidates.
- **Human Approval Gate:** Held every deletion behind user review with the reason it was flagged, so the AI proposed and the user decided.

## Agent Interface

- **MCP Tool Server:** Exposed platform services as MCP tools with a chat front end, so an agent could operate the product, not just describe it.
- **Agentic Workflows:** Built the multi-step file handling on LangGraph, so classification, duplicate checking, and cleanup ran as one orchestrated flow.

## Architecture

- **Drop-In AI Microservice:** Delivered the whole AI layer as one microservice against an existing production SaaS, with no rewrite of the host app.

---

## Skills Keyword Bank

**Languages:** Python

**AI:** LangGraph, agentic workflows, multi-step orchestration, Model Context Protocol, tool calling, document classification, near-duplicate detection, human-in-the-loop review, conversational interfaces

**Backend:** Microservice architecture, service integration against an existing SaaS, file ingestion pipelines, event-driven processing on upload

**Cloud:** AWS

**Domain:** Cloud storage, file lifecycle management, automated organization, deduplication, data cleanup, storage cost reduction

---

## Selection guidance

Strongest openers: Near-Duplicate Detection, MCP Tool Server, AI-Generated Directory Structure, Human Approval Gate.

Every bullet rests on scope, since no metric exists for this project. One real number would outrank all eight.

---

## Confirm before sending

- **No repository exists.** The company folded, so nothing here traces to code. Every bullet is from Ali's recollection.
- **Never add a number to this file.** No file counts, accuracy rates, storage reclaimed, or latency are known. This is the file most at risk of a plausible invented metric.
- **Do not name a specific AWS service.** That the work ran on AWS is claimed; which services is not established.
- **Semantic search was cut**, both as a bullet and from the header line. It came from the project tags, not from Ali's own account of the work. Restore only if he confirms it.
- **Employer is unconfirmed**, so these bullets can appear under `Projects` only, never under a `#work()` block.
- **Ali described this as "we built".** Scope claims to what he personally owned before an interview.
