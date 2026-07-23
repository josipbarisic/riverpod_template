---
name: widget-placement-auditor
description: Audit where new/changed widget files live — correct feature directory, View suffix for route-level widgets, and cross-feature imports hinting at misplacement. Use when .dart widget/view files are added or moved, or during a PR review.
---

# Widget Placement Auditor

Read-only auditor for widget file placement and naming.

## Canonical source of truth

Defer to `.cursor/rules/dart-widget-rules.mdc` and `.cursor/rules/dart-naming.mdc`.

## Structure conventions

```
lib/presentation/{feature}/
  {feature}_view.dart        # route-level → class {Feature}View
  {feature}_controller.dart
  models/ · utils/ · widgets/ · {sub_feature}/
lib/presentation/shared/widgets/   # app-wide shared widgets
```

## Accepted patterns — NEVER flag these

- Shared widgets under `presentation/shared/widgets/`, and any import **from**
  that dir.
- Same-feature imports (a sub-feature using its own feature's
  controller/model/widget).
- Importing a **controller / model / util** from another feature (only *widget*
  imports hint at misplacement).
- Non-`View` widget names — only route-level screens end in `View`; section
  widgets end in `Section`/`Card`/`Header`/`Content`/`Item`/`Row`/`Modal`/`Widget`.

## Scan

```bash
# Route-level views not named *View (confirm against router.dart)
grep -rn "class .* extends .*Widget" {path} --include="*_view.dart" | grep -v "class .*View "

# Cross-FEATURE imports of a feature-private widgets/ file (misplacement smell)
grep -rn "import 'package:riverpod_template/presentation/.*/widgets/" {path} --include="*.dart" | grep -v ".g.dart"
#   → flag only when importer and imported belong to DIFFERENT features
#     AND the imported path is not under a shared/ dir

# Two public widget classes in one file (one-class-per-file)
grep -rnc "^class .* extends " {path} --include="*.dart" | grep -v ":1$" | grep -v ":0$"
```

## Checklist

### 🔴 Placement
- [ ] Route-level widget class ends in `View` and sits at its feature root
- [ ] Widget file lives in the feature it belongs to (not a shared root by accident)

### 🟡 Cross-boundary (advisory, never blocking)
- [ ] Feature-private `widgets/` file imported by **2+ different features** →
      promote to `presentation/shared/widgets/`. A single cross-feature import and
      same-feature imports are accepted — do not flag.

### 🟢 Structure
- [ ] One public widget class per file; no `_buildX` helper methods

## Report

```markdown
## Widget Placement: {scope}

### 🔴 Placement
### 🟡 Cross-boundary
### 🟢 Structure

### Summary
- Placement: X · Cross-boundary: Y · Structure: Z
- Recommendation: [move before merge / advisory only]
```

Default to silence: a file in a valid location is not a finding. Only report a
placement issue you can justify by naming the correct destination.
