#!/bin/sh
# vendorfetch.sh -- the vendor packages' binaries (tiko-vendor RFC-0002 V9, V11).
#
#   sh build/vendorfetch.sh                    into the tree's own pkg/vendor/*/lib
#   sh build/vendorfetch.sh --out DIR          into DIR/vendor/*/lib (package.sh: $OUT/pkg)
#   sh build/vendorfetch.sh --module sqlite3   one module only
#
# A vendor package commits its translated headers and a fetch.toml; its binaries are never
# committed. This reads each pkg/vendor/<module>/fetch.toml and, for THIS host's [<os>.<n>]
# entries, downloads the pinned archive, checks its SHA-256, and either copies a file out of
# it ('copy': where upstream publishes the binary) or compiles C sources with clang into a
# static archive and/or a shared library ('cbuild': where it does not). A host makes its own
# binaries, as package.sh makes its own toolchain. A 'copy' whose url is a single file, not an
# archive, copies that file. 'script' needs no download: it runs a build script committed in
# the package (vendor/tkControls' scintk) and copies what it made.
#
#   TKO_VENDOR_CACHE    where downloads are kept (default build/.vendorfetch); one already
#                       there with the right SHA-256 is not downloaded again
#   TKO_VENDOR_MIRROR   a base URL tried first, by file name -- the tiko-lang release assets
#                       the archives are mirrored as; upstream is the fallback
#   TKO_CLANG, TKO_AR   the compiler and archiver ('cbuild'); default the LLVM install on
#                       Windows, clang / llvm-ar (else ar) on Linux and macOS
#   CXX                 the C++ compiler a 'script' entry's script uses; default clang++
#                       beside TKO_CLANG on Windows, the script's own choice elsewhere
#
# An entry whose outputs are newer than its fetch.toml is skipped, so a rerun does nothing.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT="$ROOT/pkg"
ONLY=
die( ) { echo "vendorfetch: $*" >&2; exit 1; }
note( ) { echo "vendorfetch: $*"; }
while [ $# -gt 0 ]; do
    case $1 in
        --out)    OUT=$2;  shift 2 ;;
        --module) ONLY=$2; shift 2 ;;
        -h|--help) sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) die "unknown option '$1'" ;;
    esac
done
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        HOST=windows; TRIPLE=x86_64-pc-windows-msvc
        CLANG=${TKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}
        AR=${TKO_AR:-"$(dirname "$CLANG")/llvm-ar.exe"}
        [ -n "$CXX" ] || CXX="$(dirname "$CLANG")/clang++.exe"; export CXX ;;
    Linux)
        HOST=linux; TRIPLE=x86_64-pc-linux-gnu
        CLANG=${TKO_CLANG:-${CLANG:-clang}}
        AR=${TKO_AR:-$(command -v llvm-ar || command -v ar)} ;;
    Darwin)
        # The SDK is clang's own business here: Apple's clang (and Homebrew's) find it.
        HOST=macos; TRIPLE=arm64-apple-macosx13.0
        CLANG=${TKO_CLANG:-${CLANG:-clang}}
        AR=${TKO_AR:-$(command -v llvm-ar || command -v ar)} ;;
    *) die "unsupported host '$(uname -s)'" ;;
esac
CACHE=${TKO_VENDOR_CACHE:-$ROOT/build/.vendorfetch}
mkdir -p "$CACHE"

