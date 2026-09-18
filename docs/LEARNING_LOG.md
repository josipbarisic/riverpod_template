# Learning Log

> Accumulated transferable insights from implementation work.
> Read the matching category before similar work; use `/review-learnings` for a read-only review.

Entries are distilled from the Cause and Fix in the Supervisor's Briefing
defined by `.claude/rules/post-task-learning.md`.

## Architecture

## Riverpod

## Dart

## Flutter

## Navigation

## API & Data

## Testing

## Tooling

- **[2026-09-18]** Analyzer baselines should ratchet counts, not suppress rules — Key existing diagnostics by severity, lint code, repository-relative path, and count; allow removals while failing every new key or excess occurrence so a dirty baseline does not block adoption or permit regression.
  - *Context: AI workflow sync / Tier 3 / scripts/ci/check_flutter_analyze_baseline.mjs, scripts/ci/flutter_analyze_baseline.json, .github/workflows/validate-ai-standards.yml*
- **[2026-09-18]** Instruction prose needs the same source checks as code — Resolve concrete paths, cited symbols, layer names, and CI-parity commands against the live repository, then expose the checker as shared functions so Stop hooks and CI enforce one policy.
  - *Context: AI workflow sync / Tier 3 / scripts/ci/check_instruction_claims.mjs, scripts/ai/integrity_check.mjs, .claude/rules/claims-need-source.md*
- **[2026-09-18]** Editor hooks should adapt one git-based policy — Keep Cursor and Claude event/output contracts in thin adapters, and derive manifest/codegen freshness from changed paths instead of checkout mtimes so both editors agree without false stale results.
  - *Context: hooks-automation / Tier 3 / scripts/ai/session_status.mjs, .claude/hooks/, .cursor/hooks/*
- **[2026-09-18]** Canonical workflow ownership prevents instruction drift — Keep policy in root `AGENTS.md` and `.claude/rules/`, reusable implementations in `.claude/skills/`, and slash commands as thin entry points; compatibility workflows defer to the canonical rule instead of copying it.
  - *Context: skills-flows migration / Tier 3 / AGENTS.md, .claude/skills/, .cursor/commands/*
- **[2026-09-18]** Reviewer prompts must mirror live repository contracts — Derive route mode, model placement, shared-widget location, and manifest layout from current source before adapting a reviewer; inherited app assumptions otherwise create authoritative-looking false findings.
  - *Context: skills-flows migration / Tier 3 / .claude/agents/, lib/core/routing/, lib/manifests/*

## Debugging

## Performance
