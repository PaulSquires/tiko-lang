#!/usr/bin/env bash
# site.sh -- build the tiko by Example mdBook site (published to tiko-lang.net/by-example).
#
#   build/site.sh            build into book/
#   build/site.sh --serve    local preview with live reload
#
# The highlighter, theme and callout styles are the book's: they are copied from
# ../book on every build so the two sites never drift. mdbook must be 0.4.x,
# because mdbook-admonish does not run under 0.5.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

MDBOOK="${MDBOOK:-$HOME/.cargo/bin/mdbook.exe}"
[[ -x "$MDBOOK" ]] || { echo "site.sh: no mdbook at $MDBOOK (cargo install mdbook --version '^0.4')" >&2; exit 2; }
case "$("$MDBOOK" --version)" in
  *v0.4*) ;;
  *) echo "site.sh: mdbook must be 0.4.x; mdbook-admonish does not work under 0.5" >&2; exit 2 ;;
esac

cp ../book/src/theme/tiko-highlight.js ../book/src/theme/tiko.css src/theme/
cp ../book/mdbook-admonish.css .

if [[ "${1:-}" == "--serve" ]]; then
  exec "$MDBOOK" serve --port 3021 --open
fi

"$MDBOOK" build
echo "site.sh: wrote book/ -- publish this to tiko-lang.net/by-example"
