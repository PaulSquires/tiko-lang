#!/bin/sh
# cpplane.sh -- the C++ lane: tiko-compiled code linked against C++ a C++ compiler built.
#
#   build/cpplane.sh [--no-corpus] [--no-linux] [--no-msvc] [case...]
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
#   tests/cpplane/msvc/<case>/
#                           windows-x86_64, the MSVC ABI (C2): the same three files, the library
#                           behind a C API or a COM-style interface -- tiko writes no Microsoft
#                           names (FEASIBILITY C4). lib.cpp is built TWICE, by clang for the
#                           msvc triple and by Visual Studio's cl.exe /MD /EHsc /O2 when one is
#                           installed; the reference program links the Visual Studio way, the
#                           tiko one with no Visual Studio at all -- ucrtbase, the C++ runtime's
#                           import libraries and tiko-rt's msvccxx.c.
#
# linux-x86_64 in WSL with g++ (Itanium ABI): bin/tiko compiles each tiko main here with
# '-target linux-x86_64 -c', WSL compiles the C++ and links both programs against the Linux
# tiko-rt. Needs WSL with g++, and a Linux tiko-rt: TIKO_LINUX_LIB, else the tree's own
# toolchains/tiko-linux/lib, else C:\dev\tiko-lang's. The MSVC leg needs the tree's
# build/obj/rtlib/windows-x86_64 (build/test.sh builds it). Exits 1 on any failure.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *) echo "cpplane: run from Windows (it drives WSL)" >&2; exit 3 ;;
esac
TKO=${TIKO_BIN:-"$ROOT/bin/tiko$EXT"}     # TIKO_BIN: another compiler, for a baseline
[ -x "$TKO" ] || { echo "cpplane: build tiko first (build/build.sh)" >&2; exit 3; }
CORPUS=1
LINUX=1
MSVC=1
CASES=""
for a in "$@"; do
    case "$a" in
        --no-corpus) CORPUS=0 ;;
        --no-linux) LINUX=0 ;;
        --no-msvc) MSVC=0 ;;
        -*) echo "cpplane: unknown option $a" >&2; exit 3 ;;
        *) CASES="$CASES $a" ;;
    esac
done
[ -n "$CASES" ] || CASES=$(cd "$ROOT/tests/cpplane" && for d in */; do [ "$d" = "msvc/" ] || printf '%s ' "${d%/}"; done)
MCASES=$(cd "$ROOT/tests/cpplane/msvc" && for d in */; do printf '%s ' "${d%/}"; done)
if [ $LINUX -eq 0 ]; then CASES=""; CORPUS=0; fi

if [ $LINUX -eq 1 ]; then
    command -v wsl > /dev/null 2>&1 || { echo "cpplane: needs WSL (or --no-linux)" >&2; exit 3; }
    L=${TIKO_LINUX_LIB:-}
    [ -n "$L" ] || { [ -d "$ROOT/toolchains/tiko-linux/lib" ] && L="$ROOT/toolchains/tiko-linux/lib"; }
    [ -n "$L" ] || L=/c/dev/tiko-lang/toolchains/tiko-linux/lib
    [ -f "$L/linux-x86_64/libfb.a" ] || { echo "cpplane: no Linux tiko-rt under $L (set TIKO_LINUX_LIB)" >&2; exit 3; }
fi
VENDOR="bop call call2 class derived fastcall fbcall mangle mangle-enum mangle-struct this thiscall"

