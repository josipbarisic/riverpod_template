# Cursor Commands Cheat Sheet

Quick reference for when to use each Cursor command (Riverpod Template). **9 core commands** + `/start-new-project`.

---

## Core (Daily Use)

| Command           | When to Use                                      |
|-------------------|--------------------------------------------------|
| `/fix`            | Fix any issue — GitHub issue #, URL, or describe the bug |
| `/add-feature`    | Add new screens/features (complexity + dev approach)     |
| `/refine-feature` | Refine existing feature (violations, integrations)       |
| `/commit`         | Pre-commit review + secure, atomic commit                 |
| `/analyse`        | Analyse a feature (manifest-based report)                |

---

## Specialized

| Command   | When to Use                                              |
|-----------|----------------------------------------------------------|
| `/test`   | Create tests (unit/widget/integration); Standard or TDD mode |
| `/remove` | Remove feature/widget/file and all references (impact analysis) |

---

## Meta / Learning

| Command            | When to Use                                  |
|--------------------|----------------------------------------------|
| `/enhance-prompt`  | Enhance a prompt with context and structure  |
| `/review-learnings`| Review learning log (heatmap, themes, gaps)  |

---

## Template-Only

| Command             | When to Use                          |
|---------------------|--------------------------------------|
| `/start-new-project`| Initialize a new project from template |

---

## Quick Decision Tree

```
Starting new work?
├─ New feature? → /add-feature
└─ Bug fix or issue? → /fix

Found a bug?
├─ Has GitHub issue? → /fix #123 or /fix https://...
└─ Describe it → /fix

Before committing?
└─ Review + commit → /commit

Need tests?
├─ TDD approach? → /test (choose TDD mode)
└─ Add tests? → /test (Standard mode)

Review what you've learned?
└─ /review-learnings
```

---

## Related Documentation

- **Full command details:** `.cursor/commands/README.md`
- **Architecture:** `ARCHITECTURE.md` (if present) or `lib/AGENTS.md`
- **AI agent guide:** `lib/AGENTS.md`
- **Complexity scale:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`
- **Learning log:** `.cursor/docs/LEARNING_LOG.md`
