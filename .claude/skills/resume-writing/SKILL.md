---
name: resume-writing
description: Use when writing, editing, or reviewing a resume, or tailoring one to a job posting. Rules for passing ATS scanners and ranking high in them.
---

# Resume Writing

Three rules. Rules 1 and 2 get the resume READ. Rule 3 gets it RANKED.

**Never report a "match score" or "ATS score" percentage.** No ATS computes one. Any number here would be invented.

## 0. No em dashes. Ever.

Not one `—` anywhere in the finished document. Same for the en dash `–`. Only the plain ASCII hyphen `-`.

Where they sneak in:

| Instead of | Write |
|---|---|
| `*Query Optimization* — cut p99 latency 40%` | `*Query Optimization*: cut p99 latency 40%` |
| `Mar 2023 — Present` | `Mar 2023 - Present` |
| `Reduced latency — from 1.8s to 310ms` | `Reduced latency from 1.8s to 310ms` |

Bullet titles take a **colon**, not a dash.

**Typst trap:** the `ats-friendly-resume` package's `dates-util()` helper hardcodes an em dash between start and end date. Do not call it. Pass the date range as a plain string instead:

```typst
dates: "Mar 2023 - Present",     // correct
dates: dates-util(...),           // emits an em dash
```

**Verify before sending**, since a stray dash is invisible at a glance:

```bash
pdftotext resume.pdf - | grep -n '[—–]' && echo "FOUND DASHES" || echo "clean"
```

## 1. Template must be machine-readable

- No text boxes. One is survivable. A template built out of them is not.
- Single column is safest. Two columns only if built with Word's native Columns feature, since most online two-column templates are text boxes underneath. Verify before trusting one.
- No images, graphics, charts, or skill bars.
- No headers/footers. Contact info goes in the body.
- Standard fonts: Arial, Calibri, Georgia, Times New Roman. 10-12pt body, 14-16pt headings.
- Standard bullet characters only: `•` `-` `*`
- File format: .docx or .pdf. PDF must be text-based, not a scan. Never .pages or .odt.
- Turn hyphenation off. A word split across lines gets a soft hyphen in the extracted text, and `Post-greSQL` fails an exact-match search. In Typst: `#set text(hyphenate: false)`.
- Keep the contact line to four items so it never wraps. A hyphenated URL sitting at a line break gets dehyphenated by parsers, turning `ali-aamir.dev` into the dead domain `aliaamir.dev`.

Contact block, top of body:

```
John Smith
email@example.com | (555) 123-4567 | linkedin.com/in/johnsmith
San Francisco, CA
```

City and state only. No full mailing address, no table around it.

## 2. Structure must be predictable

- Standard headings only: `Professional Summary`, `Experience` (or `Work Experience`), `Education`, `Skills`. Nothing clever, no "My Journey", no "What I Bring to the Table".
- Reverse chronological. Newest first.
- Every job lists, in this order: job title, company name, company location, dates with months.
- Same date format everywhere. Never drop months to hide a gap, since parsers use months to compute tenure and recruiters read year-only as hiding something.
- Also fill in the application form fields on the job site. That form is the ATS's backup copy of your data.

## 3. Keywords decide your rank

The ATS runs two passes:

**Pass 1, drop.** Cuts anyone missing minimum years, industry background, education, or work eligibility. Keywords do nothing here. Only real experience or schooling changes this outcome. If applications get no response, check this first. It is the usual cause, not formatting.

**Pass 2, rank.** Orders the 50 to 100 survivors, and recruiters boolean-search this pool by hand. This is where keywords work: they make you findable, not scored.

**Pull keywords from the job posting by hand, not by AI.** Understanding the job is half of getting it. Scan for:

1. **Job duties**
2. **Software, tools, and equipment**: Salesforce, AWS, Excel, Epic, HubSpot
3. **Industry terminology**: SaaS, B2B, mid-market, ARR, churn, P&L, HIPAA
4. **Certifications and methodologies**: PMP, CPA, CFA, Agile, Six Sigma
5. **Professional traits**: lower priority. Nobody searches "problem-solving".

**Place each keyword twice, no more:**

- Once in the Skills section, using the posting's exact phrasing.
- Once as a bold lead-in title at the front of a bullet point, followed by a colon.

Bullet titles are the edge. Everyone else stuffs a skills section; almost nobody labels their bullets. A human skimming 50 resumes reads the left edge of your bullets and sees which skill you used and where you used it.

**Keep bullets to 15-20 words, 25 hard cap.** At 10pt a 30-word bullet wraps to three lines, eats page space, and buries the payoff behind mechanism. Cut the how, keep the what and the so-what. Two short sentences beat one long one.

| Too long (33 words) | Tight (19 words) |
|---|---|
| Collapsed customer, supplier, shipper, consignee, consignor, warehouse, haulier, and agent into one party record carrying all 8 roles at once, so a company that both ships and receives stops existing twice. | Collapsed 8 contact types into one party record, so a firm that ships and receives stops existing twice. |

Domain vocabulary cut for length is not lost: the Skills section already carries it for keyword matching. The bullet only needs enough flavour to prove the domain is real.

Never stuff. One or two mentions per keyword. `Python, Python programming, Python developer, Python expert` is a tell.

Use the posting's exact term when your term means the same thing: "data visualization", not "making charts". Do not swap a word for a less accurate one just to match.

## Failure patterns

| Wrong | Right |
|---|---|
| Two-column layout with graphics, skill bars, colored boxes | Single column, plain text, simple bullets |
| "My Journey", "Academic Pursuits" | "Experience", "Education" |
| "Programming, databases, making charts" | "Python, SQL, Data Visualization" |
| Contact info in the page header | Contact info in the body |
| `*Mentoring* — raised approval rate to 78%` | `*Mentoring*: raised approval rate to 78%` |

## Industry adjustments

- **Tech**: languages and frameworks first. GitHub and portfolio links in Skills, not the header.
- **Business/finance**: software proficiency (Excel, SAP, Salesforce) and certifications (CPA, CFA, PMP). P&L, ROI, KPI.
- **Healthcare**: licenses and certifications up top. Name the systems (Epic, Cerner, MEDITECH) and compliance terms (HIPAA, Joint Commission).
- **Marketing**: platforms (HubSpot, Google Analytics), channels (SEO, PPC, email), and hard metrics.

## Special situations

- **Career changer**: lead with transferable skills, keyword for the TARGET industry not the current one. Usually needs a separate resume version per industry.
- **Recent grad**: Education moves up. Include relevant coursework, projects, internships. Internships are experience.
- **Executive**: ATS still applies. Include team size, budget/P&L size, board experience.
- **Employment gap**: keep real months. Fill the gap with freelance, consulting, or volunteer work carrying relevant keywords.
