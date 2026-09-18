---
name: post-task-learning
description: Persist transferable Cause and Fix insights from the Supervisor's Briefing to docs/LEARNING_LOG.md. Use after implementation when the post-task-learning rule requires persistence, or when the user asks to save a learning.
---

# Post-Task Learning

This skill is the only writer to `docs/LEARNING_LOG.md`. The required
Issue/Impact/Cause/Fix briefing shape and tier policy live in
`.claude/rules/post-task-learning.md`. Root `AGENTS.md` remains authoritative
for task scope and instruction ownership.

## 1. Read and select

Read the current log. Extract transferable mechanisms from **Cause** and
**Fix**. Use **Impact** only when it carries a reusable delivery or maintenance
constraint. Do not persist **Issue** as a standalone symptom.

Skip an insight only when an existing entry has the same concept and the new
briefing adds no context, mechanism, pitfall, or verification detail. Merge
useful nuance into the existing entry instead of duplicating it.

## 2. Categorize

Choose exactly one existing category:

- Architecture
- Riverpod
- Dart
- Flutter
- Navigation
- API & Data
- Testing
- Tooling
- Debugging
- Performance

Do not create a new category during task persistence.

## 3. Write

Add the newest entry at the top of its category:

```markdown
- **[YYYY-MM-DD]** Concise title — Mechanism and reusable fix.
  - *Context: Short task name / Tier 1|2|3 / relevant/path.dart*
```

Include the tier and up to three relevant paths when known. Preserve useful
existing entries and category order.

`docs/LEARNING_LOG.md` must retain this structure:

```markdown
# Learning Log

> Accumulated transferable insights from implementation work.
> Read the matching category before similar work; use `/review-learnings` for a read-only review.

## Architecture
## Riverpod
## Dart
## Flutter
## Navigation
## API & Data
## Testing
## Tooling
## Debugging
## Performance
```

## 4. Confirm

Report each title and destination category in one line. If the briefing
contains no transferable insight under the rule, do not invent one and do not
edit the log.
