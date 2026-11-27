#!/bin/bash
# Build vendor/compression's libraries -- zlib 1.4 with its minizip, zstd 1.6.0, liblzma (xz
# 5.8.4), brotli 1.2.1, lz4 1.11.1 and bzip2 1.0.8, all in ONE static archive and ONE shared
# library -- from six pinned source archives. Run by build/vendorfetch.sh (the 'script' entries
# in ../fetch.toml), which downloads and verifies them and passes them as TIKO_VENDOR_INPUTS in
# that order. Measured in RFC-0006 P0 (claude-docs docs/tiko-vendor/probes/cp0/P0-RESULTS.md).
#
# WHY A SCRIPT AND NOT 'cbuild': one library from six archives; 'cbuild' takes one.
#
# PLAIN CLANG, NO CMAKE, NO AUTOTOOLS (RFC-0006 CP-9): a fixed source list per codec, each file
# compiled twice -- s/ for the archive, d/ for the shared library, whose export switches differ.
# liblzma's config.h is xz/config.h beside this script (xz's CMake defaults, written by hand), so
# none of xz's build machinery runs -- the autotools path the 2024 backdoor used (CVE-2024-3094)
# included. Every object is -O2 -DNDEBUG (without NDEBUG minizip's asserts put this build's path
# into the library).
#
# EXPORTS. Windows: each codec's own switch (ZLIB_DLL, ZSTD_DLL_EXPORT, DLL_EXPORT, BROTLI*_SHARED_
# COMPILATION, LZ4_DLL_EXPORT -- all __declspec, so Windows only), and for bzip2 and minizip, which
# have none, a generated .def: bzip2's libbz2.def plus every external minizip defines. Elsewhere by
# visibility: -fvisibility=hidden for zstd, liblzma, brotli and lz4, whose headers mark the API
# default; zlib's own HAVE_HIDDEN. xxHash is in both zstd and lz4, namespaced apart (ZSTD_XXH*,
# LZ4_XXH*) and exported by neither.
#
# WINDOWS: A tiko program links ucrtbase.dll and KERNEL32.dll alone -- no Visual Studio -- so the
# archive may need nothing else. zlib's gz* and bzip2's BZ2_bzopen are compiled against the _-named
# POSIX calls ucrtbase exports (the bare names live only in VS's oldnames.lib), and minizip's
# setjmp is clang's builtin (win/builtin-setjmp.h). The build CHECKS it: every symbol the archive
# needs from outside must be an export of ucrtbase or kernel32 (tiko's lib/implib), or it fails.
# The DLL links clang's static C runtime and imports KERNEL32 alone, as every vendor DLL does.
#
# THE COMPILER is chosen as vendorfetch chooses its own: TIKO_CLANG, else the LLVM install on
# Windows, else clang on PATH. TIKO_AR and TIKO_NM likewise.
#
# Output: bin/<os>-<arch>/ beside this script -- compression_<os>_<arch>.a, and compression.dll
# or compression_<os>_<arch>.so; each fetch.toml entry copies one. Built in a scratch directory; a
# finished build is kept in TIKO_VENDOR_CACHE and copied, not redone. Incremental: a stamp of the
# inputs, this script, xz/config.h and win/builtin-setjmp.h.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../../.." && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
ARCH=${TIKO_VENDOR_ARCH:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
die( ) { echo "compression build: $*" >&2; exit 1; }
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 6 ] || die "expected 6 inputs (zlib, zstd, xz, brotli, lz4, bzip2), got $#"

HID=-fvisibility=hidden; WIN=0; SHF=; LIBS=
case $HOST-$ARCH in
    windows-x86_64)
        CC=${TIKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}; T=x86_64-pc-windows-msvc; WIN=1
        BASE="-O2 -DNDEBUG -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS"; HID=
        SH=compression.dll ;;
    linux-x86_64)
        CC=${TIKO_CLANG:-${CLANG:-clang}}; T=x86_64-pc-linux-gnu
        BASE="-O2 -DNDEBUG -fPIC"
        SH=compression_linux_x86_64.so; SHF="-shared -Wl,-soname,$SH"; LIBS="-lm -lpthread" ;;
    *) die "no build for '$HOST-$ARCH' yet (RFC-0006 P2: Linux arm64, macOS, Android)" ;;
