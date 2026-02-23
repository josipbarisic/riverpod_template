# Cursor Commands (AI-First Template)

Slash commands for standardized AI workflows. Type `/` in Cursor Chat to see them.

## Core Commands

1. **`/add-feature`** — Add a new feature/screen
   - Asks complexity (Tier 1/2/3); Tier 3 requires approval
   - Asks development approach (TDD / Implementation First / Only)
   - Creates views, controllers, states, routes
   - Anti-drift check and structured report

2. **`/refine-feature`** — Iteratively refine an existing feature
   - Fix violations (private methods, relative imports, dynamic, missing integrations)
   - Improve code quality, add missing integration points
   - Asks complexity (Tier 1/2/3); Tier 3 requires approval

3. **`/fix-bug`** — Fix bugs with proper context
   - Uses manifests for context gathering
   - Asks complexity; workflow adapts by level

4. **`/fix-gh-issue`** — Fix a GitHub issue by number or URL
   - Fetches issue details using GitHub CLI (`gh`)
   - Follows zero-drift workflow with mandatory reads

5. **`/mobile-issue`** — Debug mobile-specific issues
   - Investigates using manifest context
   - Identifies root cause before fixing

6. **`/update-route`** — Add or update routes
   - Uses `AppRoute` pattern
   - Updates router configuration

7. **`/test`** — Create tests (unit, widget, or integration)
   - Choose what to test (feature/file/method/widget)
   - Follows testing best practices with mock/stub patterns

8. **`/tdd`** — Test-driven development
   - Red–Green–Refactor cycle
   - Follows TDD best practices

9. **`/grind`** — Batch operations
   - Same change across many files
   - Systematic updates

10. **`/review`** — Pre-commit review
    - Security scanning, import validation, NEVER rules check
    - Anti-drift check, feature tests, file size guidelines
    - Structured review summary

11. **`/commit`** — Create secure, atomic commits
    - Security scanning (blocks secrets, forbidden files)
    - Prefix or conventional format
    - Untracked files confirmed before adding
    - Atomic commit enforcement with multi-commit option

12. **`/regenerate-manifests`** — Regenerate feature manifests
    - Run after structural changes (views, controllers, routes, repositories)

13. **`/analyse`** — Analyse a feature (structured report)
    - Manifest-based discovery
    - Report: purpose, architecture, controllers, API, UI/UX, strengths, gaps, recommendations

14. **`/remove`** — Remove feature/widget/file and all references
    - Impact analysis with safety warnings
    - Requires confirmation when removal affects other features

## Prompt Engineering

15. **`/enhance-prompt`** — Enhance and optimize any prompt for maximum AI effectiveness
    - Classifies intent, gathers codebase context, structures output

## Workflow

16. **`/branch`** — Create feature branch
    - Follows naming conventions (feature/fix/refactor/docs)
    - Ensures clean working directory and up-to-date base

17. **`/pr`** — Create pull request description
    - Analyzes commits and changed files
    - Generates PR template with type, changes, affected areas, testing, related issues
    - Optional `gh pr create` execution

18. **`/start-new-project`** — Initialize a new project from this template
    - Comprehensive requirements gathering
    - Project specification and implementation plan

## Skills

Agent skills (optional, for deeper workflows) live in `.cursor/skills/`:

- **flutter-code-review** — Review code for architecture violations and template patterns
- **flutter-ui-refinement** — Refine UI with reference patterns and design options
- **git-commit** — Well-formatted commits with security scan and prefix/conventional format
- **feature-planning** — Plan new features with widget decomposition and integration analysis

## Command Patterns

All commands follow these shared patterns:

### 1. Mandatory Reads

- Read `lib/AGENTS.md`
- Generate/read manifests
- Read relevant feature manifests

### 2. State What You Read

- AI must list all files read before implementing
- Transparency and accountability

### 3. Complexity Scale (User-Assigned)

At the start of relevant tasks, the AI **asks** what complexity the user assigns:

- **Tier 1 – Quick:** Single file, small change → Minimal discovery → Execute
- **Tier 2 – Moderate:** A few files, clear scope → Short discovery + plan → Execute
- **Tier 3 – Large:** New feature or big change → Full discovery + spec + plan → **Wait for approval** → Execute

Full definition and discovery depth: `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

### 4. Anti-Drift Checklist

- Prevents scope creep
- Ensures only requested changes
- No "while I'm here" improvements

### 5. Verification

- Always run `flutter analyze && flutter test`
- Self-correction protocol for failures

## Architecture

Commands are adapted for **layer-based architecture**:

- **Direct imports** (not barrel imports): `package:riverpod_template/...`
- **Layer paths**: `lib/presentation/`, `lib/data/`, `lib/domain/`
- **AppRoute** constants in `lib/core/routing/router.dart`
- **Manifests**: `lib/manifests/{feature}.manifest.generated.json`

## GitHub Integration

### Requirements

- **GitHub CLI (`gh`)** must be installed
- **Authentication** required: `gh auth login`

### Setup

1. Install GitHub CLI:
   ```bash
   # macOS
   brew install gh

   # Or download from: https://cli.github.com/
   ```

2. Authenticate:
   ```bash
   gh auth login
   ```

3. Verify access:
   ```bash
   gh issue list --limit 1
   ```

## Related Documentation

- **AI Agent Guide**: `lib/AGENTS.md` — Quick reference for AI agents
- **Complexity Workflow**: `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md` — Discovery depth by tier
- **Feature READMEs**: `lib/presentation/{feature}/README.md` — Business context
- **Cursor Rules**: `.cursor/rules/` — All coding standards and patterns
