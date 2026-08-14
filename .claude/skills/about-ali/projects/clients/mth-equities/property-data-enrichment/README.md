---
name: MTH Equities Property Data Enrichment (a.k.a. "GBM")
client: MTH Equities
status: active
codebase: /Users/ali/Documents/flatout-solutions/mthequities/mthequities-propertydataenrichment
deployment: AWS Lambda (provisioned via Pulumi)
tech_stack: TypeScript, Node 20, AWS Lambda, API Gateway, SQS, Secrets Manager, EventBridge, Pulumi, Google Gemini API, ScrapingBee, Google Sheets API, IDI skip-trace, Zod, Vitest, esbuild
target_market: Internal — feeds the MTH Equities Map and a legacy Google-Sheets-driven workflow
---

# MTH Equities Property Data Enrichment

A serverless AWS Lambda pipeline that takes a property (BBL or address) and enriches it with **owner intelligence**: pulls public NYC datasets (PLUTO, ACRIS, DOB, HPD), scrapes mortgage documents via **ScrapingBee**, runs them through **Google Gemini** to extract individual signers behind LLC walls, and performs **IDI skip-tracing** for phones and relatives.

Two integration modes:

1. **Sheet-driven** — a Google Apps Script writes property rows; the orchestrator reads them and queues for processing; results flow back to the same sheet.
2. **Callback-driven** — the [Equities Map](../equities-map/README.md) (and any future consumer) `POST`s to `/process-lots` with a `callbackUrl`; results are posted back asynchronously with Bearer auth.

## Lambda Topology

Five Lambdas + DLQs, all defined in `infrastructure/index.ts` (Pulumi TypeScript):

| Lambda | Trigger | Timeout | Purpose |
|---|---|---|---|
| **orchestrator** | API Gateway | 2 min | Reads Google Sheet rows; enqueues each property to `property-queue` |
| **process-lots-handler** | API Gateway | 2 min | REST `/process-lots`; Zod-validates payload; SSRF-checks `callbackUrl` against hostname allowlist; enqueues to `property-queue` |
| **worker** | SQS (`property-queue`) | 15 min | One property: GeoSearch (address→BBL), PLUTO/ACRIS/DOB/HPD calls, ScrapingBee fetch, Gemini analysis, IDI skip-trace; emits to `results-queue` |
| **sheet-writer** | SQS (`results-queue`) | reserved concurrency = **1** | **Dual-sink**: writes to Google Sheets (throttled to 54/min vs. the 60/min Sheets API limit) AND/OR POSTs to external `callbackUrl`. Independent try/catch per sink. Returns `SQSBatchResponse` for granular DLQ routing |
| **dlq-redrive** | EventBridge schedule (5 min) | — | Bulk-redrives DLQ messages via AWS `StartMessageMoveTask` (3 retries for properties, 5 for results) |
| **dlq-callback-notifier** | DLQ event source | — | For messages with `callbackUrl`, POSTs `{executionId, bbl, success: false, failureReason}` to notify external consumers of permanent failures; leaves sheet-only messages for redrive |

## Tech Stack (Detailed)

**Language / Runtime:** TypeScript on Node 20.
**Build:** esbuild (tree-shaken Lambda bundles, externalizes `@aws-sdk/*` to keep packages under 250 MB).
**Testing:** Vitest.
**IaC:** Pulumi (TypeScript) — provisions SQS, Lambda, API Gateway, Secrets Manager, CloudWatch.

**Key libraries**

- `@aws-sdk/*` — Secrets Manager, SQS, Lambda
- `googleapis` — Google Sheets API v4
- `axios` — HTTP client
- `pngjs` + `utif` — TIFF→PNG conversion (mortgage docs come back as TIFFs; Gemini wants PNG)
- `zod` — schema validation on `/process-lots`

**External services**

- **Google Gemini API** — `gemini-3-flash-preview`, temperature 0.1, 2 min HTTP timeout
- **ScrapingBee** — premium residential proxies + session persistence
- **Google Sheets API** — for the legacy sheet-driven workflow
- **IDI** — skip-trace for phones / relatives (currently stubbed via `_mock: true` deterministic data pending MTH-169)

## Gemini Prompt & Document Pipeline

`lambdas/document-analyzer/core/analyzer.ts` — sends multi-page TIFF/PNG pages (base64) to Gemini's REST API. Prompt instructs the model to find individuals signing on behalf of borrowing entities (i.e. **bypass LLC walls** and identify the human signer). Returns JSON: `{signerName, title, pageNumber, confidence}`. Falls back to regex extraction on truncated responses.

## Scraping Architecture

`lambdas/document-analyzer/core/fetchers/scrapingbee-fetcher.ts`:

- ScrapingBee with **session IDs** to keep proxy sticky across multi-page document fetches (avoids IP rotation mid-document).
- TIFF → PNG conversion on-the-fly (no S3 staging).
- Tracks credit consumption via `Spb-Cost` response header.
- Custom error classification: `401 = credits exhausted`, `429 = rate-limit`, others = transient.
- 90s timeout per fetch.

## SSRF Defense

`process-lots-handler.ts` validates `callbackUrl`:
- Must be HTTPS.
- Hostname must be on an allowlist.
- Zod-typed input.

This prevents attacker-controlled callback URLs from being abused as an SSRF vector against internal services.

## Notable Engineering

1. **Reserved concurrency = 1** on sheet-writer — guarantees Google Sheets API limit (60/min) is never exceeded.
2. **DLQ redrive via `StartMessageMoveTask`** — bulk re-queue without Lambda-loop coordination or DynamoDB state.
3. **Dual-sink writer** — same Lambda routes results to Sheets + callback; one failure doesn't skip the other.
4. **Secrets caching** — Gemini/ScrapingBee/IDI keys fetched once per warm Lambda instance (module-scope cache).
5. **Retry classification** — `CallbackError.isRetriable` distinguishes 5xx/408/429 (SQS retries) from 4xx (permanent failure → terminal-failure event).
6. **IDI mock harness** — deterministic `_mock: true` data lets the Map team integrate end-to-end before real IDI client lands.

## Repo Layout

```
infrastructure/      # Pulumi IaC
lambdas/             # worker, orchestrator, sheet-writer, dlq-*, shared
appsscript/          # Google Apps Script for the Sheets UI
dashboard/           # React real-time execution monitor
local-worker/        # Node CLI for offline testing
```

Yarn workspaces. Shared types in `lambdas/shared/src` (PropertyMessage, PropertyResultMessage), sheets/callback utilities, Bearer-token-cached callback client.

## Notes

- Internally referred to as **GBM** in some integration docs.
- Open ticket: **MTH-169** — replace IDI mock with real client.
- See [equities-map](../equities-map/README.md) for the consumer-side integration.
