---
name: review-branch
description: Review one pull request at its exact head in a context that did not write it — grade the linked issue's acceptance criteria, check simpler and existing alternatives, run the matching reviewer agents, and post one verdict comment. Use when the user asks to review a PR.
argument-hint: "<pr-number>"
---

# Review Branch

Run this in a session or subagent that did not write the diff. One review per head: the comment
posted at the head SHA is the verdict. This skill never merges.

## 1. Bind the head

```bash
gh pr view <pr> --json number,title,body,headRefOid,baseRefName,closingIssuesReferences,commits
gh pr diff <pr>
```

Record `headRefOid`. If the head moves during the review, start again on the new head.

## 2. Read the contract

For every closing issue, run `node scripts/project/project.mjs check <n>` and read
`gh issue view <n>`. A closing reference to a parent issue is a blocking finding. Read the root
`AGENTS.md`, `ARCHITECTURE.md`, and every `.claude/rules/*.md` whose `paths:` cover a changed file.

## 3. Review

- **Acceptance:** check each criterion against observable evidence in the diff or PR body. A
  criterion with no evidence is blocking; work no criterion describes is a finding unless the
  issue explains it.
- **Reachability:** for each option, branch, flag or fallback the diff adds, name the current case
  that reaches it; an unreachable one is a finding whose fix is deletion.
- **Existing code:** for each new method, name the closest existing symbol that already does the
  job. If the diff could call it unchanged, that is a minor finding whose fix is delegation.
- **Simpler version:** for each new state holder, abstraction or second mechanism, name a simpler
  version that meets the same criteria, or accept it in one clause.
- **Tests:** a test that asserts a hazard does not occur needs the hazard shown reachable (a red
  phase, or the fixture asserting itself valid). Otherwise the claim is unverified and blocking.
- **Specialists:** run the read-only reviewer agents whose surface the diff touches:

| Changed files | Agent |
|---|---|
| any `lib/**/*.dart` | `flutter-code-reviewer` |
| providers, controllers, notifiers, `*_state.dart` | `riverpod-pattern-auditor` |
| `lib/core/routing/**`, deeplink or navigation call sites | `route-integrity-auditor` |
| widgets and views under `lib/presentation/**` | `widget-placement-auditor` |
| feature views, controllers, routes, repositories | `manifest-freshness-checker` |

Severity: **blocking** for correctness, data, security, user-facing or acceptance defects, a second
mechanism with its simpler version named, or a placement rule broken. **Minor** for everything
else, at most three, each with evidence. Ground every finding in the code at the bound head.

## 4. Post one verdict

Write the body to a temp file. It states the head SHA, the acceptance table, the findings, and a
marker on its own line that matches the verdict:

```
<!-- review-verdict: approve -->
<!-- review-verdict: request-changes -->
```

```bash
gh pr review <pr> --comment --body-file <file>
```

A comment, because GitHub rejects an approval from the PR's author on a single-account repo; the
marker carries the verdict. Put line-specific findings as inline comments when they help. After
the author pushes fixes, review the new head once and post a fresh verdict.
