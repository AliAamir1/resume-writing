---
name: MTH Equities Deal Map
employer: FlatOut Solutions
dates: unconfirmed
tech_used: React 19 | MapLibre GL | Express | MongoDB | Turf.js | Fly.io
url: none
tags: geospatial, etl, real-estate, mapping, real-time, domain-logic, pmtiles
gaps: dates, lots ingested, analysts using it, deals sourced
---

# MTH Equities Deal Map

Analyst-facing property assemblage deal-finder for the Bronx, combining NYC MapPLUTO data with zoning rules, FAR computation, and ACRIS transaction history.

## Bullets

- *Geospatial Application Development*: Built an interactive MapLibre GL deal-finder over NYC MapPLUTO lots letting analysts search by borough-block-lot or address, draw grid zones, assign lots to teammates, and assemble multi-property deals with computed union geometry and buildable area.
- *ETL Pipeline Development*: Designed a 13-phase idempotent pipeline ingesting MapPLUTO, ACRIS, DOB, HPD, and street centerline data, fingerprinting each phase so unchanged phases skip in roughly 200 milliseconds and a full re-run completes in about 15 minutes.
- *Domain Logic Implementation*: Computed zoning-aware floor area ratio including area-weighted handling for lots spanning multiple zoning districts and wide-street bonus FAR, using Turf.js polygon intersection per lot.
- *Vector Tile Pipeline*: Built street-network vector tiles with Tippecanoe and published them as PMTiles to Cloudflare R2 for client-side rendering.
- *Real-Time Notifications*: Streamed ownership changes, deal updates, and asynchronous enrichment completions to the dashboard over Pusher with TanStack Query cache reconciliation.
- *API Integration and Security*: Exposed a Bearer-authenticated ingest endpoint for the enrichment service to post owner intelligence back asynchronously, keeping the analyst workflow fire-and-forget.
- *Backend Architecture*: Built 19 Express route modules over MongoDB Atlas covering lots, deals, grids, sales, mortgages, assessments, zoning overlays, and notifications.
