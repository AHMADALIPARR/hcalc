#!/usr/bin/env bash
# Copyright (C) 2026 HCALC contributors
# SPDX-License-Identifier: AGPL-3.0-only
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
JAR="$ROOT/tools/org.alloytools.alloy.dist.jar"
ALS="$ROOT/HCALC.als"
OUT="$ROOT/logs/alloy-out"
LOG="$ROOT/logs/alloy-check.txt"
mkdir -p "$ROOT/logs"
if ! command -v java >/dev/null 2>&1; then
  echo "Java missing; cannot run Alloy CLI" | tee "$LOG"
  exit 1
fi
if [[ ! -f "$JAR" ]]; then
  echo "Missing Alloy jar at $JAR" | tee "$LOG"
  exit 1
fi
{
  echo "=== HCALC Alloy check $(date -Iseconds) ==="
  echo "als: $ALS"
  java -jar "$JAR" version || true
  echo
  echo "=== commands ==="
  java -jar "$JAR" commands "$ALS" || true
  echo
  echo "=== exec (all commands) ==="
  rm -rf "$OUT"
  java -jar "$JAR" exec -f -o "$OUT" -t text -q "$ALS" || true
  echo
  if [[ -f "$OUT/receipt.json" ]]; then
    echo "=== receipt.json (truncated) ==="
    head -c 50000 "$OUT/receipt.json"; echo
  fi
  find "$OUT" -type f 2>/dev/null | head -80 || true
  echo "=== done ==="
} 2>&1 | tee "$LOG"
