#!/bin/sh
# fetch-seed.sh -- download, verify and unpack the pinned seed compiler.
#
#   seed/fetch-seed.sh [--host windows|linux] [--dest <dir>] [--trust-on-first-use]
#
# Reads seed/seed.lock, downloads the asset with 'gh release download' from
# PaulSquires/tiko-lang, checks its sha256 BEFORE extracting, unpacks it into
# <dest>/<host> (default: seed/cache/<host>), and runs the seed's --version.
#
# Nothing is executed from the asset until its hash matches the lock. A lock line
# with sha256 TBD is refused unless --trust-on-first-use is given; the computed hash
# is then printed so it can be recorded.

set -e

HERE=$(cd "$(dirname "$0")" && pwd)
REPO=${TKO_SEED_REPO:-PaulSquires/tiko-lang}
HOST=""
DEST=""
TOFU=0
while [ $# -gt 0 ]; do
    case "$1" in
        --host) shift; HOST="$1" ;;
        --dest) shift; DEST="$1" ;;
        --trust-on-first-use) TOFU=1 ;;
        -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
        *) echo "fetch-seed: unknown argument '$1'" >&2; exit 2 ;;
    esac
    shift
done

fail( ) { echo "fetch-seed: FAILED -- $*" >&2; exit 1; }

if [ -z "$HOST" ]; then
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) HOST=windows ;;
        Linux)                HOST=linux ;;
        *) fail "unknown host $(uname -s); pass --host" ;;
    esac
fi
[ -n "$DEST" ] || DEST="$HERE/cache"

LINE=$(grep -v '^[[:space:]]*#' "$HERE/seed.lock" | awk -v h="$HOST" '$1 == h' | head -1)
[ -n "$LINE" ] || fail "seed.lock has no line for host '$HOST'"
set -- $LINE
TAG=$2; ASSET=$3; WANT=$4; COMMIT=$5

command -v gh > /dev/null 2>&1 || fail "gh (GitHub CLI) is required"
if command -v sha256sum > /dev/null 2>&1; then SHA="sha256sum"
elif command -v shasum > /dev/null 2>&1; then SHA="shasum -a 256"
else fail "no sha256sum or shasum"; fi

DL="$DEST/.download"
rm -rf "$DL"; mkdir -p "$DL"
echo "fetch-seed: $REPO $TAG $ASSET"
gh release download "$TAG" --repo "$REPO" --pattern "$ASSET" --dir "$DL" || fail "download failed"
[ -f "$DL/$ASSET" ] || fail "the release has no asset named $ASSET"

GOT=$($SHA "$DL/$ASSET" | cut -d' ' -f1)
if [ "$WANT" = "TBD" ]; then
    [ "$TOFU" = "1" ] || fail "seed.lock has no hash for $HOST (TBD); re-run with --trust-on-first-use and record: $GOT"
    echo "fetch-seed: TRUST ON FIRST USE -- record this in seed.lock: $GOT"
elif [ "$GOT" != "$WANT" ]; then
    fail "sha256 mismatch for $ASSET: lock says $WANT, the download is $GOT"
fi

OUTD="$DEST/$HOST"
rm -rf "$OUTD"; mkdir -p "$OUTD"
case "$ASSET" in
    *.zip)    ( cd "$OUTD" && unzip -q "$DL/$ASSET" ) ;;
    *.tar.gz) tar -xzf "$DL/$ASSET" -C "$OUTD" ;;
    *) fail "unknown archive type: $ASSET" ;;
esac
rm -rf "$DL"

# The archive holds one top-level directory (tiko-windows/ or tiko-linux/).
TOP=$(ls -1 "$OUTD" | head -1)
if [ -x "$OUTD/$TOP/tiko.exe" ]; then C="$OUTD/$TOP/tiko.exe"; else C="$OUTD/$TOP/bin/tiko"; fi
[ -x "$C" ] || fail "no compiler in the unpacked seed ($OUTD/$TOP)"
echo "fetch-seed: $($C --version 2>&1 | head -1)"
echo "fetch-seed: built from $COMMIT"
echo "fetch-seed: ok -- seed at $OUTD/$TOP"
echo "fetch-seed: build with it: TKO_SEED=$C build/build.sh  (or build/bootstrap.sh --seed $C)"