# fetch.toml as 'table<TAB>key<TAB>value' lines: the subset this file's header describes --
# comments, [table] headers, key = "string".
toml( ) {
    awk '
        /^[ \t]*(#|$)/ { next }
        /^[ \t]*\[/ { t = $0; gsub( /^[ \t]*\[|\][ \t]*$/, "", t ); next }
        {
            k = $0; sub( /[ \t]*=.*/, "", k ); gsub( /^[ \t]+/, "", k )
            v = $0; sub( /^[^=]*=[ \t]*"/, "", v ); sub( /"[ \t]*(#.*)?$/, "", v )
            printf "%s\t%s\t%s\n", t, k, v
        }' "$1" | tr -d '\r'
}

# macOS has no sha256sum; its shasum is the same digest.
if command -v sha256sum >/dev/null 2>&1; then
    sha_of( ) { sha256sum "$1" | cut -d' ' -f1; }
else
    sha_of( ) { shasum -a 256 "$1" | cut -d' ' -f1; }
fi

# is_archive <url>: true for what unpack opens.
is_archive( ) { case "$1" in *.zip|*.tar.gz|*.tgz) return 0 ;; *) return 1 ;; esac; }

# fetch <url> <sha256>: the archive, in the cache, verified; its path printed. A single file is
# kept under its SHA-256's first 12 digits as well as its name: two packages' LICENSE files
# must not take each other's place.
fetch( ) {
    _f="$CACHE/${1##*/}"
    is_archive "$1" || _f="$CACHE/$(printf '%.12s' "$2")-${1##*/}"
    if [ ! -f "$_f" ] || [ "$(sha_of "$_f")" != "$2" ]; then
        rm -f "$_f"
        if [ -n "$TKO_VENDOR_MIRROR" ]; then
            curl -fsSL -o "$_f" "${TKO_VENDOR_MIRROR%/}/${1##*/}" || rm -f "$_f"
        fi
        [ -f "$_f" ] || curl -fsSL -o "$_f" "$1" || die "cannot download $1"
    fi
    [ "$(sha_of "$_f")" = "$2" ] || { rm -f "$_f"; die "${1##*/}: SHA-256 is not $2"; }
    printf '%s\n' "$_f"
}

# unpack <archive>: into a fresh directory, printed.
unpack( ) {
    _x="$CACHE/x/$(basename "$1")"
    rm -rf "$_x"; mkdir -p "$_x"
    case "$1" in
        *.zip) unzip -q "$1" -d "$_x" ;;
        *)     tar -xzf "$1" -C "$_x" ;;
    esac
    printf '%s\n' "$_x"
}

