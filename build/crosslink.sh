#!/bin/sh
# crosslink.sh -- fbc's object linked with tiko's, both ways, and run.
#
#   build/crosslink.sh
#
# THE HEADLINE COMPATIBILITY TEST (docs/plan/11 section 8). Output comparison
# proves two compilers agree about a program; this proves their OBJECTS agree
# about each other -- calling convention, name mangling, and the one runtime they
# both end up sharing. A difference here is not a wrong answer, it is a link that
# fails or a call that returns nonsense.
#
# NOT PART OF build/test.sh, because the runner drives tiko-lang and nothing else:
# every case here needs fbc invoked as well, and a suite that shells out to a
# second compiler is a different kind of thing from one that compares text.
#
# WIN64, NOT THE DEFAULT TARGET. tiko-lang defaults to windows-x86_64 and fbc is a
# MinGW toolchain, so their objects cannot meet there -- different CRT, different
# startup. '-target win64' is the MinGW ABI and is the only place this test has
# any meaning. That is a real limit on the result, not a detail of the harness:
# what is proven compatible is tiko-lang's MinGW output, which is not what it
# ships by default.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
. "$(dirname "$0")/toolchain.sh"    # TIKO_ORACLE_FBC, TIKO_ORACLE_ROOT, TIKO_CLANG (BLD-12)
FBC=${FBC:-$TIKO_ORACLE_FBC}
TIKO=${TIKO:-"$ROOT/bin/tiko.exe"}
TC="$ROOT/toolchains/tiko-windows"
LIBS="-p $TC/lib/win64 -p $TC/lib/win64-fb"

die( ) { echo "crosslink: $*" >&2; exit 1; }
note( ) { echo "crosslink: $*"; }

[ -x "$FBC" ]  || { echo "crosslink: SKIPPED -- no oracle fbc at $FBC (TIKO_ORACLE_FBC, or FBC)"; exit 77; }
[ -x "$TIKO" ] || die "no tiko at $TIKO (set TIKO)"
# THE PACKAGED win64 TREE FIRST, THEN THE ONE THIS CHECKOUT BUILT. package.sh stopped
# packaging win64 on 2026-10-10, and from then this script skipped on every run while
# check-all reported it as passing. lib/rt/build/build.sh still builds tiko-rt for win64,
# and the MinGW CRT objects win64-fb carried are the oracle fbc's own lib/win64.
if [ ! -d "$TC/lib/win64" ]; then
    FBCLIB="$(dirname "$FBC")/lib/win64"
    if [ -f "$ROOT/lib/rt/lib/win64/libfb.a" ] && [ -d "$FBCLIB" ]; then
        LIBS="-p $ROOT/lib/rt/lib/win64 -p $FBCLIB"
        note "no packaged win64 runtime -- using lib/rt/lib/win64 and $FBCLIB"
    else
        # Still a skip, but one check-all can see: exit 77, the automake SKIP code.
        echo "crosslink: SKIPPED -- no win64 runtime (lib/rt/build/build.sh Release win64)"
        exit 77
    fi
fi

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

fail=0
check( ) {
    # $1 name, $2 expected output, $3 actual
    if [ "$2" = "$3" ]; then
        note "$1 PASS"
    else
        note "$1 FAIL -- expected '$2', got '$3'"
        fail=$(( fail + 1 ))
    fi
}

# ---------------------------------------------------------------- the halves
#
# ONE VALUE OF EACH SHAPE THAT CAN DISAGREE. An integer proves the call happened;
# a double proves the floating-point register half of the convention; a string
# proves the two agree about a descriptor, which is the one that would silently
# return garbage rather than fail to link.
cat > fbchalf.bas <<'EOF'
public function FbcAdd cdecl alias "FbcAdd" ( byval a as long, byval b as long ) as long
    return a + b
end function
public function FbcScale cdecl alias "FbcScale" ( byval d as double ) as double
    return d * 2.5
end function
public function FbcName cdecl alias "FbcName" ( ) as string
    return "from-fbc"
end function
EOF

cat > tikohalf.bas <<'EOF'
public function TikoAdd cdecl alias "TikoAdd" ( byval a as long, byval b as long ) as long
    return a * b
end function
public function TikoScale cdecl alias "TikoScale" ( byval d as double ) as double
    return d + 0.25
end function
EOF

# ------------------------------------------- fbc's object, tiko-lang's program
cat > usefbc.bas <<'EOF'
declare function FbcAdd cdecl alias "FbcAdd" ( byval a as long, byval b as long ) as long
declare function FbcScale cdecl alias "FbcScale" ( byval d as double ) as double
declare function FbcName cdecl alias "FbcName" ( ) as string
print FbcAdd( 20, 22 ); " "; FbcScale( 4.0 ); " "; FbcName( )
EOF

note "fbc object -> tiko-lang program"
"$FBC" -c fbchalf.bas -o fbchalf.o >/dev/null
"$TIKO" -target win64 $LIBS usefbc.bas fbchalf.o -o a1.exe >/dev/null
check "fbc-into-tiko" " 42  10 from-fbc" "$(./a1.exe)"

# ------------------------------------------- tiko-lang's object, fbc's program
cat > usetiko.bas <<'EOF'
declare function TikoAdd cdecl alias "TikoAdd" ( byval a as long, byval b as long ) as long
declare function TikoScale cdecl alias "TikoScale" ( byval d as double ) as double
print TikoAdd( 6, 7 ); " "; TikoScale( 1.5 )
EOF

note "tiko-lang object -> fbc program"
"$TIKO" -target win64 $LIBS -c tikohalf.bas -o tikohalf.o >/dev/null
"$FBC" usetiko.bas tikohalf.o -x a2.exe >/dev/null
check "tiko-into-fbc" " 42  1.75" "$(./a2.exe)"

# -------------------------------------------------- both halves in one binary
#
# The pair above each prove one direction. This proves they can be in the SAME
# program: one runtime, one set of startup objects, both compilers' code calling
# into it.
cat > both.bas <<'EOF'
declare function FbcAdd cdecl alias "FbcAdd" ( byval a as long, byval b as long ) as long
declare function TikoAdd cdecl alias "TikoAdd" ( byval a as long, byval b as long ) as long
print FbcAdd( 1, 2 ) + TikoAdd( 3, 4 )
EOF

note "both objects in one program"
"$TIKO" -target win64 $LIBS both.bas fbchalf.o tikohalf.o -o a3.exe >/dev/null
check "both-halves" " 15" "$(./a3.exe)"

if [ "$fail" != "0" ]; then
    die "$fail case(s) failed"
fi
note "ok -- 3 cases"
