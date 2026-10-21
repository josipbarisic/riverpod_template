---
name: plan-issues
description: Turn an idea or feature request into reviewed GitHub issues on this repository's project — grounding, a short PRD, one adversarial challenge, an exact preview, one approval, then creation and read-back. Use when the user asks to plan work, break a feature into issues, or file tickets.
---

# Plan Issues

Root `AGENTS.md` § Work tracking owns statuses, labels, the leaf rule and linking. Nothing is
written to GitHub before the user approves the exact preview.

## 1. Ground

Read root `AGENTS.md`, `ARCHITECTURE.md`, `lib/AGENTS.md`, the regenerated manifest of every
feature the idea touches, and the live source behind it. Search for duplicates before proposing:

```bash
gh issue list --state all --search "<keywords>" --limit 20
```

An existing issue that already covers part of the idea is reused or updated, never duplicated.

## 2. Draft the PRD

Agree with the user, in chat, on: the problem, who has it, the user-visible outcome, acceptance
criteria a reviewer can check without reading code, what is out of scope, and a collapsed
technical approach. Keep the two layers apart: criteria say what and why, the approach says how.

## 3. Challenge it once

Argue against the draft once: a criterion nobody can verify, a hidden dependency, scope that
does not serve the outcome, a simpler cut. Revise once, then stop arguing.

## 4. Preview exactly what will be created

Show one preview, in chat, that lists everything the next step writes:

- an optional milestone (title, due date) when the work ships as one release;
- each issue: title (business-first, `{Verb} {what} {where}`, 40–80 characters), one `type:*`
  label, Priority `P0`–`P2`, Size `XS`–`XL`, and the full body with the headings its type
  requires (`TYPES` in `scripts/project/project.mjs`);
- parent/sub-issue structure, only when children must roll up into one outcome. A parent is
  never executable; its children are;
- "blocked by" edges, only where work genuinely cannot start first.

Order issues so blocked work comes after what blocks it. Ask for approval of this exact preview.
Any change after approval needs a fresh preview and a fresh approval.

## 5. Create and read back

After approval, for each issue in preview order (write each body to a temp file first):

```bash
gh issue create --title "<title>" --label "<type:...>" --body-file <file> [--milestone "<m>"] [--parent <n>]
node scripts/project/project.mjs status <n> Backlog
gh project item-edit <number> --owner <owner> --url <issue-url> --field Priority --value P1
gh project item-edit <number> --owner <owner> --url <issue-url> --field Size --value M
gh issue edit <n> --add-blocked-by <m>
```

`<number>` and `<owner>` come from `.github/project.json`. Then read every issue back
(`gh issue view <n> --json title,labels,body,milestone` and `project.mjs check <n>` for leaves) and
report any mismatch instead of declaring success. Move issues to `Ready` only when the user says
they are next. Finish with the list of created issue numbers; do not start implementation.
