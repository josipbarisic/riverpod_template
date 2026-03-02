---
description: Fix any issue — GitHub issue, bug report, or other issues
---

## Fix Issue

Unified command for fixing bugs, GitHub issues, and other issues.

**Reference:** Complexity scale → `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

---

### Step 0: Log Usage

```bash
mkdir -p .cursor/usage && echo '{"command":"/fix","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%S)'","input":"'"$(echo '$ARGUMENTS' | head -c 120 | tr '"' "'")"'"}' >> .cursor/usage/command-log.jsonl
```

---

### Step 1: Identify Input Source

Detect what the user provided:

**A) GitHub Issue (number or URL):**

- If input matches `issues/(\d+)` or is a plain number → extract issue number
- Fetch issue details (uses current repo if run from project root):

```bash
gh issue view {number} --json title,body,labels,comments,state,assignees
```

- If GitHub CLI not available or not authenticated: ask user to provide issue details manually or guide to authenticate (`gh auth login`)

**B) Text Description:**

- User describes the bug/issue directly
- Ask clarifying questions based on tier (see Step 2)

**C) Insufficient context:**

- Ask: "Please provide either a GitHub issue number/URL or describe the issue (what's broken, where, expected vs actual behavior)."

---

### Step 2: Assign Complexity (MANDATORY)

**Ask the user (e.g. via AskQuestion) if not already stated:**

```
"What complexity do you assign to this fix?"

- **Tier 1 – Quick:** Single file, obvious fix. Minimal discovery, then execute.
- **Tier 2 – Moderate:** A few files, clear cause. Short discovery + plan, then execute.
- **Tier 3 – Large:** Unclear cause, many touchpoints, or risky change. Full discovery + plan — then wait for your approval before implementing.
```

**For Tier 2–3, gather context based on input source:**

- **GitHub issue:** Extract details from issue body, comments, labels.
- **Text description (Tier 2):** What's broken, where, expected vs actual (3–5 questions).
- **Text description (Tier 3):** Full discovery — affected screen, expected/actual behavior, error messages, steps to reproduce, recent changes that might have caused it.

---

### Step 3: Mandatory Reads (ZERO-DRIFT)

**Tier 1:** Read only the affected file(s) if obvious.

**Tier 2–3:** Before any code changes:

1. Read `ARCHITECTURE.md` (code patterns, import rules, layer-based structure)
2. Generate manifests: `dart run scripts/generate_feature_manifests.dart`
3. Based on issue content, identify affected feature(s) from `lib/presentation/`
4. Read manifest for each affected feature:
   - `lib/manifests/{feature}.manifest.generated.json` (technical specifics)
5. Read feature README (if exists):
   - `lib/presentation/{feature}/README.md` (business context and integration points)
6. If issue involves API changes and project has `docs/API_CONTRACTS.md`, read it for API patterns

**Extract from manifest:**

- `views` - Screen widgets affected
- `controllers` - Riverpod controllers involved
- `stateClasses` - State classes (Freezed/Equatable)
- `providers` - Provider definitions
- `routes` - Navigation routes (AppRoute references)
- `apiEndpoints` - API endpoints used
- `dependencies` - Other features/areas this depends on

---

### Step 4: STATE What You Read

Before proposing changes, confirm:

```markdown
**FILES READ**:
- Issue #{number}: [title] (or: User-reported: [summary])
- `ARCHITECTURE.md`
- `lib/manifests/{feature}.manifest.generated.json`
- [any other relevant files]

**FROM MANIFEST**:
- Relevant views: [list]
- Relevant controllers: [list]
- Relevant routes: [list]
- Dependencies: [list]
```

---

### Step 5: Analyze and Plan (By Tier)

- **Tier 1:** No written plan; proceed to investigate and fix once the change is clear.
- **Tier 2:** State a brief plan (which files, what change), then investigate and implement. No mandatory wait.
- **Tier 3:** State full plan (root cause hypothesis, files to change, risk), then **WAIT for explicit approval** before implementing.

---

### Step 6: Investigate & Implement

Search the codebase based on manifest information:

- Check relevant views and controllers from manifest
- Follow dependency chain if needed
- Look for similar patterns in other features
- Check error handling in repositories
- Review API endpoint usage from manifest

**DIRECT IMPORT RULES (Critical):**

```dart
// CORRECT - direct absolute import
import 'package:riverpod_template/presentation/login/login_view.dart';
import 'package:riverpod_template/data/repositories/auth_repository/auth_repository.dart';

