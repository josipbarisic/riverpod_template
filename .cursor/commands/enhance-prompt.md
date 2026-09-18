---
description: Enhance and optimize any prompt for maximum AI effectiveness
---

## Enhance Prompt

Take the user's raw prompt and transform it into a structured, context-rich prompt optimized for AI agents.

**Input:** The user provides a raw prompt (task description, question, or request).

### 1. Classify the intent

Identify what the user is asking for:

| Intent | Signals | Enhancement Focus |
|--------|---------|-------------------|
| **Feature** | "add", "create", "implement", "build" | Architecture, patterns, integration points |
| **Bug Fix** | "fix", "broken", "crash", "error", "doesn't work" | Reproduction, error context, affected flow |
| **Refactor** | "refactor", "clean up", "restructure", "extract" | Current structure, target structure, constraints |
| **Question** | "how", "where", "what", "why", "explain" | Codebase location, architectural context |
| **UI/Style** | "design", "style", "layout", "spacing", "color" | Theme system, existing components, design tokens |
| **Test** | "test", "coverage", "assert", "mock" | Test patterns, mock infrastructure, test data |
| **Config/Infra** | "CI", "deploy", "config", "dependency" | Build system, environment setup |

---

### 2. Identify affected areas

From the raw prompt, determine:

1. **Which feature(s)?** → Map to `lib/presentation/{feature}/`
2. **Which layer(s)?** → Presentation, data, models, core
3. **Which files?** → Views, controllers, repositories, models, services
4. **Which routes?** → Check `lib/core/routing/app_route.dart`

---

### 3. Gather verified context

Based on the identified areas, read:

1. Root `AGENTS.md` and the relevant `ARCHITECTURE.md` section.
2. `lib/AGENTS.md` and `lib/manifests/<feature>.manifest.generated.json` for
   feature work.
3. Matching canonical `.claude/rules/*.md`.
4. Live source and the nearest tests.
5. `lib/core/routing/app_route.dart` and `router.dart` for navigation.
6. Endpoint source or API documentation for data work.

Extract key context:
- Relevant file paths and their roles
- Provider names and types
- State class fields
- Route definitions
- API endpoints
- Dependencies between features

---

Application models live in `lib/models/`. Manifests are flat files. Treat
documents and generated manifests as claims until live source confirms them.

### 4. Decompose vague language

Transform vague requests into specific, actionable items:

| Vague | Specific |
|-------|----------|
| "make it work" | "Fix [specific error] in [specific file] when [specific action]" |
| "add auth" | "Add authentication flow: login view, controller, auth repository with Firebase, route at AppRoute.login" |
| "clean up the code" | "Refactor [file] to extract [widget/method] into separate files, apply [pattern]" |
| "it's slow" | "Profile and optimize [screen]: check rebuild frequency, provider watching, unnecessary computations" |
| "update the UI" | "Modify [view file] to change [specific element]: spacing, colors, layout as per [design reference]" |

If the prompt is already specific, preserve the specificity and add context.

---

### 5. Build the enhanced prompt

Output the enhanced prompt using this structure:

```markdown
## Enhanced Prompt

### Context
- **Project:** [project name and verified stack]
- **Feature area:** `lib/presentation/{feature}/`
- **Affected files:** [list specific files from manifest/discovery]
- **Related providers:** [list provider names]
- **Related routes:** [list AppRoute constants]

### Task
[Clear, specific description of what needs to happen — rewritten from the original prompt with all ambiguity resolved]

### Requirements
1. [Specific requirement 1]
2. [Specific requirement 2]
3. [Specific requirement N]

### Constraints
- Use absolute imports (`package:riverpod_template/...`)
- Follow existing patterns in [reference file/feature]
- Use Riverpod annotation code generation only
- Keep external I/O outside views
- Use `AppRoute` path constants from `app_route.dart`
- Do not edit generated files
- [Any additional project-specific constraints]

### Reference Patterns
- **Similar feature:** `lib/presentation/{similar}/` — follow same structure
- **Manifest:** `lib/manifests/{feature}.manifest.generated.json`
- **Test pattern:** `test/presentation/{similar}/{similar}_controller_test.dart`

### Success criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] Required root `AGENTS.md` verification passes
- [ ] Manifests regenerated after structural changes

### Original Prompt
> [User's original prompt preserved for reference]
```

---

### 6. Present to the user

Show the enhanced prompt and ask:

```
Here's your enhanced prompt. You can:

1. **Use as-is** — Copy and use this prompt
2. **Adjust** — Tell me what to change
3. **Execute** — I'll execute this enhanced prompt now
```

---

### Rules

Preserve the user's intent and stated complexity tier. Add only verified
symbols, paths, commands, constraints, and success criteria. If an assumption
cannot be resolved, turn it into a focused question instead of embedding it as
fact. Root `AGENTS.md` owns bare Dart/Flutter commands and FVM discovery.
