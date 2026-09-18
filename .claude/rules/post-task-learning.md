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

# Post-Task Learning

After any implementation task, append a `Supervisor's Briefing` to the task report.

| Tier | Briefing | Persistence |
|---|---|---|
| Tier 3 | Required | Persist every distinct transferable insight |
| Tier 2 | Required | Persist every distinct transferable insight |
| Tier 1 | Required | Persist when Cause or Fix contains a transferable insight |

For a mechanical Tier 1 change with nothing transferable, write one sentence saying so and skip
persistence. Do not invent a lesson.

## Supervisor's Briefing

Use exactly four bold labels, one short paragraph each:

- **Issue:** What the user, application, test, or tool actually observed.
- **Impact:** What behavior, delivery, or future maintenance was blocked.
- **Cause:** The mechanism: name the object, field, caller, lifecycle, or configuration that
  produced the issue.
- **Fix:** What changed, where, and what verification pins the behavior.

The briefing must stand alone for a developer who did not see the task. Keep framework vocabulary;
do not turn it into a tutorial, tagged pattern list, or investigation recap.

## Persistence

After a Tier 2 or Tier 3 briefing, and after a Tier 1 briefing with a transferable Cause or Fix,
invoke `.claude/skills/post-task-learning/SKILL.md`. That skill is the only writer to
`docs/LEARNING_LOG.md` and owns deduplication, category placement, metadata, and formatting.
