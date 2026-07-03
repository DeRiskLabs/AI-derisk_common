---
name: maintain-okf-bundles
title: Maintain OKF Bundles
description: Use when creating, editing, validating, or reorganizing a strict Google Open Knowledge Format v0.1 compatible Markdown knowledge bundle. Enforces local bundle conventions, parseable concept frontmatter, standard Markdown links, date-grouped logs, readable indexes, source-grounded citations, and preservation of unknown producer-defined metadata.
category: workflow
status: active
version: 0.2
priority: REQUIRED
triggers:
  - OKF
  - Open Knowledge Format
  - knowledge bundle
  - Obsidian-compatible vault
  - markdown knowledge bundle
  - concept page
  - index.md
  - log.md
  - no wikilinks
anti_triggers:
  - application code only
  - ordinary markdown edit outside an OKF bundle
  - project has its own incompatible documentation standard
user_invocable: true
last_reviewed_at: "2026-07-03"
---

# Maintain OKF Bundles

Use this skill when creating, editing, validating, or reorganizing an OKF-compatible
Markdown knowledge bundle.

Source of truth: <https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md>.

**What OKF is.** Open Knowledge Format (OKF) v0.1, from Google Cloud Platform's
`knowledge-catalog`, represents knowledge as a directory of Markdown files with YAML
frontmatter — human-readable and agent-parseable without special tooling. In the spec, only
`type` is mandatory per concept document (`title`, `description`, `resource`, `tags`, and
`timestamp` are recommended); `index.md` (a directory listing) and `log.md` (a dated change
history) are optional; links are bundle-relative (leading `/`) or relative Markdown; consumers
must tolerate broken links and unknown `type`s.

Maintain a strict-but-compatible OKF v0.1 bundle. The official spec is the compatibility floor;
this skill applies stricter local conventions so bundles remain useful to humans, Obsidian,
coding agents, and future OKF consumers.

This skill owns bundle structure and validation. It does not perform source ingestion by
itself. Use [[okf-wiki-ingest]] when processing pending files from `sources/` or `chats/`.


## Bundle Root

An OKF bundle root is a directory that contains Markdown concept documents and may contain
reserved files. Normal local knowledge bundles should contain:

```text
index.md
log.md
pages/
sources/
chats/
ingested/
```

OKF itself does not require this exact directory structure. Do not reject a bundle merely
because it is organized differently unless the user's local convention requires it.

Common bundle roots include:

- `Brain/Hub/`
- `Brain/Thoughts/<domain>/`
- `Brain/Life/<domain>/`
- `Repositories/.../workspace/wiki/`
- `Repositories/.../workspace/project_context/`

Do not assume the bundle root is named `wiki`.


## Reserved Files

The following filenames are reserved at any directory level:

- `index.md` — directory listing or catalog.
- `log.md` — chronological update history.

Reserved files are not concept documents.

`log.md` must never have YAML frontmatter.

`index.md` normally has no YAML frontmatter. The only permitted index frontmatter is at the
bundle-root `index.md`, and only for declaring:

```yaml
---
okf_version: "0.1"
---
```


## Concept Documents

Every non-reserved `.md` file inside the bundle is an OKF concept document.

Every concept document must:

- start with parseable YAML frontmatter
- have a non-empty `type` field
- preserve unknown producer-defined frontmatter fields when edited
- use standard Markdown body content

Minimum OKF-compliant frontmatter:

```yaml
---
type: Concept
---
```

Preferred local frontmatter:

```yaml
---
type: Concept
title: Human Readable Title
description: One-sentence summary.
tags: []
timestamp: 2026-07-03T00:00:00Z
status: current
---
```

Useful optional fields:

- `aliases: []`
- `source_ids: []`
- `related: []`
- `confidence: high`
- `last_verified_from_source: 2026-07-03T00:00:00Z`
- `supersedes: []`
- `superseded_by: []`
- `privacy_level: normal`
- `resource: https://example.com/canonical-resource`

Use `resource` when the concept describes a canonical asset, external resource, or primary
maintained artifact. Do not require `resource` for abstract or synthesized knowledge pages.
For synthesized pages supported by multiple inputs, use `source_ids` and body citations.

Good `resource` use:

```yaml
---
type: Interface
title: Vendor API
resource: https://example.com/vendor-api-docs
---
```

Poor `resource` use:

```yaml
resource: "general thoughts from several chats"
```

OKF permits producer-defined `type` values and consumers must tolerate unknown types. Use
descriptive type values. Preferred local values include:

