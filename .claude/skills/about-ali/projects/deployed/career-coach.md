---
name: Career Coach
status: deployed
deployment: https://beta.verdax.co.uk/
loom: https://www.loom.com/share/a1552ae0d3114bab9aaf5852783898aa, https://www.loom.com/share/44a0b0d93b30429f8b1b19c47d2ac699
target_market: AI edtech, students, career-changers
tech_stack: OpenAI Assistants API (file_search, threads), Next.js 14, NextAuth, Node.js, Express, MongoDB (Mongoose), Cloudinary, TypeScript, Tailwind, Radix UI / Shadcn, TanStack Query, Jotai, PM2, Nginx
---

# Career Coach

## Description
Career Coach is an AI-driven e-learning platform that turns uploaded source material into a fully structured course — modules, lessons, sublessons, and quizzes — and then delivers that course through a personalized AI tutor. An admin uploads a document, OpenAI's Assistants API (with `file_search`) ingests it and emits a structured course blueprint; students then move through the course chapter by chapter while a tutor assistant explains topics, gauges understanding, and decides when they're ready to move on.

The student experience is conversational: each sublesson is delivered as a chat thread with formatted Markdown, code blocks, and transition signals (`a_new_sublesson_started`, `start_the_quiz`, `skip_lesson_and_go_to_quiz`) that the frontend uses to drive lesson state. After each lesson, a separate quiz-conductor assistant generates a mix of MCQs and open-ended questions tied to the sublessons just covered, scores the student, and feeds progress back into the user's course path. Admins manage career pathways, course recommendations, and the broader catalog from a separate admin dashboard.

Built as a split Next.js 14 frontend / Express + MongoDB backend, deployed behind Nginx with PM2, role-based auth via NextAuth (admin vs. student routing enforced in middleware).

## Tech Stack
- **AI:** OpenAI Assistants API (v2) — `file_search` for course ingestion, threads for tutor chat, separate assistant for quiz generation
- **Frontend:** Next.js 14 (App Router), React 18, TypeScript, NextAuth, TanStack Query, Jotai, React Hook Form + Zod, Tailwind CSS, Radix UI / Shadcn, Framer Motion, react-markdown + syntax highlighter, dnd-kit / react-beautiful-dnd, Web Speech API (dom-speech-recognition)
- **Backend:** Node.js, Express, TypeScript, Mongoose (MongoDB), JWT, Multer, Cloudinary, Zod
- **Infra / Deploy:** PM2, Nginx (reverse proxy), Next.js standalone build

## Target Market
- AI edtech
- Students and self-learners
- Career-changers using structured courses to upskill

## Links
- Deployment: https://beta.verdax.co.uk/
- Loom 1: https://www.loom.com/share/a1552ae0d3114bab9aaf5852783898aa
- Loom 2: https://www.loom.com/share/44a0b0d93b30429f8b1b19c47d2ac699

## Notes
- **Two-assistant architecture:** course-population assistant (file_search → structured JSON of modules/lessons/sublessons) is distinct from the lesson-deliverer assistant (per-thread tutor) and the quiz-generator assistant. Keeping these separate kept prompts focused and avoided cross-task drift.
- **State machine via assistant output:** the tutor assistant emits flags (`a_new_sublesson_started`, `start_the_quiz`, `skip_lesson_and_go_to_quiz`) that the frontend interprets to drive lesson progression — pragmatic alternative to a brittle rules engine on top of free-form chat.
- **Auth-driven routing:** `middleware.ts` enforces role-based redirects — admins land on `/admin/dashboard`, students on `/dashboard`, and each role is blocked from the other's routes at the edge.
- **Career pathways:** admins can group courses into pathways and surface recommendations, so the platform isn't just standalone courses — it's a guided progression system.
- **Edtech sibling to [Startir.AI](startir-ai.md).** Differentiator: file-driven course generation, OpenAI Assistants threads for in-lesson chat, certification flow. Deployed under the verdax.co.uk domain.
- When pitching: lead with "uploaded PDF → structured course → AI tutor → adaptive quiz" — that end-to-end loop is the hardest part to get right and is the most unique part of the build.
