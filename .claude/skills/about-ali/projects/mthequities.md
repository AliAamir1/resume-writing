# MTH Equities Platform: Resume Bullet Bank

21 bullets. Nearly every one carries a measured outcome or a scale number, which makes this the strongest file in the folder. Pick 3 to 5 per resume.

---

## Project Header Lines

- **MTH Equities Maps Platform** | TypeScript, React, Node.js, MongoDB, MapLibre GL, AWS, Vercel, Fly.io, Cloudflare
- **NYC Property Data Enrichment Service** | AWS Lambda, SQS, Pulumi, Google Gemini, DynamoDB, TypeScript
- **SNF Explorer** | React, Express, MongoDB, CMS Open Data, MapLibre GL

---

## Scale and Performance

- **Geospatial Rendering at Scale:** Rendered all 860,000 NYC tax lots in one browser map, with a tile cache dropping repeat loads to zero network calls.
- **Database Performance:** Cut a 36-second query to under 1 second, eliminating the timeouts that were breaking every lead assignment in production.
- **Nightly Job Optimization:** Rebuilt a nightly job burning 7.7 GB of disk reads per run, ending cache eviction that slowed the whole database cluster.
- **Search Performance:** Replaced an address lookup that scanned 860,000 records per keystroke with a text index, making search instant.

---

## Data Pipeline

- **NYC Data Pipeline:** Built a 30-stage nightly pipeline loading 860,000 NYC tax lots with their zoning, ownership, permit, and transit data from 25+ public datasets.
- **Pipeline Throughput:** Re-architected the pipeline onto 8 right-sized machines, erasing 190% night-to-night runtime swings caused by resource contention.
- **Rate-Limit Engineering:** Cut an 82-hour city-data job to 9 hours by sharding it across 9 egress IPs, without exceeding the endpoint's per-IP limit.
- **Public Records Join:** Joined a 2.4M-row permit archive to a 4M-row live feed to restore owner contact fields absent from the current dataset.
- **Coverage Analysis:** Found 53% of NYC lot addresses were unsearchable, then integrated the city address directory to close the gap.

---

## AI Pipeline

- **AI Document Extraction:** Built a Gemini vision pipeline reading scanned NYC deeds to resolve property ownership behind LLC filings at 92% accuracy.
- **Architecture Decision from Data:** Benchmarked public records at 60.8% owner coverage against 15.6% for AI, then routed only the unresolved 48% to a paid vision model.
- **Bottleneck Analysis:** Identified OCR as the binding constraint at 860,000 lots and switched to an engine 20x faster per page.
- **Batch Throughput:** Delivered owner and contact data for 5,000 NYC lots in 27 minutes through a serverless queue pipeline.
- **Performance Baselining:** Measured 4.7-second median and 5.9-minute p99 enrichment latency, then sized every timeout, queue, and alert to the real distribution.

---

## Infrastructure and Cost

- **Cloud Cost Reduction:** Cut a recurring AWS networking cost 85% by replacing a managed gateway with a self-hosted equivalent.

---

## Product Impact

- **Lead Generation Pipeline:** Built the full flow from NYC property search through AI owner enrichment to contractor assignment and export.
- **Zoning Rules Engine:** Encoded NYC zoning law into an engine computing legal buildable area for all 860,000 lots in under 180 seconds.
- **Assemblage Discovery:** Built an adjacency search across NYC blocks that surfaces multi-property development sites invisible to lot-by-lot analysis.

---

## SNF Explorer (separate project section)

- **Healthcare Data Platform:** Unified 5 federal CMS datasets into a single searchable record for every US nursing home.
- **Cross-Platform Join:** Matched federal nursing home records to NYC tax lots, a link the federal data does not publish.
- **Ownership Graph:** Modeled the ownership chains behind each facility with fines and violations rolled up per owner.

---

## Skills Section Keyword Bank

Lift the exact terms the posting uses.

**Languages:** TypeScript, JavaScript, Node.js, SQL

**Frontend:** React, Vite, TanStack Query, Tailwind CSS, MapLibre GL, PMTiles, IndexedDB, WebSockets, Zod

**Backend:** Express, REST API, Mongoose, JWT, RBAC, NDJSON streaming, Pusher

**Data:** MongoDB, MongoDB Atlas, DynamoDB, aggregation pipelines, index design, query optimization, geospatial queries, ETL, data pipelines, GeoJSON, GDAL, Turf.js

**Cloud and Infra:** AWS Lambda, SQS, API Gateway, DynamoDB, Secrets Manager, IAM, VPC, Pulumi, Infrastructure as Code, Vercel, Fly.io, Cloudflare R2, Docker

**AI and ML:** Google Gemini, LLM document extraction, vision models, OCR, entity resolution, prompt engineering

**DevOps:** GitHub Actions, CI/CD, monorepo, Yarn workspaces, Vitest, Stryker mutation testing

**Observability:** OpenTelemetry, PostHog, structured logging, feature flags

**Domain:** NYC Open Data, Socrata SODA API, ArcGIS, MapPLUTO, ACRIS, CMS Open Data, geospatial analysis, zoning analysis, PropTech

---

## Selection guidance

Strongest openers, in order: Database Performance, Rate-Limit Engineering, AI Document Extraction, Architecture Decision from Data, Cloud Cost Reduction. Each states a before and an after a non-technical reader can price.

Resting on scope rather than an outcome. Drop first: Lead Generation Pipeline, Assemblage Discovery, Healthcare Data Platform, Ownership Graph.

SNF Explorer is a separate product. Use it as its own `#project()` block, never mixed into MTH bullets.

---
