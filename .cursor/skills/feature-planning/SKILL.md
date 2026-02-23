---
name: feature-planning
description: Plan new features with thorough upfront design, widget decomposition, and integration analysis. Use when starting a new feature, planning implementation, or when the user asks "how should I implement" or "what's the best approach for".
---

# Feature Planning

## When This Skill Activates

Trigger phrases:

- "add a new feature"
- "implement [feature]"
- "how should I approach"
- "what's the best way to"
- "plan the implementation"
- "before we start coding"

## Planning Workflow

### Phase 1: Requirements Gathering

**Use AskQuestion tool to clarify:**

```
Question 1: "What is the feature's primary purpose?"
(Free text or common options)

Question 2: "What screens/views are needed?"
Options:
- Single screen
- List + Detail screens
- Multi-step flow
- Bottom sheet / Dialog
- Tab-based view

Question 3: "What data does it display/manage?"
Options:
- Read-only data from API
- User input / Forms
- Both read and write
- Local-only (no API)

Question 4: "How do users reach this feature?"
Options:
- Menu item
- Button on existing screen
- Deep link
- Tab in existing view
```

### Phase 2: Context Reading (ZERO-DRIFT)

**Mandatory reads before planning:**

1. `lib/AGENTS.md` — overall patterns
2. Similar feature manifest — `lib/manifests/{feature}.manifest.generated.json`
3. Similar feature README (if exists) — `lib/presentation/{feature}/README.md`

**Extract from similar feature:**

- File structure pattern
- Widget decomposition pattern
- State management approach
- Navigation pattern (AppRoute usage)

### Phase 3: Widget Decomposition

**Break down the UI into separate widget files:**

```markdown
## Widget Breakdown: {Feature}

### Main View
`lib/presentation/{feature}/{feature}_view.dart`
- Scaffold, AppBar, body structure
- State handling (loading, error, data)
- NO business logic

### Content Widgets
`lib/presentation/{feature}/widgets/`

| Widget | Responsibility | Props |
|--------|----------------|-------|
| `{feature}_content.dart` | Main content when data loaded | data, callbacks |
| `{feature}_empty.dart` | Empty state | onAction callback |
| `{feature}_loading.dart` | Loading skeleton | none |
| `{feature}_error.dart` | Error state | onRetry callback |
| `{item}_card.dart` | Individual list item | item, onTap, onDelete |
| `{item}_header.dart` | Section header | title |

### Shared Widgets (if reusable)
Consider if any widgets should go in `lib/presentation/shared/widgets/`
```

### Phase 4: State & Controller Design

```markdown
## State Management

### Controller: `{Feature}Controller`
Location: `lib/presentation/{feature}/{feature}_controller.dart`

**State Type**: `AsyncValue<{DataType}>`

**Methods:**
| Method | Purpose | Returns |
|--------|---------|---------|
| `build()` | Initial data fetch | `FutureOr<State>` |
| `refresh()` | Pull-to-refresh | `Future<void>` |
| `delete(id)` | Delete item | `Future<bool>` |
| `update(item)` | Update item | `Future<void>` |

### Dependencies
- `{feature}RepositoryProvider` — API calls
- Other providers if needed
```

### Phase 5: Integration Points

**Identify where this feature connects:**

```markdown
## Integration Analysis

### Entry Points
- [ ] Route constant in `lib/core/routing/router.dart`: `AppRoute.{featureName}`
- [ ] Route definition in same file: `GoRoute(...)`
- [ ] Navigation from: `{source_view}.dart`

### Data Dependencies
- [ ] Repository: `{feature}_repository.dart` (create / existing)
- [ ] Models: `lib/domain/{feature}/` (create / existing)
- [ ] API endpoints if needed

### Display in Other Features
- [ ] Should appear in Home screen: YES/NO
- [ ] Should appear in navigation: YES/NO
- [ ] Other integration: {describe}
```

### Phase 6: Test Planning

**Plan tests alongside feature implementation:**

```markdown
## Test Plan

### Priority 0 — Controller Tests (REQUIRED)
`test/presentation/{feature}/{feature}_controller_test.dart`
- build() — success, empty, error states
- refresh() — success, error
- CRUD operations with optimistic updates/rollback
- Validation methods

### Priority 1 — Widget Tests (RECOMMENDED)
`test/presentation/{feature}/{feature}_view_test.dart`
- Loading state renders
- Empty state renders and triggers action
- Data state renders items
- Error state renders with retry

### Test Data & Mocks
`test/test_data/{feature}_test_data.dart` — Factory helpers
`test/presentation/{feature}/mocks/` — Mock repository
```

**Reference:** See an existing feature with tests for patterns (check manifests for `testing.hasTests`).

### Phase 7: File Creation Plan

**Present complete file list before implementation:**

```markdown
## Implementation Plan

### Files to Create ({count} files)

**Views:**
1. `lib/presentation/{feature}/{feature}_view.dart` (~100 lines)

**Controllers:**
2. `lib/presentation/{feature}/{feature}_controller.dart` (~80 lines)

**Widgets:**
3. `lib/presentation/{feature}/widgets/{feature}_content.dart` (~60 lines)
4. `lib/presentation/{feature}/widgets/{feature}_loading.dart` (~30 lines)
5. `lib/presentation/{feature}/widgets/{feature}_error.dart` (~40 lines)
6. `lib/presentation/{feature}/widgets/{feature}_empty.dart` (~50 lines)
7. `lib/presentation/{feature}/widgets/{item}_card.dart` (~80 lines)

**Data Layer:**
8. `lib/data/repositories/{feature}_repository/{feature}_repository.dart` (~60 lines)
9. `lib/domain/{feature}/{feature}.dart` (~40 lines)

**Routes:**
10. Update `lib/core/routing/router.dart` (+5 lines)

**Tests (P0 — Controller):**
11. `test/test_data/{feature}_test_data.dart` (~50 lines)
12. `test/presentation/{feature}/mocks/mock_{feature}_repository.dart` (~40 lines)
13. `test/presentation/{feature}/{feature}_controller_test.dart` (~100 lines)

### Files to Modify
14. `lib/presentation/{source}/{source}_view.dart` — Add navigation

**Total: ~{X} lines of code**

Waiting for approval before implementation.
```

## Anti-Patterns to Avoid

- Starting to code without a plan
- Creating monolithic view files (>250 lines)
- Skipping widget decomposition
- Forgetting route and navigation integration
- Not reading similar feature patterns first
- Skipping test planning entirely
