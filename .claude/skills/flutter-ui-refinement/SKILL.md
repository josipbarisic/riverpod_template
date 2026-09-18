---
name: flutter-ui-refinement
description: Refine Flutter UI by grounding changes in a live reference, the project's theme, widget rules, and runtime evidence. Use for layout, spacing, color, typography, or visual-consistency requests.
---

# Flutter UI Refinement

Root `AGENTS.md` owns complexity and verification. Read
`ARCHITECTURE.md`, `lib/AGENTS.md`, and the matching
`.claude/rules/*.md` before editing.

## 1. Fix the visual target

Identify the exact screen, element, state, device, and expected appearance. If
the request names a reference widget or screenshot, use it. Ask for direction
only when the target remains ambiguous after inspecting available evidence.

## 2. Inspect the live design language

Read the target widget, its containing view, and the closest comparable
component. Inspect `lib/core/theme/` for the colors and text styles the project
actually exposes. Do not invent spacing tokens or APIs; reuse an existing
pattern when one fits.

For feature work, regenerate and read the flat feature manifest as directed by
`lib/AGENTS.md`. Before any Dart or Flutter command, discover FVM from the
repository root with `command -v fvm`; prefix the documented bare command only
when found.

## 3. Implement the smallest coherent refinement

- Keep behavior and state ownership unchanged unless the request includes it.
- Use the narrowest widget base class.
- Keep one widget class per file and extract coherent sections instead of
  adding `_buildX` helpers.
- Reuse theme colors and text styles instead of hardcoded replacements when a
  matching project value exists.
- Preserve accessibility, safe areas, text scaling, and interaction targets.

When multiple directions are materially different, present only the choices
the user must decide. Otherwise apply the reference pattern directly.

## 4. Verify the rendered result

Check the requested states and the nearest responsive edge cases. Run the
narrowest relevant widget test if behavior or interaction changed, then follow
root `AGENTS.md` for analysis and broader verification.

Report the visual finding, the mechanism changed, and the evidence used to pin
the result.
