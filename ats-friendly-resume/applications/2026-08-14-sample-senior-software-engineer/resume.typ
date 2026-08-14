// ============================================================
// SAMPLE: every company, date, project and metric below is
// INVENTED to demonstrate the format. Replace all of it with
// your real history before sending this anywhere.
// ============================================================

#import "@preview/ats-friendly-resume:0.1.1": *

#let name = "Ali Aamir"
// #let location = "Lahore, Pakistan"
#let email = "aliaamir2015@gmail.com"
#let phone = "+92 321 457 9630"
#let linkedin = "linkedin.com/in/ali-aamir-se"
#let github = "github.com/AliAamir1"
#let portfolio = "ali-aamir.vercel.app"

#show: resume.with(
  author: name,
  author-position: center,
  // location: location,
  email: email,
  phone: phone,
  linkedin: linkedin,
  github: github,
  // portfolio omitted: five contact items overflow to a second line, and the
  // wrap lands inside "ali-aamir.vercel.app". Parsers dehyphenate at line ends,
  // turning it into the dead domain "aliaamir.vercel.app".
  // portfolio: portfolio,
  personal-info-position: center,
  color-enabled: false,
  font: "Georgia",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
)

// ATS hardening: never hyphen-split a word across lines. A soft hyphen landing
// inside "PostgreSQL" or "Kubernetes" breaks exact-match keyword search.
// Justification off too, since without hyphenation it stretches spaces badly.
#set text(hyphenate: false)
#set par(justify: false)

== Professional Summary

Senior Software Engineer with 7+ years building distributed systems and REST/GraphQL APIs
for B2B SaaS platforms. Specialised in TypeScript, Node.js, and Go services on AWS, with deep
PostgreSQL query optimization experience. Led microservices migrations, owned CI/CD and
observability tooling, and mentored engineers through code review.

== Skills

- *Languages*: TypeScript, JavaScript, Go, SQL, Python, Bash
- *Backend*: Node.js, Express, Hono, GraphQL, REST, microservices, event-driven architecture
- *Data*: PostgreSQL, Redis, Kafka, SQS
- *Cloud & Infrastructure*: AWS (ECS, Lambda, RDS, S3), Terraform, Docker, Kubernetes
- *Practices*: CI/CD, distributed tracing, structured logging, load testing, code review, mentoring

== Experience

#work(
  company: "Northgate Data",
  role: "Senior Software Engineer",
  dates: "Mar 2023 - Present",
  tech-used: "TypeScript | Go | PostgreSQL | AWS",
  location: "Lahore, Pakistan (Remote)",
)
- *Microservices Architecture*: Split a monolithic billing service into six domain services over SQS, enabling independent release cadences.
- *PostgreSQL Query Optimization*: Reduced p99 API latency from 1.8s to 310ms by replacing N+1 access patterns with batched joins and adding covering indexes across 12 hot tables.
- *Observability*: Instrumented distributed tracing and structured logging across all services, cutting mean time to diagnose production incidents from 45 minutes to under 8.
- *Mentoring*: Mentored four mid-level engineers and established the team's code review standard, raising first-pass review approval rate from 41% to 78%.

#work(
  company: "Kestrel Software",
  role: "Software Engineer",
  dates: "Jun 2020 - Feb 2023",
  tech-used: "Node.js | React | PostgreSQL | Docker",
  location: "Lahore, Pakistan",
)
- *GraphQL API Design*: Designed and shipped a federated GraphQL layer over eight legacy REST endpoints, reducing average client round-trips per page from 6 to 1.
- *CI/CD*: Built GitHub Actions pipelines with Docker-based test isolation, taking deploy time from 26 minutes to 4 and eliminating manual release steps.
- *Infrastructure as Code*: Migrated hand-provisioned AWS resources to Terraform, cutting new-environment setup from 3 days to 2 hours.

#work(
  company: "Vellum Interactive",
  role: "Junior Software Engineer",
  dates: "Aug 2018 - May 2020",
  tech-used: "JavaScript | Express | MySQL",
  location: "Lahore, Pakistan",
)
- *REST API Development*: Built and maintained customer-facing REST services handling 2M+ requests per day for a B2B logistics product.
- *Load Testing*: Added automated load testing to the release process, catching throughput regressions before production.

== Projects

#project(
  name: "Tracewire",
  dates: "Jan 2024 - Present",
  tech-used: "Go | Kafka | PostgreSQL",
  url: "github.com/AliAamir1/tracewire",
)
- *Event-Driven Architecture*: Open-source tracing collector ingesting 50k spans/sec through Kafka.
- *Performance Profiling*: Cut collector memory footprint 60% via zero-allocation span decoding; 400+ GitHub stars.

== Education

#edu(
  institution: "University of the Punjab",
  location: "Lahore, Pakistan",
  degree: "Bachelor of Science in Computer Science",
  dates: "Sep 2014 - Jun 2018",
)
