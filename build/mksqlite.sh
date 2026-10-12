#!/bin/sh
# mksqlite.sh -- SQLite as a static archive for one target, so fbsqlite links there.
#
#   build/mksqlite.sh <target> <lib-dir>
#
#   <target>   windows-x86_64 | linux-x86_64
#   <lib-dir>  where libsqlite3.a is written -- package.sh passes $OUT/lib/<target>
#
#   TKO_SQLITE  the fbsqlite repository (default: ../sqlite beside this repository),
#               which vendors the amalgamation in vendor/sqlite3/
#   TKO_CLANG   the C compiler (default: clang on PATH, else C:\Program Files\LLVM)
#   TKO_AR      the archiver   (default: llvm-ar, else ar)
#
# The last line printed starting 'mksqlite: ' is the one-line result package.sh puts
# in MANIFEST.txt. Exit 0 when the archive was written and checked, non-zero otherwise.
#
# WHY THIS EXISTS (T11, found writing the book). fbsqlite's '#inclib "sqlite3"' only
# ever resolved on -target win64, through the MinGW libsqlite3.a fbc-modern's tree
# carries in lib/win64-fb. Measured 2026-10-01:
#
#   windows-x86_64     lld-link: could not open 'sqlite3.lib' -- the default target could
#                  not link a single database program
#   linux-x86_64   no fbsqlite headers and no SQLite library in the toolchain at all,
#                  because fbc-modern-linux carries neither
#
# Built from the same amalgamation with the same options, both pass all 12 of
# fbsqlite's suites, 631 of 631 assertions -- the count -target win64 gives.
#
# WHY NOT COPY THE MinGW ARCHIVE: it carries MinGW CRT dependencies, and those must
# not be within reach of an MSVC -l -- the wrong runtime would resolve them. LinkExe
# resolves lib<name>.a in a search path before it asks lld-link for <name>.lib, so a
# COFF archive named libsqlite3.a in lib/windows-x86_64 is found -- the way libfbcunit.a is.
#
# THE MSVC OBJECT MUST NAME NO LIBRARIES. clang's MSVC mode embeds /DEFAULTLIB
# directives -- libcmt and oldnames by default, and uuid from a pragma in the Windows
# headers. tiko links windows-x86_64 with -nostdlib against ucrtbase and kernel32 only,
# precisely so that a reader needs no Visual Studio (toolchain.tiko, LinkExe), and a
# directive would reach straight back into one. -fms-omit-default-lib drops the CRT
# ones, WIN32_LEAN_AND_MEAN keeps the header that adds uuid out, and
# -fno-stack-protector avoids __security_cookie, which only VC's runtime defines.
# The archive is checked for a .drectve section below rather than trusted.
#
# THE OPTIONS ARE CHECKED IN THE RESULT, not assumed. The first Linux build of this
# lost every -D on its way through a quoted shell string, compiled cleanly, and
# failed only fbsqlite's two FTS5 assertions. So the archive must define FTS5 symbols.
set -eu

target=${1:?usage: mksqlite.sh <windows-x86_64|linux-x86_64> <lib-dir>}
libdir=${2:?usage: mksqlite.sh <windows-x86_64|linux-x86_64> <lib-dir>}

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SQLITE=${TKO_SQLITE:-$ROOT/../sqlite}
SRC="$SQLITE/vendor/sqlite3/sqlite3.c"
HDR="$SQLITE/vendor/sqlite3/sqlite3.h"

fail( ) { printf 'mksqlite: %s FAILED -- %s\n' "$target" "$1"; exit 1; }

[ -f "$SRC" ] || fail "no amalgamation at $SRC (set TKO_SQLITE to the fbsqlite repository)"

# The same options fbsqlite's own vendor/build_sqlite3.bat uses for the MinGW build,
# so every target links the same SQLite.
OPTS="-O2 -DNDEBUG -fno-strict-aliasing
 -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_COLUMN_METADATA -DSQLITE_ENABLE_FTS5
 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_MATH_FUNCTIONS -DSQLITE_ENABLE_STAT4
 -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_USE_URI=1 -DSQLITE_DEFAULT_FOREIGN_KEYS=0
 -DSQLITE_OMIT_DEPRECATED"

LLVM_BIN="/c/Program Files/LLVM/bin"
CC=${TKO_CLANG:-$( command -v clang 2>/dev/null || echo "$LLVM_BIN/clang.exe" )}
AR=${TKO_AR:-$( command -v llvm-ar 2>/dev/null || command -v ar 2>/dev/null || echo "$LLVM_BIN/llvm-ar.exe" )}
NM=$( command -v llvm-nm 2>/dev/null || command -v nm 2>/dev/null || echo "$LLVM_BIN/llvm-nm.exe" )
OBJDUMP=$( command -v llvm-objdump 2>/dev/null || echo "$LLVM_BIN/llvm-objdump.exe" )

case "$target" in
    windows-x86_64)
        TFLAGS="--target=x86_64-pc-windows-msvc -fms-omit-default-lib -fno-stack-protector -DWIN32_LEAN_AND_MEAN" ;;
    linux-x86_64)
        TFLAGS="-fPIC" ;;
    win64)
        # BUILT HERE since 2026-10-10, when lib/win64-fb -- whose MinGW libsqlite3.a this
        # target used -- left the toolchain. clang's MinGW target finds MinGW's C headers
        # the way its link finds MinGW's runtime: through the MinGW on PATH.
        TFLAGS="--target=x86_64-w64-windows-gnu" ;;
    *)  fail "no recipe for this target" ;;
esac

mkdir -p "$libdir"
tmp="$libdir/.mksqlite.$$"
rm -rf "$tmp"; mkdir -p "$tmp"
trap 'rm -rf "$tmp"' EXIT

# OPTS and TFLAGS are split on whitespace on purpose: none of them contains a space.
# shellcheck disable=SC2086
"$CC" $OPTS $TFLAGS -c "$SRC" -o "$tmp/sqlite3.o" >"$tmp/log" 2>&1 \
    || fail "compile failed: $( grep -m1 -i error "$tmp/log" | cut -c1-140 )"

if [ "$target" = "windows-x86_64" ] && [ -x "$OBJDUMP" ]; then
    if "$OBJDUMP" -h "$tmp/sqlite3.o" 2>/dev/null | grep -q drectve; then
        fail "the object still names a default library (.drectve) -- it would need Visual Studio"
    fi
fi

rm -f "$libdir/libsqlite3.a"
"$AR" rcs "$libdir/libsqlite3.a" "$tmp/sqlite3.o" || fail "archive not written ($AR)"

nfts=$( "$NM" "$libdir/libsqlite3.a" 2>/dev/null | grep -ci fts5 || true )
[ "${nfts:-0}" -gt 0 ] || fail "archive has no FTS5 symbols -- the -D options did not reach the compiler"

ver=$( sed -n 's/^#define SQLITE_VERSION  *"\([0-9.]*\)".*/\1/p' "$HDR" | head -1 )
size=$( wc -c < "$libdir/libsqlite3.a" | tr -d ' ' )
printf 'mksqlite: %s libsqlite3.a -- SQLite %s, %s bytes, FTS5 present\n' "$target" "${ver:-?}" "$size"
