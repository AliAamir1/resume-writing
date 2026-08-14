# Flatout Products

Multi-component products owned by **FlatOut Ventures LLC** that Ali built (and continues to build). Sibling to [clients/](../clients/) (multi-project client engagements) and [deployed/](../deployed/) (single-file project entries).

## Index

| Product | Folder | Components | Status |
|---|---|---|---|
| **Rituo** | [rituo/](rituo/README.md) | Mobile (Expo) · Web admin (Next.js) · NestJS API · Pulumi platform · Firebase FCM · ElevenLabs · multi-provider AI | active |

## Cross-Cutting Shared Library

**CloudForge** ([rituo/cloudforge/](rituo/cloudforge/README.md)) physically lives inside the Rituo monorepo but is consumed across the Flatout portfolio — Rituo, [Kollaborative AI](../deployed/kollaborative-ai.md), and [MTH Equities Platform](../clients/mth-equities/platform/README.md) all consume it via Git-SSH dependency. When discussing infrastructure in any of those projects, mention CloudForge if the conversation goes deeper than "we use Pulumi."

## Note

Kollaborative AI is also a FlatOut product but currently lives at [deployed/kollaborative-ai.md](../deployed/kollaborative-ai.md) as a single-file entry. Move it under `products/` if it grows to need per-component subfolders.
