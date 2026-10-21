---
paths:
  - "lib/**"
  - "test/**"
  - "scripts/**"
  - "android/**"
  - "ios/**"
  - "linux/**"
  - "macos/**"
  - "web/**"
  - "windows/**"
  - "docs/**"
  - ".github/**"
  - ".claude/**"
  - "*.md"
  - "*.yaml"
  - "*.yml"
  - "pubspec.lock"
---

# Post-Task Learning

After any implementation task (fix, feature, refinement, removal, migration, test or tooling work),
append a `Supervisor's Briefing` to the task report. For a mechanical change with nothing to learn,
one sentence saying so is enough. Do not invent a lesson.

## Supervisor's Briefing

Use exactly four bold labels, one short paragraph each. No tagged bullets (`Pattern`, `Pitfall`),
no takeaway lecture, no recap of the investigation.

| Field | What it must answer for a reader who saw nothing else |
|---|---|
| **Issue** | What the user, test or tool actually saw. Name the screen, the copy or widget, and a concrete wrong value. |
| **Impact** | Why it mattered: what was blocked, and what still breaks if this does not ship. |
| **Cause** | The mechanism. Name the object, field, caller, lifecycle or flag that produced the Issue, not "we passed the wrong value". |
| **Fix** | What changed, where, and what pins it (test, fixture, assertion) so it cannot silently return. |

Match this density, not these facts:

```
**Issue:** After signing out and signing in with a second account, Profile showed the first
account's display name and avatar until the app restarted.

**Impact:** Any shared device leaks one user's profile to the next. Every keepAlive provider that
holds per-user data has the same exposure.

**Cause:** `ProfileController` is `@Riverpod(keepAlive: true)` and loaded the profile once in
`build()` with `ref.read(userRepositoryProvider)`. Nothing in `build()` depended on the signed-in
user, so sign-out never disposed or recomputed it.

**Fix:** `build()` now watches `userHandlerProvider` and returns an empty state when the user is
null. A ProviderContainer test signs in as A, signs out, signs in as B, and asserts B's name.
```

Too shallow: "Stale profile after sign-out. Provider was keepAlive. Watch the user." Too padded:
tagged bullets, first-principles definitions, or a list of files you opened.

## Depth rules

- Write for a senior Flutter reader. Do not define framework primitives. Keep the names that would
  fool a later reader: the field, the interpolating API, the assertion that looks at the wrong
  widget.
- If a field has nothing to say, this is the one-sentence nothing-to-learn case, not a hollow
  briefing.

## Persistence: traps only

After the briefing, invoke `.claude/skills/post-task-learning/SKILL.md` only when **Cause** or
**Fix** describes a trap: a failure mechanism a later edit of the same files would hit again, which
no test, rule or code comment now prevents. When the lesson can be enforced or stated as a rule, put
it in a check, the matching `.claude/rules` file, or a code comment instead. Most tasks log nothing.

That skill is the only writer to `docs/LEARNING_LOG.md` and owns the entry format.