esac
LLVMBIN=$(dirname "$CC")
if [ -n "$TIKO_AR" ]; then AR=$TIKO_AR
elif [ $WIN = 1 ]; then AR="$LLVMBIN/llvm-ar.exe"
else AR=$(command -v llvm-ar || command -v ar); fi
if [ -n "$TIKO_NM" ]; then NM=$TIKO_NM
elif [ $WIN = 1 ]; then NM="$LLVMBIN/llvm-nm.exe"
else NM=$(command -v llvm-nm || command -v nm); fi
ST=compression_${HOST}_$ARCH.a
OUT=$HERE/bin/$HOST-$ARCH
WANT="$ST $SH"

STAMP=$( { for i in "$@"; do basename "$i"; done; cat "$0" "$HERE/xz/config.h" "$HERE/win/builtin-setjmp.h"; echo "$HOST-$ARCH"; } | sha256sum | cut -c1-16 )
have=1; for f in $WANT; do [ -f "$OUT/$f" ] || have=0; done
[ "$have" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
D=$CACHE/compression-$HOST-$ARCH
cached=1; for f in $WANT; do [ -f "$D/$f" ] || cached=0; done
if [ "$cached" = 1 ] && [ "$(cat "$D/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"; for f in $WANT; do cp -f "$D/$f" "$OUT/$f"; done; echo "$STAMP" > "$OUT/.stamp"; exit 0
fi

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
# Only what is compiled: zstd 1.6.0's archive holds a test symlink Git Bash's tar cannot make.
for a in "$@"; do tar -xzf "$a" -C "$W" --exclude='*/tests/*' --exclude='*/tests' || die "cannot unpack $(basename "$a")"; done
src( ) { d=$(find "$W" -mindepth 1 -maxdepth 1 -type d -name "$1-*" | head -1); [ -d "$d" ] || die "no $1-* in the inputs"; printf '%s\n' "$d"; }
Z=$(src zlib); ZD=$(src zstd)/lib; X=$(src xz)/src; B=$(src brotli)/c; L=$(src lz4)/lib; BZ=$(src bzip2)
MZ=$Z/contrib/minizip
mkdir -p "$W/s" "$W/d"

win( ) { [ $WIN = 1 ] && echo "$*"; }
# compile CODEC DIR "SOURCES" "COMMON FLAGS" "ARCHIVE-ONLY FLAGS" "SHARED-ONLY FLAGS"
compile( ) {
    local codec=$1 dir=$2 srcs=$3 common=$4 sflags=$5 dflags=$6 f o
    for f in $srcs; do
        o=${codec}__$(echo "$f" | tr '/' '_' | sed 's/\.c$//').o
        # shellcheck disable=SC2086
        "$CC" --target=$T $BASE $common $sflags -c "$dir/$f" -o "$W/s/$o" || die "compiling $codec $f failed"
        # shellcheck disable=SC2086
        "$CC" --target=$T $BASE $common $dflags -c "$dir/$f" -o "$W/d/$o" || die "compiling $codec $f (shared) failed"
    done
}

# zlib + minizip. POSIX: the _ names on Windows (above).
ZS="adler32.c compress.c crc32.c deflate.c gzclose.c gzlib.c gzread.c gzwrite.c infback.c inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c"
if [ $WIN = 1 ]; then
    compile zlib "$Z" "$ZS" "-I$Z -Dopen=_open -Dread=_read -Dwrite=_write -Dclose=_close" "" "-DZLIB_DLL"
else
    compile zlib "$Z" "$ZS" "-I$Z -DHAVE_HIDDEN -DHAVE_UNISTD_H -D_LARGEFILE64_SOURCE=1" "" ""
fi
# minizip sees zlib.h without ZLIB_DLL: its zlib calls are inside the same library.
MZS="ioapi.c unzip.c zip.c"; [ $WIN = 1 ] && MZS="$MZS iowin32.c"
compile minizip "$MZ" "$MZS" "-I$Z -I$MZ $(win -include "$HERE/win/builtin-setjmp.h")" "" ""
# zstd: no legacy formats (pre-0.8, 2016), single-threaded, the C Huffman decoder (the .S is
# GAS-only; P0 measured the asm at 5-10% faster decompression on Linux).
ZSTDS=$(cd "$ZD" && ls common/*.c compress/*.c decompress/*.c dictBuilder/*.c)
compile zstd "$ZD" "$ZSTDS" "-I$ZD -I$ZD/common -DZSTD_DISABLE_ASM -DZSTD_LEGACY_SUPPORT=0 -DXXH_NAMESPACE=ZSTD_ $HID" "" "$(win -DZSTD_DLL_EXPORT=1)"
# liblzma: every check, filter and match finder, the lzip decoder, threads (xz/config.h).
XS=$(cd "$X" && ls liblzma/common/*.c liblzma/check/*.c liblzma/lz/*.c liblzma/lzma/*.c liblzma/rangecoder/*.c liblzma/delta/*.c liblzma/simple/*.c \
     | grep -v -e tablegen -e _small.c -e crc_clmul_consts_gen)
XS="$XS common/tuklib_physmem.c common/tuklib_cpucores.c"
XI="-DHAVE_CONFIG_H -I$HERE/xz -I$X/liblzma/api -I$X/liblzma/common -I$X/liblzma/check -I$X/liblzma/lz -I$X/liblzma/rangecoder -I$X/liblzma/lzma -I$X/liblzma/delta -I$X/liblzma/simple -I$X/common"
compile lzma "$X" "$XS" "$XI $HID" "-DLZMA_API_STATIC" "$(win -DDLL_EXPORT)"
# brotli
BS=$(cd "$B" && ls common/*.c dec/*.c enc/*.c)
compile brotli "$B" "$BS" "-I$B/include $HID" "" "-DBROTLI_SHARED_COMPILATION -DBROTLICOMMON_SHARED_COMPILATION -DBROTLIDEC_SHARED_COMPILATION -DBROTLIENC_SHARED_COMPILATION"
# lz4: block, HC and frame APIs; not lz4file.c (FILE * across a DLL boundary -- see the module).
compile lz4 "$L" "lz4.c lz4hc.c lz4frame.c xxhash.c" "-I$L -DXXH_NAMESPACE=LZ4_ $HID" "" "$(win -DLZ4_DLL_EXPORT=1)"
# bzip2
compile bzip2 "$BZ" "blocksort.c huffman.c crctable.c randtable.c compress.c decompress.c bzlib.c" \
    "-I$BZ -D_FILE_OFFSET_BITS=64 $(win -Dfdopen=_fdopen -Dsetmode=_setmode -Dfileno=_fileno)" "" ""

cd "$W"
"$AR" rcs "$ST" s/*.o || die "archiving failed"

# What the archive needs from outside itself; on Windows, ucrtbase's and kernel32's exports only.
if [ $WIN = 1 ]; then
    IMP=$ROOT/lib/implib
    [ -f "$IMP/ucrtbase.def" ] && [ -f "$IMP/kernel32.def" ] || die "no $IMP/{ucrtbase,kernel32}.def"
    "$NM" --extern-only --defined-only s/*.o 2>/dev/null | awk 'NF==3 {print $3}' | sort -u > defined.txt
    "$NM" --undefined-only s/*.o 2>/dev/null | awk '$1=="U" {print $2}' | sort -u | comm -23 - defined.txt > needs.txt
    for f in ucrtbase kernel32; do sed -n '/^EXPORTS/,$p' "$IMP/$f.def" | tail -n +2; done \
        | tr -d '\r' | awk '{print $1}' | sed 's/@.*//' | sort -u > crt.txt
    # an __imp_X calls DLL export X; _fltused and __chkstk are tiko-rt's own (msvccrt.c)
    MISS=$(sed 's/^__imp_//' needs.txt | grep -v -e '^_fltused$' -e '^__chkstk$' | sort -u | comm -23 - crt.txt | tr '\n' ' ')
    [ -z "$MISS" ] || die "the archive needs what ucrtbase.dll and KERNEL32.dll do not export: $MISS"
fi

if [ $WIN = 1 ]; then
    { echo "EXPORTS"; sed -n '/^EXPORTS/,$p' "$BZ/libbz2.def" | tail -n +2 | tr -d '\r' | sed 's/^[ \t]*//' | grep -v '^$';
      "$NM" --extern-only --defined-only d/minizip__*.o | awk 'NF==3 && $3 ~ /^[A-Za-z_][A-Za-z0-9_]*$/ {print $3}' | sort -u; } > compression.def
    # The import library and .exp stay here: beside the DLL, '#foreignlib ... dynamic' would
    # find the .lib first. -implib:, not /implib: -- MSYS would rewrite a leading slash.
    "$CC" --target=$T -shared -fuse-ld=lld -o "$SH" -Wl,-def:compression.def \
        -Wl,-implib:"$(cygpath -m "$W" 2>/dev/null || printf '%s' "$W")/compression.lib" d/*.o || die "linking $SH failed"
else
    # shellcheck disable=SC2086
    "$CC" --target=$T $SHF -o "$SH" d/*.o $LIBS || die "linking $SH failed"
fi
mkdir -p "$D" "$OUT"
for f in $WANT; do [ -f "$f" ] || die "made no $f"; cp -f "$f" "$D/$f"; cp -f "$f" "$OUT/$f"; done
echo "$STAMP" > "$D/.stamp"; echo "$STAMP" > "$OUT/.stamp"
