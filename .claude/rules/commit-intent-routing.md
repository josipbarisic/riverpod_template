---
paths:
  - "lib/**"
  - "test/**"
  - "scripts/**"
  - "android/**"
  - "ios/**"
  - "linux/**"
  - "macos/**"
  - "web/**"
  - "windows/**"
  - "docs/**"
  - ".github/**"
  - ".claude/**"
  - "*.md"
  - "*.yaml"
  - "*.yml"
  - "pubspec.lock"
---

# Commit Intent Routing

When the user says `commit`, `commit this`, `commit and push`, `push this`, `save changes`,
`save this`, `finalize changes`, or otherwise asks to record the work in Git, run the local
`.claude/skills/commit/SKILL.md` workflow. It is named `commit` so a personal `git-commit` skill
cannot shadow it. Do not replace it with a shortened direct commit.

The skill owns status inspection, untracked-file confirmation, secret scanning, verification,
staging, commit execution, and optional push. `AGENTS.md` and canonical rules remain authoritative
when skill text disagrees.

## Commit message format

Use:

```text
Prefix: Short description
```

Keep the subject at most 72 characters, capitalize the prefix and description, omit the trailing
period, and include no tool attribution or assistant trailers. A commit for a tracked issue ends
its subject with `(#<n>)`.

| Prefix | Use |
|---|---|
| `Add:` | New feature, file, or capability |
| `Update:` | Changed existing behavior or configuration |
| `Fix:` | Bug fix |
| `Remove:` | Deleted feature, file, or code |
| `Refactor:` | Restructure without behavior change |
| `Style:` | Presentation-only change |
| `Docs:` | Documentation or instruction change |
| `Chore:` | Maintenance, dependencies, generated artifacts, or configuration |
| `Test:` | Test additions or changes |
| `WiP:` | Explicitly requested incomplete checkpoint |

One commit contains one coherent intent. Push only when the user explicitly requests it.
