# Experience

Reverse chronological. Feeds the `#work()` blocks in `ats-friendly-resume/`. Bullets come from `projects/`: open a project file, check its `employer` field, and attach its bullets under the matching role.

Source: Ali's LinkedIn profile, recorded 2026-08-14. LinkedIn is authoritative for company, title, and dates. Where an earlier version of this file disagreed, LinkedIn won. See "Corrections applied" below.

## Roles

| Company | Title | Dates | Duration | Type | Location |
|---|---|---|---|---|---|
| FlatOut Solutions | Technical Lead | Aug 2024 - Present | 2 yr 1 mo | Contract | United States, Remote |
| Appremon | Senior Software Engineer | May 2024 - Nov 2024 | 7 mos | Full-time | Wilmington, Delaware, United States, Remote |
| Megaverse Technologies | Software Engineer | Feb 2024 - May 2024 | 4 mos | Full-time | Lahore, Pakistan, On-site |
| Megaverse Technologies | Associate Software Engineer | May 2023 - Feb 2024 | 10 mos | Full-time | Lahore, Pakistan, On-site |
| Semicolons PVT. LTD | Software Engineer Intern | Apr 2022 - Aug 2022 | 5 mos | Part-time | Lahore, Pakistan, On-site |

**Excluded from the resume by Ali's instruction:** Co-Founder, Greetly AI, self-employed, Mar 2025 - Present, On-site. Keep it in this table for LinkedIn form-fill parity, never in a generated resume.

Total professional experience counting the Semicolons internship: 4 yr 4 mos as of Aug 2026. This matches the `4` in `profile/facts.md`. Counting from the first full-time role (Megaverse, May 2023) it is 3 yr 3 mos.

## Recommended resume shape

Four `#work()` blocks. Megaverse consolidates to one row with the promotion in the title, because two rows at one employer read as a data error to a parser computing tenure.

```typst
#work(
  company: "FlatOut Solutions",
  role: "Technical Lead",
  dates: "Aug 2024 - Present",
  tech-used: "TypeScript | NestJS | Next.js | React Native | AWS | Pulumi",
  location: "United States (Remote)",
)

#work(
  company: "Appremon",
  role: "Senior Software Engineer",
  dates: "May 2024 - Nov 2024",
  tech-used: "React | TypeScript | AWS",
  location: "United States (Remote)",
)

#work(
  company: "Megaverse Technologies",
  role: "Software Engineer (previously Associate Software Engineer)",
  dates: "May 2023 - May 2024",
  tech-used: "React | React Native | Redux | AWS",
  location: "Lahore, Pakistan",
)

#work(
  company: "Semicolons PVT. LTD",
  role: "Software Engineer Intern",
  dates: "Apr 2022 - Aug 2022",
  tech-used: "MERN | React | Node.js",
  location: "Lahore, Pakistan",
)
```

Drop the Semicolons block first when a posting needs the space. It is the oldest and weakest row.

**Location rule.** FlatOut and Appremon are US companies worked remotely, so both render `United States (Remote)`. Megaverse and Semicolons were genuinely on-site in Lahore and cannot claim a US location. They currently render `Lahore, Pakistan`. See open item 5 before sending.

## Bullets available from LinkedIn

These are Ali's own LinkedIn descriptions, unedited. They are raw source, not resume-ready: they carry no keyword titles and no metrics. Rewrite into `*Keyword Title*: claim.` shape before use, and never add a number that is not proven.

**Appremon**
- Architected and developed a scalable React application to manage organizations, security sensors, and network configurations.
- Built a super admin panel with a dashboard for app management and real-time analytics.
- Developed and automated CI/CD pipelines for efficient deployment on AWS.
- Skills tagged: React.js, TypeScript, +1 unlisted.

