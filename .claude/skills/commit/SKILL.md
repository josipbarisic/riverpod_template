---
name: commit
description: Commit the current work safely with untracked-file confirmation, secret scanning, repository checks, and the project's generic prefix message format. Use when the user asks to commit, save, finalize, or push changes.
---

# Commit

Use this workflow only after explicit commit intent. Root `AGENTS.md`, the
canonical `.claude/rules/*.md`, and the user's scope remain authoritative.

## 1. Inspect before staging

From the repository root, inspect:

```bash
git status --short
git diff
git diff --cached
git log -5 --oneline
```

List every untracked file. Ask which untracked files to include unless the user
already named them. Never use `git add .` or `git add -A` blindly, and never
stage credentials, `.env`, signing material, keystores, or provisioning files.

## 2. Choose one coherent intent

Use the generic format owned by
`.claude/rules/commit-intent-routing.md`:

```text
Prefix: Short description
```

Keep the subject at most 72 characters. Use one of `Add:`, `Update:`, `Fix:`,
`Remove:`, `Refactor:`, `Style:`, `Docs:`, `Chore:`, `Test:`, or an explicitly
requested `WiP:`. Split unrelated intents only with the user's agreement.

## 3. Verify in proportion to the change

Follow root `AGENTS.md`. Before any Dart or Flutter command, run this discovery
from the repository root without executing FVM:

```bash
command -v fvm
```

If found, prefix the documented bare commands with `fvm`; otherwise run them
as written. Do not install, initialize, or change FVM. Documentation-only and
instruction-only commits do not require Flutter tests.

Stop on a failing required check. Do not weaken tests or validation to make the
commit pass.

## 4. Stage exact paths and scan

Stage only confirmed paths, then inspect the staged patch:

```bash
git add -- <confirmed-paths>
git diff --cached --check
git diff --cached
```

Scan staged filenames and content for credentials and private material. Treat
matches as candidates and inspect them; block the commit when the staged patch
contains a real secret.

Validate the message and committed text against the machine-readable policy in
`.claude/rules/no-tool-attribution.md`. That rule owns the pattern list; do not
duplicate it here.

## 5. Commit and verify

Pass the message through a heredoc:

```bash
git commit -m "$(cat <<'EOF'
Prefix: Short description
EOF
)"
git status --short
```

Report the commit hash, message, included paths, checks run, and whether the
branch remains ahead or dirty.

Push only when explicitly requested. Never force-push a protected branch.
