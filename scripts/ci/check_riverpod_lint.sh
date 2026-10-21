#!/usr/bin/env bash
# Runs dart analyze with the riverpod_lint analyzer plugin (pinned under `plugins:` in
# analysis_options.yaml) and enforces scripts/ci/flutter_analyze_baseline.json on the result.
#
# A plugin that fails to load reports nothing, which would look like a clean run. To rule that out,
# a canary file that must trigger missing_provider_scope is analyzed in the same run; the check fails
# when the canary is not reported. The canary's own diagnostics are then removed and every remaining
# diagnostic, analyzer and riverpod_lint alike, goes through the baseline checker.
#
# Usage, from the repository root: bash scripts/ci/check_riverpod_lint.sh
set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$root" || exit 1

canary='lib/riverpod_lint_canary.dart'
if [ -e "$canary" ]; then
  echo "$canary already exists; remove it before running this check"
  exit 1
fi

out="$(mktemp)"
err="$(mktemp)"
rest="$(mktemp)"
trap 'rm -f "$canary" "$out" "$err" "$rest"' EXIT

cat > "$canary" <<'DART'
import 'package:flutter/widgets.dart';

void riverpodLintCanary() => runApp(const SizedBox());
DART

dart analyze --format=machine > "$out" 2> "$err"
status=$?
cat "$out"

# stderr is reported, never discarded. The analyzer writes nothing there on a healthy run, so any
# output (a plugin that failed to resolve or crashed, an analyzer exception) fails the check.
if [ -s "$err" ]; then
  echo "dart analyze wrote to stderr:" >&2
  cat "$err" >&2
  echo "dart analyze --format=machine wrote unexpected stderr (shown above)"
  exit 1
fi

# Exit 0-3 means analysis finished (none, info, warning, error); anything else is a crash.
if [ "$status" -gt 3 ]; then
  echo "dart analyze crashed (exit $status)"
  exit 1
fi

if ! grep -qiE "^[A-Z]+\|[A-Z_]+\|MISSING_PROVIDER_SCOPE\|[^|]*/$canary\|" "$out"; then
  echo "riverpod_lint did not report the canary: the analyzer plugin did not load"
  exit 1
fi
echo "riverpod_lint loaded: the canary reported missing_provider_scope"

grep -vE "^[A-Z]+\|[A-Z_]+\|[A-Z_]+\|[^|]*/$canary\|" "$out" > "$rest"

# The analyzer exit status covered the canary too, so it is checked above rather than passed on.
node scripts/ci/check_flutter_analyze_baseline.mjs "$rest"
