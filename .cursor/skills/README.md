# Cursor Skills (Riverpod Template)

Skills are auto-fired playbooks the agent reads when a matching situation arises.
Each lives in its own kebab-case folder as `SKILL.md` with YAML front-matter
(`name`, `description`). Rules in `.cursor/rules/` are the source of truth for
conventions; skills are the *workflows* that apply them.

## Available Skills

### Workflow

| Skill | Fires when |
|---|---|
| `git-commit` | User expresses commit intent ("commit", "push", "save changes"). The canonical commit path — routed here by `.cursor/rules/commit-intent-routing.mdc`. |
| `pr-no-cursor-references` | Creating/editing PR or commit text. Runs the no-tool-attribution validation from `.cursor/rules/no-tool-attribution.mdc`. |
| `feature-planning` | Starting a new feature; planning-only, produces a decomposition + plan before code. |
| `flutter-ui-refinement` | Changing colors, spacing, layout, or "make it match X" styling requests. |
| `flutter-ios-transition-freeze` | iOS freeze after navigation, phantom taps, stacked screens, unresponsive-after-back. |

### PR Review Auditors (read-only)

Dispatched by the `/review-pr-v2` command based on which files changed. Each is
advisory and produces a severity-grouped report — none edit code.

| Skill | Reviews |
|---|---|
| `flutter-code-review` | Widget construction, Dart idioms, architecture in changed `.dart` files. |
| `riverpod-pattern-auditor` | `@riverpod`/Notifier hygiene, `ref` lifecycle, `AsyncValue`, invalidation. |
| `route-integrity-auditor` | GoRouter ↔ `AppRoute` integrity, orphan constants, deep-link regressions. |
| `widget-placement-auditor` | Feature-directory placement, `View` suffix, cross-feature widget imports. |
| `manifest-freshness-checker` | Stale `lib/manifests/**/*.manifest.generated.json` vs their sources. |

### Learning

| Skill | Fires when |
|---|---|
| `post-task-learning` | After any implementation task (via `.cursor/rules/post-task-learning.mdc`) — persists the inline Supervisor's Briefing to `.cursor/docs/LEARNING_LOG.md`. |

## Authoring Conventions

- One skill per folder: `.cursor/skills/<kebab-name>/SKILL.md`.
- Front-matter `description` must state *when to use it* — that's the trigger.
- Defer to `.cursor/rules/*.mdc` for conventions; don't duplicate rule content.
- Keep auditors read-only. Keep workflows scoped to what was asked.

## Related

- Rules (source of truth): `.cursor/rules/README.md`
- Commands: `.cursor/commands/README.md`
- Automated hooks: `.cursor/hooks.json` + `.cursor/hooks/`
