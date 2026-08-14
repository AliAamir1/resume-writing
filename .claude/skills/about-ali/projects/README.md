# Projects

Flat list. One file per project. Every file has the same shape: frontmatter with the fields a resume block needs, a one-line context sentence, and a pool of pre-formatted bullets.

## How to use this for an application

1. Read the job posting and pull its keywords by hand.
2. Scan the `tags` column below, open the 2-4 strongest matching files.
3. Copy the bullets whose titles match the posting's language. Do not rewrite them into new claims.
4. Under `Experience`, bullets attach to the employer named in that file's `employer` field. Under `Projects`, the file stands alone as its own block.

Frontmatter maps straight onto the Typst blocks in `ats-friendly-resume/`: `name`, `dates`, `tech_used`, `url`.

Bullets are already ATS-formatted: `*Keyword Title*: claim.` ASCII hyphens only, no em or en dashes anywhere. Keep it that way.

`gaps` names what is missing from that file. `unconfirmed` means the fact is not established anywhere in the source material, not that it is unknowable. Never fill one in by guessing.

## Index

| Project | Employer | Tags | File |
|---|---|---|---|
| Kollaborative AI | FlatOut Ventures | llm, multi-provider, mcp, rag, rbac, real-time, iac | [kollaborative-ai.md](kollaborative-ai.md) |
| AI Voice Agent for Towing Operators | FlatOut Solutions | voice-ai, agentic, llm-routing, twilio, multi-tenant, hitl | [tow123-voice-agent.md](tow123-voice-agent.md) |
| Tow123 AI Dispatch Console | FlatOut Solutions | agentic, llm, real-time, integrations, testing, eval | [tow123-dispatcher.md](tow123-dispatcher.md) |
| ROAS | FlatOut Solutions | nestjs, marketing-analytics, attribution, oauth, stripe, iac | [roas.md](roas.md) |
| Rituo | FlatOut Ventures | react-native, mobile, llm, multi-provider, voice, nestjs, iap | [rituo-app.md](rituo-app.md) |
| Property Owner Enrichment Pipeline | FlatOut Solutions | serverless, aws-lambda, llm, gemini, scraping, sqs, security | [mth-property-enrichment.md](mth-property-enrichment.md) |
| MTH Equities Deal Map | FlatOut Solutions | geospatial, etl, real-estate, mapping, real-time, domain-logic | [mth-equities-map.md](mth-equities-map.md) |
| SNF Ownership Explorer | FlatOut Solutions | geospatial, healthcare-data, etl, mapping, performance | [mth-snf-explorer.md](mth-snf-explorer.md) |
| MTH Equities metrics bullet bank | FlatOut Solutions | UNRECONCILED, see file header | [mth-bullet-bank.md](mth-bullet-bank.md) |
| CloudForge | FlatOut Ventures | iac, pulumi, library-design, aws, iam, incident-response, rca | [cloudforge.md](cloudforge.md) |
| Tow123 AWS Platform | FlatOut Solutions | iac, pulumi, aws, governance, scp, oidc, ecs, devops | [tow123-platform.md](tow123-platform.md) |
| Rituo AWS Platform | FlatOut Ventures | iac, pulumi, aws, governance, scp, oidc, multi-account | [rituo-platform.md](rituo-platform.md) |
| MTH Equities AWS Platform | FlatOut Solutions | iac, pulumi, aws, governance, scp, oidc, multi-account | [mth-platform.md](mth-platform.md) |
| Tow123 Roadside Marketplace | FlatOut Solutions | marketplace, real-time, mobile, react-native, stripe, migration | [tow123-marketplace.md](tow123-marketplace.md) |
| Towbook Billing Automation Pipeline | FlatOut Solutions | serverless, aws-lambda, etl, scraping, event-driven, iac | [tow123-billing-automation.md](tow123-billing-automation.md) |
| Freight Forwarding Operations API | unconfirmed | rest-api, prisma, postgresql, multi-tenant, pdf, logistics | [cargo-backend.md](cargo-backend.md) |
| Freight Operations Portal | unconfirmed | nextjs, frontend, tanstack-query, forms, auth, vercel | [cargo-ops-portal.md](cargo-ops-portal.md) |
| Career Coach | unconfirmed | llm, openai, edtech, rag, file-search, nextjs | [career-coach.md](career-coach.md) |
| Organyz | unconfirmed | agentic, langgraph, python, aws-ml, semantic-search | [organyz.md](organyz.md) |
| Omnilocal | unconfirmed | integrations, etl, scraping, serverless, real-estate | [omnilocal.md](omnilocal.md) |
| joinpangia | unconfirmed | llm, langchain, agentic, fact-checking, multimodal, python | [joinpangia.md](joinpangia.md) |
| Alvanda | unconfirmed | b2b, saas, real-time, socketio, redis, mern, workflow | [alvanda.md](alvanda.md) |
| Convify | unconfirmed | nextjs, builder-ui, craftjs, docker, cicd, analytics | [convify.md](convify.md) |
| Startir.AI | unconfirmed | llm, edtech, structured-output, python, fastapi | [startir-ai.md](startir-ai.md) |
| GGMS Marketing Suite | unconfirmed | mern, lead-gen, crm, scraping, docker, cicd | [ggms-marketing-suite.md](ggms-marketing-suite.md) |
| GGMS Listings CMS | unconfirmed | real-estate, maps, cms, php, wordpress, docker | [ggms-cms.md](ggms-cms.md) |
| Client-Side Invoice Generator | unconfirmed | typescript, zod, pdf, frontend, type-safety | [cargo-invoice-generator.md](cargo-invoice-generator.md) |
| PerigonAi | unconfirmed | geospatial, mapbox, storytelling, frontend, amplify | [perigon-ai.md](perigon-ai.md) |
| TSKR | unconfirmed | marketplace, real-time, socketio, nextjs | [tskr.md](tskr.md) |
| SIMuSPACE | unconfirmed | data-viz, workflow, enterprise, polyglot | [simuspace.md](simuspace.md) |
| Jarvis | unconfirmed | llm, sales, crm, twilio, python, lead-scoring | [jarvis.md](jarvis.md) |
| PhotoMentor | unconfirmed | vision-llm, python, fastapi | [photomentor.md](photomentor.md) |
| LandscapeAI | unconfirmed | open-source-ml, huggingface, image-generation, python | [landscape-ai.md](landscape-ai.md) |
| Crypto Chart CLI Terminal | unconfirmed | frontend, cli-ui, charts, firebase | [crypto-chart-cli.md](crypto-chart-cli.md) |
| Freight Dashboard Prototype | unconfirmed | prototype, forms, tables, dashboard | [cargo-dashboard-prototype.md](cargo-dashboard-prototype.md) |
| REHQ | unconfirmed | undocumented | [rehq.md](rehq.md) |

## Do not put on a resume

- **Freight Dashboard Prototype** - mock data, no auth, never deployed.
- **REHQ** - nothing documented beyond a Loom link.
- **Jarvis, PhotoMentor, LandscapeAI** - demo deployments only, no public URL. Usable as project entries for junior-weight postings, not as production claims.
