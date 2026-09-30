#!/usr/bin/env bash
# site.sh -- build the mdBook site that is published to tiko-lang.net/book.
#
#   build/site.sh            build into book/
#   build/site.sh --serve    local preview with live reload
#
# mdbook is pinned to the 0.4 line: mdbook-admonish cannot run under 0.5.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

MDBOOK="${MDBOOK:-$HOME/.cargo/bin/mdbook.exe}"
PYTHON="${PYTHON:-python}"
[[ -x "$MDBOOK" ]] || { echo "site.sh: no mdbook at $MDBOOK (cargo install mdbook --version '^0.4')" >&2; exit 2; }

case "$("$MDBOOK" --version)" in
  *v0.4*) ;;
  *) echo "site.sh: mdbook must be 0.4.x; mdbook-admonish does not work under 0.5" >&2; exit 2 ;;
esac

# The generated inputs come from the compiler's own tables.
"$PYTHON" tools/gen_syntax.py
"$PYTHON" tools/gen_diagnostics.py
"$PYTHON" tools/gen_cli.py

if [[ "${1:-}" == "--serve" ]]; then
  exec "$MDBOOK" serve --open
fi

"$MDBOOK" build
echo "site.sh: wrote book/ -- publish this to tiko-lang.net/book"
