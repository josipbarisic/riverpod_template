# Cursor Commands Cheat Sheet

Quick reference for when to use each Cursor command (Riverpod Template).

---

## Getting Started

| Command                 | When to Use                                        |
|-------------------------|----------------------------------------------------|
| `/branch`               | Starting new work – create a feature/fix branch   |
| `/regenerate-manifests` | Before/after structural changes (routes, features) |

---

## Bug Fixing

| Command         | When to Use                    |
|-----------------|--------------------------------|
| `/fix-bug`      | Fixing any bug in the codebase  |
| `/fix-gh-issue` | Fixing a specific GitHub issue |
| `/mobile-issue` | Debugging mobile-specific issues |

---

## Adding Features

| Command         | When to Use                 |
|-----------------|-----------------------------|
| `/add-feature`  | Adding new screens/features |
| `/refine-feature` | Refining an existing feature (violations, integrations) |
| `/update-route` | Adding or modifying a route |

---

## Testing

| Command | When to Use                              |
|---------|------------------------------------------|
| `/test` | Creating tests (unit/widget/integration) |
| `/tdd`  | Following Test-Driven Development        |

---

## Code Maintenance

| Command  | When to Use                          |
|----------|--------------------------------------|
| `/grind` | Making same change across many files |

---

## Code Quality

| Command   | When to Use                          |
|-----------|--------------------------------------|
| `/review` | Before committing – check for issues |
| `/commit` | Creating secure, atomic commits      |

---

## Collaboration

| Command | When to Use                       |
|---------|-----------------------------------|
| `/pr`   | Creating pull request description |

---

## Discovery & Analysis

| Command   | When to Use                                  |
|-----------|----------------------------------------------|
| `/analyse` | Analyse a feature (manifest-based report)   |
| `/enhance-prompt` | Enhance a prompt with context and structure |
| `/remove` | Remove feature/widget/file and all references (impact analysis) |

---

## Quick Decision Tree

```
Starting new work?
├─ New feature? → /add-feature
├─ Bug fix? → /fix-bug
└─ Need branch? → /branch

Found a bug?
├─ Has GitHub issue? → /fix-gh-issue [number]
├─ Mobile-specific? → /mobile-issue
└─ General bug? → /fix-bug

Before committing?
├─ Check code quality → /review
└─ Create commit → /commit

Need tests?
├─ TDD approach? → /tdd
└─ Add tests? → /test

Batch operations?
└─ Same change in many files? → /grind

Creating PR?
└─ Generate description → /pr
```

---

## Related Documentation

- **Full command details:** `.cursor/commands/README.md`
- **Architecture:** `ARCHITECTURE.md` (if present) or `lib/AGENTS.md`
- **AI agent guide:** `lib/AGENTS.md`
- **Complexity scale:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`
