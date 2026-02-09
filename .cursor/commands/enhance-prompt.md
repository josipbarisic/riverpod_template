---
description: Enhance and optimize any prompt for maximum AI effectiveness
---

## Enhance Prompt

Take the user's raw prompt and transform it into a structured, context-rich prompt optimized for AI agents.

**Input:** The user provides a raw prompt (task description, question, or request).

---

### Step 1: Classify the Intent

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

### Step 2: Identify Affected Codebase Areas

From the raw prompt, determine:

1. **Which feature(s)?** → Map to `lib/presentation/{feature}/`
2. **Which layer(s)?** → Presentation, data, models, core
3. **Which files?** → Views, controllers, repositories, models, services
4. **Which routes?** → Check `lib/core/routing/app_route.dart`

---

### Step 3: Gather Context (AUTOMATED)

Based on the identified areas, read:

1. **Always:** `ARCHITECTURE.md` (skim for relevant section)
2. **If feature-related:** `lib/manifests/{feature}.manifest.generated.json`
3. **If API-related:** `lib/core/utils/network/endpoints.dart`
4. **If navigation-related:** `lib/core/routing/router.dart` and `app_route.dart`
5. **If testing:** Existing test patterns in `test/`

Extract key context:
- Relevant file paths and their roles
- Provider names and types
- State class fields
- Route definitions
- API endpoints
- Dependencies between features

---

### Step 4: Decompose Vague Language

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

### Step 5: Build the Enhanced Prompt

Output the enhanced prompt using this structure:

```markdown
## Enhanced Prompt

### Context
- **Project:** [project name] (Flutter/Riverpod, clean architecture)
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
- Views: UI only, no business logic (≤250 lines)
- Controllers: business logic via Riverpod (≤150 lines)
- No `dynamic` types, no private `_build*` methods
- Use `AppRoute.xxx` for navigation (no string literals)
- [Any additional project-specific constraints]

### Reference Patterns
- **Similar feature:** `lib/presentation/{similar}/` — follow same structure
- **Manifest:** `lib/manifests/{feature}.manifest.generated.json`
- **Test pattern:** `test/presentation/{similar}/{similar}_controller_test.dart`

### Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] All tests pass (`flutter test`)
- [ ] No analysis errors (`flutter analyze`)
- [ ] Manifests regenerated (if structure changed)

### Original Prompt
> [User's original prompt preserved for reference]
```

---

### Step 6: Present to User

Show the enhanced prompt and ask:

```
Here's your enhanced prompt. You can:

1. **Use as-is** — Copy and use this prompt
2. **Adjust** — Tell me what to change
3. **Execute** — I'll execute this enhanced prompt now
```

---

### Enhancement Principles

1. **Be specific** — Replace "it" and "this" with actual file/class/method names
2. **Add context** — Include manifest data, file paths, provider names
3. **Set boundaries** — State what SHOULD and SHOULD NOT change
4. **Define done** — Clear success criteria that can be verified
5. **Reference patterns** — Point to existing code as examples to follow
6. **Preserve intent** — Never change WHAT the user wants, only clarify HOW
7. **Front-load importance** — Put the most critical information first
8. **Scope explicitly** — If the prompt implies multiple tasks, break them into numbered items
