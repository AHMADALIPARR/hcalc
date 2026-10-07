#!/usr/bin/env bash
# Copyright (C) 2026 HCALC contributors
# SPDX-License-Identifier: AGPL-3.0-only
# Per-command Alloy checks. Parse CLI stdout: "N. check NAME ... UNSAT|SAT"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
JAR="$ROOT/tools/org.alloytools.alloy.dist.jar"
ALS="$ROOT/HCALC.als"
OUT="$ROOT/logs/per-check-prod"
LOG="$ROOT/logs/alloy-check.txt"
mkdir -p "$OUT" "$ROOT/logs"

TS="$(date -Iseconds)"
{
  echo "=== HCALC Alloy PRODUCTION check ${TS} PT ==="
  echo "als: $ALS"
  java -jar "$JAR" version || true
  echo

  mapfile -t LINES < <(java -jar "$JAR" commands "$ALS" 2>/dev/null)

  PASS=0; FAIL=0; RUN_OK=0; RUN_BAD=0

  echo "=== checks (UNSAT = PASS) + runs (SAT = instance) ==="
  for line in "${LINES[@]}"; do
    KIND=""; CMD=""
    if [[ "$line" =~ Check[[:space:]]+([A-Za-z0-9_]+) ]]; then
      KIND=check; CMD="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ Run[[:space:]]+([A-Za-z0-9_]+) ]]; then
      KIND=run; CMD="${BASH_REMATCH[1]}"
    else
      continue
    fi
    o="$OUT/$CMD"
    rm -rf "$o"
    set +e
    # IMPORTANT: do not use -q; result is printed on stdout
    out=$(java -jar "$JAR" exec -f -o "$o" -t text -c "$CMD" "$ALS" 2>&1)
    rc=$?
    set -e
    # Match Alloy CLI summary line
    summary=$(echo "$out" | rg -o '[0-9]+\.\s+(check|run)\s+\S+.*' | tail -1 || true)
    if echo "$out" | rg -q '\bUNSAT\b'; then
      res=UNSAT
    elif echo "$out" | rg -q '\bSAT\b'; then
      res=SAT
    else
      res="UNKNOWN(rc=$rc)"
    fi

    if [[ "$KIND" == check ]]; then
      if [[ "$res" == UNSAT ]]; then
        printf '%-54s UNSAT (PASS)\n' "check $CMD"
        PASS=$((PASS+1))
      else
        printf '%-54s %s (FAIL)\n' "check $CMD" "$res"
        echo "$out" | tail -5
        FAIL=$((FAIL+1))
      fi
    else
      if [[ "$res" == SAT ]]; then
        printf '%-54s SAT (instance)\n' "run $CMD"
        RUN_OK=$((RUN_OK+1))
      else
        printf '%-54s %s\n' "run $CMD" "$res"
        RUN_BAD=$((RUN_BAD+1))
      fi
    fi
  done

  echo
  echo "=== summary ==="
  echo "checks_UNSAT_PASS=$PASS checks_FAIL=$FAIL runs_SAT=$RUN_OK runs_other=$RUN_BAD"
  echo "=== done ==="
  [[ "$FAIL" -eq 0 ]]
} 2>&1 | tee "$LOG"
