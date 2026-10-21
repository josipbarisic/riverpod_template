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

# No Tool Attribution

Do not attribute commits, pull requests, reviews, code comments, documentation, or committed
generated artifacts to editors, assistants, LLMs, or generation tooling. Technical references to
a tool or product are allowed; authorship claims, generation footers, session trailers, and
assistant co-authors are forbidden.

CI attribution validation must consume this machine-readable POSIX extended regular-expression
block instead of hardcoding a second list. Keep one pattern per line, with no blank pattern lines.

```attribution-pattern
(made|generated|created|written|authored|assisted|powered|built|coded|drafted|developed)[[:space:]]+(by|with|via|using)[[:space:]]+.*(cursor|claude|gpt(-[0-9]+)?|copilot|ai assistant|llm)
cursor[[:space:]]+ai
co-authored-by:.*(cursor|claude|gpt(-[0-9]+)?|copilot|ai assistant|llm|\[bot\])
🤖[[:space:]]*generated[[:space:]]+with
generated[[:space:]]+automatically
claude-session:
```

Correct published attribution immediately. Editing delivery text is reversible; rewriting or
force-pushing commit history requires explicit user approval.
