---
description: Create a feature branch for new work
---

## Create Feature Branch

### Step 1: Determine Branch Type

Ask the user (if not clear):

- What type of work? (feature, fix, refactor, docs)
- Branch name preference?

### Step 2: Generate Branch Name

**Naming Convention:**

- **Feature**: `feature/{short-description}` (e.g., `feature/user-profile-settings`)
- **Bug fix**: `fix/{short-description}` (e.g., `fix/login-error-handling`)
- **Refactor**: `refactor/{short-description}` (e.g., `refactor/auth-controller`)
- **Docs**: `docs/{short-description}` (e.g., `docs/api-documentation`)

**Rules:**

- Use kebab-case (lowercase with hyphens)
- Keep it short but descriptive (max 50 chars)
- No special characters except hyphens

### Step 3: Check Current Branch

```bash
git branch --show-current
```

### Step 4: Ensure Clean Working Directory

```bash
git status
```

**If uncommitted changes:**

- Ask user: Commit, stash, or discard?
- **NEVER** create branch with uncommitted changes without user approval

### Step 5: Ensure Up-to-Date Base

```bash
git fetch origin
git status
```

**If behind:**

- Ask user: Pull latest changes first?
- **NEVER** create branch from outdated base without user approval

### Step 6: Create Branch

```bash
# From main (default) — adjust base branch to match your project workflow
git checkout main
git pull origin main
git checkout -b {branch-name}

# Or from specific branch (if user specified)
git checkout {base-branch}
git pull origin {base-branch}
git checkout -b {branch-name}
```

### Step 7: Verify

```bash
git branch --show-current
git log --oneline -1
```

**Confirm:**

- Branch name is correct
- Based on correct branch
- Up-to-date with remote

### Step 8: Inform User

```markdown
**Branch Created**: `{branch-name}`
**Based on**: `{base-branch}`
**Ready for**: {work description}
```

---

## Notes

- **Default base**: `main` branch (adjust per project workflow)
- **Always pull latest** before creating branch
- **Never create branch** with uncommitted changes without approval
- **Branch naming**: Follow convention (feature/fix/refactor/docs)
