# Riverpod Template – Claude Code Instructions

## Primary Rule Source

**All coding standards, patterns, and workflows are defined in Cursor configurations.**

**Cursor rules take precedence over anything in this file.**

---

## MANDATORY First Steps

### Before ANY Code Edit

You MUST read these files before making any code changes. Do NOT proceed without reading them first:

1. `.cursor/rules/pre-edit-checklist.mdc` - Violations to avoid
2. `.cursor/rules/discovery-first.mdc` - Complexity workflow

### Before Any Task (Add/Fix/Refine)

You MUST read and follow the complexity workflow:

1. `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md` - Full complexity scale
2. **Ask the user for complexity tier** (1/2/3) if not stated
3. Follow discovery depth for that tier:
   - **Tier 1**: Minimal questions → execute
   - **Tier 2**: Short discovery + plan → execute
   - **Tier 3**: Full discovery + plan → **WAIT for explicit approval**

### For Feature Context

Read relevant rules based on what you're doing:

| Task | Read |
|------|------|
| Widget work | `.cursor/rules/dart-widget-rules.mdc` |
| Imports | `.cursor/rules/dart-imports.mdc` |
| Navigation | `.cursor/rules/dart-navigation.mdc` |
| Riverpod/state | `.cursor/rules/dart-riverpod.mdc` |
| Naming | `.cursor/rules/dart-naming.mdc` |
| All rules | `.cursor/rules/` (all `.mdc` files) |

---

## Manifest Workflow (Feature Work Only)

For feature work, read the manifest first:
```
lib/manifests/{feature}.manifest.generated.json
```

If stale (feature files newer than `generatedAt`), regenerate:
```bash
dart run scripts/generate_feature_manifests.dart
```

---

## Essential Commands

```bash
# Code generation (after @riverpod/@freezed changes)
dart run build_runner build -d

# Manifest generation (after structural changes)
dart run scripts/generate_feature_manifests.dart

# Run app
flutter run --flavor dev

# Analyze
flutter analyze
```
