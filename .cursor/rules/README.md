# Cursor Rule Pointers

`AGENTS.md` is the primary all-agent instruction source. Canonical path-scoped rules live only in
`.claude/rules/*.md`.

`riverpod-template.mdc` is the sole always-applied Cursor entry point. Every other `.mdc` file is a
scoped pointer whose `globs:` correspond to the canonical rule's `paths:`. Do not copy rule text
into this directory.

| Cursor pointer | Canonical owner | Scope |
|---|---|---|
| `dart-conventions.mdc` | `.claude/rules/dart-conventions.md` | Dart under `lib/` |
| `dart-state.mdc` | `.claude/rules/dart-state.md` | Controllers, providers, states, user handler |
| `dart-widgets.mdc` | `.claude/rules/dart-widgets.md` | Presentation Dart |
| `dart-navigation.mdc` | `.claude/rules/dart-navigation.md` | Routing, deeplinks, presentation navigation |
| `claims-need-source.mdc` | `.claude/rules/claims-need-source.md` | Source, tests, tooling, platforms, docs |
| `no-tool-attribution.mdc` | `.claude/rules/no-tool-attribution.md` | Repository artifacts |
| `commit-intent-routing.mdc` | `.claude/rules/commit-intent-routing.md` | Repository artifacts |
| `post-task-learning.mdc` | `.claude/rules/post-task-learning.md` | Repository artifacts |

When policy changes, edit the canonical Markdown file. Change its pointer only when the canonical
`paths:` change.
