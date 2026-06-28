---
name: maintain-okf-bundles
title: Maintain OKF Bundles
description: Use when creating, editing, validating, or reorganizing a strict Google Open Knowledge Format v0.1 compatible Markdown bundle. Enforces required index.md and log.md files, required YAML frontmatter, standard Markdown links, no wikilinks, exact ledger entries, and compatibility with official OKF consumers.
category: knowledge-management
status: active
version: 0.1
priority: REQUIRED
triggers:
  - OKF
  - Open Knowledge Format
  - Obsidian-compatible vault
  - markdown knowledge bundle
  - OKF concept
  - OKF index.md
  - OKF log.md
  - no wikilinks
anti_triggers:
  - application code only
  - ordinary markdown edit outside an OKF bundle
  - project has its own incompatible documentation standard
user_invocable: true
last_reviewed_at: "2026-06-28"
---

# Maintain OKF Bundles

Use this skill for Google Open Knowledge Format v0.1 compatible Markdown bundles.

Source of truth: <https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md>.

Maintain a strict OKF-compatible bundle. The official spec is the compatibility floor;
this skill enforces the stricter bundle rules below.


## Required Structure

Verify these files exist at the bundle root:

- `index.md` — master entry catalog. Keep it updated with high-level map references.
- `log.md` — chronological change audit. Every edit you make must prepend one row:

```markdown
- [YYYY-MM-DD HH:MM] ACTION: path/to/file.md - [Brief change summary]
```


## Link Rules

- Never use wikilinks such as `[[Example]]`.
- Use standard Markdown links only.
- Use explicit paths relative to the bundle root, including the `.md` extension.
- Check changed links for broken internal targets when the target file is inside the
  bundle.

Good:

```markdown
[Dietary Rules](pages/nutrition/protocols.md)
```

Bad:

```markdown
[[Dietary Rules]]
```


## Metadata

Every document created or modified inside this bundle must start with clean YAML
frontmatter:

```yaml
---
type: concept
title: "Human-Readable Title"
description: "Short summary fragment."
tags:
  - tag1
resource: "sources/source.md"
timestamp: "2026-06-28T17:05:00Z"
---
```

Rules:

- `type`, `title`, `description`, `resource`, and `timestamp` are required.
- `tags` are optional.
- `type` should be a lowercase singular noun.
- `resource` is singular and should identify the primary source, raw input, or
  canonical asset.
- Preserve producer-defined frontmatter fields when editing.


## Process

1. Identify the OKF bundle root.
2. Verify `index.md` and `log.md` exist.
3. For each created or changed concept document, validate frontmatter and links.
4. Update `index.md` when catalog entries change.
5. Prepend a `log.md` entry for each administrative or content edit.


## Completion Criteria

Done when changed files have required frontmatter, standard Markdown links, an updated
`index.md` when needed, and a prepended `log.md` row.
