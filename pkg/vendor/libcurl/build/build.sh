#!/bin/bash
# Build vendor/libcurl's libraries -- curl 8.23.0's libcurl, SELF-CONTAINED: libssh2 (for SFTP and
# SCP) and OpenSSL inside it, static and hidden (claude-docs docs/tiko-vendor RFC-0004 FT-11, and
# the author's choice at P2: no import of vendor/libssh2, so the two modules' link modes never
# meet) -- from the pinned sources. Run by build/vendorfetch.sh ('script' entries in ../fetch.toml),
# which downloads and verifies them and passes them as TIKO_VENDOR_INPUTS, in this order:
#
#   openssl  libssh2  curl
#
#   1. libssh2 + libcrypto: vendor/libssh2's own build/build.sh, given the first two inputs and
#      the same cache -- the same bytes as that package's static archive, built once.
#   2. Linux and macOS: OpenSSL again, STATIC, for libssl (curl's TLS there; Windows' is
#      Schannel). The same pin and Configure line as libssh2's (RFC-0004 FT-12), so libssl's
#      libcrypto references resolve to the libcrypto already in the libssh2 archive: ONE libcrypto
#      in the library. (Two identical static libcryptos in one program also link and run --
#      RFC-0004 P2 section 1 -- but there is no need for two here.)
#   3. curl with CMake: every optional dependency off, the protocols of RFC-0004 FT-5 on (FTP,
#      FTPS, SFTP, SCP, HTTP, HTTPS, FILE). Windows: clang (MSVC target, static CRT: tiko links
#      libcmt), Schannel, a static and a shared tree. Linux: gcc, OpenSSL, the static tree only.
#      macOS: Apple's clang, arm64, macOS 13.0, OpenSSL, the static tree only.
#   4. The SHARED LIBRARY. Windows: CMake's libcurl.dll, libssh2 and libcrypto linked in; it exports
#      what curl's headers dllexport (curl_*) and imports only system DLLs. Linux:
#      libcurl_linux_<arch>.so linked here (CMake's names itself libcurl.so.4): soname its own
#      file name, a version script exporting curl_* alone. macOS: libcurl_macos_arm64.dylib, install
#      name @rpath/ and its file name, an exported-symbols list of curl's _curl_* functions, the
#      CoreFoundation and SystemConfiguration frameworks (curl's macos.c).
#   5. The STATIC ARCHIVE: curl's objects with libssh2's archive (libssh2 + libcrypto) and, on
#      Linux and macOS, libssl -- merged into one. A Windows program linking it needs ws2_32,
#      crypt32, secur32, bcrypt, iphlpapi, advapi32 and user32, a macOS one curl's frameworks
#      (../libcurl.tiko names them), and a Windows one tiko's runtime's _onexit (RFC-0003 DB-11).
#
# Host tools beyond vendorfetch's: vendor/libssh2's (Visual Studio's C tools, Strawberry Perl, NASM
# on Windows; gcc, make, perl on Linux; the Command Line Tools on macOS), CMake (Windows: C:\Program
# Files\CMake; macOS: Homebrew's) and Ninja on Windows (Meson's), LLVM on Windows.
#
# Output: bin/<host>/ beside this script (bin/linux-arm64/ on arm64 Linux) -- Windows libcurl.dll
# and libcurl_windows_x86_64.a; Linux libcurl_linux_<arch>.so and .a; macOS
# libcurl_macos_arm64.dylib and .a. Incremental: a stamp of the inputs, this script and libssh2's.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SSH2_BUILD=$HERE/../../libssh2/build/build.sh
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 3 ] || { echo "libcurl: expected 3 inputs, got $#" >&2; exit 1; }
SRC_OSSL=$1; SRC_SSH2=$2; SRC_CURL=$3

case $HOST in
    windows) ARCH=x86_64 ;;
    linux)   ARCH=${TIKO_VENDOR_ARCH:-x86_64}
             case $ARCH in x86_64) OSSL_TARGET=linux-x86_64 ;; arm64) OSSL_TARGET=linux-aarch64 ;;
                 *) echo "libcurl: no recipe for linux-$ARCH" >&2; exit 1 ;; esac ;;
    macos)   ARCH=arm64 ;;
    *) echo "libcurl: no recipe for host '$HOST'" >&2; exit 1 ;;
