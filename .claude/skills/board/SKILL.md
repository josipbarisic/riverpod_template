---
name: board
description: Read-only snapshot of this repository's GitHub Project — what is in progress, in review, merged but unreleased, and what to pick next. Use when the user asks for status, the board, what to work on, or a summary of the work.
---

# Board

Read-only: this skill changes no issue, status or file. `.github/project.json` names the project.

```bash
gh project item-list <number> --owner <owner> --format json --limit 1000
node scripts/project/project.mjs ready --limit=5
gh pr list --state open --json number,title,headRefName,reviewDecision,isDraft
```

Report, shortest first:

1. **Waiting on someone:** open pull requests without a verdict, and In review issues.
2. **In progress:** issue, branch, and how long since it last changed.
3. **Merged, not released:** count, and the oldest; suggest a release when it is large.
4. **Next:** the top `ready` lines, highest Priority first. With none, say whether Backlog has
   issues to promote, or suggest `plan-issues`.

Flag drift without fixing it: an open issue in Merged or Done, a closed issue still In progress,
or an In progress issue with no branch.
