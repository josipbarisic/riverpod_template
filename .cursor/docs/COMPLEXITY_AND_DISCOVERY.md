# Complexity Scale & Discovery-First Workflow

This document defines how we assign **complexity** to tasks and how much **discovery and planning** happen before implementation. The AI must **ask** the user for complexity at the start of relevant tasks and then follow the workflow for that level.

---

## Core Principle

**Before writing code:** Ask complexity → Run discovery for that level → Plan (if needed) → Then implement.

Higher complexity = more questioning, more specification, and explicit approval before implementation.

---

## Complexity Scale (User-Assigned)

The **user** assigns the complexity level at the start of the task. The AI may suggest a level based on the request but must **ask** and use the user's answer.

| Tier | Name | Typical scope | When the user would pick this |
|------|------|---------------|--------------------------------|
| **1** | **Quick** | Single file, &lt;~30 lines, obvious change | "Fix this typo", "Change this color", "Add this one import", "Update this string" |
| **2** | **Moderate** | 2–5 files, ~30–100 lines, clear scope | "Fix this bug in X and Y", "Add this widget to the existing screen", "Refactor this into two widgets" |
| **3** | **Large** | New feature, many files, or ambiguous | "Add a new screen", "Refactor the auth flow", "We need to rethink this screen" |

### Tier 1 – Quick

- **Scope:** One file, small change, no design decisions.
- **Discovery:** 0–1 clarifying questions if anything is ambiguous.
- **Planning:** None; go straight to the change.
- **Approval:** Execute immediately after minimal confirmation.

**Example:** "Update the empty state copy on the login screen" → User says Tier 1 → Confirm which string → Edit → Done.

### Tier 2 – Moderate

- **Scope:** A few files, clear goal, some alignment with existing patterns.
- **Discovery:** Short discovery: what exactly, where, any constraints. 3–5 targeted questions.
- **Planning:** Brief plan (what files, what changes). State it before coding.
- **Approval:** User sees the plan; AI proceeds to implement (no formal "proceed" required unless user asks).

**Example:** "Fix the bug where saving doesn't refresh the list" → User says Tier 2 → Ask: which screen, expected behavior → Plan: controller + view → Implement.

### Tier 3 – Large

- **Scope:** New feature, big refactor, many touchpoints, or unclear requirements.
- **Discovery:** Full discovery: purpose, screens, data, integration points, options.
- **Planning:** Written specification and implementation plan (files, steps, integrations). STATE what you read and what you'll do.
- **Approval:** **WAIT for explicit approval** (e.g. "proceed", "approved", "go ahead") before implementing.

**Example:** "Add a settings screen" → User says Tier 3 → Full discovery (where it lives, what toggles, API?) → Spec + plan → Wait for approval → Implement.

---

## Mandatory First Step for Relevant Commands

For **add-feature**, **fix-bug**, **refine-feature**, **fix-gh-issue**, **mobile-issue**, and similar workflow commands:

### Step 0: Assign Complexity

**The AI must ask:**

```
"What complexity do you assign to this task?"

- **Tier 1 – Quick:** Single file, small change, no real decisions.
- **Tier 2 – Moderate:** A few files, clear scope, some design/pattern choices.
- **Tier 3 – Large:** New feature, big change, or ambiguous — full spec and plan, then wait for approval.
```

If the user already stated complexity in the prompt, use it. Otherwise, ask once and base all following steps on the chosen level.

---

## Discovery Depth by Tier

| Step | Tier 1 | Tier 2 | Tier 3 |
|------|---------|---------|---------|
| Ask complexity | ✓ (or infer from request) | ✓ Ask | ✓ Ask |
| Clarifying questions | 0–1 | 3–5 targeted | Full discovery |
| Read ARCHITECTURE.md / manifests | If relevant | Yes | Yes, always |
| Read similar feature / reference | No | If helpful | Yes |
| State plan before code | No | Yes, brief | Yes, full plan + spec |
| Wait for approval | No | Optional | **Yes, required** |
| Violation scan (pre/post) | Optional | Yes | Yes |

---

## What "Discovery" Includes (Tier 2–3)

- **What** exactly we're building or changing (screens, behavior, data).
- **Where** it lives (feature folder, routes, entry points).
- **How** it fits: integration points, existing providers, APIs.
- **Reference:** Similar feature or widget to copy patterns from.
- **Constraints:** Design, performance, or product constraints the user mentions.

For **Tier 3**, discovery should produce a short **spec** (user-visible behavior, main data and flows) and an **implementation plan** (files to add/change, order of work).

---

## Where This Is Referenced

- **Rules:** `.cursor/rules/discovery-first.mdc` – reminds the AI to ask complexity and follow this workflow.
- **Commands:** Each relevant command has a **Step 0: Assign complexity** and ties its steps to Tier 1 / 2 / 3.
- **Skills:** `feature-planning` aligns with Tier 3 discovery and planning.

---

## Summary

1. **Ask** the user for complexity (Tier 1, 2, or 3) at the start of the task.
2. **Do not** skip discovery for Tier 2–3; do not implement large tasks without a plan and approval.
3. **Tier 1:** Minimal questions → implement.
4. **Tier 2:** Short discovery → brief plan → implement.
5. **Tier 3:** Full discovery → spec + plan → **wait for approval** → implement.
