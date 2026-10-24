#!/bin/bash
# relbuild.sh <tree> <out.exe> <mirror> -- a Release tiko for corpus runs, leaving <tree> alone.
# -O 2 without -exx: about 8x faster than Debug over an AfxNova file (1.4s vs 12s).
#
# BUILT FROM A MIRROR of <tree>'s src/, pkg/ and inc/: build.sh leaves its intermediates
# beside the sources, so two builds of one tree collide. From the mirror this can run AT THE
# SAME TIME as the tree's own Debug build (build/gate.sh does).
#
# EXITS NONZERO when the build fails or leaves no binary -- the copy this replaced
# (~/.claude/tiko-gate/relbuild.sh) filtered the build through 'grep | head' and always
# exited 0.
set -o pipefail
TREE=$1 OUT=$2 MIRROR=$3
[ -n "$MIRROR" ] || { echo "relbuild: usage: relbuild.sh <tree> <out.exe> <mirror>" >&2; exit 2; }
mkdir -p "$MIRROR/build"
mirror( ) {
    MSYS_NO_PATHCONV=1 robocopy "$(cygpath -w "$TREE/$1")" "$(cygpath -w "$MIRROR/$1")" \
        /MIR /XF *.o *.asm *.c /NFL /NDL /NJH /NJS /NP > /dev/null
    [ $? -lt 8 ]    # robocopy: 0-7 is success
}
mirror src || exit 1
mirror pkg || exit 1
mirror inc || exit 1
cp "$TREE/build/sources.txt" "$TREE/build/build.sh" "$MIRROR/build/" || exit 1
# THE SEED IS build.sh's DEFAULT STAGE0, found relative to the tree by defaultseed.sh -- and
# the mirror has no seed/ or toolchains/ of its own, so the TREE's choice is handed over.
[ -f "$TREE/build/defaultseed.sh" ] && cp "$TREE/build/defaultseed.sh" "$MIRROR/build/"
if [ -z "${TKO_SEED:-}" ] && [ -f "$TREE/build/defaultseed.sh" ]; then
    . "$TREE/build/defaultseed.sh"
    TKO_SEED=$(default_seed "$TREE" 1) && export TKO_SEED
fi
cd "$MIRROR" || exit 1
rm -f bin/tiko.exe "$OUT"
TKO_EDITOR_DIR=/c/nonexistent bash build/build.sh Release --no-dll > "$MIRROR/release.log" 2>&1
rc=$?
if [ "$rc" != "0" ] || [ ! -f bin/tiko.exe ]; then
    grep -E " error |error [0-9]+:|did not compile" "$MIRROR/release.log" | head -5
    echo "relbuild: Release build failed (exit $rc, $MIRROR/release.log)" >&2
    exit 1
fi
cp -f bin/tiko.exe "$OUT"
