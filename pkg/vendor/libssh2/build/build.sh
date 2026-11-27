#!/bin/bash
# Build vendor/libssh2's libraries -- libssh2 with OpenSSL's libcrypto folded in, static and
# hidden (claude-docs docs/tiko-vendor RFC-0004 FT-4, FT-11) -- from the pinned sources. Run by
# build/vendorfetch.sh ('script' entries in ../fetch.toml), which downloads and verifies them and
# passes them as TIKO_VENDOR_INPUTS, in this order:
#
#   openssl  libssh2
#
# The crypto backend is OpenSSL on every host: Windows' own (WinCNG) has no ed25519, no
# curve25519 and reads no OpenSSH-format private key, which is what ssh-keygen writes (RFC-0004
# P0 section 2). OpenSSL is not a module of its own (RFC-0003 DB-3 as revised): each library that
# needs it carries it inside.
#
#   1. OpenSSL, STATIC ONLY ('no-shared'): its VC targets then compile /MT /Zl -- the static C
#      runtime, no default library -- where a shared build is /MD and imports VCRUNTIME140.
#      Windows: VC-WIN64A with clang-cl and NASM; Linux: gcc, -fPIC. The same Configure lines as
#      vendor/libpq's. libssh2 needs libcrypto only.
#   2. libssh2 with clang (Windows) / gcc (Linux) over src/*.c -- no CMake. libssh2_setup.h has a
#      hand-written Windows config, and elsewhere, with no HAVE_CONFIG_H, defines nothing: the
#      -D flags below ARE the Linux config (P0 section 3).
#   3. The SHARED LIBRARY. Windows: libssh2.dll, exporting what libssh2.h dllexports
#      (LIBSSH2_EXPORTS; libssh2_priv.h defines LIBSSH2_LIBRARY itself) and nothing of
#      OpenSSL's, linked with the static CRT, as tiko links. Linux: libssh2_linux_x86_64.so,
#      its soname its own file name, a version script exporting libssh2_* alone -- OpenSSL is
#      inside and invisible. (So Linux also exports four names libssh2.h does not mark
#      LIBSSH2_API: libssh2_sign_sk -- declared there without it, so libssh2.dll lacks it --
#      and three internal ones.)
#   4. The STATIC ARCHIVE: libssh2's objects and libcrypto merged into one. A program linking it
#      on Windows also needs ws2_32, crypt32, user32 and advapi32 (../libssh2.tiko names them) and
#      tiko's runtime's _onexit (RFC-0003 DB-11: OpenSSL's crypto/init.c calls it).
#
# Host tools beyond vendorfetch's: Windows -- Visual Studio's C tools (vcvars64.bat, for nmake
# and OpenSSL's link checks), a NATIVE Perl (Strawberry: OpenSSL's Configure refuses MSYS perl
# for VC targets), NASM, LLVM; Linux -- gcc, make, perl. TIKO_VCVARS, TIKO_PERL_DIR and
# TIKO_NASM_DIR override where the Windows ones are looked for.
#
# Output: bin/<host>/ beside this script -- Windows libssh2.dll and libssh2_windows_x86_64.a;
# Linux libssh2_linux_x86_64.so and libssh2_linux_x86_64.a. The build trees live under
# TIKO_VENDOR_CACHE (OpenSSL's Windows build is about half an hour: nmake is serial).
# Incremental: a stamp of the inputs and this script; a finished build in the cache is copied.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 2 ] || { echo "libssh2: expected 2 inputs, got $#" >&2; exit 1; }
SRC_OSSL=$1; SRC_SSH2=$2

case $HOST in
    windows) ARCH=x86_64 ;;
    linux)   ARCH=${TIKO_VENDOR_ARCH:-x86_64}
             [ "$ARCH" = x86_64 ] || { echo "libssh2: linux-$ARCH is not built yet (RFC-0004 P3)" >&2; exit 1; } ;;
    *) echo "libssh2: host '$HOST' is not built yet (RFC-0004 P3)" >&2; exit 1 ;;
