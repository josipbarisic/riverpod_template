# Development Rules

This document outlines important development rules and best practices for this project.

## Freezed Classes

**Rule: All Freezed classes MUST use the `abstract` keyword before the class declaration.**

```dart
// ✅ Correct
@freezed
abstract class User with _$User {
  const factory User({required String name}) = _User;
}

// ❌ Incorrect
@freezed
class User with _$User {
  const factory User({required String name}) = _User;
}
```

This is required for Freezed code generation to work correctly. Without the `abstract` keyword, the generated code will not properly implement the required mixin methods.

## Package Implementation Details

**Rule: Always check package source files for implementation details instead of guessing or making assumptions.**

When working with external packages:

1. **Check the actual package files** in `~/.pub-cache/hosted/pub.dev/` or use `flutter pub deps` to find the package location
2. **Read the package's source code** to understand the correct API usage
3. **Check example files** in the package's `example/` directory if available
4. **Never assume API behavior** - always verify by examining the actual implementation

### Example: Checking Package Files

```bash
# Find package location
find ~/.pub-cache/hosted/pub.dev -path "*/package_name-*/lib/*.dart"

# View specific file
cat ~/.pub-cache/hosted/pub.dev/package_name-*/lib/package_name.dart

# Check example usage
cat ~/.pub-cache/hosted/pub.dev/package_name-*/example/lib/main.dart
```

### Why This Matters

- Package APIs change between versions
- Documentation may be outdated or incomplete
- Source code is the single source of truth
- Example files show real-world usage patterns

## Code Generation

After making changes to Freezed classes or Riverpod providers:

1. Run `dart run build_runner build --d` to regenerate code
2. Always verify that `flutter analyze` passes after regeneration
3. Commit generated files (`.freezed.dart`, `.g.dart`) to version control