esac
OUT=$HERE/bin/$HOST
[ "$HOST" = linux ] && [ "$ARCH" != x86_64 ] && OUT=$HERE/bin/linux-$ARCH
case $HOST in
    windows) OUTS="$OUT/libcurl.dll $OUT/libcurl_windows_x86_64.a" ;;
    linux)   OUTS="$OUT/libcurl_linux_$ARCH.so $OUT/libcurl_linux_$ARCH.a" ;;
    macos)   OUTS="$OUT/libcurl_macos_arm64.dylib $OUT/libcurl_macos_arm64.a" ;;
esac

digest() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi; }
STAMP=$( { for f in "$@"; do basename "$f"; done; cat "$0" "$SSH2_BUILD"; echo "$HOST $ARCH"; } | digest | cut -c1-16 )
fresh=1
for o in $OUTS; do [ -f "$o" ] || fresh=0; done
[ "$fresh" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
W=$CACHE/libcurl-$HOST-$ARCH
if [ "$(cat "$W/done/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"
    for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
    echo "$STAMP" > "$OUT/.stamp"
    exit 0
fi

# 1. libssh2 + libcrypto, by vendor/libssh2's script (incremental: a no-op when it is built).
TIKO_VENDOR_INPUTS="$SRC_OSSL $SRC_SSH2" bash "$SSH2_BUILD"
SSH2_OUT=$HERE/../../libssh2/build/bin/$HOST
[ "$HOST" = linux ] && [ "$ARCH" != x86_64 ] && SSH2_OUT=$HERE/../../libssh2/build/bin/linux-$ARCH
SSH2_A=$SSH2_OUT/libssh2_${HOST}_$ARCH.a
[ -f "$SSH2_A" ] || { echo "libcurl: vendor/libssh2's build made no $SSH2_A" >&2; exit 1; }

rm -rf "$W"; mkdir -p "$W/src" "$W/done"
LOG=$W/build.log
: > "$LOG"
tar -xzf "$SRC_SSH2" -C "$W/src"
tar -xJf "$SRC_CURL" -C "$W/src"
S_SSH2=$(ls -d "$W"/src/libssh2-*); S_CURL=$(ls -d "$W"/src/curl-*)
fail() { echo "libcurl: $1 failed -- $LOG" >&2; tail -25 "$LOG" >&2; exit 1; }

# The protocols and dependencies (RFC-0004 FT-5): every optional library off. PICKY_COMPILER off:
# curl's own extra -W set (-Wformat-non-iso on its I64 formats: 24 warnings, RFC-0004 P0).
COMMON="-DCMAKE_BUILD_TYPE=Release -DBUILD_CURL_EXE=OFF -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF
 -DBUILD_LIBCURL_DOCS=OFF -DBUILD_MISC_DOCS=OFF -DENABLE_CURL_MANUAL=OFF -DCURL_DISABLE_INSTALL=ON
 -DCURL_USE_LIBSSH2=ON -DCURL_USE_LIBSSH=OFF -DCURL_USE_LIBPSL=OFF -DUSE_NGHTTP2=OFF -DUSE_NGTCP2=OFF
 -DCURL_BROTLI=OFF -DCURL_ZSTD=OFF -DCURL_ZLIB=OFF -DUSE_LIBIDN2=OFF -DCURL_USE_GSSAPI=OFF
 -DENABLE_UNIX_SOCKETS=OFF -DCURL_DISABLE_DICT=ON -DCURL_DISABLE_GOPHER=ON -DCURL_DISABLE_IMAP=ON
 -DCURL_DISABLE_POP3=ON -DCURL_DISABLE_SMTP=ON -DCURL_DISABLE_TELNET=ON -DCURL_DISABLE_TFTP=ON
 -DCURL_DISABLE_RTSP=ON -DCURL_DISABLE_MQTT=ON -DCURL_DISABLE_LDAP=ON -DCURL_DISABLE_LDAPS=ON
 -DCURL_DISABLE_IPFS=ON -DCURL_DISABLE_WEBSOCKETS=ON -DLIBSSH2_INCLUDE_DIR=$S_SSH2/include
 -DPICKY_COMPILER=OFF"
# What curl's own log says it built, checked: a protocol missing is a build that is wrong.
check_protocols() {
    grep -q "Protocols: file ftp ftps http https scp sftp" "$1" \
        || { echo "libcurl: the protocol set is not FT-5's -- $1" >&2; grep "Protocols:" "$1" >&2; exit 1; }
}

if [ "$HOST" = windows ]; then
    winpath() { cygpath -w "$1"; }
    PATH="/c/Program Files/CMake/bin:/c/Program Files/Meson:/c/Program Files/LLVM/bin:$PATH"
    # libcrypto (inside the libssh2 archive) needs these four; curl names its own.
    SSL_SYS="-lws2_32 -lcrypt32 -luser32 -ladvapi32"
    WINOPT="-G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
     -DCURL_USE_SCHANNEL=ON -DCURL_USE_OPENSSL=OFF -DCURL_WINDOWS_SSPI=ON -DUSE_WIN32_IDN=OFF
     -DLIBSSH2_LIBRARY=$SSH2_A"
    cmake -S "$S_CURL" -B "$W/st" $COMMON $WINOPT -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON \
        > "$W/st.cfg.log" 2>&1 || fail "CMake (static)"
    check_protocols "$W/st.cfg.log"
    cmake --build "$W/st" >> "$LOG" 2>&1 || fail "curl (static)"
    cmake -S "$S_CURL" -B "$W/sh" $COMMON $WINOPT -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF \
        "-DCMAKE_SHARED_LINKER_FLAGS=$SSL_SYS" > "$W/sh.cfg.log" 2>&1 || fail "CMake (shared)"
    check_protocols "$W/sh.cfg.log"
    cmake --build "$W/sh" >> "$LOG" 2>&1 || fail "curl (shared)"
    cp -f "$W/sh/lib/libcurl.dll" "$W/done/libcurl.dll"
    # THE DLL MUST BE SELF-CONTAINED AND EXPORT curl's API ALONE.
    llvm-readobj --coff-imports "$W/done/libcurl.dll" > "$W/imports.txt"
    if grep -qi 'libssh2\|libssl\|libcrypto\|vcruntime' "$W/imports.txt"; then
        echo "libcurl: libcurl.dll imports libssh2, OpenSSL or VCRUNTIME -- not self-contained" >&2; exit 1
    fi
    llvm-readobj --coff-exports "$W/done/libcurl.dll" | grep 'Name:' > "$W/exports.txt"
    grep -q 'Name: curl_easy_perform$' "$W/exports.txt" || { echo "libcurl: libcurl.dll does not export curl_easy_perform" >&2; exit 1; }
    if grep -q 'Name: \(libssh2_\|EVP_\|OPENSSL_\|CRYPTO_\)' "$W/exports.txt"; then
        echo "libcurl: libcurl.dll exports libssh2 or OpenSSL" >&2; exit 1
    fi
    llvm-lib /out:"$(winpath "$W/done/libcurl_windows_x86_64.a")" "$(winpath "$W/st/lib/libcurl.lib")" \
        "$(winpath "$SSH2_A")" >> "$LOG" 2>&1 || fail "the merged archive"
elif [ "$HOST" = macos ]; then
    # Apple's clang and ld64, arm64, macOS 13.0; OpenSSL's Configure line is vendor/libpq's and
    # vendor/libssh2's for this host (RFC-0004 FT-12), so libssl's libcrypto references resolve in
    # the libssh2 archive. TLS is OpenSSL: curl has no other backend on macOS.
    export MACOSX_DEPLOYMENT_TARGET=13.0
    MCC=/usr/bin/clang
    J=$(sysctl -n hw.ncpu 2>/dev/null || echo 4)
    OSSL=$W/ossl
    tar -xzf "$SRC_OSSL" -C "$W/src"
    S_OSSL=$(ls -d "$W"/src/openssl-*)
    ( cd "$S_OSSL" && ./Configure darwin64-arm64-cc no-shared no-tests no-docs CC=$MCC --prefix="$OSSL" --libdir=lib \
        && make -j"$J" build_libs && make install_dev ) >> "$LOG" 2>&1 || fail "OpenSSL"
    cmake -S "$S_CURL" -B "$W/st" $COMMON -DCMAKE_C_COMPILER=$MCC -DCMAKE_OSX_ARCHITECTURES=arm64 \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=13.0 -DCURL_USE_OPENSSL=ON -DOPENSSL_ROOT_DIR="$OSSL" \
        -DOPENSSL_USE_STATIC_LIBS=ON -DLIBSSH2_LIBRARY="$SSH2_A" -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON \
        > "$W/st.cfg.log" 2>&1 || fail "CMake"
    check_protocols "$W/st.cfg.log"
    cmake --build "$W/st" -j"$J" >> "$LOG" 2>&1 || fail "curl"
    # The two frameworks curl's lib/macos.c (Curl_macos_init: the system's proxy settings) needs,
    # MEASURED from the link without them: CFRelease (CoreFoundation), SCDynamicStoreCopyProxies
    # (SystemConfiguration). Nothing else is undefined. A static program needs them too
    # (../libcurl.tiko names them).
    SYSL="-framework CoreFoundation -framework SystemConfiguration"
    DY=libcurl_macos_arm64.dylib
    nm -gU "$W/st/lib/libcurl.a" 2>/dev/null | awk '$2 == "T" && $3 ~ /^_curl_/ { print $3 }' | sort -u > "$W/exports.list"
    $MCC -dynamiclib -o "$W/done/$DY" -install_name "@rpath/$DY" \
        -Wl,-exported_symbols_list,"$W/exports.list" -Wl,-force_load,"$W/st/lib/libcurl.a" \
        "$OSSL/lib/libssl.a" "$SSH2_A" $SYSL >> "$LOG" 2>&1 || fail "the shared library"
    nm -gU "$W/done/$DY" > "$W/exports.txt"
    grep -q ' _curl_easy_perform$' "$W/exports.txt" || { echo "libcurl: $DY does not export curl_easy_perform" >&2; exit 1; }
    if grep -q ' _libssh2_\| _SSL_\| _EVP_\| _OPENSSL_' "$W/exports.txt"; then
        echo "libcurl: $DY exports libssh2 or OpenSSL" >&2; exit 1
    fi
    /usr/bin/libtool -static -no_warning_for_no_symbols -o "$W/done/libcurl_macos_arm64.a" \
        "$W/st/lib/libcurl.a" "$OSSL/lib/libssl.a" "$SSH2_A" >> "$LOG" 2>&1 || fail "the merged archive"
else
    J=$(nproc 2>/dev/null || echo 4)
    OSSL=$W/ossl
    tar -xzf "$SRC_OSSL" -C "$W/src"
    S_OSSL=$(ls -d "$W"/src/openssl-*)
    ( cd "$S_OSSL" && ./Configure $OSSL_TARGET no-shared no-tests no-docs -fPIC --prefix="$OSSL" --libdir=lib \
        && make -j"$J" build_libs && make install_dev ) >> "$LOG" 2>&1 || fail "OpenSSL"
    cmake -S "$S_CURL" -B "$W/st" $COMMON -DCMAKE_C_COMPILER=gcc -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DCURL_USE_OPENSSL=ON -DOPENSSL_ROOT_DIR="$OSSL" -DOPENSSL_USE_STATIC_LIBS=ON \
        -DLIBSSH2_LIBRARY="$SSH2_A" -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON \
        > "$W/st.cfg.log" 2>&1 || fail "CMake"
    check_protocols "$W/st.cfg.log"
    cmake --build "$W/st" -j"$J" >> "$LOG" 2>&1 || fail "curl"
    SO=libcurl_linux_$ARCH.so
    printf '{ global: curl_*; local: *; };\n' > "$W/exports.map"
    # libssl before the libssh2 archive: its libcrypto references resolve there, with libssh2's.
    gcc -shared -o "$W/done/$SO" -Wl,-soname,"$SO" -Wl,--version-script="$W/exports.map" \
        -Wl,--whole-archive "$W/st/lib/libcurl.a" -Wl,--no-whole-archive \
        -Wl,--start-group "$OSSL/lib/libssl.a" "$SSH2_A" -Wl,--end-group \
        -pthread -ldl -Wl,-z,defs >> "$LOG" 2>&1 || fail "the shared library"
    nm -D --defined-only "$W/done/$SO" > "$W/exports.txt"
    grep -q ' curl_easy_perform$' "$W/exports.txt" || { echo "libcurl: $SO does not export curl_easy_perform" >&2; exit 1; }
    if grep -q ' libssh2_\| SSL_\| EVP_\| OPENSSL_' "$W/exports.txt"; then
        echo "libcurl: $SO exports libssh2 or OpenSSL" >&2; exit 1
    fi
    printf 'CREATE %s\nADDLIB %s\nADDLIB %s\nADDLIB %s\nSAVE\nEND\n' "$W/done/libcurl_linux_$ARCH.a" \
        "$W/st/lib/libcurl.a" "$OSSL/lib/libssl.a" "$SSH2_A" | ar -M >> "$LOG" 2>&1 || fail "the merged archive"
fi

mkdir -p "$OUT"
for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o"; done
echo "$STAMP" > "$W/done/.stamp"
echo "$STAMP" > "$OUT/.stamp"
