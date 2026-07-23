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

**Use AskQuestion tool:**

```
Question 1: "What specifically needs to change?"
Options:
- Colors (background, text, borders)
- Spacing (padding, margins, gaps)
- Shape (border radius, shadows)
- Typography (font size, weight, style)
- Layout (alignment, arrangement)
- Multiple of the above

Question 2: "Is there a similar component in the app I should reference?"
Options:
- Yes (ask which one)
- No, describe what you want
- Show me options
```

### Step 2: Find Reference Patterns

**If user provides a reference component:**

1. Search for the file:
   ```bash
   find lib/presentation -name "*reference_name*" -type f
   ```

2. Read the file and extract design tokens:
   - Colors: theme or app color constants
   - Spacing: padding, margins (theme or extensions if project uses `.w`, `.h`, `.r`)
   - Border radius: `BorderRadius.circular(...)` values
   - Shadows: `BoxShadow` configurations
   - Text styles: theme or `TextStyles` constants

3. Report findings:
   ```markdown
   **From {reference_file}:**
   - Background: {color usage}
   - Padding: {spacing usage}
   - Border radius: {value}
   - Shadow: {configuration}
   ```

**If no reference provided:**

Search for similar widgets:

```bash
grep -r "class.*Card\|class.*Tile\|class.*Item" lib/presentation/ --include="*.dart" | head -10
```

Suggest 2–3 results as reference options.

### Step 3: Present Options

**ALWAYS present 2–3 options before implementing:**

```markdown
**Option A**: Match `{ReferenceWidget}` style
- Rounded corners (12)
- Subtle shadow
- White background

**Option B**: Match `{OtherWidget}` style
- Sharp corners
- Border instead of shadow
- Slightly gray background

**Option C**: Custom
- Describe your preference

Which approach should I use?
```

### Step 4: Extract Design Tokens

Once direction is confirmed, read the reference and extract ALL relevant tokens. Document them before applying:

```dart
// Colors — use your project's theme/color system
final backgroundColor = theme.colorScheme.surface;
final textColor = theme.colorScheme.onSurface;
final borderColor = theme.colorScheme.outline;

// Spacing
final padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
final gap = 8.0;

// Shape
final borderRadius = BorderRadius.circular(12);
final shadow = BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 8,
  offset: Offset(0, 2),
);
```

### Step 5: Implement Changes

Apply the extracted design tokens consistently.

**Pre-implementation checklist:**

- [ ] Using theme or app color constants (not hardcoded colors)
- [ ] Using project spacing pattern (not raw numbers if project has a pattern)
- [ ] Following reference component's pattern
- [ ] No private `_build` methods being created (extract to widgets if needed)

### Step 6: Verify Consistency

After implementation, verify:

- Colors match the reference or chosen option
- Spacing is consistent
- Shape matches the established pattern

## Common Design Tokens

See your project's theme/color file for available tokens.

### Spacing Patterns

| Size | Value | Use |
|------|-------|-----|
| Small | 4 | Tight gaps, icon padding |
| Medium | 8 | Standard gaps, list spacing |
| Large | 16 | Section padding, card padding |
| XLarge | 24 | Major section spacing |

### Border Radius Patterns

| Size | Value | Use |
|------|-------|-----|
| Small | 4 | Subtle rounding |
| Medium | 8 | Standard cards, buttons |
| Large | 12 | Prominent cards, sheets |
| XLarge | 16 | Large panels, dialogs |
| Pill | 999 | Fully rounded (chips, tags) |

## Anti-Patterns to Avoid

- Hardcoded color values (`Color(0xFF123456)`)
- Raw numbers for spacing where the project uses theme or extensions
- Implementing without asking for reference or direction
- Guessing the design direction
