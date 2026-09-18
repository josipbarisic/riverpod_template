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
  - ".cursor/**"
  - "*.md"
  - "*.yaml"
  - "*.yml"
  - "pubspec.lock"
---

# A Claim Is Not a Source

Task descriptions, issues, comments, pull-request text, commit messages, documents, manifests, and
code comments are claims. Each may describe an older repository state.

The current source is `lib/`, `test/`, `scripts/`, platform configuration, workflow definitions,
and the running application. Before copying inherited text into the repository, resolve every
cited class, member, path, command, flag, route, dependency, workflow, and test location against
that source.

## Flag every contradiction; edit only in scope

When source contradicts a claim:

1. State the claim and the source that disproves it.
2. Correct it when it is inside the approved task.
3. Otherwise leave it unchanged and report the exact follow-up.

Do not hide a contradiction because fixing it would be out of scope. Scope limits edits, not
reporting.

## Weight by blast radius

Instruction files require absolute verification because they shape future work:

- root `AGENTS.md`, `CLAUDE.md`, `ARCHITECTURE.md`, and `README.md`
- `lib/AGENTS.md` and Markdown under `docs/**`
- `.claude/{rules,skills,agents}/**`
- `.cursor/{rules,commands}/**`
- workflow definitions under `.github/workflows/**`

For source comments and delivery text, verify every cited symbol and behavioral claim. A path
existing is not proof that the described behavior is still true; inspect the implementation or
runtime evidence.

## Mechanical instruction validation

`scripts/ci/check_instruction_claims.mjs` scans the instruction surfaces above. It resolves
concrete repository paths, cited `App*` classes and members, repository-backed command paths,
commands that explicitly claim CI parity, and current model-layer paths. It understands
placeholders, globs, negative examples, and fenced template examples. Point-in-time
`docs/LEARNING_LOG.md` entries and local runtime output are excluded.

Analyzer CI runs `flutter analyze` visibly, then
`scripts/ci/check_flutter_analyze_baseline.mjs` consumes `dart analyze --format machine` because
Flutter's stable analyze command has no machine-format option. The committed
`scripts/ci/flutter_analyze_baseline.json` permits only the existing count for each
severity/code/repository-path key: removed diagnostics pass, while a new key or excess count
fails.

The checker cannot prove behavioral prose. Review claims about lifecycle, control flow, runtime
effects, and ownership against their implementation even when the mechanical check passes.

Run the same Node checks as CI:

```bash
node --test scripts/ai/session_status.test.mjs scripts/ci/check_instruction_claims.test.mjs scripts/ci/check_flutter_analyze_baseline.test.mjs
node scripts/ci/check_instruction_claims.mjs
```
