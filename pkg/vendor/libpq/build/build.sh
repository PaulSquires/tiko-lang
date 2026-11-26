#!/bin/bash
# Build vendor/libpq's libraries -- PostgreSQL's client library with OpenSSL folded in, static
# and hidden (claude-docs docs/tiko-vendor RFC-0003 DB-3, DB-10) -- from the pinned sources. Run
# by build/vendorfetch.sh ('script' entries in ../fetch.toml), which downloads and verifies them
# and passes them as TIKO_VENDOR_INPUTS, in this order:
#
#   openssl  postgresql
#
# Neither project publishes what a tiko program can link, so every host builds:
#   1. OpenSSL, STATIC ONLY ('no-shared'): its VC targets then compile /MT /Zl -- the static C
#      runtime, no default library named -- where a shared build is /MD and imports VCRUNTIME140
#      (RFC-0003 P0, F7). Windows: VC-WIN64A with clang-cl and NASM; Linux: gcc, -fPIC.
#   2. libpq with Meson and Ninja, every optional feature off but OpenSSL, only libpq's targets
#      built. Windows: MSVC's cl, NOT clang-cl -- PostgreSQL's Meson applies its MSVC setup (the
#      win32_msvc headers: dirent.h, unistd.h) only when the compiler id is 'msvc' (P0, F6).
#      Meson's configure wants flex and bison although libpq uses neither.
#   3. The SHARED LIBRARY. Windows: Meson's libpq.dll, which links the static OpenSSL in, /MT --
#      it imports only system DLLs. Linux: linked here, not by Meson, so its soname is its own
#      file name (libpq_linux_x86_64.so; a Meson build names itself libpq.so.5) and only libpq's
#      API is exported (Meson's exports.list): OpenSSL is inside and invisible.
#   4. The STATIC ARCHIVE: libpq.a with what it needs and Meson leaves apart -- PostgreSQL's
#      libpgcommon_shlib.a and libpgport_shlib.a, then libssl and libcrypto -- merged into one
#      (P0, F9). A program linking it on Windows also needs ws2_32, secur32, crypt32, advapi32,
#      user32 and shell32 (../libpq.tiko names them) and tiko's runtime's _onexit (DB-11).
#
# Host tools beyond vendorfetch's: Windows -- Visual Studio's C tools (vcvars64.bat), Meson and
# Ninja, a NATIVE Perl (Strawberry: OpenSSL's Configure refuses MSYS perl for VC targets), NASM,
# win_flex / win_bison (WinFlexBison); Linux -- gcc, make, perl, meson >= 0.57.2, ninja, flex,
# bison. TIKO_VCVARS, TIKO_PERL_DIR, TIKO_NASM_DIR and TIKO_FLEXBISON_DIR override where the
# Windows ones are looked for.
#
# Output: bin/<host>/ beside this script -- Windows libpq.dll and libpq_windows_x86_64.a; Linux
# libpq_linux_x86_64.so and libpq_linux_x86_64.a. The build trees live under TIKO_VENDOR_CACHE
# (OpenSSL's Windows build is about half an hour: nmake is serial). Incremental: a stamp of the
# inputs and this script; a finished build in the cache is copied, not redone.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 2 ] || { echo "libpq: expected 2 inputs, got $#" >&2; exit 1; }
SRC_OSSL=$1; SRC_PG=$2

case $HOST in
    windows) ARCH=x86_64 ;;
    linux)   ARCH=${TIKO_VENDOR_ARCH:-x86_64}
             [ "$ARCH" = x86_64 ] || { echo "libpq: linux-$ARCH is not built yet (RFC-0003 P4)" >&2; exit 1; } ;;
    *) echo "libpq: host '$HOST' is not built yet (RFC-0003 P4)" >&2; exit 1 ;;
esac
OUT=$HERE/bin/$HOST
case $HOST in
    windows) OUTS="$OUT/libpq.dll $OUT/libpq_windows_x86_64.a" ;;
    linux)   OUTS="$OUT/libpq_linux_$ARCH.so $OUT/libpq_linux_$ARCH.a" ;;
esac

