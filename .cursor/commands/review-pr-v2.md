---
description: Review the current PR/branch by dispatching specialised reviewers based on the files that changed
---

## Review PR v2

Review the current branch without editing files. Read root `AGENTS.md` and
derive the changed set with read-only Git commands. Exclude generated Dart and
manifest files from code review, while retaining manifest paths as freshness
signals.

### 1. Collect changed files

Determine the base branch (argument if given, else `develop`, else `main`) and
list branch changes:

```bash
BASE="develop"
git diff --name-only "$(git merge-base HEAD "origin/$BASE" 2>/dev/null || git merge-base HEAD "$BASE")"...HEAD
```

If the worktree itself is the requested review scope, include staged,
unstaged, and untracked paths explicitly.

### 2. Dispatch canonical reviewers

Run every matching read-only reviewer from `.claude/agents/`:

| Reviewer agent | Trigger |
|---|---|
| `flutter-code-reviewer` | any non-generated `*.dart` file |
| `riverpod-pattern-auditor` | `*.dart` with `@riverpod`/`@Riverpod`, a `_$` Notifier, or `*_controller.dart` / `*_provider.dart` / `*_repository.dart` |
| `manifest-freshness-checker` | structural source, route, test, generator, or flat manifest change |
| `widget-placement-auditor` | any **added or renamed** `lib/presentation/**/*.dart` widget/view file |
| `route-integrity-auditor` | any change to `router.dart`, `app_route.dart`, or a deep-link/notification handler |

The reviewer files are:

- `.claude/agents/flutter-code-reviewer.md`
- `.claude/agents/riverpod-pattern-auditor.md`
- `.claude/agents/manifest-freshness-checker.md`
- `.claude/agents/widget-placement-auditor.md`
- `.claude/agents/route-integrity-auditor.md`

### 3. Aggregate

Deduplicate overlapping findings and preserve each `path:line` citation:

```markdown
## PR Review: {branch} → {base}

### Critical
### Warnings
### Good patterns

### Summary
- Reviewers run: {list}
- Critical: X · Warnings: Y
- Recommendation: [fix critical findings / no blocking findings]
```

## Rules

- Read-only review: do not edit files.
- If no reviewable files changed, say so and stop.
- Reviewers are advisory and never CI gates.
- Do not recommend merge while a confirmed Critical finding is open.
