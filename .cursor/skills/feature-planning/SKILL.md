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

**Clarify with the user:**

- What is the feature’s primary purpose?
- What screens/views are needed? (single screen, list + detail, multi-step flow, bottom sheet, tabs)
- What data does it display/manage? (read-only from API, user input, both, local-only)
- How do users reach this feature? (menu, button on existing screen, deep link, tab)

### Phase 2: Context Reading (ZERO-DRIFT)

**Mandatory reads before planning:**

1. `ARCHITECTURE.md` or `lib/AGENTS.md` – overall patterns
2. Similar feature manifest – `lib/manifests/{feature}.manifest.generated.json`
3. Similar feature README (if exists) – `lib/presentation/{feature}/README.md`

**Extract from similar feature:** file structure, widget decomposition, state management, navigation (RoutePath usage).

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

| Widget           | Responsibility   | Props              |
|------------------|------------------|--------------------|
| {feature}_content | Main content     | data, callbacks    |
| {feature}_empty   | Empty state      | onAction           |
| {feature}_loading | Loading skeleton | -                  |
| {feature}_error    | Error state      | onRetry            |
| {item}_card       | List item        | item, onTap        |
```

### Phase 4: State & Controller Design

```markdown
## State Management

### Controller: `{Feature}Controller`
Location: `lib/presentation/{feature}/{feature}_controller.dart`

**State:** e.g. `AsyncValue<{DataType}>`

**Methods:** build(), refresh(), and feature-specific methods (delete, update, etc.)

**Dependencies:** `{feature}RepositoryProvider`, other providers as needed
```

### Phase 5: Integration Points

**Identify where this feature connects:**

```markdown
## Integration

### Routes
- [ ] Add `RoutePath.{featureName}` in `lib/routing/router.dart`
- [ ] Add `GoRoute` in same file
- [ ] Navigation from: {source_view}.dart

### Data
- [ ] Repository: `lib/data/repositories/{feature}_repository/` (create or existing)
- [ ] Domain models: `lib/domain/` (create or existing)
- [ ] API / endpoints if needed: `lib/utils/network/endpoints.dart` or project API docs

### Entry points
- [ ] Where should this appear? (bottom nav, menu, home, etc.)
```

### Phase 6: File Creation Plan

**Present the file list before implementation:**

```markdown
## Implementation Plan

### Files to Create
1. `lib/presentation/{feature}/{feature}_view.dart`
2. `lib/presentation/{feature}/{feature}_controller.dart`
3. `lib/presentation/{feature}/widgets/{feature}_content.dart`
4. … (list all widgets and data layer files)

### Files to Modify
- `lib/routing/router.dart` – add RoutePath constant and GoRoute
- `lib/presentation/{source}/{source}_view.dart` – add navigation

**Total: ~X files**

Waiting for approval before implementation.
```

## Anti-Patterns to Avoid

- Starting to code without a plan
- Monolithic view files (>250 lines)
- Skipping widget decomposition
- Forgetting route and navigation integration
- Not reading similar feature patterns first
