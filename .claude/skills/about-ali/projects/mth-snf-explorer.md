---
name: SNF Ownership Explorer
employer: FlatOut Solutions
dates: unconfirmed
tech_used: React 19 | MapLibre GL | Express | MongoDB | TypeScript
url: none
tags: geospatial, healthcare-data, etl, mapping, performance, jwt, cms-data
gaps: dates, acquisition decisions supported, users
---

# SNF Ownership Explorer

Geospatial intelligence platform over 15,000+ Medicare-certified skilled nursing facilities, built for an acquisitions team screening deals on financials, ratings, penalties, and ownership structure.

## Bullets

- *Geospatial Data Visualization*: Built a nationwide map of over 15,000 Medicare-certified skilled nursing facilities with client-side clustering and multi-faceted filtering across state, bed count, CMS health and staffing star ratings, ownership type, chain size, and fines.
- *Client-Side Performance*: Compiled filter state directly into MapLibre WebGL expressions so filter changes recompile rather than re-fetch, backed by a 24-hour IndexedDB-persisted GeoJSON cache.
- *Healthcare Data ETL*: Built a nine-step pipeline ingesting CMS Provider Info, Penalties, SNF Enrollments, and SNF All Owners datasets, crosswalking facility CCN to NPI, enriching from the NPPES registry, and bulk-upserting to MongoDB in batches of 500.
- *Ownership Intelligence*: Surfaced private equity firm, REIT, LLC, and holding company entity flags plus 12-month ownership-change detection as filterable screening criteria.
- *Authentication*: Implemented JWT access and refresh token pairs with bcrypt hashing and silent client-side token refresh.
- *Testable Architecture*: Kept filter construction, search index building, and ownership-flag resolution as pure functions with unit tests, layering controllers over services over models on the server.
