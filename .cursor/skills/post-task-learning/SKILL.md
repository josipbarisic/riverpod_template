---
name: post-task-learning
description: Persist every distinct bullet from the inline Supervisor's Briefing to .cursor/docs/LEARNING_LOG.md. Use after any implementation task triggered by the post-task-learning rule, or when the user says "log this", "save learning", or "add to learning log". Be permissive — capture wide, prune later.
---

# Post-Task Learning (Persistence)

This skill is the only writer to `.cursor/docs/LEARNING_LOG.md`. It runs after
the inline `Supervisor's Briefing` and persists each distinct bullet so that
nothing transferable is lost in chat history.

**Principle:** capture wide, prune later. Filtering happens during
`/review-learnings`, not here.

## When This Skill Activates

- Automatically after every Supervisor's Briefing (the rule
  `.cursor/rules/post-task-learning.mdc` mandates invocation for Tier 2–3
  and Tier 1 tasks with ≥ 1 non-trivial bullet)
- Manually when the user says: "log this", "save this learning",
  "add to learning log", "persist that insight"

## Workflow

### Step 1 — Read the Current Log

```bash
cat .cursor/docs/LEARNING_LOG.md
```

If the file does not exist, create it with the structure in Step 4.

### Step 2 — Select Items (Permissive Default)

Take **every bullet** from the inline briefing and persist it. Skip an item
only if it satisfies **all three** of these strict conditions:

1. An entry with the **same concept** (not just same words) already exists.
2. The new bullet adds **zero new nuance** (no new context, no new pitfall,
   no new file/feature link).
3. The new bullet would not be useful for `/review-learnings` to surface as a
   pattern across tasks.

If any of the three is unmet, write the new entry. When in doubt, write.

You may merge a near-duplicate as a sub-bullet under the existing entry
rather than create a new top-level entry — but err on the side of writing.

### Step 3 — Categorize

Assign exactly **one** category per item. If the item could fit two, pick the
primary one; add a sub-bullet cross-reference if needed.

| Category       | What belongs here                                                       |
|----------------|-------------------------------------------------------------------------|
| `Architecture` | Layer decisions, separation of concerns, when to split files            |
| `Riverpod`     | Provider patterns, state, ref usage, code-gen, keepAlive                |
| `Dart`         | Language features, null safety, generics, async, sealed/pattern         |
| `Flutter`      | Widget lifecycle, rendering, animations, platform-specific behavior     |
| `Navigation`   | GoRouter, route guards, deep linking, transitions                       |
| `API & Data`   | Repository patterns, serialization, error format, contracts             |
| `Testing`      | Widget, controller, integration test patterns, mocking, fixtures        |
| `Tooling`      | Build runner, CI/CD, analyzer, scripts, manifests, hooks                |
| `Debugging`    | Root cause analysis techniques, log strategies, repro patterns          |
| `Performance`  | Rebuild prevention, dispose timing, lazy loading, frame budget          |

If a bullet truly does not fit, add it under the closest match and flag in
the sub-bullet `Context:` line — do not invent a new category at write time.

### Step 4 — Entry Format

```markdown
- **[YYYY-MM-DD]** {concise title — one line} — {explanation, same depth as the inline bullet}
  - *Context: {trigger — e.g. "#123" or short task name} / Tier {1|2|3} / {1–3 most relevant file paths, optional}*
```

The trailing `Tier` and file paths are required when known; omit if the task
was a pure read-only exercise or there is no associated ticket.

### Step 5 — File Structure

`.cursor/docs/LEARNING_LOG.md` always has these top-level sections, in order:

```markdown
# Learning Log

> Accumulated insights from development sessions. Organized by category.
> Use `/review-learnings` for periodic summarisation, heatmaps, and pruning.

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

Append new entries to the **top** of the relevant section so the most recent
context surfaces first.

### Step 6 — Confirm

After appending, state briefly what was logged. One line per entry is enough:

```
Logged to LEARNING_LOG.md:
- "keepAlive prevents disposal on tab switch" → Riverpod
- "ref.invalidate vs ref.refresh" → Riverpod
- "ref.read in build() won't react" → Riverpod (sub-bullet under existing "Provider reactivity")
```

No verbose confirmation needed.

## Anti-Duplication (Loose)

Scan the relevant category for items with the **same concept**. If found and
the new bullet adds nuance, append as a sub-bullet:

```markdown
- **[2026-03-15]** keepAlive prevents disposal on tab switch — original explanation …
  - **[2026-05-21]** Combined with an auth-state watch in `build()` to also clear cross-account state on logout. *Context: #137*
```

If the new bullet adds no nuance, skip it (the only legitimate skip case).

## Depth Calibration

The reader is a senior Flutter developer (5+ years). Calibrate accordingly:

- **Skip**: definitions of basic Dart/Flutter primitives.
- **Brief**: standard Riverpod patterns, common GoRouter usage, typical
  Freezed setup.
- **Explain**: why a specific pattern was chosen over alternatives, non-obvious
  side effects, framework internals that affect behavior, tradeoffs that
  depend on context.

## Edge Cases

- **All bullets are sub-bullets under existing entries**: still write them.
  Sub-bullets are the dedupe path — they're not skips.
- **User asks to log something specific**: log exactly what they ask, in the
  appropriate category, even if it doesn't follow from a recent task.
- **The inline briefing was 1 bullet**: still persist it. One-bullet briefings
  are usually the most pattern-establishing.
- **The task only changed docs / comments / config**: still persist any
  tooling, debugging, or process insight that emerged.
- **Category section missing**: create it in the right place (matching the
  fixed order in Step 5). Do not reorder existing sections.