digest() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi; }
STAMP=$( { for f in "$@"; do basename "$f"; done; cat "$0"; echo "$HOST $ARCH"; } | digest | cut -c1-16 )
fresh=1
for o in $OUTS; do [ -f "$o" ] || fresh=0; done
[ "$fresh" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
W=$CACHE/libpq-$HOST-$ARCH
if [ "$(cat "$W/done/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"
    for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
    echo "$STAMP" > "$OUT/.stamp"
    exit 0
fi

command -v meson >/dev/null || [ -x "C:/Program Files/Meson/meson.exe" ] || { echo "libpq: meson is not on PATH" >&2; exit 1; }
rm -rf "$W"; mkdir -p "$W/src" "$W/done"
LOG=$W/build.log
: > "$LOG"
tar -xzf "$SRC_OSSL" -C "$W/src"
tar -xjf "$SRC_PG" -C "$W/src"
S_OSSL=$(ls -d "$W"/src/openssl-*); S_PG=$(ls -d "$W"/src/postgresql-*)
fail() { echo "libpq: $1 failed -- $LOG" >&2; tail -25 "$LOG" >&2; exit 1; }

if [ "$HOST" = windows ]; then
    winpath() { cygpath -w "$1"; }
    VCVARS=${TIKO_VCVARS:-$("C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath 2>/dev/null | tr -d '\r')\\VC\\Auxiliary\\Build\\vcvars64.bat}
    PERLD=${TIKO_PERL_DIR:-C:\\Strawberry\\perl\\bin}
    NASMD=${TIKO_NASM_DIR:-$(winpath "$LOCALAPPDATA")\\bin\\NASM}
    # winget's own Links directory may hold no win_flex at all (measured: empty), so the package
    # directory it unpacked WinFlexBison into is looked for instead.
    FBD=${TIKO_FLEXBISON_DIR:-$(ls -d "$LOCALAPPDATA"/Microsoft/WinGet/Packages/WinFlexBison* 2>/dev/null | head -1)}
    [ -n "$FBD" ] && [ -f "$FBD/win_flex.exe" ] || { echo "libpq: no win_flex.exe (WinFlexBison; set TIKO_FLEXBISON_DIR)" >&2; exit 1; }
    FBD=$(winpath "$FBD")
    OSSL=$W/ossl
    # One batch file per step: vcvars64's environment is cmd's, and MSYS would rewrite the
    # /-options of every tool if they were run from here.
    cat > "$W/ossl.bat" <<EOF
@echo off
call "$VCVARS" >nul || exit /b 1
set PATH=$PERLD;$NASMD;C:\\Program Files\\LLVM\\bin;%PATH%
cd /d $(winpath "$S_OSSL") || exit /b 1
perl Configure VC-WIN64A CC=clang-cl no-shared no-tests no-docs --prefix=$(winpath "$OSSL") --openssldir=$(winpath "$OSSL")\\ssl || exit /b 1
nmake /nologo build_libs || exit /b 1
EOF
    cmd //c "$(winpath "$W/ossl.bat")" >> "$LOG" 2>&1 || fail "OpenSSL"
    # NOT 'nmake install_dev': it copies ossl_static.pdb, which clang-cl's /Zi /Fd never writes
    # ("Can't Open ossl_static.pdb", measured). The headers are the source tree's include/ --
    # an in-tree build generates its configured ones there -- and the two archives its root's.
    mkdir -p "$OSSL/lib"
    cp -f "$S_OSSL/libssl.lib" "$S_OSSL/libcrypto.lib" "$OSSL/lib/"
    cp -rf "$S_OSSL/include" "$OSSL/include"
    # The system libraries static OpenSSL needs, for Meson's link checks and libpq.dll's link.
    SYSLIBS="ws2_32.lib crypt32.lib user32.lib advapi32.lib"
    cat > "$W/pq.bat" <<EOF
@echo off
call "$VCVARS" >nul || exit /b 1
set PATH=$PERLD;C:\\Program Files\\Meson;$FBD;%PATH%
set CC=cl
cd /d $(winpath "$S_PG") || exit /b 1
meson setup $(winpath "$W/b") --buildtype=release --auto-features=disabled -Dssl=openssl -Db_vscrt=mt ^
  -Dextra_include_dirs=$(winpath "$OSSL")\\include -Dextra_lib_dirs=$(winpath "$OSSL")\\lib ^
  -DFLEX=win_flex -DBISON=win_bison -Dtap_tests=disabled -Ddocs=disabled ^
  "-Dc_link_args=$SYSLIBS" || exit /b 1
ninja -C $(winpath "$W/b") src/interfaces/libpq/libpq.dll src/interfaces/libpq/libpq.a || exit /b 1
EOF
    cmd //c "$(winpath "$W/pq.bat")" >> "$LOG" 2>&1 || fail "libpq (Meson)"
    L=$W/b/src/interfaces/libpq
    cp -f "$L/libpq.dll" "$W/done/libpq.dll"
    # THE DLL MUST NOT NEED OPENSSL'S: a libssl/libcrypto import means Meson found shared ones.
    if llvm-readobj --coff-imports "$W/done/libpq.dll" | grep -qi 'libssl\|libcrypto\|vcruntime'; then
        echo "libpq: libpq.dll imports OpenSSL or VCRUNTIME -- not self-contained" >&2; exit 1
    fi
    llvm-lib /out:"$(winpath "$W/done/libpq_windows_x86_64.a")" "$(winpath "$L/libpq.a")" \
        "$(winpath "$W/b/src/common/libpgcommon_shlib.a")" "$(winpath "$W/b/src/port/libpgport_shlib.a")" \
        "$(winpath "$OSSL/lib/libssl.lib")" "$(winpath "$OSSL/lib/libcrypto.lib")" >> "$LOG" 2>&1 || fail "the merged archive"
else
    J=$(nproc 2>/dev/null || echo 4)
    OSSL=$W/ossl
    ( cd "$S_OSSL" && ./Configure linux-x86_64 no-shared no-tests no-docs -fPIC --prefix="$OSSL" --libdir=lib \
        && make -j"$J" build_libs && make install_dev ) >> "$LOG" 2>&1 || fail "OpenSSL"
    ( cd "$S_PG" && meson setup "$W/b" --buildtype=release --auto-features=disabled -Dssl=openssl \
        -Dextra_include_dirs="$OSSL/include" -Dextra_lib_dirs="$OSSL/lib" \
        -Dtap_tests=disabled -Ddocs=disabled \
        && ninja -C "$W/b" src/interfaces/libpq/libpq.a src/interfaces/libpq/exports.list \
             src/common/libpgcommon_shlib.a src/port/libpgport_shlib.a ) >> "$LOG" 2>&1 || fail "libpq (Meson)"
    L=$W/b/src/interfaces/libpq
    SO=libpq_linux_$ARCH.so
    gcc -shared -o "$W/done/$SO" -Wl,-soname,"$SO" -Wl,--version-script="$L/exports.list" \
        -Wl,--whole-archive "$L/libpq.a" -Wl,--no-whole-archive \
        "$W/b/src/common/libpgcommon_shlib.a" "$W/b/src/port/libpgport_shlib.a" \
        "$OSSL/lib/libssl.a" "$OSSL/lib/libcrypto.a" -lm -Wl,-z,defs >> "$LOG" 2>&1 || fail "the shared library"
    # THE VERSION SCRIPT IS WHAT HIDES OPENSSL: everything it does not name is local. NOT
    # --exclude-libs,ALL, which also hides the whole-archive libpq.a -- a library exporting
    # nothing at all (measured).
    nm -D --defined-only "$W/done/$SO" > "$W/exports.txt"
    grep -q ' PQconnectdb$' "$W/exports.txt" || { echo "libpq: $SO does not export PQconnectdb" >&2; exit 1; }
    if grep -q ' SSL_\| EVP_' "$W/exports.txt"; then
        echo "libpq: $SO exports OpenSSL" >&2; exit 1
    fi
    printf 'CREATE %s\nADDLIB %s\nADDLIB %s\nADDLIB %s\nADDLIB %s\nADDLIB %s\nSAVE\nEND\n' \
        "$W/done/libpq_linux_$ARCH.a" "$L/libpq.a" "$W/b/src/common/libpgcommon_shlib.a" \
        "$W/b/src/port/libpgport_shlib.a" "$OSSL/lib/libssl.a" "$OSSL/lib/libcrypto.a" | ar -M >> "$LOG" 2>&1 || fail "the merged archive"
fi

mkdir -p "$OUT"
for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
echo "$STAMP" > "$W/done/.stamp"
echo "$STAMP" > "$OUT/.stamp"
