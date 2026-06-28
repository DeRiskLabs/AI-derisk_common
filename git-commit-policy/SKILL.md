---

name: git-commit-policy
title: Git Commit Policy
description: "Create clean git commits after implementation work. Use when the user asks to commit, prepare a commit, inspect staged changes, write a commit message, or decide whether the current work is ready to commit."
category: workflow
status: active
version: 2.1
priority: REQUIRED
user_invocable: true
last_reviewed_at: 2026-06-05

---


# Git Commit Policy


## Repository State Check

Before beginning implementation:

* Check repository status.
* If pre-existing changes are present, stop and ask the user how they should be handled.
* Do not assume ownership of existing changes.
* Possible user instructions may include:

  * leave them untouched
  * stash them
  * discard them
  * commit them separately


## Rules

When a completed logical unit of work is ready:

1. Run required validation.
2. Verify validation passes.
3. Update any required project metadata.
4. Create a git commit.
5. Report completion.


## Commit Timing

* Commit completed, validated work.
* Large tasks may result in multiple commits.
* Prefer multiple logical commits over a single oversized commit.
* Do not create speculative, checkpoint, or work-in-progress commits.
* If implementation results in an unusually large number of commits, inform the user so they can decide whether to reorganize history before merging.


## Commit Preconditions

Before committing implementation work:

* Narrow relevant tests must pass.
* The project's required full suites must pass once where applicable.
* Changes that cross repository boundaries, API contracts, or integration points must satisfy validation requirements for all affected components.
* Documentation-only, artifact-only, or metadata-only changes do not require unrelated test suites to be executed.
* Where the project tracks completion metadata (stories, test plans, implementation records, etc.), update it before the final commit.
* If multiple repositories changed, commit each repository separately.
* If required validation cannot be executed, do not commit unless the user explicitly accepts the risk.


## Commit Messages

Use clear, descriptive commit messages.

The commit message should contain:

* A concise subject line of 50 characters or fewer.
  - Separate subject from body with a blank line
  - Capitalize the subject line (see example below)
  - Do not end the subject line with a period
  - Use the imperative mood in the subject line

  Prefer:

  ```text
  Add Request Registry API
  Implement Story Workspace Bundle
  Normalize artifact metadata
  ```

  Avoid:

  ```text
  fix
  updates
  stuff
  wip
  ```

* A longer explanation body describing the change and its intent when additional context would be useful.
  - Wrap the body at 72 characters
  - Use the body to explain what and why vs. how

Do not include AI attribution, agent attribution, co-author trailers, or similar metadata unless explicitly requested by the user or required by project policy.


## Do Not Commit If

* Git identity is missing.
* Required validation has not been completed.
* The repository state is unknown.
* Pre-existing changes are present and the user has not provided instructions for handling them.
* The commit would include files unrelated to the completed work.

When unable to commit, clearly explain why. Ask the user for direction.


## Completion Reporting

After committing, report:

* Validation performed.
* Validation results.
* Commit hash.
* Commit message.
