---
client: MTH Equities
relationship: contractor / build partner (via Flatout Solutions)
domain: NYC real estate investment, property assemblage, skilled-nursing-facility (SNF) due diligence
project_count: 4
status: active
---

# MTH Equities — Client Overview

MTH Equities is a real estate investment firm focused on **NYC property assemblage in the Bronx** and **skilled-nursing-facility (SNF) acquisitions** nationwide. Ali built and continues to maintain the technical platform that powers their deal-sourcing, due-diligence, and ownership-intelligence workflows — four interconnected products plus the AWS governance layer they all run on.

## What I Built

A purpose-built deal-finder stack for a real estate PE workflow:

1. **[Equities Map](equities-map/)** — the analyst-facing product: an interactive Maplibre-GL map of NYC PLUTO lots in target Bronx ZIP codes (10451–10475), with a 13-phase ETL pipeline that ingests MapPLUTO + ACRIS + DOB + zoning data, computes zoning-aware FAR (including split-zone weighting and §23-153 wide-street bonuses), and surfaces high-value assemblage opportunities. Analysts draw grid zones, group lots into multi-property "deals," and trigger owner enrichment.
2. **[Property Data Enrichment](property-data-enrichment/)** — the AI/scraping back-of-house: a serverless AWS Lambda pipeline that takes a list of BBLs from the Map, scrapes mortgage documents via ScrapingBee, runs them through **Gemini** (`gemini-3-flash-preview`) to extract individual signers behind LLC walls, performs IDI skip-tracing for phone/relative data, and posts the enriched ownership intelligence back to the Map via a Bearer-authenticated callback.
3. **[SNF Explorer](snf-explorer/)** — a standalone geospatial-intelligence app for ~15K+ Medicare-certified skilled nursing facilities, with CMS-driven ETL (Provider Info, Penalties, SNF Enrollments, SNF All Owners) + NPPES enrichment, ownership-structure analysis (PE firm / REIT / LLC flags), and a Jewish-owned-property tagging workflow for DEI-focused investment screening.
4. **[Platform](platform/)** — the foundation everything runs on: a Pulumi/TypeScript IaC project that provisions **AWS Organizations**, **Identity Center**, **multi-account governance**, **GitHub OIDC** trust, **CloudFormation StackSets** for parameterized CI/CD role provisioning, and **KMS-encrypted Pulumi state** with cross-account access. Two SCPs enforce DevOps and sensitive-data guardrails.

## How They Fit Together

```
                  ┌─────────────────────────────────────┐
                  │   MTH Equities Platform (Pulumi)    │
                  │   AWS Orgs · OUs · IAM · OIDC ·     │
                  │   StackSets · KMS Pulumi state      │
                  └──────────────────┬──────────────────┘
                       deploys into  │
       ┌──────────────────────┬──────┴──────┬─────────────────────┐
       ▼                      ▼             ▼                     ▼
┌──────────────┐    ┌────────────────────┐  ┌──────────────┐   (other AWS
│ Equities Map │◄──►│ Property Data      │  │ SNF Explorer │    accounts /
│ (Fly.io)     │    │ Enrichment         │  │ (independent)│    workloads)
│ Maplibre GL  │    │ (AWS Lambda + SQS) │  │  Maplibre GL │
│ MongoDB      │    │ Gemini · ScrapingBee│  │  MongoDB    │
│ PLUTO ETL    │    │                    │  │  CMS ETL    │
└──────┬───────┘    └─────────┬──────────┘  └──────────────┘
       │  POST /process-lots  │
       └──────────────────────┘
       ◄─── callback to /api/enrichment/ingest (Bearer) ───
```

