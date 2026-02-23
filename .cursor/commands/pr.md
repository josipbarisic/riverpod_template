---
description: Create a pull request description
---

## Create Pull Request Description

### Step 1: Gather Context

```bash
# Current branch
git branch --show-current

# Commits in this branch (adjust base branch as needed)
git log origin/main..HEAD --oneline

# Changed files
git diff --name-status origin/main..HEAD

# File count
git diff --name-only origin/main..HEAD | wc -l
```

### Step 2: Analyze Changes

**Extract:**

- Number of commits
- Files changed (count and types)
- Feature areas affected (from file paths: `lib/presentation/{feature}/`)
- Breaking changes (if any)

### Step 3: Check for Related Issues

```bash
# Check commit messages for issue references
git log origin/main..HEAD --pretty=format:"%s" | grep -iE "(fix|close|resolve|#[0-9]+)"
```

**If GitHub CLI available:**

```bash
gh issue list --state open --limit 10
```

### Step 4: Generate PR Description

**Template:**

```markdown
## Description

{Clear, concise description of what this PR does}

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Refactor
- [ ] Documentation
- [ ] Style/formatting
- [ ] Performance
- [ ] Tests

## Changes Made

- {Change 1}
- {Change 2}
- {Change 3}

## Affected Areas

- `lib/presentation/{feature}/` — {description}
- `lib/data/repositories/{repo}/` — {description}

## Testing

- [ ] Manual testing completed
- [ ] Unit tests added/updated
- [ ] All tests passing: `flutter test`

## Screenshots/Videos (if applicable)

{Add screenshots or videos if UI changes}

## Related Issues

- Closes #{issue-number}
- Related to #{issue-number}

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] Branch is up-to-date with base
```

### Step 5: Fill Template

**From analysis:**

- **Description**: Summarize main purpose
- **Type**: Select appropriate checkboxes
- **Changes**: List key changes from commit messages
- **Affected Areas**: From file paths analysis
- **Testing**: Ask user about testing status
- **Related Issues**: From commit message analysis

### Step 6: Review with User

**Present PR description and ask:**

- Any additional context needed?
- Any related issues to link?
- Screenshots/videos to add?

### Step 7: Create PR (Optional)

**If user wants to create PR immediately:**

```bash
gh pr create --title "{PR Title}" --body-file /dev/stdin --base main <<'EOF'
{paste generated description}
EOF
```

**Or provide instructions:**

```markdown
## To Create PR:

1. Copy the PR description above
2. Push branch: `git push -u origin {branch-name}`
3. Open PR on GitHub
4. Paste description
5. Add reviewers
6. Submit
```

---

## Notes

- **Base branch**: Usually `main` (adjust per project workflow)
- **PR title**: Clear and concise (max 72 chars)
- **Description**: Explain WHAT and WHY, not HOW (code shows how)
- **Always link issues**: If PR closes/fixes an issue, use "Closes #123"