esac
OUT=$HERE/bin/$HOST
case $HOST in
    windows) OUTS="$OUT/libssh2.dll $OUT/libssh2_windows_x86_64.a" ;;
    linux)   OUTS="$OUT/libssh2_linux_$ARCH.so $OUT/libssh2_linux_$ARCH.a" ;;
esac

digest() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi; }
STAMP=$( { for f in "$@"; do basename "$f"; done; cat "$0"; echo "$HOST $ARCH"; } | digest | cut -c1-16 )
fresh=1
for o in $OUTS; do [ -f "$o" ] || fresh=0; done
[ "$fresh" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
W=$CACHE/libssh2-$HOST-$ARCH
if [ "$(cat "$W/done/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"
    for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
    echo "$STAMP" > "$OUT/.stamp"
    exit 0
fi

rm -rf "$W"; mkdir -p "$W/src" "$W/done" "$W/o-static" "$W/o-shared"
LOG=$W/build.log
: > "$LOG"
tar -xzf "$SRC_OSSL" -C "$W/src"
tar -xzf "$SRC_SSH2" -C "$W/src"
S_OSSL=$(ls -d "$W"/src/openssl-*); S_SSH2=$(ls -d "$W"/src/libssh2-*)
fail() { echo "libssh2: $1 failed -- $LOG" >&2; tail -25 "$LOG" >&2; exit 1; }
OSSL=$W/ossl

if [ "$HOST" = windows ]; then
    winpath() { cygpath -w "$1"; }
    VCVARS=${TIKO_VCVARS:-$("C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe" -latest -property installationPath 2>/dev/null | tr -d '\r')\\VC\\Auxiliary\\Build\\vcvars64.bat}
    PERLD=${TIKO_PERL_DIR:-C:\\Strawberry\\perl\\bin}
    NASMD=${TIKO_NASM_DIR:-$(winpath "$LOCALAPPDATA")\\bin\\NASM}
    # A batch file: vcvars64's environment is cmd's, and MSYS would rewrite nmake's /-options.
    cat > "$W/ossl.bat" <<EOF
@echo off
call "$VCVARS" >nul || exit /b 1
set PATH=$PERLD;$NASMD;C:\\Program Files\\LLVM\\bin;%PATH%
cd /d $(winpath "$S_OSSL") || exit /b 1
perl Configure VC-WIN64A CC=clang-cl no-shared no-tests no-docs --prefix=$(winpath "$OSSL") --openssldir=$(winpath "$OSSL")\\ssl || exit /b 1
nmake /nologo build_libs || exit /b 1
EOF
    cmd //c "$(winpath "$W/ossl.bat")" >> "$LOG" 2>&1 || fail "OpenSSL"
    # NOT 'nmake install_dev' (it copies a .pdb clang-cl never writes -- vendor/libpq): the
    # headers are the source tree's include/, the archive its root's.
    mkdir -p "$OSSL/lib"
    cp -f "$S_OSSL/libcrypto.lib" "$OSSL/lib/"
    cp -rf "$S_OSSL/include" "$OSSL/include"
    CF="-O2 -D_CRT_SECURE_NO_WARNINGS -DLIBSSH2_OPENSSL -I$S_SSH2/include -I$OSSL/include"
    for f in "$S_SSH2"/src/*.c; do
        n=$(basename "$f" .c)
        clang $CF -c "$f" -o "$W/o-static/$n.o" >> "$LOG" 2>&1 || fail "libssh2 ($n.c)"
        clang $CF -DLIBSSH2_EXPORTS -c "$f" -o "$W/o-shared/$n.o" >> "$LOG" 2>&1 || fail "libssh2 ($n.c, shared)"
    done
    SYSLIBS="-lws2_32 -lcrypt32 -luser32 -ladvapi32"
    clang -shared -fuse-ld=lld -o "$W/done/libssh2.dll" "$W"/o-shared/*.o "$OSSL/lib/libcrypto.lib" $SYSLIBS \
        >> "$LOG" 2>&1 || fail "libssh2.dll"
    rm -f "$W/done/libssh2.lib" "$W/done/libssh2.exp"
    # THE DLL MUST BE SELF-CONTAINED AND EXPORT libssh2 ALONE.
    llvm-readobj --coff-imports "$W/done/libssh2.dll" > "$W/imports.txt"
    if grep -qi 'libssl\|libcrypto\|vcruntime' "$W/imports.txt"; then
        echo "libssh2: libssh2.dll imports OpenSSL or VCRUNTIME -- not self-contained" >&2; exit 1
    fi
    llvm-readobj --coff-exports "$W/done/libssh2.dll" | grep 'Name:' > "$W/exports.txt"
    grep -q 'Name: libssh2_init$' "$W/exports.txt" || { echo "libssh2: libssh2.dll does not export libssh2_init" >&2; exit 1; }
    if grep -q 'Name: \(EVP_\|OPENSSL_\|CRYPTO_\)' "$W/exports.txt"; then
        echo "libssh2: libssh2.dll exports OpenSSL" >&2; exit 1
    fi
    llvm-ar rcs "$W/ssh2.a" "$W"/o-static/*.o >> "$LOG" 2>&1 || fail "the archive"
    llvm-lib /out:"$(winpath "$W/done/libssh2_windows_x86_64.a")" "$(winpath "$W/ssh2.a")" \
        "$(winpath "$OSSL/lib/libcrypto.lib")" >> "$LOG" 2>&1 || fail "the merged archive"
else
    J=$(nproc 2>/dev/null || echo 4)
    ( cd "$S_OSSL" && ./Configure linux-x86_64 no-shared no-tests no-docs -fPIC --prefix="$OSSL" --libdir=lib \
        && make -j"$J" build_libs && make install_dev ) >> "$LOG" 2>&1 || fail "OpenSSL"
    CF="-O2 -fPIC -DLIBSSH2_OPENSSL -DHAVE_UNISTD_H -DHAVE_INTTYPES_H -DHAVE_SYS_SELECT_H
        -DHAVE_SYS_UIO_H -DHAVE_SYS_SOCKET_H -DHAVE_SYS_IOCTL_H -DHAVE_SYS_TIME_H -DHAVE_SYS_UN_H
        -DHAVE_ARPA_INET_H -DHAVE_NETINET_IN_H -DHAVE_GETTIMEOFDAY -DHAVE_STRTOLL -DHAVE_SNPRINTF
        -DHAVE_EXPLICIT_BZERO -DHAVE_POLL -DHAVE_SELECT -DHAVE_O_NONBLOCK
        -I$S_SSH2/include -I$OSSL/include"
    for f in "$S_SSH2"/src/*.c; do
        gcc $CF -c "$f" -o "$W/o-static/$(basename "$f" .c).o" >> "$LOG" 2>&1 || fail "libssh2 ($(basename "$f"))"
    done
    SO=libssh2_linux_$ARCH.so
    printf '{ global: libssh2_*; local: *; };\n' > "$W/exports.map"
    gcc -shared -o "$W/done/$SO" -Wl,-soname,"$SO" -Wl,--version-script="$W/exports.map" \
        "$W"/o-static/*.o "$OSSL/lib/libcrypto.a" -pthread -ldl -Wl,-z,defs >> "$LOG" 2>&1 || fail "the shared library"
    nm -D --defined-only "$W/done/$SO" > "$W/exports.txt"
    grep -q ' libssh2_init$' "$W/exports.txt" || { echo "libssh2: $SO does not export libssh2_init" >&2; exit 1; }
    if grep -q ' EVP_\| OPENSSL_\| CRYPTO_' "$W/exports.txt"; then
        echo "libssh2: $SO exports OpenSSL" >&2; exit 1
    fi
    ar rcs "$W/ssh2.a" "$W"/o-static/*.o
    printf 'CREATE %s\nADDLIB %s\nADDLIB %s\nSAVE\nEND\n' \
        "$W/done/libssh2_linux_$ARCH.a" "$W/ssh2.a" "$OSSL/lib/libcrypto.a" | ar -M >> "$LOG" 2>&1 || fail "the merged archive"
fi

mkdir -p "$OUT"
for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
echo "$STAMP" > "$W/done/.stamp"
echo "$STAMP" > "$OUT/.stamp"