W="$ROOT/build/.cpplane"
rm -rf "$W"
mkdir -p "$W/cases" "$W/corpus" "$W/msvc"
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
# THE MSVC LEG, windows-x86_64. Each case's lib.cpp by clang for the msvc triple (/MD) and, when
# Visual Studio is installed, by cl.exe /MD /EHsc /O2 -- the settings a distributed Windows C++
# library is usually built with. The reference links the Visual Studio way (clang's driver
# finds its libraries); the tiko program is linked by tiko with the tree's runtime overlay.
if [ $MSVC -eq 1 ]; then
    CLANG=${TIKO_CLANG:-"/c/Program Files/LLVM/bin/clang.exe"}
    WRT="$ROOT/build/obj/rtlib/windows-x86_64"
    MW="$W/msvc"
    CXF="--target=x86_64-pc-windows-msvc -std=c++17 -O2 -fms-runtime-lib=dll -fexceptions -fcxx-exceptions"
    VCVARS=$(ls "/c/Program Files/Microsoft Visual Studio/"*/*/VC/Auxiliary/Build/vcvars64.bat 2>/dev/null | head -1)
    if [ ! -f "$WRT/libfb.a" ]; then
        echo "FAIL msvc: no $WRT (build/test.sh builds it)"; fail=$((fail + 1))
    elif ! "$CLANG" $CXF -c "$ROOT/tests/cpplane/show.cpp" -o "$MW/show.o" > "$MW/show.log" 2>&1; then
        echo "FAIL msvc: show.cpp did not compile"; fail=$((fail + 1))
    else
        for c in $MCASES; do
            d="$ROOT/tests/cpplane/msvc/$c"
            vars="clang"
            "$CLANG" $CXF -c "$d/lib.cpp" -o "$MW/$c.lib-clang.o" > "$MW/$c.cxx.log" 2>&1 || { note "msvc/$c" "clang did not compile lib.cpp" "$MW/$c.cxx.log"; continue; }
            "$CLANG" $CXF -c "$d/driver.cpp" -o "$MW/$c.drv.o" >> "$MW/$c.cxx.log" 2>&1 || { note "msvc/$c" "clang did not compile driver.cpp" "$MW/$c.cxx.log"; continue; }
            if [ -n "$VCVARS" ]; then
                printf '@echo off\r\ncall "%s" > nul\r\ncl /nologo /std:c++17 /MD /EHsc /O2 /c "%s" /Fo"%s"\r\n' \
                    "$(cygpath -w "$VCVARS")" "$(cygpath -w "$d/lib.cpp")" "$(cygpath -w "$MW/$c.lib-cl.o")" > "$MW/$c.cl.bat"
                cmd //c "$(cygpath -w "$MW/$c.cl.bat")" > "$MW/$c.cl.log" 2>&1 && vars="clang cl"
            fi
            for v in $vars; do
                n="msvc/$c[$v]"
                lo="$MW/$c.lib-$v.o"
                "$CLANG" $CXF -fuse-ld=lld "$MW/$c.drv.o" "$lo" "$MW/show.o" -o "$MW/$c-$v.ref.exe" > "$MW/$c-$v.ref.log" 2>&1 \
                    || { note "$n" "the C++ reference did not link" "$MW/$c-$v.ref.log"; continue; }
                TIKO_LIBPATH="$WRT" "$TKO" -target windows-x86_64 "$d/driver.tiko" "$lo" "$MW/show.o" \
                    -o "$MW/$c-$v.tk.exe" > "$MW/$c-$v.tk.log" 2>&1 || { note "$n" "tiko did not build or link it" "$MW/$c-$v.tk.log"; continue; }
                "$MW/$c-$v.ref.exe" > "$MW/$c-$v.ref.out" 2>&1; rr=$?
                "$MW/$c-$v.tk.exe" > "$MW/$c-$v.tk.out" 2>&1; tr_=$?
                if [ $rr -ne 0 ]; then note "$n" "the C++ reference exited $rr" "$MW/$c-$v.ref.out"; continue; fi
                if [ $tr_ -ne 0 ]; then note "$n" "the tiko program exited $tr_" "$MW/$c-$v.tk.out"; continue; fi
                if cmp -s "$MW/$c-$v.ref.out" "$MW/$c-$v.tk.out"; then
                    echo "PASS $n"; pass=$((pass + 1))
                else
                    echo "FAIL $n: output differs (< C++  > tiko)"
                    diff "$MW/$c-$v.ref.out" "$MW/$c-$v.tk.out" | head -12 | sed 's/^/    /'
                    fail=$((fail + 1))
                fi
            done
        done
    fi
fi
echo "cpplane: $pass passed, $fail failed"
[ $fail -eq 0 ]
