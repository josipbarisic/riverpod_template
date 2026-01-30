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

### Step 1b: Untracked Files – ALWAYS CONFIRM Before Adding

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

**BLOCK the commit if found:**

- Staged: `.env`, `.env.local`, `*.keystore`, `*.jks`, `*.p12`, or any file in `.gitignore`
- Content: `API_KEY=`, `SECRET=`, `client_secret`, `FIREBASE_.*=`, `-----BEGIN RSA PRIVATE KEY-----`, `sk-`, `sk_live_`, `sk_test_`, credentials in URLs

```bash
git diff --staged | grep -iE "(API_KEY|SECRET|client_secret|FIREBASE_|PRIVATE_KEY|sk-|sk_live|sk_test)" && echo "SECURITY ALERT" && exit 1
```

If secrets found: report them, recommend removal/rotation, and do not commit.

### Step 3: Analyze Changes for Commit Message

Group by type. You may use either:

- **Conventional:** `feat`, `fix`, `refactor`, `test`, `style`, `chore`, `docs` → `type(scope): description`
- **Prefix format:** `Add:`, `Update:`, `Fix:`, `Remove:`, `Refactor:`, `Style:`, `Docs:`, `Chore:` → `Prefix: Short description` (max 72 chars, capitalize, no period at end)

Identify affected feature(s) from `lib/presentation/{feature}/`.

### Step 4: Write Atomic Commit

- One logical change per commit
- **Conventional:** `type(scope): description` (e.g. `feat(auth): add login screen`)
- **Prefix:** `Prefix: Description` (e.g. `Add: Login screen`, `Fix: Token refresh on 401`, `Chore: Regenerate feature manifests`)

### Step 5: Stage and Commit

**Staging:** If there were untracked files, use only the paths the user confirmed in Step 1b. Otherwise you may use `git add -A` or `git add <paths>` for the files that belong to this commit.

```bash
git add [paths or -A if no untracked files / user confirmed]
git commit -m "Prefix: Short description"
# or
git commit -m "type(scope): description"
```

### Success

Commit is atomic, conventional, and free of secrets.
