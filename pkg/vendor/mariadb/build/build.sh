#!/bin/bash
# Build vendor/mariadb's shared library -- MariaDB Connector/C (libmariadb, the MySQL client API
# of mysql.h) -- from the pinned sources (claude-docs docs/tiko-vendor RFC-0003). Run by
# build/vendorfetch.sh ('script' entries in ../fetch.toml), which downloads and verifies them and
# passes them as TIKO_VENDOR_INPUTS, in this order:
#
#   connector-c  openssl
#
# DYNAMIC ONLY (RFC-0003 DB-2): Connector/C is LGPL-2.1, so it ships as a shared library a
# program's user can replace. Every host builds it with CMake and Ninja:
#   - TLS: Schannel on Windows (no OpenSSL there at all); on Linux OpenSSL 3.5, built here
#     STATIC ('no-shared', -fPIC) and folded into the library, hidden (RFC-0003 DB-3) -- the
#     openssl input is fetched on every host and unused on Windows.
#   - EVERY AUTH PLUGIN BUILT IN (CLIENT_PLUGIN_*=STATIC): mysql_native_password,
#     caching_sha2_password and sha256_password (MySQL 8's), client_ed25519 and parsec
#     (MariaDB's), dialog, mysql_clear_password. A DYNAMIC plugin is a separate file looked for
#     in a plugin directory at connect time, so MySQL 8's default login would fail without it.
#     auth_gssapi_client (Kerberos) and remote_io (curl) are off: they would be separate files,
#     or need libraries no tiko host has. pvio_shmem (Windows shared memory) is built in too.
#   - Windows: clang for x86_64-pc-windows-msvc, /MT -- libmariadb.dll imports only system
#     DLLs -- and -DWIN32_LEAN_AND_MEAN, without which parsec.c and schannel.c see winsock.h
#     before winsock2.h ("redefinition of 'sockaddr'", RFC-0003 P0).
#   - Linux: gcc; CMake's libmariadb.so.3 is NOT what ships. The library is linked again here
#     from CMake's libmariadbclient.a and the static OpenSSL, through CMake's own export list
#     (mariadbclient.def, a VERSION script: the libmysqlclient_18 / libmariadb_3 symbol versions
#     MySQL programs expect), so its soname is its own file name, libmariadb_linux_x86_64.so.
#
# Output: bin/<host>/ beside this script -- Windows libmariadb.dll, Linux
# libmariadb_linux_x86_64.so. The build trees live under TIKO_VENDOR_CACHE. Incremental: a stamp
# of the inputs and this script; a finished build in the cache is copied, not redone.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 2 ] || { echo "mariadb: expected 2 inputs, got $#" >&2; exit 1; }
SRC_CC=$1; SRC_OSSL=$2

case $HOST in
    windows) ARCH=x86_64; OUTS=libmariadb.dll ;;
    linux)   ARCH=${TIKO_VENDOR_ARCH:-x86_64}
             [ "$ARCH" = x86_64 ] || { echo "mariadb: linux-$ARCH is not built yet (RFC-0003 P4)" >&2; exit 1; }
             OUTS=libmariadb_linux_$ARCH.so ;;
    *) echo "mariadb: host '$HOST' is not built yet (RFC-0003 P4)" >&2; exit 1 ;;
esac
OUT=$HERE/bin/$HOST

