---
name: about-ali
description: Use when responding as Ali, writing on his behalf (LinkedIn, applications, cold outreach, portfolio copy), discussing his projects, tech stacks, work history, target markets, or matching his voice and perspective. Authoritative reference for Ali's complete professional profile.
---

# About Ali

Authoritative knowledge base for Ali — his portfolio, work, tech stacks, target markets, voice, and history. **Always read the relevant files in this skill before speaking on Ali's behalf or making claims about his experience.**

## When to Use

- Drafting messages, posts, applications, or cover letters as Ali
- Answering "what has Ali built?", "what's his stack?", "what does he know?"
- Picking which project to highlight for a given role/audience
- Anything where getting his profile *wrong* would be worse than asking

## How This Skill Is Organized

This skill is a **directory tree, not a single file.** Don't try to load everything at once — navigate to what you need.

```
about-ali/
├── SKILL.md                      ← you are here (map + when to use)
├── profile/                      ← who Ali is (bio, voice, contact, skills)
│   └── README.md                 ← (to be filled)
├── projects/                     ← portfolio, one file per project
│   ├── README.md                 ← INDEX — start here for project lookups
│   ├── deployed/                 ← live, public, production projects
│   │   ├── tskr.md
│   │   ├── joinpangia.md
│   │   ├── simuspace.md
│   │   ├── rehq.md
│   │   ├── kollaborative-ai.md
│   │   ├── alvanda.md
│   │   ├── tow123.md
│   │   ├── startir-ai.md
│   │   ├── omnilocal.md
│   │   ├── convify.md
│   │   ├── perigon-ai.md
│   │   ├── crypto-chart-cli.md
│   │   ├── ggms-cms.md
│   │   ├── ggms-marketing-suite.md
│   │   ├── career-coach.md
│   │   └── organyz.md
│   ├── internal/                 ← deployed over HTTP / no public deployment
│   │   ├── jarvis.md
│   │   ├── photomentor.md
│   │   └── landscape-ai.md
│   ├── clients/                  ← multi-project client engagements
│   │   ├── mth-equities/         ← MTH Equities (4 projects + governance platform)
│   │   │   ├── README.md         ← unified overview, integration map, full stack
│   │   │   ├── equities-map/        ← analyst dashboard + 13-phase PLUTO ETL (Fly.io)
│   │   │   ├── property-data-enrichment/  ← Gemini + ScrapingBee + AWS Lambda pipeline
│   │   │   ├── snf-explorer/        ← nationwide SNF map + CMS-driven ETL
│   │   │   └── platform/            ← Pulumi-based AWS multi-account governance
│   │   └── 121-air-sea-cargo/    ← 121 Air Sea Cargo (UAE freight forwarder, 4 components)
│   │       ├── README.md         ← unified overview · integration map · domain highlights
│   │       ├── backend/             ← Express + Prisma + PG · 18 models · Puppeteer PDF
│   │       ├── ops-portal/          ← Next.js 15 production internal portal (Vercel)
│   │       ├── cargo-frontend/      ← earlier prototype iteration (mock data, no auth)
│   │       └── invoice-generator/   ← standalone client-side PDF tool (jsPDF + dom-to-image)
│   └── products/                 ← multi-project FlatOut-owned products
│       └── rituo/                ← Rituo (wellness app + IaC + reusable component lib)
│           ├── README.md         ← unified overview + arch diagram + tech-stack table
│           ├── app/              ← Expo mobile + Next.js admin + NestJS API + multi-provider AI
│           ├── platform/         ← Pulumi multi-account AWS governance (S3-backed state)
│           ├── cloudforge/       ← reusable Pulumi/TS component lib (used across portfolio)
│           └── incidents/        ← postmortems (currently: 2026-04-15 ECR lifecycle RCA)
├── experience/                   ← work history, roles, companies (to be filled)
│   └── README.md
├── voice/                        ← writing samples, tone rules (to be filled)
│   └── README.md
└── upwork-proposals/             ← archived Upwork job postings + proposals sent (style corpus)
    ├── README.md                 ← INDEX + how to use for style inference
    └── YYYY-MM-DD-<slug>.md      ← one file per proposal (job posting + proposal text)
```

## Navigation Rules

**Don't recall from memory — read the file.** Project details rot fast. Always open the actual `.md` for the project you're discussing.

1. **Looking up a specific project?** Open [projects/README.md](projects/README.md) for the index, then jump to the project file.
2. **Picking projects for an audience?** Read the index, filter by `Target Market` and `Tech Stack` fields, then open the 2–3 strongest matches in full.
3. **Writing in Ali's voice?** Read [voice/README.md](voice/README.md) before drafting (when populated).
4. **Answering "what's his experience with X stack"?** Grep across `projects/**/*.md` for the technology, then open the matching files.
5. **Drafting an Upwork proposal?** Open [upwork-proposals/README.md](upwork-proposals/README.md) and skim 2–3 past entries to match Ali's send-shape on that surface before writing.

## Project File Schema

Every project file under `projects/` follows the same shape so cross-referencing is mechanical:

```markdown
---
name: <Project Name>
status: deployed | internal | archived
deployment: <URL or "internal" or "none">
loom: <URL or "none">
target_market: <comma-separated audiences>
tech_stack: <comma-separated technologies>
---

# <Project Name>

## Description
<1–3 paragraphs in Ali's words>

## Tech Stack
- bullet list

## Target Market
- bullet list

## Links
- Deployment: ...
- Loom: ...

## Notes
<freeform — context, scale, what was hard, what to highlight when pitching>
```

## Maintenance

- New project? Add a file under `projects/deployed/` or `projects/internal/`, then add a one-line entry to [projects/README.md](projects/README.md).
- New project under an existing **client**? Add a subfolder under `projects/clients/<client>/<project>/README.md` and link it from the client's `README.md`.
- New **client** with multiple projects? Create `projects/clients/<client-slug>/` with a `README.md` (unified overview + integration map) and one subfolder per project.
- New project under an existing **FlatOut product**? Add a subfolder under `projects/products/<product>/<component>/README.md` and link from the product's `README.md`.
- New **FlatOut product** with multiple components? Create `projects/products/<product-slug>/` mirroring the `clients/<client>/` shape.
- **Production incident worth keeping?** Add it under `projects/products/<product>/incidents/<slug>.md` (or `clients/<client>/<project>/incidents/`) — RCAs are portfolio gold for showing engineering maturity.
- Changed status (e.g. project went down)? Update the frontmatter `status` and `deployment` fields in that project's file, and update the index.
- New tech learned / new role / new client? Add to `experience/` or `profile/skills.md`, don't cram into a project file.

## Red Flags — Stop and Read the File

- About to claim Ali "built X with Y stack" without opening the project file → **stop, read it.**
- About to write copy in Ali's voice without checking `voice/` → **stop, read it.**
- About to pick a project to feature without checking the index → **stop, read it.**

Memory is stale. The files are the source of truth.
