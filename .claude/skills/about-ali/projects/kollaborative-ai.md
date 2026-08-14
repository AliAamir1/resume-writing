---
name: Kollaborative AI
employer: FlatOut Ventures LLC
dates: unconfirmed
tech_used: Next.js 15 | React 19 | Convex | TypeScript | Pulumi | AWS ECS Fargate
url: kollaborativeai.com
tags: llm, multi-provider, mcp, rag, rbac, real-time, iac, saas
gaps: dates, team size, users or revenue
---

# Kollaborative AI

Team-native AI workspace unifying GPT, Claude, and Gemini with real-time collaboration, custom @mention expert agents, and org-level governance.

## Bullets

- *Multi-Provider LLM Integration*: Built a team AI workspace unifying OpenAI GPT-5, Anthropic Claude 4.6, and Google Gemini 3 behind one interface, preserving full conversation history when users switch providers mid-thread.
- *Real-Time Collaboration*: Architected the product real-time-first on Convex subscriptions so multiple teammates work the same conversations and Spaces simultaneously, with no bespoke backend service to operate.
- *RAG and MCP Integration*: Shipped @mention-able custom AI experts backed by retrieval over team documents, plus Model Context Protocol support for connecting external tools and data sources without bespoke glue.
- *Role-Based Access Control*: Implemented four-tier dynamic RBAC (Owner, Manager, Member, Guest) with org, space, and user level system-prompt inheritance enforced at the data layer rather than in the UI.
- *Infrastructure as Code*: Provisioned the platform in Pulumi across two isolated stacks, splitting long-lived DNS from ephemeral compute so tearing down app infrastructure never touches the hosted zone.
- *Container Orchestration*: Deployed a multi-stage Dockerized Next.js app to AWS ECS Fargate behind an ALB with ECR, Route53, and SES.
- *CI/CD Pipeline*: Automated deploys through GitHub Actions using OIDC-only AWS authentication, keeping zero long-lived cloud credentials in CI.
- *SaaS Billing Architecture*: Shipped four pricing tiers with per-org bring-your-own-key management and pooled per-seat usage allowances.
