@AGENTS.md

<!-- AGENTS.md is the tracked instruction source for every agent. Only Claude Code specifics live here. -->

## Claude Code only

- Canonical path-scoped rules live in `.claude/rules/*.md`; load the files whose `paths:` match
  the work.
- Reusable workflows live in `.claude/skills/`.
- `.claude/agents/` contains read-only advisory reviewers for Flutter, Riverpod, routes, widget
  placement, and flat-manifest freshness. They never edit files or act as CI gates.
- `.claude/settings.json` registers SessionStart, generated-file blocking, debounced codegen
  reminders, and a non-blocking Stop integrity check. `.claude/hooks/*.mjs` are adapters over the
  shared policy in `scripts/ai/`; Stop writes `.claude/last-session-status.json`.
