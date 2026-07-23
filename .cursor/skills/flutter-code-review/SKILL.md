---
name: flutter-code-review
description: Review Flutter/Dart code for architecture violations, code quality, and template patterns. Use when reviewing code, before committing, when asked to "check" or "review" code, or after making significant changes.
---

# Flutter Code Review

## When This Skill Activates

Trigger phrases:

- "review this code"
- "check for issues"
- "before I commit"
- "is this correct"
- "any problems with this"

## Automated Violation Scan

Run these checks on the target files:

### Critical Violations (MUST FIX)

```bash
# 1. Private widget methods (PROHIBITED)
grep -rn "Widget _build\|Widget _create\|Widget _make" {path} --include="*.dart" | grep -v ".g.dart"

# 2. Private show/dialog methods (should be separate widgets)
grep -rn "void _show\|Future<void> _show\|void _display" {path} --include="*.dart" | grep -v ".g.dart"

# 3. Relative imports (PROHIBITED)
grep -rn "import ['\"]\.\./" {path} --include="*.dart" | grep -v ".g.dart"

# 4. Dynamic type (PROHIBITED)
grep -rn ": dynamic\|<dynamic>" {path} --include="*.dart" | grep -v ".g.dart"

# 5. Logic in views (business logic should be in controllers)
grep -rn "if.*await\|try.*catch" {path} --include="*_view.dart" | grep -v ".g.dart"
```

### Warning-Level Issues

```bash
# 1. Missing const constructors
grep -rn "new [A-Z]\|= [A-Z][a-zA-Z]*(" {path} --include="*.dart" | grep -v ".g.dart" | grep -v "const"

# 2. Hardcoded colors (use theme / app colors)
grep -rn "Color(0x\|Colors\." {path} --include="*.dart" | grep -v ".g.dart" | grep -v "theme\|AppColors\|appColors"

# 3. Hardcoded strings (should use l10n / string constants if project has them)
grep -rn "Text(['\"][A-Z]" {path} --include="*.dart" | grep -v ".g.dart"

# 4. Raw numbers for spacing (use theme or extensions if project has them)
grep -rn "EdgeInsets\.\(all\|symmetric\|only\)([0-9]" {path} --include="*.dart" | grep -v ".g.dart"
```

## Review Checklist

### Architecture

- [ ] **No private widget methods** — Extract to separate widget files
- [ ] **No relative imports** — Use `package:riverpod_template/...`
- [ ] **No dynamic types** — Use specific types
- [ ] **Views have no business logic** — Move to controllers
- [ ] **Controllers handle state** — No direct API calls in views
- [ ] **Routes** — Use `AppRoute.xxx` only (no string literals)

### Widget Structure

- [ ] Correct base class (`ConsumerWidget`, `HookConsumerWidget`, etc.)
- [ ] `const` constructor where possible
- [ ] Parameters are `final`
- [ ] Proper use of `ref.watch()` vs `ref.read()`

### Styling

- [ ] Colors from theme or app color constants (not hardcoded)
- [ ] Spacing consistent (theme or extensions if project uses them)
- [ ] Text from l10n or string constants if project has them

### Code Quality

- [ ] No commented-out code
- [ ] No TODO/FIXME without issue reference
- [ ] Error handling on async operations
- [ ] Proper null safety

### Testing

- [ ] **Feature tests pass** — If feature has tests (check manifest `testing.hasTests`)
- [ ] **Tests updated** — If behavior changed, tests reflect new behavior
- [ ] **No test regressions** — Existing tests still pass

## Run Feature Tests

**Before approving code review, verify feature tests pass.**

```bash
# 1. Check if feature has tests
cat lib/manifests/{feature}.manifest.generated.json | grep -A 5 '"testing"'

# 2. If hasTests: true, run them
flutter test test/presentation/{feature}/

# 3. All tests must pass before approval
```

## Report Format

```markdown
## Code Review: {file/feature}

### Critical (Must Fix)

- `file.dart:42` — Private widget method `_buildCard()` → Extract to `card_widget.dart`
- `file.dart:15` — Relative import → Use absolute import

### Warnings

- `file.dart:78` — Hardcoded color → Use theme / app colors
- `file.dart:92` — Raw spacing value → Use theme or extensions

### Good Patterns Found

- Proper use of `const` constructors
- State management follows Riverpod patterns
- Clean separation of concerns

### Testing

- Feature has tests: Yes/No
- Tests passing: All pass / X failures
- Test command: `flutter test test/presentation/{feature}/`

### Summary

- Critical: X issues
- Warnings: Y issues
- Tests: Passing / Failing
- Recommendation: [Fix critical issues before commit / Ready to commit]
```

## Quick Fix Patterns

### Private Method → Separate Widget

```dart
// BEFORE (in view file)
Widget _buildHeader() {
  return Container(...);
}

// AFTER (new file: widgets/header_widget.dart)
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(...);
}
```

### Relative → Absolute Import

```dart
// BEFORE
import '../widgets/my_widget.dart';

// AFTER
import 'package:riverpod_template/presentation/feature/widgets/my_widget.dart';
```

### Dynamic → Specific Type

```dart
// BEFORE
final dynamic data;
Map<String, dynamic> toJson();

// AFTER
final UserData data;
Map<String, Object?> toJson();
```
