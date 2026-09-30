#!/usr/bin/env bash
# pdf.sh -- markdown -> typst -> PDF.
#
#   build/pdf.sh                 the whole book
#   build/pdf.sh --draft         + DRAFT watermark and per-chapter status stamps
#   build/pdf.sh --chapter 05    one chapter (always drafted)
#   build/pdf.sh --png           also render page 1 to PNG, for eyeballing the design
#
# pandoc and typst both ship inside Quarto and are not on PATH. Override with
# PANDOC= and TYPST= if they live somewhere else.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

QUARTO_TOOLS="${QUARTO_TOOLS:-/c/Users/TheDude/AppData/Local/Programs/Quarto/bin/tools}"
PANDOC="${PANDOC:-$QUARTO_TOOLS/pandoc.exe}"
TYPST="${TYPST:-$QUARTO_TOOLS/x86_64/typst.exe}"
PYTHON="${PYTHON:-python}"

[[ -x "$PANDOC" ]] || { echo "pdf.sh: no pandoc at $PANDOC" >&2; exit 2; }
[[ -x "$TYPST"  ]] || { echo "pdf.sh: no typst at $TYPST"  >&2; exit 2; }

draft=0; only=""; png=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --draft)   draft=1 ;;
    --chapter) only="${2:?--chapter needs a number, e.g. 05}"; draft=1; shift ;;
    --png)     png=1 ;;
    *) echo "pdf.sh: unknown argument $1" >&2; exit 2 ;;
  esac
  shift
done

mkdir -p out out/src

# ---------------------------------------------------------------- generated inputs
"$PYTHON" tools/gen_syntax.py --check || { echo "pdf.sh: regenerating syntax"; "$PYTHON" tools/gen_syntax.py; }
"$PYTHON" tools/gen_diagnostics.py
"$PYTHON" tools/gen_cli.py

# ---------------------------------------------------------------- input list
# SUMMARY.md is the order, so the site and the PDF cannot fall out of step. Every link
# in it of the form [Title](file.md) is a page, in the order mdBook reads them.
mapfile -t entries < <(sed -nE 's/.*\]\(([^)]+\.md)\).*/src\/\1/p' src/SUMMARY.md)

files=()
for f in "${entries[@]}"; do
  # The site's cover page is HTML; the PDF's cover is drawn by the typst template (B24).
  [[ "$f" == "src/cover.md" ]] && continue
  [[ -n "$only" && "$f" != *"/ch$only-"* ]] && continue
  [[ -f "$f" ]] || { echo "pdf.sh: skipping missing $f" >&2; continue; }
  if (( draft )); then
    dest="out/src/$(basename "$f")"
    # After the chapter title, not before it: a block ahead of the heading would take a
    # page of its own, because a level-1 heading starts one.
    awk -v f="$f" '
      NR == 1 && /^# / { print; print ""; print "```admonish warning title=\"Draft status\""; print f; print "```"; next }
      { print }
    ' "$f" > "$dest"
    files+=("$dest")
  else
    files+=("$f")
  fi
done
[[ ${#files[@]} -gt 0 ]] || { echo "pdf.sh: nothing to build" >&2; exit 2; }

# ---------------------------------------------------------------- admonitions
# pandoc cannot read mdbook-admonish fences (more than one word in the info string), so they
# are rewritten to fenced divs first; tools/filters/admonish.lua draws them. Every file goes
# through this, draft or not: without it each admonition prints as raw text.
mkdir -p out/prep
prepped=()
for f in "${files[@]}"; do
  dest="out/prep/$(basename "$f")"
  "$PYTHON" tools/prep_admonish.py "$f" > "$dest"
  prepped+=("$dest")
done
files=("${prepped[@]}")

# ---------------------------------------------------------------- markdown -> typst
args=(
  --from markdown+fenced_divs+fenced_code_attributes+footnotes+pipe_tables+smart
  --to typst
  --template template/book.typ
  --lua-filter tools/filters/mdbook_include.lua
  --lua-filter tools/filters/admonish.lua
  --metadata title="The tiko Programming Language" --metadata author="Paul Squires"
  --metadata syntax=../template/tiko.sublime-syntax
  --output out/book.typ
)
(( draft )) && args+=(--metadata draft=true)

"$PANDOC" "${args[@]}" "${files[@]}"

# ---------------------------------------------------------------- typst -> PDF
# NOT $( ((draft)) && echo … ): a false (( )) returns 1, and under `set -e` that kills the
# script -- silently, and only in a non-draft build.
suffix=""
(( draft )) && suffix="-draft"
out_pdf="out/the-tiko-programming-language${suffix}${only:+-ch$only}.pdf"
"$TYPST" compile --root . out/book.typ "$out_pdf"
echo "pdf.sh: wrote $out_pdf"

if (( png )); then
  # The first four pages, for eyeballing the design. typst 0.12 added --pages; the typst that
  # ships in Quarto today is 0.11, which rejects it, so there every page is rendered and the
  # ones past the fourth are deleted. {n} is zero-padded to the width of the page count.
  rm -f out/page-*.png
  if "$TYPST" compile --help 2>&1 | grep -q -- '--pages'; then
    "$TYPST" compile --root . --ppi 120 --pages 1-4 out/book.typ "out/page-{n}.png"
  else
    "$TYPST" compile --root . --ppi 120 out/book.typ "out/page-{n}.png"
    for png_file in out/page-*.png; do
      n="${png_file##*/page-}"; n="${n%.png}"
      if (( 10#$n > 4 )); then rm -f "$png_file"; fi
    done
  fi
  echo "pdf.sh: wrote out/page-*.png"
fi
