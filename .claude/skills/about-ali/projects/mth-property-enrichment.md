---
name: Property Owner Enrichment Pipeline
employer: FlatOut Solutions
dates: unconfirmed
tech_used: TypeScript | AWS Lambda | SQS | Google Gemini | Pulumi | Zod
url: none
tags: serverless, aws-lambda, llm, gemini, scraping, sqs, dlq, security, ssrf
gaps: dates, properties enriched, signer extraction accuracy, cost per property
---

# Property Owner Enrichment Pipeline

Serverless pipeline that takes a property and returns owner intelligence: scrapes mortgage documents, uses an LLM to identify the humans signing behind LLC walls, and skip-traces contact data.

## Bullets

- *Serverless Architecture*: Built a six-Lambda AWS pipeline spanning an API Gateway orchestrator, a REST intake handler, an SQS worker, a dual-sink results writer, a scheduled dead-letter redrive, and a failure notifier, all provisioned in Pulumi.
- *LLM Document Extraction*: Used Google Gemini to read scraped multi-page mortgage documents and identify the individual signing on behalf of a borrowing entity, returning typed JSON with signer name, title, page number, and confidence, with regex fallback on truncated responses.
- *Web Scraping Infrastructure*: Fetched documents through residential proxies with sticky sessions to avoid mid-document IP rotation, converting TIFF pages to PNG in process and classifying errors as credit-exhausted, rate-limited, or transient.
- *Rate Limit Engineering*: Pinned the results writer to a reserved concurrency of one to hold third-party API writes under a 60-per-minute ceiling at an effective 54 per minute.
- *Queue Reliability*: Automated bulk dead-letter redrive on an EventBridge schedule using native message move tasks instead of Lambda-loop coordination, with retry classification separating retriable 5xx, 408, and 429 responses from permanent 4xx failures.
- *Application Security*: Blocked server-side request forgery by requiring HTTPS and validating caller-supplied callback hostnames against a Zod-typed allowlist before enqueueing any work.
- *Integration Design*: Built a dual-sink writer routing the same result to a spreadsheet workflow and an external HTTP callback with independent error handling per sink, so one failing consumer never blocks the other.
