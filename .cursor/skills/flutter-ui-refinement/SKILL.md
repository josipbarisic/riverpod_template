---
name: flutter-ui-refinement
description: Refine Flutter UI components by finding reference patterns, asking about design specifics, and presenting options. Use when the user asks to change colors, spacing, layout, design, styling, or says something "doesn't look right" or "should match" another component.
---

# Flutter UI Refinement

## When This Skill Activates

Trigger phrases:
- "change the color/spacing/design"
- "doesn't look right"
- "should match [component]"
- "make it look like [reference]"
- "adjust the UI"
- "styling issue"

## Workflow

### Step 1: Understand the Request

Before ANY code changes, gather information:

**Ask the user:**

- "What specifically needs to change?" (colors, spacing, shape, typography, layout, or multiple)
- "Is there a similar component in the app I should reference?" (yes – which one / no – describe / show options)

### Step 2: Find Reference Patterns

**If user provides a reference component:**

1. Locate the file (e.g. under `lib/presentation/` or `lib/theme/`).
2. Read the file and extract design tokens:
   - Colors (theme, `AppColors`, or project color constants)
   - Spacing (padding, margins – theme or extensions like `.w`, `.h`, `.r` if the project uses them)
   - Border radius, shadows
   - Text styles (theme or `TextStyles`)

3. Report findings:
   ```markdown
   **From {reference_file}:**
   - Background: {color usage}
   - Padding: {spacing usage}
   - Border radius: {value}
   - Shadow: {configuration}
   ```

**If no reference provided:**

Search for similar widgets (cards, tiles, list items) under `lib/presentation/` and suggest 2–3 as options.

### Step 3: Present Options

**Present 2–3 options before implementing:**

```markdown
**Option A**: Match `{ReferenceWidget}` style
- Rounded corners, subtle shadow, white background

**Option B**: Match `{OtherWidget}` style
- Sharp corners, border instead of shadow

**Option C**: Custom – describe your preference

Which approach should I use?
```

### Step 4: Extract Design Tokens

Once direction is confirmed, read the reference and extract relevant tokens. Use the project’s existing patterns (theme, `AppColors`, spacing extensions, etc.).

### Step 5: Implement Changes

Apply the design tokens consistently.

**Pre-implementation checklist:**

- [ ] Using theme or app color constants (not hardcoded colors)
- [ ] Using project spacing pattern (theme or extensions, not raw numbers)
- [ ] Following reference component’s pattern
- [ ] No new private `_build` methods (extract to widgets if needed)

### Step 6: Verify Consistency

After implementation, verify colors, spacing, and shape match the reference or chosen option.

## Anti-Patterns to Avoid

- Hardcoded color values (`Color(0xFF123456)`)
- Raw numbers for spacing where the project uses theme or extensions
- Implementing without asking for reference or direction
- Guessing the design direction
