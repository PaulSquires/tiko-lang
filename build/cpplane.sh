#!/bin/sh
# cpplane.sh -- the C++ lane: tiko-compiled code linked against C++ a C++ compiler built.
#
#   build/cpplane.sh [--no-corpus] [case...]
#
# THE REFERENCE IS THE C++ COMPILER (docs/tiko-cpp, FEASIBILITY 4 C1). Two corpora:
#
#   tests/cpplane/<case>/   lib.cpp, a C++ library; driver.cpp, a C++ main calling it; and
#                           driver.tiko, a tiko main making the same calls. Both drivers print
#                           only through show.cpp, so the tiko program's output must equal the
#                           C++ program's byte for byte -- names (mangling), layouts, by-value
#                           classes, vtables, construction and destruction order all show.
#   tests/vendor/fbc-tests/cpp/
#                           the vendored suite's twelve C++ pairs: the C++ half by the C++
#                           compiler, the BASIC half by tiko with -g, run; a failed ASSERT is a
#                           non-zero exit. Never edited (tests/vendor is fbc's, verbatim).
#
# linux-x86_64 in WSL with g++ (Itanium ABI): bin/tiko compiles each tiko main here with
# '-target linux-x86_64 -c', WSL compiles the C++ and links both programs against the Linux
# tiko-rt. windows-x86_64 is not a lane yet: it is the MSVC ABI, whose names tiko does not
# write (FEASIBILITY 2.6, C4).
#
# Needs WSL with g++, and a Linux tiko-rt: TIKO_LINUX_LIB, else the tree's own
# toolchains/tiko-linux/lib, else C:\dev\tiko-lang's. Exits 1 on any failure.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *) echo "cpplane: run from Windows (it drives WSL)" >&2; exit 3 ;;
esac
TKO=${TIKO_BIN:-"$ROOT/bin/tiko$EXT"}     # TIKO_BIN: another compiler, for a baseline
[ -x "$TKO" ] || { echo "cpplane: build tiko first (build/build.sh)" >&2; exit 3; }
command -v wsl > /dev/null 2>&1 || { echo "cpplane: needs WSL" >&2; exit 3; }

L=${TIKO_LINUX_LIB:-}
[ -n "$L" ] || { [ -d "$ROOT/toolchains/tiko-linux/lib" ] && L="$ROOT/toolchains/tiko-linux/lib"; }
[ -n "$L" ] || L=/c/dev/tiko-lang/toolchains/tiko-linux/lib
[ -f "$L/linux-x86_64/libfb.a" ] || { echo "cpplane: no Linux tiko-rt under $L (set TIKO_LINUX_LIB)" >&2; exit 3; }

CORPUS=1
CASES=""
for a in "$@"; do
    case "$a" in
        --no-corpus) CORPUS=0 ;;
        -*) echo "cpplane: unknown option $a" >&2; exit 3 ;;
        *) CASES="$CASES $a" ;;
    esac
done
[ -n "$CASES" ] || CASES=$(cd "$ROOT/tests/cpplane" && for d in */; do printf '%s ' "${d%/}"; done)
VENDOR="bop call call2 class derived fastcall fbcall mangle mangle-enum mangle-struct this thiscall"

W="$ROOT/build/.cpplane"
rm -rf "$W"
mkdir -p "$W/cases" "$W/corpus"
# A Windows path as WSL sees it: /c/x -> /mnt/c/x.
mnt( ) { echo "$1" | sed 's#^/\([a-zA-Z]\)/#/mnt/\L\1/#'; }

# THE TIKO HALVES, compiled here. A case whose tiko main does not compile is a failure
# recorded now and skipped in WSL.
for c in $CASES; do
    if ! "$TKO" -target linux-x86_64 -c -m driver "$ROOT/tests/cpplane/$c/driver.tiko" \
            -o "$W/cases/$c.o" > "$W/cases/$c.tiko.log" 2>&1; then
        echo "tiko" > "$W/cases/$c.nobuild"
    fi
done
if [ $CORPUS -eq 1 ]; then
    for t in $VENDOR; do
        if ! "$TKO" -target linux-x86_64 -g -c -m "$t-fbc" "$ROOT/tests/vendor/fbc-tests/cpp/$t-fbc.bas" \
                -o "$W/corpus/$t.o" > "$W/corpus/$t.tiko.log" 2>&1; then
            echo "tiko" > "$W/corpus/$t.nobuild"
        fi
    done
fi

