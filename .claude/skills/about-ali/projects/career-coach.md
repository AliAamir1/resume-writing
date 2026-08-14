---
name: Career Coach
employer: unconfirmed
dates: unconfirmed
tech_used: OpenAI Assistants API | Next.js 14 | Express | MongoDB | TypeScript
url: beta.verdax.co.uk
tags: llm, openai, edtech, rag, file-search, nextjs, middleware
gaps: dates, employer, courses generated, learners
---

# Career Coach

AI e-learning platform turning an uploaded document into a structured course, then delivering it through a conversational AI tutor with adaptive quizzing.

## Bullets

- *OpenAI Assistants API*: Built a three-assistant architecture separating course generation using file search over uploaded documents, per-thread lesson delivery, and quiz generation, keeping prompts focused and preventing cross-task drift.
- *Document-to-Course Pipeline*: Ingested uploaded source material and emitted a structured blueprint of modules, lessons, and sublessons, then delivered it chapter by chapter through a conversational tutor that gauges understanding before advancing.
- *LLM State Machine*: Drove lesson progression from transition flags emitted by the assistant and interpreted by the frontend, a pragmatic alternative to a rules engine layered over free-form chat.
- *Adaptive Assessment*: Generated mixed multiple-choice and open-ended quizzes tied to the sublessons just covered, scored them, and fed results back into each learner's course path.
- *Role-Based Routing*: Enforced admin and student separation in Next.js middleware so each role is blocked from the other's routes at the edge.
- *Production Deployment*: Deployed a split Next.js frontend and Express with MongoDB backend behind Nginx with PM2 process management.
