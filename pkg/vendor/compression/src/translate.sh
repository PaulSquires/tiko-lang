#!/bin/bash
# vendor/compression: regenerate the committed translations -- every ../*.ti and ../brotli/*.ti --
# from the six pinned source archives of ../fetch.toml. Run by hand on Windows from Git Bash
# when a pin changes or c2t improves; never by vendorfetch.sh or the build.
#
#     bash src/translate.sh <ARCHIVES> [TIKO]
#
# ARCHIVES is a directory holding the six archives under their own names (build/.vendorfetch/
# after 'sh build/vendorfetch.sh --module compression' has them); TIKO is the compiler whose c2t
# translates (default the tree's bin/tiko.exe). Three passes are made -- Windows; Linux against
# WSL's system headers (SYSROOT, default //wsl.localhost/Ubuntu); macOS against macos-libc/, a
# stand-in for Apple's (its README says why and how it is checked) -- each with --verify. The
# macOS pass is what makes every per-OS block end '#else' rather than '#elseif defined(
# TIKO_OS_LINUX)', which macOS and Android (neither Windows nor TIKO_OS_LINUX) would miss.
# Prints 'rc=<c2t exit> header TODOs' per header: 0 clean, 2 translated with TODOs, 1 failed.
#
# THE STEPS: unpack; prepare.py writes the headers c2t reads (five rewritten, the rest copied, all
# in one directory -- c2t writes a local '#include' as the path between the two headers); c2t
# translates each into the package, dependencies first (zconf before zlib, ints and ioapi before
# zip). The .ti files keep the C headers' names, so each banner names its header and SHA-256.
set -u
HERE=$(cd "$(dirname "$0")" && pwd); PKG=$(dirname "$HERE"); ROOT=$(cd "$PKG/../../.." && pwd)
ARC=$(cd "${1:?usage: translate.sh <ARCHIVES> [TIKO]}" && pwd); T=${2:-$ROOT/bin/tiko.exe}
SR=${SYSROOT:-//wsl.localhost/Ubuntu}
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
# Each archive is known by its top directory, not its file name (GitHub's are all v<version>).
for a in zlib-1.4 zstd-1.6.0 xz-5.8.4 brotli-1.2.1 lz4-1.11.1 bzip2-1.0.8; do
    f=$(for x in "$ARC"/*.tar.gz; do tar -tzf "$x" 2>/dev/null | head -1 | grep -q "^$a/" && echo "$x"; done | head -1)
    [ -f "$f" ] || { echo "translate.sh: no archive of $a in $ARC" >&2; exit 1; }
    tar -xzf "$f" -C "$W" --exclude='*/tests/*' --exclude='*/tests' || exit 1
done
python -I "$HERE/prepare.py" "$W" "$W/h" || exit 1
cd "$PKG" || exit 1
one( ) {  # one <header in $W/h> <output .ti> [c2t options]
    local name=$1 h=$W/h/$1 o=$2; shift 2; mkdir -p "$(dirname "$o")"
    "$T" c2t "$h" -o "$o" --sysroot "$SR" --macos-sysroot "$HERE/macos-libc" --verify "$@" > "$W/c2t.log" 2>&1; local rc=$?
    local n=$(grep -m1 -oE "^'' [0-9]+ items? needs? manual" "$o" 2>/dev/null | grep -oE "[0-9]+")
    echo "rc=$rc $name ${n:-0}"; [ $rc != 1 ] || tail -6 "$W/c2t.log"
}
one zconf.h zconf.ti
one zlib.h zlib.ti
one ints.h ints.ti
one ioapi.h ioapi.ti
one zip.h zip.ti
one unzip.h unzip.ti
one iowin32.h iowin32.ti
one zstd_errors.h zstd_errors.ti
one zstd.h zstd.ti
one zdict.h zdict.ti
# LZMA_API_IMPORT is dllimport in the Windows pass alone (no LZMA_API_STATIC); nothing to a
# caller's import of a function: defined away so the passes agree.
one lzma.h lzma.ti -D "LZMA_API_IMPORT="
for h in port types shared_dictionary decode encode; do one brotli/$h.h brotli/$h.ti -I "$W/h"; done
one lz4.h lz4.ti
one lz4hc.h lz4hc.ti
one lz4frame.h lz4frame.ti
one bzlib.h bzlib.ti
