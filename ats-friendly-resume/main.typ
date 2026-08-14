#import "@preview/ats-friendly-resume:0.1.1": *

// Your personal information replace mine with yours (pls don't steal my identity)
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
  // Personal information
  // Below these lines are optional
  // Feel free to comment out and remove them
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
  // Document formatting and values
  // These are already defined by default, feel free to omit or edit them
  color-enabled: false,
  text-color: "#000080",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
)

== Technical Skills
- *Programming Languages*: TypeScript, JavaScript, Go, Bash, HTML, CSS
- *Web Technologies*: React, Next.js, Sveltekit, Node.js, Express, Bun, Hono
- *DevOps & Tools*: Postman, Docker, Git, Github Actions

== Experience

// Experience section
// tech-used is optional so feel free to omit it.

#work(
  company: "Nimble Labs",
  role: "Full Stack Developer",
  dates: "Sep 2021 - Present",
  location: "Manila, Philippines",
)
- Designed and maintained full-stack web applications using React and Hono, serving internal and external clients.
- Built and integrated REST/GraphQL APIs for cross-service communication, improving data reliability and developer productivity.
- Reduced API response times by 40% through query optimization and edge caching with Bun.
- Collaborated with product and design teams to deliver responsive dashboards and analytics tools for customer operations.

#work(
  company: "AstraTech Solutions",
  role: "Senior Software Engineer",
  dates: "Sep 1999 - Aug 2021",
  tech-used: "React | TypeScript | Node.js",
  location: "Manila, Philippines",
)
- Led migration from legacy systems to a modern TypeScript/Node.js backend, enabling quicker feature delivery and improved maintainability.
- Developed monitoring and telemetry tooling to surface application health and performance metrics in real time.
- Implemented CI/CD pipelines using GitHub Actions and Docker, reducing deployment time and rollback incidents.
- Mentored junior engineers and established code review and testing best practices across the engineering team.

== Projects

// Projects section
// tech-used is optional so feel free to omit it.

#project(
  name: "FleetOps Manager",
  dates: "Sep 2002 - Mar 2003",
  tech-used: "React | TypeScript | Node.js",
  url: "github.com/aybangueco/fleetops",
)
- Architected a centralized platform for managing vehicle configurations, maintenance schedules, and upgrade histories.
- Built telemetry dashboards for diagnostics and real-time alerts, increasing uptime and lowering maintenance costs.
- Created RESTful APIs for logistics partners and internal tooling with robust authentication and role-based access.

#project(
  name: "CityWatch Incident Tracker",
  dates: "Jan 2020 - Dec 2020",
  tech-used: "Next.js | Go | PostgreSQL",
  url: "github.com/aybangueco/citywatch",
)
- Developed an incident reporting and response coordination system for municipal operations.
- Implemented analytics dashboards to track response times, incident trends, and resource allocation.
- Deployed production workloads via Docker and GitHub Actions, improving release safety and observability.

== Education

#edu(
  institution: "Metropolitan University",
  location: "Manila, Philippines",
  degree: "Bachelor of Science in Computer Science",
  dates: "Sep 2021 - Jul 2025",
)
