---
name: MTH Equities Map (a.k.a. "MTH Deals")
client: MTH Equities
status: active
codebase: /Users/ali/Documents/flatout-solutions/mthequities/mthequities-maps
deployment: Fly.io (ewr region)
tech_stack: React 19, TypeScript, Vite, Maplibre GL 5.18, TanStack Query, Express 4, Node 20, MongoDB Atlas, Mongoose, Turf.js, Tippecanoe, PMTiles, Pusher, Resend, JWT, Cloudflare R2
target_market: Real estate deal analysts (internal MTH Equities team)
---

# MTH Equities Map

The analyst-facing flagship: an algorithmic real-estate deal-finder for the **Bronx (target ZIPs 10451–10475)** that surfaces high-value property assemblage opportunities by combining the NYC MapPLUTO dataset with zoning rules, FAR calculation, and ACRIS transaction history.

Internally branded as **"MTH Deals."**

## What It Does

Analysts use an interactive Maplibre-GL map to:

- Search by **BBL** (borough-block-lot), address, or block number.
- Apply **zoning-aware filters** that respect FAR, lot size, building class, and air-rights eligibility.
- Draw **grid zones** on the map and auto-assign lots to team members.
- Group lots into **multi-property "deals"** with computed union geometry, total buildable area, and FAR breakdown by use type.
- Trigger **owner enrichment** (mortgage-signer extraction + skip-trace) on a selected batch of lots, which posts back to the map asynchronously via callback.
- See **real-time updates** for ownership changes, deal updates, and enrichment completion via Pusher.

## Architecture

```
dashboard/ (React + Maplibre GL)  ↔  server/ (Express + MongoDB)  ↔  MongoDB Atlas
                                          ▲
                                     etl/ (Node.js)
                                          ▲
                            NYC Open Data (SODA, ArcGIS), MapPLUTO GDB
```

Three workspaces: `dashboard/`, `server/`, `etl/`.

### Server (`server/src/modules/`) — 19 route modules

`pluto`, `map`, `search`, `deals`, `grids`, `lots`, `sales`, `mortgages`, `assessments`, `auth`, `users`, `mih`, `neighborhoods`, `transit-zones`, `boroughs`, `notifications`, `enrichment`, `pusher-auth`.

Bearer-token auth on the enrichment-ingest endpoint for callbacks from the GBM (property-data-enrichment) service.

### ETL (`etl/src/phases/`) — 13 idempotent phases

Defined in `etl/src/etl-all.ts`; each phase tracks a fingerprint (hash of source data) and skips in ~200ms if unchanged. Full pipeline re-runs in ~15 min on `performance-2x` Fly.io hardware (dedicated cores, 6 GB RAM). Node heap is capped at 6 GB to prevent OOM during large result-set buffering.

| Phase | Purpose |
|---|---|
| seed-lots | Export MapPLUTO `.gdb` for target Bronx ZIPs → GeoJSON → Mongo `lots` upsert |
| classify-lots | Mark each lot as "subject" (development-eligible) or "air rights" (FAR uplift candidate) |
| enrich-split-zones | Area-weighted FAR (§77-22) for lots spanning multiple zoning districts (Turf.js polygon intersection) |
| enrich-street-widths | Query CSCL SODA, apply QH bonus FAR (§23-153) for wide streets ≥75 ft |
| seed-acris | Pull mortgages, sales, assessments from NYC ACRIS SODA |
| seed-assessments | Tax assessment ingestion |
| seed-neighborhoods | Neighborhood polygon seed |
| seed-transit-zones | Transit-zone overlay seed |
| build-streets-pmtiles | Tippecanoe-build vector tiles of street network → upload to Cloudflare R2 |

(Plus a few orchestration / helper phases.)

## Tech Stack (Detailed)

**Frontend** (`dashboard/`)
- React 19 + Vite + TypeScript
- Maplibre GL 5.18 (vector tiles), React Map GL 8.1
- TanStack React Query 5.96 (data + Pusher real-time updates)
- TailwindCSS 4, shadcn/ui (`@base-ui/react`, Radix UI)
- nuqs (URL state), Recharts 2.15 (analytics), PMTiles 4.4

**Backend** (`server/`)
- Express 4.21, TypeScript, Node 20
- Mongoose 9.3, MongoDB Atlas
- JWT auth + Bearer API keys for enrichment callbacks
- Pusher 5.3 (real-time), Resend 6.9 (email)

**ETL** (`etl/`)
- Node.js with `tsx` (TypeScript runner)
- Turf.js 7.3 (spatial operations)
- Flatbush 4.5 (R-tree spatial index)
- AWS S3 SDK 3.1 (PMTiles upload)
- Tippecanoe (compiled from source in Docker)

**Infrastructure**
- Fly.io: server on `shared-cpu-1x` (512 MB), ETL on `performance-2x` (6 GB, dedicated cores)
- Health check `/api/health` every 30s
- `server/Dockerfile` (tsup build), `etl/Dockerfile` (multi-stage with Tippecanoe compile + tsx runtime)
- MongoDB Atlas
- Cloudflare R2 (PMTiles dev bucket)

## Integration with Property Data Enrichment

The Map calls `POST https://<gbm-apigw>/process-lots` (spec: `2026-04-23-enrichment-integration-design.md`) to enqueue lots. The enrichment service runs the pipeline and posts results back to `POST /api/enrichment/ingest` with a Bearer token, upserting `lot.ownerEnrichment` (owner name, phones, relatives). Grid roll-up counters auto-update via Pusher. See [property-data-enrichment](../property-data-enrichment/README.md) for the other side.

## Notable Features

- **Zoning-aware FAR with split-zone weighting** — uncommon level of NYC-zoning fidelity.
- **Drawable grid zones** for team assignment.
- **Multi-lot "deal" assembly** with union geometry + buildable-area math.
- **Async enrichment with real-time push notifications** — fire-and-forget UX, results stream in.
- **Idempotent ETL with fingerprinting** — re-runs are cheap.

## Notes

- "MTH Deals" is the user-facing brand; "mthequities-maps" is the repo name.
- Filepaths to remember: `server/src/modules/`, `etl/src/phases/`, `dashboard/src/`, `server/fly.toml`, `etl/fly.toml`, `2026-04-23-enrichment-integration-design.md`.