digest() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi; }
STAMP=$( { for f in "$@"; do basename "$f"; done; cat "$0"; echo "$HOST $ARCH"; } | digest | cut -c1-16 )
[ -f "$OUT/$OUTS" ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
W=$CACHE/mariadb-$HOST-$ARCH
if [ "$(cat "$W/done/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"; cp -f "$W/done/$OUTS" "$OUT/$OUTS"; echo "$STAMP" > "$OUT/.stamp"
    exit 0
fi
command -v cmake >/dev/null || { echo "mariadb: cmake is not on PATH" >&2; exit 1; }
command -v ninja >/dev/null || { echo "mariadb: ninja is not on PATH" >&2; exit 1; }

rm -rf "$W"; mkdir -p "$W/src" "$W/done"
LOG=$W/build.log
: > "$LOG"
fail() { echo "mariadb: $1 failed -- $LOG" >&2; tail -25 "$LOG" >&2; exit 1; }
tar -xzf "$SRC_CC" -C "$W/src"
S_CC=$(ls -d "$W"/src/mariadb-connector-c-*)

C=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
   -DWITH_UNIT_TESTS=OFF -DWITH_CURL=OFF -DWITH_EXTERNAL_ZLIB=OFF
   -DCLIENT_PLUGIN_MYSQL_NATIVE_PASSWORD=STATIC -DCLIENT_PLUGIN_CACHING_SHA2_PASSWORD=STATIC
   -DCLIENT_PLUGIN_SHA256_PASSWORD=STATIC -DCLIENT_PLUGIN_CLIENT_ED25519=STATIC
   -DCLIENT_PLUGIN_PARSEC=STATIC -DCLIENT_PLUGIN_DIALOG=STATIC -DCLIENT_PLUGIN_MYSQL_CLEAR_PASSWORD=STATIC
   -DCLIENT_PLUGIN_AUTH_GSSAPI_CLIENT=OFF -DCLIENT_PLUGIN_REMOTE_IO=OFF)
# pvio_shmem (Windows only) accepts STATIC or DYNAMIC, not OFF ("Invalid plugin type OFF",
# measured): built in, so the DLL stays one file.
[ "$HOST" = windows ] && C+=(-DCLIENT_PLUGIN_PVIO_SHMEM=STATIC)

if [ "$HOST" = windows ]; then
    CL=${TIKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}
    cmake -S "$S_CC" -B "$W/b" "${C[@]}" -DWITH_SSL=SCHANNEL \
        -DCMAKE_C_COMPILER="$CL" -DCMAKE_RC_COMPILER="$(dirname "$CL")/llvm-rc.exe" \
        -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
        -DCMAKE_C_FLAGS="-DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_WINSOCK_DEPRECATED_NO_WARNINGS" \
        >> "$LOG" 2>&1 || fail "configure"
    cmake --build "$W/b" --target libmariadb >> "$LOG" 2>&1 || fail "the build"
    cp -f "$W/b/libmariadb/libmariadb.dll" "$W/done/libmariadb.dll"
    if llvm-readobj --coff-imports "$W/done/libmariadb.dll" | grep -qi 'vcruntime\|api-ms-win-crt\|libssl\|libcrypto'; then
        echo "mariadb: libmariadb.dll imports a C runtime or OpenSSL DLL -- not self-contained" >&2; exit 1
    fi
else
    J=$(nproc 2>/dev/null || echo 4)
    tar -xzf "$SRC_OSSL" -C "$W/src"
    S_OSSL=$(ls -d "$W"/src/openssl-*); OSSL=$W/ossl
    ( cd "$S_OSSL" && ./Configure linux-x86_64 no-shared no-tests no-docs -fPIC --prefix="$OSSL" --libdir=lib \
        && make -j"$J" build_libs && make install_dev ) >> "$LOG" 2>&1 || fail "OpenSSL"
    cmake -S "$S_CC" -B "$W/b" "${C[@]}" -DWITH_SSL=OPENSSL -DOPENSSL_ROOT_DIR="$OSSL" \
        -DOPENSSL_USE_STATIC_LIBS=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_C_COMPILER=gcc \
        >> "$LOG" 2>&1 || fail "configure"
    cmake --build "$W/b" --target mariadbclient >> "$LOG" 2>&1 || fail "the build"
    L=$W/b/libmariadb; SO=libmariadb_linux_$ARCH.so
    [ -f "$L/mariadbclient.def" ] || { echo "mariadb: CMake wrote no mariadbclient.def" >&2; exit 1; }
    gcc -shared -o "$W/done/$SO" -Wl,-soname,"$SO" \
        -Wl,--whole-archive "$L/libmariadbclient.a" -Wl,--no-whole-archive \
        "$OSSL/lib/libssl.a" "$OSSL/lib/libcrypto.a" "$L/mariadbclient.def" -lm -lpthread -ldl -Wl,-z,defs \
        >> "$LOG" 2>&1 || fail "the shared library"
    nm -D --defined-only "$W/done/$SO" > "$W/exports.txt"
    grep -q ' mysql_real_connect@' "$W/exports.txt" || { echo "mariadb: $SO does not export mysql_real_connect" >&2; exit 1; }
    if grep -q ' SSL_\| EVP_' "$W/exports.txt"; then echo "mariadb: $SO exports OpenSSL" >&2; exit 1; fi
fi

mkdir -p "$OUT"
cp -f "$W/done/$OUTS" "$OUT/$OUTS"
echo "$STAMP" > "$W/done/.stamp"
echo "$STAMP" > "$OUT/.stamp"
