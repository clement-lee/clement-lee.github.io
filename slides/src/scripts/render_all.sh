#!/usr/bin/env bash
# Best-effort batch render of every deck under src/. A single deck failing
# to render (expected for older decks — see slides/README.md) never stops
# the loop and, without --strict, never fails this script's exit status.
# CI runs this in best-effort mode: it is a verification signal only and
# never touches the committed slides/*.html|*.pdf files.
set -uo pipefail
cd "$(dirname "$0")/../.."   # -> slides/

strict=0
if [[ "${1:-}" == "--strict" ]]; then
  strict=1
fi

report=src/render-report.md
{
  echo "# Render report ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
  echo
  echo "| Deck | Status | Notes |"
  echo "|---|---|---|"
} > "$report"

pass=0
fail=0
skip=0
any_fail=0

# A missing LaTeX package can drop pdflatex into an interactive
# "Enter file name:" prompt instead of failing outright; with no stdin
# attached that hangs forever. A hard per-deck timeout guarantees one
# broken deck can never block the whole batch.
timeout_secs=180

skiplist=src/skip-render.txt

while IFS= read -r -d '' rmd; do
  name="${rmd#src/}"
  stem=$(basename "$rmd" .Rmd)
  srcdir=$(dirname "$rmd")

  # skip-render.txt entries are relative to src/ (e.g. "open-research/foo.Rmd")
  if [[ -f "$skiplist" ]] && grep -qxF "${rmd#src/}" "$skiplist"; then
    echo "| $name | skip | listed in skip-render.txt |" >> "$report"
    skip=$((skip + 1))
    continue
  fi

  log=$(mktemp)
  if timeout "${timeout_secs}s" Rscript src/scripts/render_one.R "$rmd" > "$log" 2>&1; then
    echo "| $name | pass | |" >> "$report"
    pass=$((pass + 1))
  else
    status=$?
    if [[ $status -eq 124 ]]; then
      note="timed out after ${timeout_secs}s"
    else
      note=$(tail -n 3 "$log" | tr '\n' ' ' | sed 's/|/\\|/g')
    fi
    echo "| $name | FAIL | $note |" >> "$report"
    fail=$((fail + 1))
    any_fail=1
  fi
  rm -f "$log"
  # Stray LaTeX intermediates can land in either the source dir or here,
  # depending on how far the compile got; never touch the real outputs.
  rm -f "${srcdir}/${stem}".aux "${srcdir}/${stem}".log "${srcdir}/${stem}".nav \
        "${srcdir}/${stem}".snm "${srcdir}/${stem}".toc "${srcdir}/${stem}".vrb \
        "${srcdir}/${stem}".out "${srcdir}/${stem}".tex \
        "${stem}".aux "${stem}".log "${stem}".nav "${stem}".snm "${stem}".toc \
        "${stem}".vrb "${stem}".out "${stem}".tex
done < <(find src -name '*.Rmd' -not -path 'src/_shared/*' -not -path 'src/renv/*' -print0 | sort -z)

{
  echo
  echo "**${pass} passed, ${fail} failed, ${skip} skipped**"
} >> "$report"

cat "$report"

if [[ "$strict" -eq 1 && "$any_fail" -eq 1 ]]; then
  exit 1
fi
exit 0
