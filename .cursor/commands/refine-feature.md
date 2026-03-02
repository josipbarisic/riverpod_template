---
description: Iteratively refine an existing feature - fix violations, add integrations, improve code quality
---

## Refine Existing Feature

Use this when:

- Feature was created but has architectural violations (private methods, missing integrations)
- Feature works but needs refinement based on feedback
- Integration points were missed during initial creation
- Code quality issues need fixing
- UI/design needs adjustment

**Reference:** `.cursor/docs/COMPLEXITY_AND_DISCOVERY.md`

---

### Step 0: Log Usage

```bash
mkdir -p .cursor/usage && echo '{"command":"/refine-feature","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%S)'"}' >> .cursor/usage/command-log.jsonl
```

---

### Step 0a: Assign Complexity (MANDATORY)

Ask the user if not already stated:

- **Tier 1 – Quick:** One small change. Minimal discovery, then execute.
- **Tier 2 – Moderate:** A few files, clear scope. Short discovery + plan, then execute.
- **Tier 3 – Large:** Many changes, UI overhaul, or integration work. Full discovery + plan — then **wait for approval** before implementing.

Use the user's answer for all following steps. **Tier 3** = wait for approval. **Tier 2** = state plan, then implement. **Tier 1** = minimal questions, then implement.

---

### Step 1: Classify the Refinement Type

Determine: UI/Design, Behavior, Integration, Code quality, or Performance.

---

### Step 2: Mandatory Reads (Tier 2–3)

Before any code changes:

1. Read `ARCHITECTURE.md` or `lib/AGENTS.md`
2. Read the feature's manifest: `lib/manifests/{feature}.manifest.generated.json`
3. Read related feature manifests if integrating with other features (e.g. dashboard, home)
4. Read existing feature files that need updates
5. If UI refinement and user gave a reference widget, read that file

Extract from manifest: exports.views, exports.controllers, dependencies, apiEndpoints. For UI: colors, spacing, border radius, text styles from reference.

---

### Step 3: Scan for Violations

Check feature files for:

- **Private _build methods** (prohibited) – extract to separate widget file
- **Private _show / _display methods** – should be separate widgets
- **Relative imports** (prohibited) – use `package:riverpod_template/...`
- **dynamic type** (prohibited) – use specific type

```bash
grep -r "Widget _build" lib/presentation/{feature}/ --include="*.dart" | grep -v ".g.dart" || true
grep -rE "import ['\"]\.\./" lib/presentation/{feature}/ --include="*.dart" | grep -v ".g.dart" || true
grep -r ":\s*dynamic" lib/presentation/{feature}/ --include="*.dart" | grep -v ".g.dart" || true
```

State what you found: **FILES READ**, **VIOLATIONS FOUND**, **MISSING INTEGRATIONS**, **WHAT WORKS**.

---

### Step 4: Plan (Tier 2–3)

**Tier 2:** State a brief plan (files to change, what you'll do), then implement. No mandatory wait.

**Tier 3:** State full plan and **WAIT for explicit approval** before implementing. Include: violations to fix, integrations to add, files to modify, rationale.

---

### Step 5: Implementation (after approval if Tier 3)

**Fix violations:**

- Extract private methods to widgets (new file per widget)
- Fix relative imports → `package:riverpod_template/...`
- Replace dynamic with specific types

**Add integrations:** Update existing views/controllers to include feature data; follow existing patterns.

**NEVER:** relative imports, `dynamic`, private `_build*` methods, logic in views, editing generated files.

---

### Step 6: Verification

```bash
dart run build_runner build -d
dart run scripts/generate_feature_manifests.dart
```

Re-run violation scans (should find nothing). Then:

```bash
flutter analyze
flutter test
```

---

### Step 7: Report

State: **VIOLATIONS FIXED**, **INTEGRATIONS ADDED**, **FILES MODIFIED**, **VERIFIED** (scans, analyze, test, manifests).
