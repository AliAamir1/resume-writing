# Bio

## One-line

Tech Lead at FlatOut Solutions. I start with why a feature exists before drawing the architecture, and I stay on the pager long enough to find out if I got the why right.

## One-paragraph

As an Engineer, the first thing I want from a project is to understand why it exists. Who's stuck without the feature, what changes for them once it ships, what business outcome it actually moves. If I can't answer that clearly, I push back before drawing diagrams I'll have to throw away. Once the why is settled, the architecture and infrastructure tend to fall out of the problem instead of becoming arguments, and that part of the work feels like the cherry on top. Most of what I've shipped lives at the seams between systems: a multi-provider AI workspace that lets a team @mention GPT, Claude, and Gemini in the same thread (Kollaborative AI); a closed-loop attribution pipeline tying Meta ad spend back to GoHighLevel CRM revenue (ROAS); a voice agent that replaces a human dispatcher for tow operators (Tow123). Less greenfield CRUD, more making five vendors behave like one product. I take infrastructure as seriously as the product, which is how a portfolio-wide Pulumi component library got extracted (CloudForge) once the copy-paste across three production stacks got loud enough to justify it. AI-native by habit, not curiosity: MCP servers and multi-model orchestration are the daily tools, not the demo. Stack-agnostic on purpose. TypeScript, NestJS, Next.js, React Native, Python, Pulumi, AWS get picked from the problem, not from what's already comfortable. What I want next is a problem where the hard part isn't writing the code, it's deciding what to build, and a team that trusts me to own that decision.

## Full

Open `projects/README.md` for full project portfolio. Key narrative threads:

- **Generative AI app layer:** RAG, MCP servers, agentic workflows, multi-provider LLM routing, voice agents. NOT classical ML, model training, or data science.
- **Backend:** Node.js, NestJS, TypeScript, Express + Prisma, FastAPI/LangGraph (Python).
- **Frontend:** React 19, Next.js 15, TanStack Query, Convex real-time, Tailwind/Shadcn/Radix.
- **Cloud / infra:** AWS-primary (ECS Fargate, ALB, Route53, SES, Lambda, SQS, Amplify), Pulumi for IaC (multi-account orgs, two-stack patterns, GitHub OIDC), MongoDB Atlas, Cloudflare.
- **Mobile:** React Native (Expo SDK 54, Expo IAP, OTA updates).
- **Tooling philosophy:** AI-native development. Built MCP servers wired into Claude Code; daily-driver workflow is agent + tools rather than chatops + scripts.
