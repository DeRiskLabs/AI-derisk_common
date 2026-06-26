---

name: handover-prompt
title: Handover Prompt on Completion
description: Use after a major logical unit of work is complete, committed, and ready to hand off, or when pausing with state that another agent may need. End with a concise copy-pasteable handover prompt that points to repo artifacts, current state, next work, verification commands, and standing constraints. Do not use for tiny one-off answers with no durable state.
category: workflow
status: active
version: 1.0
priority: REQUIRED
user_invocable: true
last_reviewed_at: 2026-06-28

---


# Handover Prompt on Completion


## When

After completing a major logical unit of work and committing it, include a handover
prompt before handing back. Also use this when pausing mid-effort with state worth
resuming.

Do not add a handover prompt for tiny one-off answers, read-only status checks, or work
with no durable repo state.


## Principle

The repository is the source of truth. The handover prompt is a pointer into it, not a
substitute for it. A fresh agent with empty context must be able to resume from the
prompt plus the repo alone.

Put durable conclusions in artifacts first. The prompt should cite those artifacts, not
restate them at length.


## Structure

Give one copy-pasteable fenced block containing:

1. **Objective** - one-line goal and what to read first, in order.
2. **State** - repo path, branch, latest commit, clean/dirty status, and what is done.
3. **Next** - the next unit of work, in order.
4. **Verification** - exact commands to build, test, run, or inspect.
5. **Constraints** - easy-to-violate rules such as commit policy, push policy,
   attribution policy, project-specific bans, and required skills.

Keep it tight: pointers and state, not narrative.


## Before Handing Over

- Commit completed, validated work according to `git-commit-policy`.
- Never push unless the user explicitly asks.
- Never add AI attribution, generated-by text, or AI co-author trailers to commits.
- Capture durable state in artifacts before relying on the handover prompt.
- If the tree is dirty, say exactly what remains dirty and why.
