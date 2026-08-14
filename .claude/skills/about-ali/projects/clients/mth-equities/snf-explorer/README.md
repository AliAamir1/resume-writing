---
name: MTH SNF Explorer
client: MTH Equities
status: active
codebase: /Users/ali/Documents/flatout-solutions/mthequities/snf_explorer
deployment: Dockerized Node 20 server (port 8080), MongoDB Atlas (snf-explorer cluster)
tech_stack: React 19, Vite, TypeScript, Maplibre GL 5.18, TanStack Query 5, IndexedDB, Tailwind 4, Radix UI, React Router 7, nuqs, Express 4, Mongoose 9.3, MongoDB 7.1, JWT (access + refresh), bcryptjs, Resend, Zod, Vitest
target_market: Internal MTH acquisitions team — SNF due diligence
---

# MTH SNF Explorer

A standalone interactive geospatial-intelligence platform for **~15,000+ Medicare-certified Skilled Nursing Facilities** in the US. Built for MTH Equities' acquisitions team to drill into facility financials, ratings, regulatory penalties, and ownership structures — and to flag **Jewish-owned properties** for DEI-focused investment screening.

Independent of the other three MTH projects: separate MongoDB Atlas cluster, no shared imports, distinct Docker image. Shares only Resend SDK and root tooling (Prettier, Husky, lint-staged) via the monorepo.

Server entrypoint: `mth_snf_explorer/server/src/app.ts`.

## What It Does

- Browse a nationwide map of SNFs with **client-side MapLibre clustering** (sub-millisecond filter changes after a 24-hour-cached GeoJSON load via TanStack Query + IndexedDB persistence).
- Multi-faceted filtering: states, bed-count range, CMS health/quality/staffing star ratings, ownership type (corporate/private), chain size, fines, single-owner toggle, Jewish-owned toggle.
- Free-text search across `searchBlob` (server-computed: facility name + legal name + city + CCN + chain + owner names).
- Server-paginated list panel (sortable by rating, fines, beds, name).
- Detail sheet per facility with financials, regulatory data, and full ownership tree.
- Authenticated **notes + flags** on facilities and owners (`ownership_flags` collection — graceful degradation if unavailable).

## Data Sources & ETL

`yarn workspace server etl:snf` runs a 9-step pipeline that ingests:

| Source | Dataset | Purpose |
|---|---|---|
| **CMS Provider Catalog** | Provider Info (`4pq5-n9py`) | Facility details, ratings |
| **CMS Provider Catalog** | Penalties (`g6vv-u9sr`) | Fines, payment denials |
| **CMS Data API** | SNF Enrollments (`5f2c306f`) | CCN ↔ NPI crosswalk |
| **CMS Data API** | SNF All Owners (`afe44b85`) | Ownership structure + entity flags (corporation, LLC, PE firm, REIT, holding co., etc.) |
| **NPPES NPI Registry** | (inline enrichment) | Authorized official contact info |

Pipeline builds in-memory crosswalks, merges by CCN, enriches with NPPES, then bulk upserts to Mongo in batches of 500. Facilities without geo coordinates are filtered at render. CLI flags: `--dry-run`, `--skip-nppes`.

## Architecture

Yarn-workspace monorepo (`/server`, `/dashboard`). Standard controller → service → model layering on the server, with services as **pure functions** (`buildMongoFilter`, `buildSearchBlob`) for testability.

```
dashboard/  React 19 + Maplibre GL    server/  Express 4 + Mongoose
features/                              src/
  snf/                                   modules/{auth,snf,notes,flags}/
  notes/                                   controller / service / model
  flags/                                 db/models/
  auth/                                  middlewares/  routes.ts  app.ts
hooks/ (useSnfMapQuery, useSnfFilters)  etl/index.ts  (CMS + NPPES ingestion)
api/   (snf-api.ts, auth-api.ts)
```

### Map Implementation

- GeoJSON source with `location: { type: "Point", coordinates: [lng, lat] }`.
- Two MapLibre layers: clustered circles + unclustered pins.
- **Pure filter builder** (`buildLayerFilter.ts`) compiles to MapLibre expressions:
  - `['in', value, ['literal', [...]]]` for state filter
  - range filters for beds / rating / chain / fines / owner count
  - substring match on `searchBlob`
- Filter changes never re-fetch — they recompile a WebGL expression.

### Auth

JWT access + refresh token pair, bcryptjs hashing. `auth-api.ts` on the client handles JWT injection and silent token refresh.

## Notable Logic

- **Jewish-owned resolution rule** (pure function):
  1. Facility-level "no" override wins.
  2. Else "yes" if any owner is flagged.
  3. Else "no."
- **Ownership-change detection** — flags facilities with ownership changes in the last 12 months.
- **Entity-type flags** captured from CMS All Owners — surfaces PE firms, REITs, holding companies as filterable categories.

## Deployment

`server/Dockerfile`: Node 20-slim, Yarn 4.12.0 via Corepack, TypeScript bundled to `dist/index.js` (tsup), exposes 8080. Env: MongoDB Atlas URI, Resend API key, JWT secrets. **No** Kubernetes / IaC inside this repo.

## Notes

- Standalone by design — different domain (national SNFs vs. NYC lots), different audience (acquisitions vs. analysts), different data lifecycle (CMS quarterly refreshes vs. continuous PLUTO/ACRIS).
- The Jewish-ownership tagging is a deliberate domain feature, not boilerplate — note when discussing.
