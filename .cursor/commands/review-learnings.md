---
description: Review accumulated learning notes, identify patterns and gaps, suggest focus areas
---

## Review Learnings

Read `docs/LEARNING_LOG.md` and produce a read-only review. The log is written
only by `.claude/skills/post-task-learning/SKILL.md`; this command never edits,
deduplicates, or prunes it.

## 1. Validate the entries

Entries should capture transferable Cause and Fix mechanisms from the
Issue/Impact/Cause/Fix Supervisor's Briefing in
`.claude/rules/post-task-learning.md`. Distinguish real reusable mechanisms
from task-specific symptoms and flag shallow entries without rewriting them.

## 2. Review the log

Report:

- entry count by category
- three to five recurring mechanisms, when present
- near-duplicates and contradictory guidance
- categories with little or no evidence
- the strongest transferable entries
- two or three concrete focus areas for future work

If fewer than five entries exist, keep the review brief. Do not infer a skill
gap from an empty category without supporting work history.

## 3. Optional follow-up

Offer a focused category review or a separate cleanup proposal. Any log edit
must happen through the canonical post-task-learning skill and requires the
user to request it.
