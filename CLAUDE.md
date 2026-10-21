@AGENTS.md

<!-- AGENTS.md is the tracked instruction source for every agent. Only Claude Code specifics live here. -->

## Claude Code only

- Canonical path-scoped rules live in `.claude/rules/*.md`; load the files whose `paths:` match
  the work.
- Reusable workflows live in `.claude/skills/`.
- `.claude/agents/` contains read-only advisory reviewers. They never edit files or act as CI gates:
  - `flutter-code-reviewer` — correctness, render safety, widget construction, architecture
  - `riverpod-pattern-auditor` — codegen, `ref` lifecycle, `AsyncValue`, invalidation
  - `route-integrity-auditor` — `AppRoute`/`GoRoute` pairs, navigation targets, deeplinks
  - `widget-placement-auditor` — feature placement, `View` naming, one widget per file
  - `manifest-freshness-checker` — source changes that leave a flat manifest stale
- `.claude/settings.json` registers SessionStart, generated-file blocking, debounced codegen
  reminders, and a non-blocking Stop integrity check. `.claude/hooks/*.mjs` are adapters over the
  shared policy in `scripts/ai/`; Stop writes `.claude/last-session-status.json`.
- CI never runs `build_runner`, so nothing backs the codegen reminder: run it yourself after
  annotation changes.
