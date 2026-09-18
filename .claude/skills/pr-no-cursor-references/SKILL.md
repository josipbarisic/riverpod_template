---
name: pr-no-cursor-references
description: Apply the repository's no-tool-attribution policy when drafting or validating pull-request, review, commit, or committed documentation text.
---

# Delivery Text Attribution Check

This compatibility-named workflow defers completely to
`.claude/rules/no-tool-attribution.md`. That rule owns the policy and the
machine-readable patterns; do not maintain a second phrase list here.

## Workflow

1. Draft the title, body, comment, review, commit message, or documentation
   around behavior and code.
2. Read the current attribution-pattern block from
   `.claude/rules/no-tool-attribution.md`.
3. Validate the exact final text against that block before submission.
4. Rewrite every matching authorship claim or generated footer.
5. After creating external delivery text, read it back and validate the live
   value before reporting success.

Use heredocs for multi-line Git and GitHub text so the submitted value matches
the reviewed value. Follow `.claude/skills/git-commit/SKILL.md` for commits.

If a published pull-request field violates the rule, edit and re-check it
immediately. Rewriting commit history or force-pushing still requires explicit
user approval and the Git safety rules in root `AGENTS.md`.