- **Map ↔ Enrichment** is a fire-and-forget REST integration: Map enqueues lots for enrichment, Enrichment processes them through SQS lambdas, and a `sheet-writer` Lambda dual-sinks results to either Google Sheets (legacy MTH workflow) or back to the Map's `/api/enrichment/ingest` endpoint. Failures are surfaced via a DLQ-callback-notifier Lambda. SSRF is blocked via Zod hostname allowlist on the callback URL.
- **SNF Explorer is intentionally isolated** — separate MongoDB Atlas cluster, no cross-imports. Different domain, different data sources, different audience (acquisitions team vs. analysts).
- **Platform** is the IaC layer the rest of the AWS-resident workloads (Enrichment confirmed; Map + SNF likely) deploy into via GitHub Actions OIDC roles.

## Unified Tech Stack (across all 4 projects)

| Layer | Tools |
|---|---|
| Frontend | React 19, TypeScript, Vite, **Maplibre GL 5.18**, React Map GL, TanStack Query 5, TailwindCSS 4, shadcn/ui, Radix, nuqs (URL state), Recharts, PMTiles |
| Backend (apps) | Express 4, TypeScript, Node 20, Mongoose 9, MongoDB Atlas, JWT auth, Pusher (real-time), Resend (email), Zod |
| Backend (serverless) | AWS Lambda, API Gateway, SQS, Secrets Manager, CloudWatch, EventBridge (DLQ redrive schedule) |
| ETL & Geo | Turf.js 7 (spatial ops), Flatbush (R-tree), Tippecanoe (vector tiles), AWS S3 + Cloudflare R2 (PMTiles), `tsx` runtime |
| AI / Scraping | **Google Gemini API** (`gemini-3-flash-preview`), **ScrapingBee** (residential proxies + sessions), pngjs/utif (TIFF→PNG) |
| External data | NYC SODA APIs (PLUTO, ACRIS, CSCL, DOB, HPD), **NPPES NPI Registry**, **CMS Provider Info / Penalties / SNF Enrollments / SNF All Owners**, **IDI skip-trace** |
| Infrastructure as Code | **Pulumi (TypeScript)** — AWS Organizations, Identity Center, IAM, CloudFormation StackSets, KMS, S3 |
| CI/CD | GitHub Actions with **OIDC keyless auth** to AWS, parameterized per-repo via StackSet |
| Hosting | **Fly.io** (Map server `shared-cpu-1x`, ETL `performance-2x` 6 GB), AWS Lambda, MongoDB Atlas |

## Notable Engineering Highlights

- **Zoning-aware FAR computation** with split-zone weighting (§77-22) and wide-street bonuses (§23-153) — Turf.js polygon intersection on every lot.
- **13-phase idempotent ETL** with per-phase fingerprints; full re-run in ~15 min, individual phases skippable in ~200ms.
- **Vector-tile pipeline** — Tippecanoe-built PMTiles uploaded to R2 for client-side rendering of street networks.
- **Reserved-concurrency=1** Lambda pattern to respect Google Sheets 60/min API limit (1.1s per write = 54/min effective).
- **DLQ redrive automation** via scheduled `StartMessageMoveTask` instead of Lambda-loop coordination.
- **Dual-sink result writer** — same Lambda routes to Google Sheets *and/or* external HTTP callback based on message fields, with independent error handling per sink.
- **Multi-account AWS governance** with SCPs for DevOps guardrails + sensitive-data restrictions; product engineers get scoped Identity Center permission sets per environment.
- **Client-side MapLibre filter expressions** for sub-millisecond re-filtering of 15K+ SNF points after a 24-hour-cached GeoJSON load.
- **Owner-rule resolution** for Jewish-ownership flagging — facility-level "no" override > owner flags > default — implemented as a pure function for testability.

## Per-Project Deep Dives

- [Equities Map](equities-map/README.md) — the analyst dashboard + PLUTO ETL.
- [Property Data Enrichment](property-data-enrichment/README.md) — Gemini + ScrapingBee + AWS Lambda enrichment service.
- [SNF Explorer](snf-explorer/README.md) — CMS-driven SNF map and ownership intelligence.
- [Platform](platform/README.md) — Pulumi-based AWS multi-account governance.
