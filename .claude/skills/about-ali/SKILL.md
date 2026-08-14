---
name: about-ali
description: Use when responding as Ali, writing on his behalf (LinkedIn, applications, cold outreach, portfolio copy), discussing his projects, tech stacks, work history, target markets, or matching his voice and perspective. Authoritative reference for Ali's complete professional profile.
---

# About Ali

Source of truth for Ali's portfolio, work history, and personal facts. **Read the file before making any claim on his behalf.** Memory goes stale; these files do not.

## Layout

```
about-ali/
├── SKILL.md                  you are here
├── profile/
│   ├── facts.md              contact, education, availability, comp, work auth, EEO, form-fill rules
│   └── skills.md             years-of-experience table, scoring shortcuts
├── experience/
│   └── README.md             roles reverse-chronological, #work()-ready
└── projects/
    ├── README.md             flat index with tags, plus what must never go on a resume
    └── <slug>.md             one file per project, ~35 of them
```

No category folders. A project is a project whether it was internal, client work, or a product.

## Project file shape

```markdown
---
name: <resume-facing project name>
employer: <company, or "unconfirmed">
dates: <Mon YYYY - Mon YYYY, or "unconfirmed">
tech_used: <Pipe | Separated | Stack>
url: <bare domain, or "none">
tags: <comma-separated, for matching against a posting>
gaps: <what is missing from this file>
---

# <name>

<one sentence of context>

## Bullets

- *Keyword Title*: claim.
```

Bullets are written pre-formatted for the Typst resume in `ats-friendly-resume/`. Frontmatter maps onto `#project(name:, dates:, tech-used:, url:)`; `employer` says which `#work()` block the bullets belong under instead.

## Writing an application

1. Pull keywords from the posting by hand. See the `resume-writing` skill for why this is not delegable.
2. Match against the `tags` column in [projects/README.md](projects/README.md), open the 2-4 strongest files.
3. Copy bullets whose titles already speak the posting's language. Do not invent new claims to fit.
4. Fill contact, education, and screening answers from [profile/facts.md](profile/facts.md) verbatim.
5. Check the posting against the hard remote constraints in `profile/facts.md` before writing anything.

## Rules

- **No em dashes or en dashes.** Not in project files, not in generated resumes. ASCII hyphen only. A stray dash is invisible at a glance and survives into the PDF.
- **`unconfirmed` is not a blank to fill.** It means the fact was never established. Ask Ali; never infer it.
- **Never invent a metric.** Bullets state scope facts that the source material proves. If a number would strengthen a bullet, it is listed in that file's `gaps`.
- **Never claim a demo is production.** See the "Do not put on a resume" section of the projects index.

## Maintenance

- New project: add `projects/<slug>.md` in the shape above, add a row to the index.
- Facts changed: edit `profile/facts.md`. It is the only place contact, comp, and screening answers live.
- New role: add a row to `experience/README.md` and reconcile the open items there.