**Megaverse Technologies** (spans both titles)
- Contributed to Project ALVANDA (React application), emphasizing modular design, Redux, and Context API for state management.
- Code quality, API integration, UI responsiveness, collaborative problem-solving.
- Frontend deployed on AWS Amplify; backend on EC2 with Elastic IP.
- Developed a React Native application, Pure-Yoga, using Redux and Context API, with multilingual support and themes.
- Used GoJS, React Flow, and D3.js to render dynamic organizational trees and procedural graphs in ALVANDA.
- Skills tagged: React.js, React Native, +5 unlisted.

**Semicolons PVT. LTD**
- Industry-level proficiency in MERN stack codebase development.
- Collaborative development within a team of developers.
- Git and GitHub for version control.
- Skills tagged: React.js, Node.js, +2 unlisted.

**FlatOut Solutions**
- No description on LinkedIn. Bullets come from `projects/` files tagged `employer: FlatOut Solutions` or `FlatOut Ventures`.

## Corrections applied

The previous version of this table had company, title, and date triples scrambled across rows. Every row moved. Recorded so the same errors are not reintroduced:

| Previously recorded | Actually |
|---|---|
| Greetly AI, Senior Software Engineer, Feb 2024 - May 2024 | That slot is Megaverse Technologies, Software Engineer. Greetly is Co-Founder, Mar 2025 - Present. |
| Appremon, Software Engineer Intern, Apr 2022 - Aug 2022 | That slot is Semicolons PVT. LTD. Appremon is Senior Software Engineer, May 2024 - Nov 2024. |
| Semicolons PVT. LTD, Associate Software Engineer, dates unconfirmed | That title belongs to Megaverse, May 2023 - Feb 2024. Semicolons dates are Apr 2022 - Aug 2022, now confirmed. |
| Three overlapping FlatOut rows (Technical Lead, Senior SWE, Software Engineer) | LinkedIn shows one FlatOut role: Technical Lead, Aug 2024 - Present. See open item 1. |

## Open items

1. **Did FlatOut have earlier titles before Technical Lead?** LinkedIn lists a single role from Aug 2024. The old table claimed a Software Engineer to Senior to Technical Lead progression with dates that overlapped each other. If a real promotion history exists it is worth showing, but the dates must come from Ali, not from the old table. Until then the resume states Technical Lead, Aug 2024 - Present.

2. **Appremon overlaps FlatOut by four months.** Appremon runs May 2024 to Nov 2024 full-time; FlatOut starts Aug 2024 on contract. Both appear on the resume, so a recruiter will see concurrent employment Aug to Nov 2024. This is normal for contract alongside full-time, but be ready to explain it in a screen.

3. **`profile/facts.md` answers "Second job / employed outside primary role: No".** Greetly AI (Co-Founder, Mar 2025 - Present) runs concurrently with FlatOut, and the Appremon overlap above is a second instance. Ali should decide how to answer that screening question, since the current value contradicts the timeline.

4. **Study-period gap, Sep 2022 to Apr 2023.** Eight months between Semicolons ending and Megaverse starting. Covered by the NUCES degree (Aug 2019 to Jul 2023) in `profile/facts.md`, so the Education block explains it. No action needed unless a form asks directly.

5. **Megaverse and Semicolons locations need Ali's call.** Both were on-site roles in Lahore, so "United States (Remote)" would be false and cannot be written. Three honest options: keep `Lahore, Pakistan`, omit the location argument entirely (the resume-writing skill wants a location per role, so this costs a little), or write `Pakistan`. Default until Ali says otherwise: keep `Lahore, Pakistan`.

6. **Project-to-employer attribution is still mostly missing.** Only FlatOut work is attributed in `projects/`. Every other project file carries `employer: unconfirmed`, so those bullets can only appear under `Projects`, never under a `#work()` block. The Appremon, Megaverse, and Semicolons roles have only the raw LinkedIn descriptions above.

## Form-fill rule

LinkedIn Easy Apply pre-fills work-history slots from the raw values in the Roles table, including the Greetly row. Keep this table matching LinkedIn exactly even after the resume consolidates Megaverse and drops Greetly. For slots LinkedIn leaves blank, do not fabricate.