// WRONG - relative import (prohibited)
import '../login/login_view.dart';
import '../../data/repositories/auth_repository/auth_repository.dart';
```

**NEVER rules to follow:**

- NEVER use relative imports (always use absolute `package:riverpod_template/...`)
- NEVER use `dynamic` type
- NEVER skip try-catch on async operations
- NEVER put logic in view widgets (views: UI only, controllers: logic)
- NEVER use private `_build` methods (extract to separate widget class)
- NEVER edit generated files (`*.g.dart`, `*.freezed.dart`)

**Route Updates (if needed):**

- Add route constant in `lib/core/routing/app_route.dart`: `static const String {routeName} = '{routeName}';`
- Add route definition in `lib/core/routing/router.dart`: `GoRoute(name: AppRoute.{routeName}, path: '/${AppRoute.{routeName}}', ...)`

**File Size Guidelines (not strict limits):**

- Views: Aim for ≤250 lines (extract widgets if larger)
- Controllers: Aim for ≤150 lines (extract methods if larger)
- Repositories: Aim for ≤200 lines
- Widgets/Models: Aim for ≤100 lines

---

### Step 7: Code Generation (if needed)

If `@riverpod`, `@freezed`, or `@JsonSerializable` changed:

```bash
dart run build_runner build -d
```

---

### Step 8: Anti-Drift Checklist

Before completing, verify you did NOT:

- [ ] Add error handling beyond what was asked
- [ ] Handle edge cases not mentioned in the issue
- [ ] Create new files without listing them in plan
- [ ] Add TODO/FIXME comments
- [ ] Suggest "next steps" or improvements
- [ ] Rename variables for "clarity" without being asked

**If any checked, UNDO that change.**

---

### Step 9: Tests

**Check manifest's `testing.hasTests` to see if the feature has tests.**

#### If feature HAS tests (`hasTests: true`):

Run feature-specific tests BEFORE and AFTER your fix:

```bash
flutter test test/presentation/{feature}/
```

If tests fail after your fix:

1. Determine if test failure indicates a bug in your fix → Fix the bug
2. Or if behavior intentionally changed → Update the tests
3. Never commit with failing tests

#### If feature has NO tests (`hasTests: false`):

**Ask the user:**

```
"This feature doesn't have tests. Would you like to add tests for the fixed functionality?"

- **Yes, add tests** - Create test for the bug fix to prevent regression
- **Yes, add full P0 tests** - Create complete controller test suite
- **No, skip tests** - Not recommended, bug could regress
```

If user wants tests, reference `login` (or `sign_up`) testing patterns:

- `test/test_data/auth_test_data.dart`
- `test/presentation/login/mocks/mock_auth_repository.dart`
- `test/presentation/login/login_controller_test.dart`

---

### Step 10: Verify

```bash
flutter analyze && flutter test
```

If failures occur, apply Self-Correction Protocol (max 3 attempts):

1. Read error output carefully
2. Identify root cause
3. Apply minimal fix following existing patterns
4. Re-run verification

---

### Step 11: Report (Tier-Appropriate Format)

**Tier 1:**

```markdown
**SCOPE**: Fix [brief description] (#{number} or user-reported)
**FILES READ**: [list]
**CHANGES**: [code blocks]
**TESTING**: Feature tests passing ✓ / No tests (offered to add)
**VERIFIED**: analyze ✓ test ✓
```

**Tier 2:**

```markdown
**SCOPE**: Fix [brief description] (#{number} or user-reported)
**PLAN** (X files, ~Y lines):
1. [file] - [change]
**FILES READ**: [list]
**CHANGES**: [code blocks]
**TESTING**:
- Feature had tests: Yes/No
- Tests passing: ✅ / N/A
- Tests added: [list or "user declined"]
**VERIFIED**: analyze ✓ test ✓
```

**Tier 3:**

```markdown
**SCOPE**: Fix [brief description] (#{number} or user-reported)
**PLAN** (X files, ~Y lines):
1. [file] - [change]
2. [file] - [change]
...
**FILES READ**: [list]
**TESTING PLAN**: [tests to run/add after fix]
**WAITING FOR APPROVAL** before implementation
```

---

### Step 12: Regenerate Manifests (if structure changed)

If you added/modified views, controllers, routes, or repositories:

```bash
dart run scripts/generate_feature_manifests.dart
```

---

### Step 13: Create PR (Optional)

If user wants to create a PR, use `gh pr create` from the project root (current repo), or generate a PR description and let the user run the command.
