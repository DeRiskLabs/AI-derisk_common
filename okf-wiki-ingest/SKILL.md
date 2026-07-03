---
name: okf-wiki-ingest
title: Ingest Sources Into OKF Wiki
description: Use when processing source documents, pending files, or AI chat transcripts into an OKF-compliant LLM wiki. Extracts durable knowledge, reconciles it with existing concept pages, creates source or chat records, cites claims, archives raw inputs, and updates pages/index/log without restating generic OKF bundle rules.
category: workflow
status: active
version: 0.1
priority: REQUIRED
triggers:
  - ingest sources
  - ingest chats
  - process sources
  - process chats
  - update wiki from sources
  - update LLM wiki
  - fold transcripts into wiki
  - OKF wiki ingest
  - process wiki/sources
  - process wiki/chats
anti_triggers:
  - ordinary markdown edit
  - answer a question without updating files
  - application code only
  - source is sensitive and policy forbids access
user_invocable: true
last_reviewed_at: "2026-07-03"
---

# OKF Wiki Ingest

Use this skill to process pending source documents and AI chat transcripts into a durable
OKF-compatible LLM wiki.

This skill works for both project workspace wikis and the user's personal Brain. Treat it as
the write-path companion to [[maintain-okf-bundles]].

Use [[maintain-okf-bundles]] for generic OKF bundle structure, frontmatter, index, log, link,
citation, and reserved-file rules. This skill decides what knowledge changes; that skill keeps
the resulting bundle valid.


## Bundle Root

Operate on any OKF bundle root. Do not assume the directory is named `wiki`.

Common roots:

- `Repositories/.../workspace/wiki/`
- `Repositories/.../workspace/project_context/`
- `Brain/Hub/`
- `Brain/Thoughts/<domain>/`
- `Brain/Life/<domain>/`

The local ingest convention expects:

```text
<bundle-root>/
├── index.md
├── log.md
├── pages/
├── sources/
├── chats/
└── ingested/
    ├── sources/
    └── chats/
```

If `ingested/sources/` or `ingested/chats/` is missing, create it. For Brain roots, do not
create a nested `wiki/` directory unless the user explicitly asks.


## Core Principles

The wiki is current synthesized knowledge. The output of ingest should be a better `pages/`
knowledge graph, not a pile of source summaries. Prefer updating existing concept pages over
creating duplicates. Create new pages only for durable entities, architecture decisions,
processes, systems, interfaces, policies, terms, unresolved questions, or reusable patterns.

Sources are evidence, not the knowledge layer. Pending inputs live in `sources/` and `chats/`.
Processed input records and archived raw inputs live in `ingested/sources/` and
`ingested/chats/`. Durable knowledge lives in `pages/`.

Citations are mandatory for non-trivial source-derived claims. Cite only records you actually
read and created or verified. Never treat model prior knowledge as a citation.

Provenance must not be destroyed. Preserve original input bytes where possible. For every
processed input, record a stable source or chat ID, original filename, archived filename,
original path, ingestion date, checksum, source type, pages created or updated, and durable
knowledge extracted.

Contradictions are first-class knowledge. If a new source contradicts an existing page, do not
silently overwrite. Update the page to show the current best understanding, cite both sides
where possible, and use sections such as `# Contradictions / Superseded Claims` or
`# Open Questions`.

Chats are lower-authority but high-context sources. Extract durable decisions, requirements,
rationale, constraints, rejected options, naming conventions, and next actions. Do not treat
speculative chat exploration as settled fact unless the transcript clearly records a decision.

Ingestion may produce no page change. An input touches `pages/` only when it adds, sharpens, or
contradicts durable knowledge. When no durable knowledge is extracted, create the ingested
record, say that no durable knowledge was extracted, update `log.md`, and do not manufacture a
concept page.


## Privacy And Policy

Before reading pending inputs, inspect applicable local policy files if present:

- `AGENTS.md`
- `CLAUDE.md`
- `_policy.md`
- `_brain_policy.md`
- `_life_policy.md`

For `Brain/Life` or any sensitive domain, assume local-only handling unless policy says
otherwise. Do not send raw personal, financial, medical, family, employment, identity, or legal
material to cloud tools unless explicit permission is present. If the current agent cannot
safely read the material, stop and report the policy issue.


## Pending Inputs

Pending source documents are files under:

- `sources/`
- `chats/`

Ignore `.DS_Store`, hidden files, temporary editor files, and files already marked failed,
blocked, or skipped.

Process sources and chats separately. Prefer processing one input at a time when sources are
large, sensitive, or likely to cause broad wiki changes.

For source documents, identify document type, title, author/vendor/project/publisher if
available, date if available, reliability, durable claims, definitions, APIs, processes,
architecture details, decisions, constraints, examples, terminology, and relationships.

For chat transcripts, identify participants if possible, settled decisions, agreed
requirements, rejected options, rationale, terminology, architectural direction, project
constraints, next actions, and unresolved questions.

For images, diagrams, PDFs, spreadsheets, or binary documents, use available local tools to
inspect text and visible structure. If a file cannot be read, create a failed ingestion record
only if useful. Leave the original in place unless policy says otherwise. Never pretend to have
read inaccessible content.


## Knowledge Delta

Before editing pages, build an internal delta:

- New concepts that need new pages.
- Existing concepts whose canonical knowledge should change.
- Contradictions or superseded claims.
- Cross-links that should now exist.
- Important open questions introduced by the source.
- Low-confidence extractions that should not be stated as fact.

Use existing wiki pages as the main comparison target. Use model knowledge only to spot likely
missing context or terminology. Never let model priors override cited sources.


