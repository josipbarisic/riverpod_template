# Cursor Commands (Riverpod Template)

This directory contains Cursor IDE slash commands for standardized AI workflows.

**Focused command set** for clarity and reduced maintenance. Committing is handled
by the `git-commit` skill (routed automatically from natural-language commit
intent by `.cursor/rules/commit-intent-routing.mdc`), not a slash command.

## Available Commands

### Core Commands (Daily Use)

1. **`/fix`** — Fix any issue: GitHub issue (by number/URL), user-reported bug, or other
   - Smart input detection: GitHub issue → fetches via `gh`; text description → direct
   - Unified discovery → tier → plan → implement → verify flow
   - Merged from: `/fix-gh-issue`, `/fix-bug`, `/mobile-issue`

2. **`/add-feature`** — Add a new feature/screen
   - Asks complexity (Tier 1/2/3); Tier 3 requires approval
   - Asks development approach (TDD / Implementation First / Only)
   - Follows layer-based architecture patterns
   - Creates views, controllers, states, routes

3. **`/refine-feature`** — Iteratively refine an existing feature
   - Fix violations, add integrations, improve code quality
   - Asks complexity (Tier 1/2/3); Tier 3 requires approval

4. **`/analyse`** — Analyse a feature with manifest-based discovery
   - Structured report: purpose, architecture, controllers, API, UI/UX, strengths, gaps
   - Reads AGENTS.md and feature manifest; checks staleness

### Specialized Commands (Periodic Use)

5. **`/test`** — Create tests (unit, widget, or integration)
   - Standard mode: write tests for existing code
   - TDD mode: Red-Green-Refactor cycle
   - Merged from: `/test` + `/tdd`

6. **`/remove`** — Remove a feature, widget, or file and all references
   - Impact analysis with safety warnings
   - Requires explicit confirmation when removal affects other features

7. **`/review-pr-v2`** — Review the current branch by dispatching specialised reviewers
   - Detects changed file kinds and runs matching auditor skills
   - Aggregates findings into one severity-grouped report (read-only)

### Meta / Learning Commands

8. **`/enhance-prompt`** — Enhance and optimize any prompt for AI effectiveness
   - Classifies intent, gathers codebase context, structures with requirements and constraints

9. **`/review-learnings`** — Review accumulated learning notes
   - Category heatmap, recurring themes, blind spots, focus areas

### Template-Only

10. **`/start-new-project`** — Initialize a new project from this template
    - Requirements gathering, project specification, implementation plan

## Usage Tracking

Every command logs its invocation to `.cursor/usage/command-log.jsonl` as Step 0.

**Format:** One JSON line per invocation:

```json
{"command":"/fix","timestamp":"2026-03-02T14:30:00","input":"#45"}
{"command":"/review-pr-v2","timestamp":"2026-03-02T16:00:00"}
```

**Location:** `.cursor/usage/command-log.jsonl`

Use this to review which commands you use, how often, and to spot workflow patterns.

## Removed Commands

The following commands were removed during consolidation. Their functionality is merged into the commands above or covered by rules in `.cursor/rules/`.

| Removed | Absorbed By |
|---------|-------------|
| `/fix-gh-issue` | `/fix` (merged) |
| `/fix-bug` | `/fix` (merged) |
| `/mobile-issue` | `/fix` (merged) |
| `/commit` | `git-commit` skill + `commit-intent-routing` rule |
| `/review` | `git-commit` skill (pre-commit review) / `/review-pr-v2` (branch review) |
| `/tdd` | `/test` (TDD mode option) |
| `/regenerate-manifests` | Inline step in `/fix`, `/add-feature`, `/refine-feature` |
| `/branch` | Removed — use git directly |
| `/pr` | Removed — use `gh pr create` or ask AI for description |
| `/update-route` | Covered by `/add-feature` (route steps) |
| `/grind` | Removed — describe batch operations ad-hoc |

## Usage

1. In Cursor Chat, type `/` to see available commands
2. Select a command from the dropdown
3. Command content loads — you can edit before submitting
4. AI follows the command step-by-step

## GitHub Integration

- **GitHub CLI (`gh`)** — required for `/fix` when using a GitHub issue number or URL
- **Authentication:** `gh auth login`
- From project root, `gh issue view {number}` uses the current repository

## Command Patterns

All commands follow these patterns:

### 1. Usage Tracking (Step 0)

Every command logs to `.cursor/usage/command-log.jsonl` as its first step.

### 2. Mandatory Reads (ZERO-DRIFT)

- Read `ARCHITECTURE.md` (or `lib/AGENTS.md`)
- Generate/read manifests when relevant
- Read relevant feature manifests: `lib/manifests/{feature}.manifest.generated.json`

### 3. Complexity Scale (User-Assigned)

- **Tier 1 – Quick:** Single file, small change → Minimal discovery → Execute
- **Tier 2 – Moderate:** A few files, clear scope → Short discovery + plan → Execute
- **Tier 3 – Large:** New feature or big change → Full discovery + spec + plan → **Wait for approval** → Execute

Full definition: `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

### 4. Anti-Drift Checklist

- Prevents scope creep
- Ensures only requested changes

### 5. Verification

- Run `flutter analyze && flutter test`
- Self-correction protocol for failures

## Architecture

Commands are adapted for **layer-based architecture**:

- **Direct imports:** `package:riverpod_template/...`
- **Layer paths:** `lib/presentation/`, `lib/data/`, `lib/models/`, `lib/core/`
- **AppRoute** pattern: `lib/core/routing/app_route.dart`, `lib/core/routing/router.dart`
- **Manifests:** `lib/manifests/{feature}.manifest.generated.json`

## Skills

Deeper workflows in `.cursor/skills/` (see `.cursor/skills/README.md` for the full index):

- **git-commit** — secure, atomic commits (canonical commit path)
- **pr-no-cursor-references** — no-tool-attribution validation for PR/commit text
- **feature-planning** — phased, planning-only feature design
- **flutter-code-review** / **flutter-ui-refinement** — code + UI review
- **flutter-ios-transition-freeze** — iOS freeze / phantom-tap debugging
- **riverpod-pattern-auditor** / **route-integrity-auditor** / **widget-placement-auditor** / **manifest-freshness-checker** — read-only PR auditors dispatched by `/review-pr-v2`
- **post-task-learning** — persist learning notes to `LEARNING_LOG.md`

## Related Documentation

- **AI Agent Guide:** `lib/AGENTS.md`
- **Complexity & Discovery:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`
- **Learning Log:** `.cursor/docs/LEARNING_LOG.md`
- **Feature READMEs:** `lib/presentation/{feature}/README.md`
- **Cursor Rules:** `.cursor/rules/`
