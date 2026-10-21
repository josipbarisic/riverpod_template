---
name: post-task-learning
description: Record a trap from the Supervisor's Briefing in docs/LEARNING_LOG.md — a failure mechanism that a later edit of the same files would hit again and that no test, rule or code comment now prevents. Use when the post-task-learning rule calls for it, or when the user says "log this", "save learning", or "add to learning log".
---

# Post-Task Learning (Traps)

This skill is the only writer to `docs/LEARNING_LOG.md`. The log holds traps only, so most tasks
write nothing. The briefing shape and when this skill runs live in
`.claude/rules/post-task-learning.md`.

## 1. Is it a trap?

Read the briefing's **Cause** and **Fix**. Write an entry only when all three hold:

1. **It will recur.** Someone editing the same files later would hit the same failure.
2. **It is not obvious from the code.** The mechanism is a framework internal, a hidden coupling, a
   wrong-looking-but-correct choice, or a test that looks like it proves something it does not.
3. **Nothing else captures it.** No test fails on it, no `.claude/rules` file states it, and no code
   comment at the spot explains it.

When the lesson can be enforced or stated as a rule, put it there instead and stop:

- a check or test, if it can be made mechanical;
- the `.claude/rules/*.md` file whose `paths:` cover those files, if it is a standing rule;
- a code comment at the spot, if it explains one place.

Say in the task report where it went. Task narration, design decisions and preferences are never
entries.

## 2. Check what the log already says

Search by the paths the trap applies to instead of reading the log:

```bash
rg -n '<path or feature directory>' docs/LEARNING_LOG.md
```

If an entry already covers the same mechanism, extend it with what is new, or skip when nothing is.

## 3. Write the entry

Add it to the top of the closest category section:

```markdown
- **[YYYY-MM-DD]** {symptom} — {mechanism}. Guard: {what now prevents it, or what to do}.
  - *Paths: `{path}`, `{path}` · Context: {short task name}*
```

The `Paths:` line is required: agents find entries by searching for the file they are about to
edit. Name the field, caller, flag or API that does the damage, at the same density as the
briefing's Cause.

## 4. Confirm

One line per entry, or one line saying nothing was logged and why:

```
Logged to LEARNING_LOG.md: "Profile keeps the previous account after sign-out" → Riverpod
```

Categories, in order: Architecture, Riverpod, Dart, Flutter, Navigation, API & Data, Testing,
Tooling, Debugging, Performance. Do not add or reorder sections.
