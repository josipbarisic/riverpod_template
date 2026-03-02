---
name: post-task-learning
description: Persist learning notes to the learning log after task completion. Use after any implementation task when the post-task-learning rule triggers, or when the user asks to "log this", "save learning", or "add to learning log".
---

# Post-Task Learning

Persist key insights from completed tasks to `.cursor/docs/LEARNING_LOG.md`.

## When This Skill Activates

- Automatically after the inline Supervisor's Briefing (triggered by the `post-task-learning` rule)
- Manually when the user says "log this learning" or similar

## Workflow

### Step 1: Read the Current Log

```bash
cat .cursor/docs/LEARNING_LOG.md
```

If the file doesn't exist, create it using the template in Step 4.

### Step 2: Select Items to Log

From the inline briefing, pick items that have **durable learning value** — things worth reviewing later. Skip items that are:

- Trivially obvious to a senior Flutter developer
- Hyper-specific to one file with no transferable insight
- Already logged (check existing entries to avoid duplicates)

Typically 1–3 items per task. Sometimes zero if the task was routine.

### Step 3: Categorize Each Item

Assign exactly one category:

| Category | What belongs here |
|----------|-------------------|
| `Architecture` | Layer decisions, separation of concerns, when to split files |
| `Riverpod` | Provider patterns, state management, ref usage, code-gen |
| `Dart` | Language features, null safety, generics, async patterns |
| `Flutter` | Widget lifecycle, rendering, platform-specific behavior |
| `Navigation` | GoRouter, route guards, deep linking, transitions |
| `API & Data` | Repository patterns, serialization, error handling, contracts |
| `Testing` | Test patterns, mocking, coverage, test architecture |
| `Tooling` | Build runner, CI/CD, analyzer, scripts |
| `Debugging` | Root cause analysis techniques, common failure patterns |
| `Performance` | Optimization patterns, rebuild prevention, lazy loading |

### Step 4: Append to Log

Append each item to the appropriate category section in `.cursor/docs/LEARNING_LOG.md`.

**Entry format:**

```markdown
- **[{date}]** {concise title} — {explanation, same depth rules as inline briefing}
  - *Context: {task/issue that triggered this, e.g. "Fix #42" or "Add profile screen"}*
```

**Date format:** `YYYY-MM-DD`

If the category section doesn't exist yet, create it following the file structure.

**Log file structure:**

```markdown
# Learning Log

> Accumulated insights from development sessions. Organized by category for review.
> Use `/review-learnings` to get a summary and identify gaps.

## Architecture

- **[2025-06-15]** Extract widgets over 250 lines — ...
  - *Context: Refine profile view*

## Riverpod

- **[2025-06-15]** keepAlive prevents disposal on tab switch — ...
  - *Context: Fix #98*

## Dart
## Flutter
## Navigation
## API & Data
## Testing
## Tooling
## Debugging
## Performance
```

### Step 5: Confirm

After appending, state briefly what was logged:

```
Logged to LEARNING_LOG.md: "keepAlive prevents disposal on tab switch" (Riverpod)
```

No verbose confirmation needed. One line is enough.

## Depth Calibration

The user is a **senior Flutter developer (5+ years)**. Calibrate accordingly:

- **Skip**: What `StatelessWidget` is, what `async/await` does, basic Dart syntax
- **Brief**: Standard Riverpod patterns, common GoRouter usage, typical Freezed setup
- **Explain**: Why a specific pattern was chosen over alternatives, non-obvious side effects, framework internals that affect behavior, tradeoffs that depend on context

## Anti-Duplication

Before appending, scan the log for:

1. Same concept already explained (even if worded differently)
2. Same context/task already logged

If a duplicate exists but the new entry adds meaningful nuance, append it as a sub-bullet under the original entry rather than creating a new one.

## Edge Cases

- **No items worth logging**: Skip persistence entirely. Don't log for the sake of logging.
- **Item spans multiple categories**: Pick the primary category. Don't duplicate across sections.
- **User asks to log something specific**: Log exactly what they ask, categorized appropriately.