# One entry: the table's keys, then what its kind makes.
entry( ) {
    _mod=$1; _mdir=$2; _toml=$3; _tab=$4
    _get( ) { toml "$_toml" | awk -F'\t' -v t="$_tab" -v k="$1" '$1 == t && $2 == k { print $3; exit }'; }
    _kind=$(_get kind); _url=$(_get url); _sha=$(_get sha256)
    if [ "$_kind" = script ]; then
        # THE SCRIPT IS RUN EVERY TIME: it is incremental itself, and the freshness test below
        # sees only fetch.toml, not the sources the script compiles.
        _scr="$ROOT/pkg/vendor/$_mod/$(_get script)"; _from="$ROOT/pkg/vendor/$_mod/$(_get from)"; _to=$(_get to)
        [ -f "$_scr" ] && [ -n "$_to" ] || die "$_mod [$_tab]: 'script' needs script, from and to"
        bash "$_scr" >/dev/null || die "$_mod [$_tab]: $(_get script) failed"
        [ -f "$_from" ] || die "$_mod [$_tab]: $(_get script) made no $(_get from)"
        mkdir -p "$(dirname "$_mdir/$_to")"
        cp -f "$_from" "$_mdir/$_to"
        note "$_mod [$_tab]: $_to"
        return
    fi
    [ -n "$_url" ] && [ -n "$_sha" ] || die "$_mod [$_tab]: needs url and sha256"
    _outs=
    case $_kind in
        copy)   _outs=$(_get to) ;;
        cbuild) _outs="$(_get static) $(_get shared)" ;;
        *) die "$_mod [$_tab]: kind is 'copy', 'cbuild' or 'script', not '$_kind'" ;;
    esac
    _fresh=1
    for _o in $_outs; do
        if [ ! -f "$_mdir/$_o" ] || [ "$_toml" -nt "$_mdir/$_o" ]; then _fresh=0; fi
    done
    if [ "$_fresh" = 1 ]; then note "$_mod [$_tab]: up to date"; return; fi
    _dl=$(fetch "$_url" "$_sha")
    if [ "$_kind" = copy ] && ! is_archive "$_url"; then
        _to=$(_get to)
        mkdir -p "$(dirname "$_mdir/$_to")"
        cp -f "$_dl" "$_mdir/$_to"
        note "$_mod [$_tab]: $_to"
        return
    fi
    _x=$(unpack "$_dl")
    case $_kind in
    copy)
        _from=$(_get from); _to=$(_get to)
        _src=$(find "$_x" -path "*/$_from" -o -name "$_from" | head -1)
        [ -n "$_src" ] && [ -f "$_src" ] || die "$_mod [$_tab]: '$_from' is not in ${_url##*/}"
        mkdir -p "$(dirname "$_mdir/$_to")"
        cp -f "$_src" "$_mdir/$_to"
        note "$_mod [$_tab]: $_to"
        ;;
    cbuild)
        _dir="$_x/$(_get dir)"; _objs=
        for _s in $(_get sources); do
            _o="$_x/$(basename "$_s" .c).o"
            # shellcheck disable=SC2046
            "$CLANG" --target=$TRIPLE $(_get cflags) -c "$_dir/$_s" -o "$_o" || die "$_mod: clang failed on $_s"
            _objs="$_objs $_o"
        done
        _st=$(_get static); _sh=$(_get shared)
        if [ -n "$_st" ]; then
            mkdir -p "$(dirname "$_mdir/$_st")"; rm -f "$_mdir/$_st"
            # shellcheck disable=SC2086
            "$AR" rcs "$_mdir/$_st" $_objs || die "$_mod: archiving $_st failed"
            note "$_mod [$_tab]: $_st"
        fi
        if [ -n "$_sh" ]; then
            mkdir -p "$(dirname "$_mdir/$_sh")"
            if [ "$HOST" = windows ]; then
                # A DLL, with lld. Its import library and .exp stay in the unpack directory:
                # beside the DLL, '#foreignlib ... dynamic' would find the .lib first. The
                # sources must dllexport what the DLL exports -- their cflags say how.
                # -implib:, not /implib: -- MSYS would rewrite a leading slash as a path.
                _imp="$(cygpath -m "$_x" 2>/dev/null || printf '%s' "$_x")/$(basename "$_sh" .dll).lib"
                # shellcheck disable=SC2086
                "$CLANG" --target=$TRIPLE -shared -fuse-ld=lld -o "$_mdir/$_sh" \
                    -Wl,-implib:"$_imp" \
                    $_objs $(_get libs) || die "$_mod: linking $_sh failed"
            elif [ "$HOST" = macos ]; then
                # THE INSTALL NAME IS @rpath/<its own name>, the soname's counterpart: a program
                # records it, and finds the copy beside it through its '@loader_path' run path.
                # shellcheck disable=SC2086
                "$CLANG" --target=$TRIPLE -dynamiclib -Wl,-install_name,"@rpath/$(basename "$_sh")" \
                    -o "$_mdir/$_sh" $_objs $(_get libs) || die "$_mod: linking $_sh failed"
            else
                # THE SONAME IS THE FILE'S OWN NAME: a program records it as NEEDED, and the
                # copy tiko puts beside the program (RFC-0002 V13) is found by it through $ORIGIN.
                # shellcheck disable=SC2086
                "$CLANG" --target=$TRIPLE -shared -Wl,-soname,"$(basename "$_sh")" -o "$_mdir/$_sh" \
                    $_objs $(_get libs) || die "$_mod: linking $_sh failed"
            fi
            note "$_mod [$_tab]: $_sh"
        fi
        ;;
    esac
}

_n=0
for _ft in "$ROOT"/pkg/vendor/*/fetch.toml; do
    [ -f "$_ft" ] || continue
    _mod=$(basename "$(dirname "$_ft")")
    [ -z "$ONLY" ] || [ "$ONLY" = "$_mod" ] || continue
    _mdir="$OUT/vendor/$_mod"
    mkdir -p "$_mdir"
    for _tab in $(toml "$_ft" | cut -f1 | grep "^$HOST\." | sort -u); do
        entry "$_mod" "$_mdir" "$_ft" "$_tab"
        _n=$(( _n + 1 ))
    done
done
note "$_n entries for $HOST -> $OUT/vendor"
