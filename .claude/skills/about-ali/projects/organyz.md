# Organyz: Resume Bullet Bank

12 bullets. No repository exists for this work, so no bullet carries a number. Pick 3 to 4 per resume.

The product: a cloud storage platform. Organyz already had the storage; this work was the AI layer on top of it, delivered as a single microservice, that reads a user's files and organizes them for them.

---

## Project Header Lines

- **Organyz AI Layer** | Python, LangGraph, Model Context Protocol, semantic search, AWS

---

## Classification and Organization

- **Automatic File Classification:** Classified and tagged every file in a user's storage, including new uploads at the moment they landed.
- **AI-Generated Directory Structure:** Proposed a full folder hierarchy from file content, so a user could reorganize an entire disk in one action instead of dragging files.
- **Content-Based Retrieval:** Indexed file contents semantically, so users found files by what was inside them rather than by remembering a filename.

## Cleanup and Lifecycle

- **Near-Duplicate Detection:** Flagged files that were similar but not byte-identical, the case exact-hash deduplication silently misses.
- **Stale File Detection:** Surfaced files left untouched long enough to be dead weight and proposed them as deletion candidates.
- **Suggested Actions, Not Automatic Ones:** Turned every finding into a reviewable proposal rather than a silent background change to someone's files.

## Human in the Loop

- **Approval Before Deletion:** Gated every destructive operation behind explicit user review, so the AI proposed and the user decided.
- **Explained Recommendations:** Surfaced why a file was flagged, so users could accept or reject a suggestion without opening it.

## Agent Interface

- **MCP Tool Server:** Exposed the platform's own services as Model Context Protocol tools, so an agent could operate the product rather than just answer questions about it.
- **Conversational Front End:** Shipped a chat interface over that MCP server, giving users natural-language access to every storage and organization feature.
- **Agentic Workflows:** Built the multi-step file handling on LangGraph, so classification, duplicate checking, and cleanup ran as one orchestrated flow.

## Architecture

- **Drop-In AI Microservice:** Delivered the whole AI layer as a single microservice against an existing production SaaS, with no rewrite of the host application.

---

## Skills Keyword Bank

**Languages:** Python

**AI:** LangGraph, agentic workflows, multi-step orchestration, Model Context Protocol, tool calling, semantic search, embeddings, document classification, near-duplicate detection, human-in-the-loop review, conversational interfaces

**Backend:** Microservice architecture, service integration against an existing SaaS, file ingestion pipelines, event-driven processing on upload

**Cloud:** AWS

**Domain:** Cloud storage, file lifecycle management, automated organization, deduplication, data cleanup, storage cost reduction

---

## Report

### Strongest 4

1. **Near-Duplicate Detection.** Every engineer knows hash-based dedup and knows it misses the near-miss case. Naming that gap shows you understood the actual problem.
2. **MCP Tool Server.** Currently rare on resumes and specific. It says the agent could act on the product, which is the distinction most candidates miss.
3. **AI-Generated Directory Structure.** A non-technical reader instantly pictures the value: one action instead of an afternoon of dragging files.
4. **Approval Before Deletion.** Judgment, not just capability. Anyone can delete files with an LLM; gating it is the part worth hiring.

### Everything here rests on scope, not a number

Unlike the other files in this folder, there is no strongest-by-metric tier, because there is no metric. Every bullet describes what was built. In a space-constrained resume, prefer bullets from files that carry real numbers and use these to cover AI and agentic keywords a posting asks for.

If a posting is heavy on agentic, MCP, or document AI, this file is the right pick despite the missing numbers.

### Verification notes

- **No repository exists.** The company ran out of budget and no longer operates, so there is no code to trace a claim back to. Every bullet is written from Ali's recollection alone.
- **No numbers anywhere, on purpose.** File counts, user counts, accuracy rates, storage reclaimed, latency: none are known. Do not add one later without a source. This is the file most at risk of a plausible-sounding invented metric.
- **The AWS surface is unconfirmed.** "AWS" is claimed because the work ran there, but which services (Bedrock, SageMaker, Textract, Comprehend, S3 events) is not established. Do not name a specific service until Ali confirms it.
- **Semantic search is inferred from the project tags,** not from Ali's own description of the work. Confirm before leaning on it in an interview.
- **`employer` is unconfirmed.** Ali has said the company no longer exists, which narrows it, but the skill rules forbid inferring the answer. Until he names it, these bullets can appear only under `Projects`, never under a `#work()` block.
- **Ali's share of the work is unstated.** He described it as "we built", so scope the claims to what he personally owned before an interview.

### Gaps

- Which employer this belongs to
- Which AWS services were used
- Whether semantic search was actually part of the build
- Any number at all: files processed, users served, duplicates found, storage reclaimed
- Which LLM provider backed the classification and chat
- Dates the work ran
