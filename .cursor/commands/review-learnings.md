---
description: Review accumulated learning notes, identify patterns and gaps, suggest focus areas
---

## Review Learnings

Summarize the learning log, identify what you've been learning about vs. blind spots, and suggest focus areas.

**Reference:** `.cursor/docs/LEARNING_LOG.md`

---

### Step 0: Log Usage

```bash
mkdir -p .cursor/usage && echo '{"command":"/review-learnings","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%S)'"}' >> .cursor/usage/command-log.jsonl
```

---

### Step 1: Read the Learning Log

```bash
cat .cursor/docs/LEARNING_LOG.md
```

If the file is empty or has no entries, say so and suggest completing a few tasks first.

---

### Step 2: Generate the Review

Produce a structured review with these sections:

#### 2a: Category Heatmap

Show which categories have entries and how many. Visual indicator of coverage:

```markdown
| Category | Entries | Coverage |
|----------|---------|----------|
| Architecture | 8 | ████████░░ |
| Riverpod | 12 | ████████████ |
| Dart | 2 | ██░░░░░░░░ |
| Flutter | 0 | ░░░░░░░░░░ |
| ... | | |
```

#### 2b: Key Themes

Identify 3–5 recurring themes across entries. What concepts keep coming up? Are there patterns in what the user encounters?

Example:
- "Provider lifecycle management comes up repeatedly — you've dealt with keepAlive, invalidation, and disposal across 4 different tasks."
- "API error handling patterns appear in 3 entries — the distinction between network errors and business logic errors is a recurring theme."

#### 2c: Blind Spots

Categories with zero or very few entries. These are areas where either:
- The AI handled it without needing to explain (possible knowledge gap hiding)
- The work hasn't touched those areas yet

Flag which is more likely based on the project's recent activity.

#### 2d: Strongest Learnings

Pick the 3–5 most valuable entries from the entire log — the ones with the highest transferable value across projects.

#### 2e: Suggested Focus

Based on the heatmap and blind spots, suggest 2–3 areas to pay closer attention to in upcoming tasks. Frame as:
- "Next time we work on X, pay attention to Y because..."
- "Consider asking me to explain Z in more depth when it comes up"

---

### Step 3: Optional Actions

Ask the user:

```
Would you like me to:
(a) Deep-dive into any specific category
(b) Quiz you on logged concepts to test retention
(c) Clean up / consolidate duplicate entries
(d) Export a study summary for offline review
```

---

### Rules

- This is a **read-only** command — never modify the log file during review.
- Keep the review conversational but structured. This is a coaching session, not a report.
- Be honest about gaps. Don't sugarcoat empty categories.
- If the log has fewer than 5 entries total, keep the review brief and encourage more usage first.
