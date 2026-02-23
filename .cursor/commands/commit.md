---
description: Create secure, atomic commits with security scanning
---

## Secure Commit

Ensure commits are atomic, well-described, and **security-safe**.

### Step 1: Check Changed Files

```bash
git status
git diff --staged --name-only
git diff --name-only
```

### Step 1b: Untracked Files — ALWAYS CONFIRM Before Adding

**If `git status` shows any untracked (non-added) files:**

1. **List them** explicitly in your response, e.g.:
   ```markdown
   **Untracked files:** `.cursor/commands/remove.md`, `lib/other_new_file.dart`
   ```
2. **Ask the user** before staging or committing:
   - "Do you want to add **all** of these to this commit?"
   - "Or **only some**? (Tell me which paths to add.)"
   - "Or **none**? (I'll commit only already-staged and modified files.)"
3. **Do not** run `git add -A` or `git add .` when untracked files exist until the user has confirmed (e.g. "yes add all", "add remove.md and README.md", "no don't add any").
4. If the user says "add all" or lists specific files to add, then run `git add <paths>` accordingly and proceed. If "none", proceed with only currently staged/modified files.

**If there are no untracked files,** you may stage changed files as needed and proceed to Step 2.

### Step 2: SECURITY SCAN (CRITICAL)

**BLOCK the commit if ANY of these are found:**

#### Forbidden Files (NEVER commit):

- `.env`, `.env.local`, `.env.production`
- `*.keystore`, `*.jks` (Android signing keys)
- `*.p12`, `*.mobileprovision` (iOS signing)
- Any file in `.gitignore` that got staged

#### Forbidden Patterns in Content:

Scan staged files for these patterns — **ABORT if found**:

- `API_KEY=`, `APIKEY=`, `api_key:`
- `SECRET=`, `SECRET_KEY=`
- `client_secret`
- `FIREBASE_.*=` (with actual values)
- `-----BEGIN RSA PRIVATE KEY-----`
- `sk-` (OpenAI keys), `sk_live_`, `sk_test_` (Stripe keys)
- Hardcoded URLs with credentials: `https://user:pass@`

```bash
git diff --staged | grep -iE "(API_KEY|SECRET|client_secret|FIREBASE_|PRIVATE_KEY|sk-|sk_live|sk_test)" && echo "SECURITY ALERT" && exit 1
```

**If security issues found:**

```markdown
**SECURITY ALERT — COMMIT BLOCKED**

Found sensitive data in staged changes:
- [file]: [pattern found]

**Action Required:**
1. Remove sensitive data from the file
2. If already committed elsewhere, rotate the credential immediately
3. Add file to `.gitignore` if it should never be committed
4. Use environment variables or secure storage instead
```

### Step 3: Analyze Changes for Commit Message

Group changes by type. You may use either:

- **Conventional:** `feat`, `fix`, `refactor`, `test`, `style`, `chore`, `docs` → `type(scope): description`
- **Prefix format:** `Add:`, `Update:`, `Fix:`, `Remove:`, `Refactor:`, `Style:`, `Docs:`, `Chore:`, `Test:`, `WiP:` → `Prefix: Short description` (max 72 chars, capitalize, no period at end)

Identify affected feature(s) from `lib/presentation/{feature}/`.

**If multiple logical changes exist:**
Ask user: "I see changes to [X] and [Y]. Should I commit these separately for atomic history?"

### Step 4: Write Atomic Commit

**Good examples:**

- `Add: User profile screen`
- `feat(auth): add login validation`
- `Fix: Null check on empty user list`
- `Refactor: Extract date picker widget`
- `Style: Card shadows and spacing`
- `Chore: Regenerate feature manifests`

**Bad examples:**

- `Updated stuff` (no prefix, vague)
- `fix: the bug in login` (lowercase, not descriptive)
- `WIP` (no description)

### Step 5: Execute Commit

**Staging:** If there were untracked files, use only the paths the user confirmed in Step 1b.
Otherwise you may use `git add -A` or `git add <paths>` for the files that belong to this commit.

**Single commit (use heredoc for multi-line messages):**

```bash
git add [paths or -A if no untracked files / user confirmed]
git commit -m "$(cat <<'EOF'
Prefix: Short description

Optional body with more context.
EOF
)"
```

**Multiple atomic commits:**

```bash
git add [specific files]
git commit -m "Prefix: First logical change"
git add [other files]
git commit -m "Prefix: Second logical change"
```

### Step 6: Confirm Success

```markdown
**Commit Created**
- Hash: [short hash]
- Message: `Prefix: Description`
- Files: [count] files changed
- Security: No secrets detected
```

---

## Do NOT Commit

These files should never be committed:

- `.env`, `.env.*`
- `*.keystore`, `*.jks`, `*.p12`, `*.mobileprovision`
- Files in `.gitignore`
- Generated files (`*.g.dart`, `*.freezed.dart`) unless intentionally tracked

## Quick Reference

| Rule | Value |
|------|-------|
| Subject line max | 72 chars |
| Body line max | 72 chars |
| Format | `Prefix: Description` or `type(scope): description` |
| One commit = | One logical change |

**Common scopes:** `auth`, `home`, `profile`, `core`, `routing`, `theme`, `data`, `models`, `onboarding`
