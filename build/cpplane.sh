#!/bin/sh
# cpplane.sh -- the C++ lane: tiko-compiled code linked against C++ a C++ compiler built.
#
#   build/cpplane.sh [--no-corpus] [--no-linux] [--no-msvc]
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
#   tests/cpplane/cppinclude/<case>/
#                           C3, the importer: lib.hpp, lib.cpp, driver.cpp and driver.tiko, which
#                           #include's the "lib.ti" that 'tiko -cppimport lib.hpp' writes here,
#                           and whose shim (lib.ti.cpp) is compiled and linked into the tiko
#                           program only. Run on BOTH legs; the Linux import reads libstdc++'s
#                           headers from TIKO_CPP_SYSROOT (default //wsl.localhost/Ubuntu).
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
        *) echo "cpplane: no case arguments; run the whole lane" >&2; exit 3 ;;
    esac
done
# Itanium cases: the top-level ones and cppinclude's. MSVC cases: msvc's and cppinclude's. A case is
# named by its path under tests/cpplane; its files here by that path with '/' made '_'.
CASES=$(cd "$ROOT/tests/cpplane" && for d in */; do case "$d" in msvc/|cppinclude/) ;; *) printf '%s ' "${d%/}" ;; esac; done; \
        for d in cppinclude/*/; do printf '%s ' "${d%/}"; done)
MCASES=$(cd "$ROOT/tests/cpplane" && for d in msvc/*/ cppinclude/*/; do printf '%s ' "${d%/}"; done)
CPPSYSROOT=${TIKO_CPP_SYSROOT:-//wsl.localhost/Ubuntu}
safe( ) { echo "$1" | tr '/' '_'; }
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
    s=$(safe "$c")
    inc=""
    if [ -f "$ROOT/tests/cpplane/$c/lib.hpp" ]; then
        mkdir -p "$W/cases/$s.inc"
        ( cd "$ROOT/tests/cpplane/$c" && MSYS_NO_PATHCONV=1 "$TKO" -target linux-x86_64 -csysroot "$CPPSYSROOT" \
              -cppimport lib.hpp -cppimport-out "$(cygpath -m "$W/cases/$s.inc")/lib.ti" ) > "$W/cases/$s.import.log" 2>&1 \
            || { echo "import" > "$W/cases/$s.nobuild"; continue; }
        inc="-d TKO_LANE_IMPORTED -i $W/cases/$s.inc"
    fi
    if ! "$TKO" -target linux-x86_64 -c -m driver $inc "$ROOT/tests/cpplane/$c/driver.tiko" \
            -o "$W/cases/$s.o" > "$W/cases/$s.tiko.log" 2>&1; then
        echo "tiko" > "$W/cases/$s.nobuild"
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
    s=\$(echo \$c | tr / _)
    [ -f cases/\$s.nobuild ] && continue
    d="$CL/\$c"
    ( \$CXX -std=c++17 -O1 -c "\$d/lib.cpp" -o cases/\$s.lib.o &&
      \$CXX -std=c++17 -O1 -c "\$d/driver.cpp" -o cases/\$s.drv.o &&
      \$CXX cases/\$s.drv.o cases/\$s.lib.o show.o -o cases/\$s.ref ) > cases/\$s.cxx.log 2>&1 || { echo cxx > cases/\$s.nobuild; continue; }
    shim=""
    if [ -f cases/\$s.inc/lib.ti.cpp ]; then
        \$CXX -std=c++17 -O1 -I "\$d" -c cases/\$s.inc/lib.ti.cpp -o cases/\$s.shim.o > cases/\$s.shim.log 2>&1 || { echo shim > cases/\$s.nobuild; continue; }
        shim=cases/\$s.shim.o
    fi
    \$CXX -no-pie "$RT/fbrt0.o" cases/\$s.o \$shim cases/\$s.lib.o show.o "$RT/libfb.a" \
        -lm -lpthread -ltinfo -o cases/\$s.tk > cases/\$s.link.log 2>&1 || { echo link > cases/\$s.nobuild; continue; }
    sh -c "./cases/\$s.ref" > cases/\$s.ref.out 2>&1; echo \$? > cases/\$s.ref.rc
    sh -c "timeout 30 ./cases/\$s.tk" > cases/\$s.tk.out 2>&1; echo \$? > cases/\$s.tk.rc
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
    s=$(safe "$c")
    if [ -f "$W/cases/$s.nobuild" ]; then
        why=$(cat "$W/cases/$s.nobuild")
        case "$why" in
            import) note "$c" "tiko -cppimport failed" "$W/cases/$s.import.log" ;;
            tiko) note "$c" "tiko did not compile driver.tiko" "$W/cases/$s.tiko.log" ;;
            cxx)  note "$c" "the C++ side did not build" "$W/cases/$s.cxx.log" ;;
            shim) note "$c" "the generated shim did not compile" "$W/cases/$s.shim.log" ;;
            link) note "$c" "the tiko program did not link" "$W/cases/$s.link.log" ;;
        esac
        continue
    fi
    if [ "$(cat "$W/cases/$s.ref.rc")" != "0" ]; then note "$c" "the C++ reference exited $(cat "$W/cases/$s.ref.rc")" "$W/cases/$s.ref.out"; continue; fi
    if [ "$(cat "$W/cases/$s.tk.rc")" != "0" ]; then note "$c" "the tiko program exited $(cat "$W/cases/$s.tk.rc")" "$W/cases/$s.tk.out"; continue; fi
    if cmp -s "$W/cases/$s.ref.out" "$W/cases/$s.tk.out"; then
        echo "PASS $c"; pass=$((pass + 1))
    else
        echo "FAIL $c: output differs (< C++  > tiko)"
        diff "$W/cases/$s.ref.out" "$W/cases/$s.tk.out" | head -12 | sed 's/^/    /'
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
            d="$ROOT/tests/cpplane/$c"
            nm=$c
            c=$(safe "$c")
            vars="clang"
            "$CLANG" $CXF -c "$d/lib.cpp" -o "$MW/$c.lib-clang.o" > "$MW/$c.cxx.log" 2>&1 || { note "$nm" "clang did not compile lib.cpp" "$MW/$c.cxx.log"; continue; }
            "$CLANG" $CXF -c "$d/driver.cpp" -o "$MW/$c.drv.o" >> "$MW/$c.cxx.log" 2>&1 || { note "$nm" "clang did not compile driver.cpp" "$MW/$c.cxx.log"; continue; }
            # A cppinclude case goes through '#cppinclude' itself here: tiko imports the header,
            # compiles the shim and links it -- the user's path. Its own cache directory, so a run
            # proves the compile and not an object an earlier run left.
            extra=""
            if [ -f "$d/lib.hpp" ]; then
                rm -rf "$MW/$c.ccache"
                extra="-ccachedir $MW/$c.ccache"
            fi
            if [ -n "$VCVARS" ]; then
                printf '@echo off\r\ncall "%s" > nul\r\ncl /nologo /std:c++17 /MD /EHsc /O2 /c "%s" /Fo"%s"\r\n' \
                    "$(cygpath -w "$VCVARS")" "$(cygpath -w "$d/lib.cpp")" "$(cygpath -w "$MW/$c.lib-cl.o")" > "$MW/$c.cl.bat"
                cmd //c "$(cygpath -w "$MW/$c.cl.bat")" > "$MW/$c.cl.log" 2>&1 && vars="clang cl"
            fi
            for v in $vars; do
                n="$nm[$v]"
                lo="$MW/$c.lib-$v.o"
                "$CLANG" $CXF -fuse-ld=lld "$MW/$c.drv.o" "$lo" "$MW/show.o" -o "$MW/$c-$v.ref.exe" > "$MW/$c-$v.ref.log" 2>&1 \
                    || { note "$n" "the C++ reference did not link" "$MW/$c-$v.ref.log"; continue; }
                TIKO_LIBPATH="$WRT" "$TKO" -target windows-x86_64 $extra "$d/driver.tiko" "$lo" "$MW/show.o" \
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