# THE C++ HALVES AND BOTH LINKS, in WSL: one script, so one round trip.
RT="$(mnt "$L")/linux-x86_64"
CL="$(mnt "$ROOT/tests/cpplane")"
VD="$(mnt "$ROOT/tests/vendor/fbc-tests/cpp")"
cat > "$W/wsl.sh" <<EOF
cd "$(mnt "$W")" || exit 2
CXX=\${CXX:-g++}
\$CXX -std=c++17 -O1 -c "$CL/show.cpp" -o show.o || exit 2
for c in $CASES; do
    [ -f cases/\$c.nobuild ] && continue
    d="$CL/\$c"
    ( \$CXX -std=c++17 -O1 -c "\$d/lib.cpp" -o cases/\$c.lib.o &&
      \$CXX -std=c++17 -O1 -c "\$d/driver.cpp" -o cases/\$c.drv.o &&
      \$CXX cases/\$c.drv.o cases/\$c.lib.o show.o -o cases/\$c.ref ) > cases/\$c.cxx.log 2>&1 || { echo cxx > cases/\$c.nobuild; continue; }
    \$CXX -no-pie "$RT/fbrt0.o" cases/\$c.o cases/\$c.lib.o show.o "$RT/libfb.a" \
        -lm -lpthread -ltinfo -o cases/\$c.tk > cases/\$c.link.log 2>&1 || { echo link > cases/\$c.nobuild; continue; }
    ./cases/\$c.ref > cases/\$c.ref.out 2>&1; echo \$? > cases/\$c.ref.rc
    timeout 30 ./cases/\$c.tk > cases/\$c.tk.out 2>&1; echo \$? > cases/\$c.tk.rc
done
if [ $CORPUS -eq 1 ]; then
    for t in $VENDOR; do
        [ -f corpus/\$t.nobuild ] && continue
        \$CXX -c -Wall -Wno-attributes "$VD/\$t-cpp.cpp" -o corpus/\$t.cpp.o > corpus/\$t.cxx.log 2>&1 || { echo cxx > corpus/\$t.nobuild; continue; }
        \$CXX -no-pie "$RT/fbrt0.o" corpus/\$t.o corpus/\$t.cpp.o "$RT/libfb.a" \
            -lm -lpthread -ltinfo -o corpus/\$t.tk > corpus/\$t.link.log 2>&1 || { echo link > corpus/\$t.nobuild; continue; }
        timeout 30 ./corpus/\$t.tk > corpus/\$t.tk.out 2>&1; echo \$? > corpus/\$t.tk.rc
    done
fi
exit 0
EOF
sed -i 's/\r$//' "$W/wsl.sh"
MSYS_NO_PATHCONV=1 wsl bash "$(mnt "$W")/wsl.sh" || { echo "cpplane: WSL step failed" >&2; exit 3; }

# THE VERDICTS.
pass=0; fail=0
note( ) { echo "FAIL $1: $2"; [ -f "$3" ] && tr -d '\r' < "$3" | grep -v '^\s*|' | head -6 | sed 's/^/    /'; fail=$((fail + 1)); }
for c in $CASES; do
    if [ -f "$W/cases/$c.nobuild" ]; then
        why=$(cat "$W/cases/$c.nobuild")
        case "$why" in
            tiko) note "$c" "tiko did not compile driver.tiko" "$W/cases/$c.tiko.log" ;;
            cxx)  note "$c" "the C++ side did not build" "$W/cases/$c.cxx.log" ;;
            link) note "$c" "the tiko program did not link" "$W/cases/$c.link.log" ;;
        esac
        continue
    fi
    if [ "$(cat "$W/cases/$c.ref.rc")" != "0" ]; then note "$c" "the C++ reference exited $(cat "$W/cases/$c.ref.rc")" "$W/cases/$c.ref.out"; continue; fi
    if [ "$(cat "$W/cases/$c.tk.rc")" != "0" ]; then note "$c" "the tiko program exited $(cat "$W/cases/$c.tk.rc")" "$W/cases/$c.tk.out"; continue; fi
    if cmp -s "$W/cases/$c.ref.out" "$W/cases/$c.tk.out"; then
        echo "PASS $c"; pass=$((pass + 1))
    else
        echo "FAIL $c: output differs (< C++  > tiko)"
        diff "$W/cases/$c.ref.out" "$W/cases/$c.tk.out" | head -12 | sed 's/^/    /'
        fail=$((fail + 1))
    fi
done
if [ $CORPUS -eq 1 ]; then
    for t in $VENDOR; do
        if [ -f "$W/corpus/$t.nobuild" ]; then
            why=$(cat "$W/corpus/$t.nobuild")
            case "$why" in
                tiko) note "cpp/$t" "tiko did not compile $t-fbc.bas" "$W/corpus/$t.tiko.log" ;;
                cxx)  note "cpp/$t" "the C++ half did not build" "$W/corpus/$t.cxx.log" ;;
                link) note "cpp/$t" "did not link" "$W/corpus/$t.link.log" ;;
            esac
            continue
        fi
        rc=$(cat "$W/corpus/$t.tk.rc")
        if [ "$rc" = "0" ]; then echo "PASS cpp/$t"; pass=$((pass + 1)); else note "cpp/$t" "exited $rc" "$W/corpus/$t.tk.out"; fi
    done
fi
echo "cpplane: $pass passed, $fail failed"
[ $fail -eq 0 ]