- `Concept`
- `Architecture Decision`
- `System Component`
- `Process`
- `Policy`
- `Interface`
- `Data Model`
- `Project Concept`
- `Glossary Term`
- `Source Record`
- `Chat Transcript Record`
- `Decision Record`
- `Template`
- `Agent Skill`

Do not enforce lowercase-only type values. Do not rename existing type values unless the user
asks for normalization.


## Link Rules

Use standard Markdown links only. Do not use wikilinks such as `[[Example]]`.

Prefer bundle-relative links beginning with `/`:

```markdown
[API Authentication](/pages/api-authentication.md)
```

Relative Markdown links are allowed when they improve local readability:

```markdown
[Neighboring Concept](./neighboring-concept.md)
```

When linking to concept documents, include the `.md` extension.

Avoid creating broken links unless the link intentionally marks planned or missing knowledge.
Report existing broken links you notice, but do not automatically remove them.


## Citations

When a concept body makes non-trivial claims derived from a source, add citations under a
`# Citations` heading.

Preferred citation form:

```markdown
# Citations

[1] [Vendor API Documentation](/ingested/sources/src-20260703-vendor-api-docs-a1b2c3d4.md)
[2] [Architecture discussion transcript](/ingested/chats/chat-20260703-architecture-discussion-b4c3d2e1.md)
```

Do not invent citations. Do not cite a source that was not read. Do not treat model prior
knowledge as a citation.


## Index Rules

`index.md` should help humans and agents discover the bundle.

Use sections and short descriptions:

```markdown
# Knowledge Catalog

## Core Concepts

- [AI-Enabled Brain](/pages/core-concepts/ai-enabled-brain.md) - Personal OKF-based knowledge system maintained by AI agents.

## Processes

- [OKF Wiki Ingest](/pages/processes/okf-wiki-ingest.md) - Process for folding raw sources and chats into durable knowledge.
```

Keep the index useful, not exhaustive noise. Prefer entries for durable pages, important
subdirectories, and recently important records. Include descriptions from concept frontmatter
where possible. Do not turn the index into a raw source dump.


## Log Rules

`log.md` must use date-grouped entries, newest first. Date headings must use ISO
`YYYY-MM-DD`.

Preferred format:

```markdown
# Directory Update Log

## 2026-07-03

- **Update**: Revised [AI-Enabled Brain](/pages/core-concepts/ai-enabled-brain.md) to clarify Hub, Life, and Thoughts boundaries.
- **Creation**: Added [Brain Privacy Boundary](/pages/core-concepts/brain-privacy-boundary.md).
- **Ingest**: Processed [Karpathy LLM Wiki](/ingested/sources/src-20260703-karpathy-llm-wiki-a1b2c3d4.md).
```

Do not use one-line timestamp ledger rows unless the local bundle or project overlay
explicitly requires them.


## Raw Source Caveat

Local wiki bundles may use these inboxes:

- `sources/`
- `chats/`

These are staging areas. While raw `.md`, `.markdown`, or `.mdx` files are waiting there, the
bundle may be temporarily non-conformant because OKF treats non-reserved Markdown files as
concept documents. This is acceptable only as a pending-ingest state.

After ingestion, raw Markdown inputs must either become valid OKF concept documents or be
archived with a non-Markdown suffix such as `.md.raw`, with a separate OKF wrapper record.


## Process

1. Identify the OKF bundle root.
2. Read local policy files if present: `AGENTS.md`, `CLAUDE.md`, `_policy.md`,
   `_brain_policy.md`, `_life_policy.md`.
3. Inspect `index.md` and `log.md`.
4. Validate non-reserved `.md` files as concept documents.
5. Preserve unknown frontmatter fields.
6. Use standard Markdown links, preferably bundle-relative `/...`.
7. Update `index.md` when catalog-worthy pages are created, removed, renamed, or materially
   changed.
8. Update `log.md` for every meaningful content or administrative change.
9. Keep diffs focused and avoid churn.
10. If under version control, do not commit unless explicitly instructed or project policy
    requires it.


## Completion Criteria

Done when the bundle root is clear; `index.md` and `log.md` follow local rules; every
non-reserved `.md` file has parseable frontmatter with a non-empty `type`; unknown frontmatter
fields were preserved; links use standard Markdown; source-derived claims have citations; no
raw non-OKF Markdown remains outside pending inboxes unless intentionally archived as raw input;
and changes are coherent and limited to the requested work.
