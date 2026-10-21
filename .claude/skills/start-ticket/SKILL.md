---
name: start-ticket
description: Implement one GitHub issue end to end — check it is executable, set In progress, create its linked branch, implement and verify, then open a pull request that closes it. Use when the user says "start #N", "work on the next ticket", or names an issue to implement.
---

# Start Ticket

Root `AGENTS.md` § Work tracking owns statuses, the leaf rule, and branch, commit and PR
conventions; its tier and verification rules apply to the implementation. This skill never merges.

## 1. Pick and check the issue

With a number, use it. Without one, list candidates and confirm the pick with the user:

```bash
node scripts/project/project.mjs ready
```

Then confirm it is executable and read it in full:

```bash
node scripts/project/project.mjs check <n>
gh issue view <n> --comments
```

A non-zero `check` stops here: report its reasons. A parent is worked through its sub-issues.

## 2. Start

```bash
node scripts/project/project.mjs status <n> "In progress"
gh issue develop <n> --base develop --name <n>-<short-slug> --checkout
```

`gh issue develop` links the branch to the issue. Start from an up-to-date `develop`.

## 3. Implement and verify

Follow the tier, feature workflow and verification in root `AGENTS.md` and `lib/AGENTS.md`.
Treat the acceptance criteria (or Desired behavior) as the contract: record any deviation as an
issue comment when it happens, and update the body if the user agrees to change scope. Work the
issue does not describe belongs in a new issue, not this branch.

## 4. Open the pull request

Commit through the `commit` skill. Then open a ready (not draft) pull request into `develop`:

```markdown
Fixes #<n>

## Acceptance
- [x] <criterion> — <observable proof: test name, screenshot, command output>

## Changes
<the mechanism first, then the notable files>
```

Use one `Fixes #<n>` line per issue this PR fully completes. An issue it only partly completes is
referenced as `Refs #<n>` and stays open. The Project Sync workflow moves the issue to In review
when the PR opens and to Merged when it merges. Report the PR URL and suggest `review-branch` in a
fresh session.
