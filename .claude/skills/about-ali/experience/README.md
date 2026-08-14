# Experience

Reverse chronological. Feeds the `#work()` blocks in `ats-friendly-resume/`. Bullets come from `projects/`: open a project file, check its `employer` field, and attach its bullets under the matching role.

## Recommended resume shape

One FlatOut entry with the promotion visible in the title, because three overlapping FlatOut rows read as a data error to both a parser and a recruiter. Confirm the start month before sending.

```typst
#work(
  company: "FlatOut Solutions",
  role: "Technical Lead (previously Senior Software Engineer, Software Engineer)",
  dates: "May 2024 - Present",
  tech-used: "TypeScript | NestJS | Next.js | React Native | AWS | Pulumi",
  location: "Lahore, Pakistan (Remote)",
)
```

## Roles

| Company | Title | Dates | Notes |
|---|---|---|---|
| FlatOut Solutions | Technical Lead | March 2025 - Present | Current role |
| FlatOut Solutions | Senior Software Engineer | August 2024 - October 2025 | Overlaps both other FlatOut rows |
| FlatOut Solutions | Software Engineer | May 2024 - November 2024 | Overlaps the Senior row |
| Greetly AI | Senior Software Engineer | February 2024 - May 2024 | |
| Megaverse Technologies | Software Engineer | May 2023 - February 2024 | |
| Semicolons PVT. LTD | Associate Software Engineer | unconfirmed, likely 2022 | Dates missing |
| Appremon | Software Engineer Intern | April 2022 - August 2022 | Internship counts as experience |

Location for all: Lahore, Pakistan (remote where applicable).

## Open items

1. **FlatOut dates overlap.** Senior Software Engineer runs August 2024 to October 2025 while Technical Lead starts March 2025, and Software Engineer runs May 2024 to November 2024 inside the Senior window. ATS parsers compute tenure from months, so overlapping rows at one employer either double-count or get flagged. Needs the real promotion dates.
2. **Semicolons PVT. LTD has no dates.** Cannot ship a resume with a blank date range. Either supply months or drop the row.
3. **Which projects belong to which employer is largely unrecorded.** Only the FlatOut work is attributed in the source material. Every other project file carries `employer: unconfirmed`. Until those are filled, those projects can only appear under `Projects`, never under a `#work()` entry.

## Form-fill rule

LinkedIn pre-fills Easy Apply work-history slots from the raw values in the table above, so keep the table matching LinkedIn exactly even after the resume consolidates the FlatOut rows. For slots LinkedIn leaves blank, do not fabricate.
