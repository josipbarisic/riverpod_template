---
name: git-commit
description: Create well-formatted git commits with conventional or prefix-style messages, security scanning, test validation, and optional push. Use when the user says "commit", "commit this", "push", "save changes", or "commit and push".
---

# Git Commit Skill

## When This Skill Activates

Trigger phrases:

- "commit"
- "commit this"
- "commit and push"
- "push to remote"
- "save these changes"
- "create a commit"

## Commit Message Format

Use either **Prefix format** or **conventional** `type(scope): description`.

### Prefix Format (recommended)

```
Prefix: Short description
```

**Rules:**

1. Subject line: max 72 characters
2. Prefix: one of the allowed prefixes (capitalized)
3. Description: concise, capitalized, no period at end

**Allowed Prefixes:**

| Prefix      | When to Use                          | Example                             |
|-------------|--------------------------------------|-------------------------------------|
| `Add:`      | New feature, file, or capability     | `Add: User profile screen`          |
| `Update:`   | Modify existing functionality        | `Update: Home view layout`          |
| `Fix:`      | Bug fix                              | `Fix: Null check on empty list`     |
| `Remove:`   | Delete feature, file, or code        | `Remove: Deprecated auth flow`      |
| `Refactor:` | Code restructure, no behavior change | `Refactor: Extract form widgets`    |
| `Style:`    | UI/styling only                      | `Style: Card shadows and spacing`   |
| `Docs:`     | Documentation changes                | `Docs: Update README`               |
| `WiP:`      | Work in progress (incomplete)        | `WiP: Onboarding flow`             |
| `Chore:`    | Maintenance, deps, config            | `Chore: Regenerate manifests`       |
| `Test:`     | Adding/updating tests                | `Test: Auth controller coverage`    |

### Conventional Format

```
type(scope): description
```

Examples: `feat(auth): add login screen`, `fix(home): crash on load`, `chore(manifests): regenerate`.

### Good Examples

```
Add: Login screen with validation
Update: Profile view styling
Fix: Token refresh on 401 response
Refactor: Extract date picker widget
Chore: Regenerate feature manifests
Test: Home controller unit tests
```

### Bad Examples

```
Updated files                    # No prefix, too vague
fixed the bug                    # Lowercase, no prefix
WIP                              # No description
Add: Added new feature           # Redundant "Added"
```

## Workflow

### Step 0: Run Tests (MANDATORY)

**Before any commit, run the test suite:**

```bash
flutter test
```

**If tests fail:**

```markdown
**COMMIT BLOCKED — TESTS FAILING**

Found failing tests:
- {test file}: {failure description}

**Required Actions:**
1. Fix the failing tests
2. If you modified a model, update its test in `test/models/`
3. If you modified a repository, update its test in `test/repositories/`
4. If you modified a controller, update its test in `test/presentation/`
5. Re-run `flutter test` until all pass
```

**Test update guidelines:**

| Changed File | Update Test In |
|--------------|----------------|
| `lib/models/*.dart` | `test/models/*_test.dart` |
| `lib/data/repositories/**/*.dart` | `test/repositories/*_test.dart` |
| `lib/presentation/**/*_controller.dart` | `test/presentation/**/*_controller_test.dart` |

### Step 1: Analyze Changes

```bash
git status
git diff --staged --stat
git diff --stat
git log --oneline -5
```

### Step 2: Untracked Files — Confirm Before Adding

If there are untracked files, list them and ask: add all / only some / none. Do not run `git add -A` or `git add .` until the user confirms.

### Step 3: Security Scan (CRITICAL)

**BLOCK commit if found in staged content:**

```bash
git diff --staged | grep -iE "(API_KEY|SECRET|PASSWORD|TOKEN|PRIVATE_KEY|sk-|sk_live)" && echo "SECRETS DETECTED" || echo "No secrets"
```

**Forbidden:** API_KEY, SECRET, PASSWORD, private keys, `.env` files, signing keys.

**If secrets found:**

```markdown
**SECURITY ALERT — COMMIT BLOCKED**

Found sensitive data in staged changes:
- {file}: {pattern found}

**Action Required:**
1. Remove the secret from the file
2. If already committed elsewhere, rotate the credential immediately
3. Add file to `.gitignore` if it should never be committed
4. Use environment variables or secure storage instead
```

### Step 4: Determine Commit Strategy

If there are multiple logical changes, ask whether to create separate commits for atomic history.

```markdown
I see changes to:
- {Area 1} ({N} files)
- {Area 2} ({N} files)

Should I create separate commits for atomic history?
```

### Step 5: Generate Message

Choose prefix or conventional form, derive scope from paths (e.g. `lib/presentation/{feature}/`), write a short description.

### Step 6: Execute Commit

Use only the paths the user confirmed. Use heredoc for multi-line messages:

```bash
git add [paths]
git commit -m "$(cat <<'EOF'
Prefix: Short description

Optional body explaining why (wrap at 72 chars).
EOF
)"
```

**Multiple atomic commits:**

```bash
git add lib/presentation/feature1/
git commit -m "Add: Feature one screen"

git add lib/presentation/feature2/
git commit -m "Fix: Feature two null check"
```

### Step 7: Push (if requested)

Only push if the user explicitly asked. Verify before pushing:

- [ ] Branch name is correct
- [ ] Not pushing to main/master directly
- [ ] All commits have proper messages

```bash
git push -u origin HEAD
```

### Step 8: Confirmation

```markdown
**Commit Created**

- **Hash**: `abc1234`
- **Message**: `Add: User profile screen`
- **Files**: 5 files changed, +120 -45
- **Tests**: All tests passing
- **Security**: No secrets detected
- **Pushed**: Yes/No
```

## Do NOT Commit

- `.env` files
- `*.keystore`, `*.jks`, `*.p12`, `*.mobileprovision`
- Any file listed in `.gitignore`
- Generated files (`*.g.dart`, `*.freezed.dart`) unless intentionally tracked

## Quick Reference

| Rule | Value |
|------|-------|
| Subject line max | 72 chars |
| Body line max | 72 chars |
| Format | `Prefix: Description` or `type(scope): description` |
| One commit = | One logical change |

**Common scopes:** `auth`, `home`, `profile`, `core`, `routing`, `theme`, `data`, `models`, `onboarding`