## Concept Page Updates

When updating an existing page:

- preserve unknown frontmatter fields
- update `timestamp` to the current ISO 8601 datetime when the page changes
- add relevant `source_id` or `chat_id` values to `source_ids` without duplicates
- keep the page readable in Obsidian
- add or update cross-links using bundle-relative paths
- add citations for source-derived claims
- remove stale claims only when clearly superseded
- otherwise mark stale claims as superseded, contested, or unresolved

When creating a new page:

- use a stable lowercase hyphenated filename
- place it under `pages/` or a sensible nested directory under `pages/`
- include OKF frontmatter per [[maintain-okf-bundles]]
- use `source_ids` for synthesized pages rather than inventing a primary `resource`
- include links to related pages
- include citations

Recommended body for a new synthesized page:

```markdown
# Summary

The durable, current understanding of this concept.

# Details

Structured knowledge, examples, constraints, and relationships.

# Relationships

- Related to [Other Concept](/pages/other-concept.md) because ...

# Open Questions

- Questions that remain unresolved.

# Citations

[1] [Source title](/ingested/sources/src-YYYYMMDD-title-sha8.md)
```

Do not force this structure when an existing page already has a useful shape. Extend rather
than churn.


## Ingested Records

For every processed file, create an OKF concept record under:

- `ingested/sources/<source-id>.md`
- `ingested/chats/<chat-id>.md`

Use stable IDs:

- `src-YYYYMMDD-<slug>-<sha8>`
- `chat-YYYYMMDD-<slug>-<sha8>`

`<sha8>` is the first eight characters of the SHA-256 checksum of the original file.

Source record frontmatter should include:

```yaml
---
type: Source Record
title: Vendor API Documentation
description: Ingestion record for the original vendor API documentation.
tags:
  - source
  - ingested
timestamp: 2026-07-03T00:00:00Z
source_id: src-20260703-vendor-api-documentation-a1b2c3d4
original_filename: vendor-api-docs.pdf
archived_file: vendor-api-docs.pdf
sha256: a1b2c3d4...
status: ingested
pages_updated:
  - /pages/api-authentication.md
  - /pages/webhook-retry-policy.md
---
```

Use `chat_id` and `type: Chat Transcript Record` for chat transcript records.

Recommended record body:

```markdown
# Summary

Briefly describe what this source is and why it matters.

# Extracted Knowledge

- Durable knowledge extracted from this source.

# Pages Updated

- [API Authentication](/pages/api-authentication.md)

# Archived Input

Original file: `vendor-api-docs.pdf`
```

For no-change ingests, set `pages_updated: []` and write `No durable knowledge extracted.`
under `# Extracted Knowledge`.


## Archive Inputs

Only after page updates and the ingested record are ready, move the original file into the
matching `ingested/` directory.

If the original file extension is `.md`, `.markdown`, or `.mdx` and the file is not already an
OKF concept document, rename the archived copy to a non-Markdown suffix such as:

- `original-chat.md.raw`
- `source-notes.markdown.raw`
- `transcript.mdx.raw`

Record the archived filename in the ingested record. Verify that the checksum of the archived
copy matches the original checksum.

Do not delete or move pending input until the relevant ingested record and wiki updates have
been written.


## Index And Log

Update `index.md` as a content-oriented catalog. Do not turn it into a raw source dump.

Recommended sections:

- `# Knowledge Catalog`
- `## Core Concepts`
- `## Architecture`
- `## Processes and Policies`
- `## Recent Ingested Knowledge`

Update `log.md` with date-grouped entries. Example:

```markdown
# Directory Update Log

## 2026-07-03

- **Ingest**: Processed `vendor-api-docs.pdf` as [src-20260703-vendor-api-docs-a1b2c3d4](/ingested/sources/src-20260703-vendor-api-docs-a1b2c3d4.md).
- **Update**: Revised [API Authentication](/pages/api-authentication.md) with current token expiry rules.
- **Creation**: Added [Webhook Retry Policy](/pages/webhook-retry-policy.md).
- **Conflict**: Marked old retry timing claim as superseded by newer vendor documentation.
```


## Workflow

1. Locate the bundle root.
2. Read applicable policy and local instruction files.
3. Validate the starting state with [[maintain-okf-bundles]].
4. Find pending inputs in `sources/` and `chats/`.
5. Read each input deeply enough to cite it honestly.
6. Build the knowledge delta against existing `pages/`.
7. Update or create concept pages only where durable knowledge changes.
8. Create ingested source or chat records.
9. Archive original inputs with checksum-preserving provenance.
10. Update `index.md` and `log.md`.
11. Validate the final OKF state with [[maintain-okf-bundles]].
12. Report processed, created, updated, conflicts/open questions, and skipped/failed items.


## Completion Criteria

Done when pending inputs were either ingested, skipped, blocked, or reported; durable knowledge
was reconciled into `pages/`; source-derived claims have citations; ingested records preserve
provenance and checksums; raw non-OKF Markdown no longer remains in `sources/`, `chats/`, or
`ingested/`; `index.md` and `log.md` reflect meaningful changes; and the final bundle validates
under [[maintain-okf-bundles]].


## Quality Rules

Prefer synthesis over dumping. Prefer small, focused concept pages over sprawling essays.
Prefer updating existing pages over duplicating concepts. Preserve useful page structure. Avoid
churn. Keep claims source-grounded. Keep chat-derived decisions distinct from source-derived
facts. Mark low-confidence claims explicitly or leave them out. Never let the source archive
replace the curated wiki. Never silently remove disputed or superseded knowledge. Do not make a
Git commit unless explicitly instructed or project policy requires it.
