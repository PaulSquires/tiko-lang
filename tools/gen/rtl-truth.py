#!/usr/bin/env python3
"""Extract the runtime ABI from what FBC EMITS, and check it against libfb.

    python tools/gen/rtl-truth.py

Writes tests/expected/fbc-rtl.txt: one row per runtime function, with the exact C
signature fbc declares for it.

Why this and not fbc's own rtl-*.bas tables: those are compiler SOURCE and are GPL,
and docs/plan/11 already flags the runtime's licence as a prerequisite for release.
The signatures are recoverable from the artifact instead -- 'fbc -r' leaves a C
intermediate that DECLARES every runtime function it calls -- which is both
licence-clean and better evidence, because it is what fbc actually emits rather than
what a table says it should.

Every name is then checked against libfb.a, so a signature that no longer matches an
exported symbol is caught here rather than at link time.
"""
import re
import subprocess
import sys
from pathlib import Path

import fbxtargets

ROOT = Path(__file__).resolve().parents[2]

# The toolchains live in fbxtargets, so control.py can point a half elsewhere.
TARGETS = {
    "win64": (fbxtargets.FBC64, fbxtargets.TC / "lib/win64/libfb.a",
              ROOT / "tests/expected/fbc-rtl.txt", ROOT / "build/.rt", []),
    "win32": (fbxtargets.FBC32, fbxtargets.TC / "lib/win32/libfb.a",
              ROOT / "tests/expected/fbc-rtl-win32.txt", ROOT / "build/.rt32",
              ["-gen", "gcc"]),
}

# Each probe is a fragment whose lowering pulls in a family of runtime calls. They are
# deliberately small: the point is to make fbc declare the functions, not to exercise
# them.
# Probes that must be compiled as the MAIN module. fb_Init/fb_End are emitted only for
# the entry translation unit, so without -m they never appear and the inventory cannot
# be checked against them.
MAIN_MODULE = {"module"}

PROBES = {
    # Module-level code, which fbc wraps in main(): fb_Init before the body, fb_End
    # after the cleanups.
    "module": '''
dim as long g = 7
dim as string s = "hi"
print g
''',
    "string": '''
sub P( )
    dim as string a, b
    a = "x"
    a = b
    a = a + b
    a = "abc" + b
    a = b + a
    if a = b then
    end if
    a = left(b, 1)
    a = mid(b, 1, 2)
    a = str(1)
    dim as long n = len(a)
    dim as long v = valint(a)
end sub
''',
    # SWAP: strings go through the runtime, scalars are a temporary and three stores.
    # The FIXED-LENGTH and aggregate forms are different entry points again --
    # fb_WstrSwap for wide, fb_MemSwap for a UDT by size -- and a probe that swaps only
    # two var-length strings never makes fbc emit them.
    "swap": '''
type SwapU
    as integer a, b
end type
sub S( )
    dim as string a, b
    dim as zstring * 5 z1, z2
    dim as wstring * 5 w1, w2
    dim as SwapU u1, u2
    swap a, b
    swap z1, z2
    swap w1, w2
    swap u1, u2
end sub
''',
    # DELETE is not an fb_* entry point at all: fbc emits libc's free, guarded by a
    # null check, with the destructor called first.
    "deletestmt": '''
type DelU
    as integer a
    declare destructor( )
end type
destructor DelU( )
end destructor
sub D( )
    dim as DelU ptr p = new DelU
    delete p
end sub
''',
    # WIDE STRINGS. A wstring value is a bare uint16*; there is no descriptor and no
    # var-length form. The probe has to touch each shape separately because fbc picks a
    # different entry for wide-to-wide, wide-from-narrow and wide-to-narrow.
    "wstring": '''
declare sub WTake( byref x as const wstring )
sub WProbe( )
    dim as wstring * 50 w, w2
    dim as string s
    dim as long n
    w = "abc"
    w = w2
    s = w
    n = len( w )
    if w = w2 then
    end if
    w = w & w2
    w &= w2
    print w
    w = wstr( n )
    dim as ulong u : w = wstr( u )
    dim as longint q : w = wstr( q )
    dim as ulongint uq : w = wstr( uq )
    dim as single f : w = wstr( f )
    dim as double d : w = wstr( d )
    w = wstr( s )
    s = str( w )
    dim as wstring ptr p = @w
    dim as wstring * 8 w3
    w3 = w & s
    w3 = s & w
    '' fb_WstrConcat proper is emitted only where the result is a genuine RVALUE:
    '' assigning into a fixed wstring is optimised into assign + concat-assign.
    WTake( w & w2 )
end sub
sub WTake( byref x as const wstring )
end sub
''',
    # INPUT: a start call, then one per destination. LINE INPUT is one call with the
    # destination inside it.
    "inputstmt": '''
sub I( )
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint li : dim as ulongint uli
    dim as single f : dim as double d
    dim as string s : dim as wstring * 8 w
    input b : input ub : input sh : input ush
    input l : input ul : input li : input uli
    input f : input d : input s : input w
    input "prompt"; l
    input ; l
    input #1, l
    line input s
    line input "p"; s
end sub
''',
    # FreeBASIC's BUILT-IN PROCEDURES. fbc predeclares these and lowers each straight
    # to a runtime call -- 'allocate' is libc malloc, the mutex four are fb_Mutex*, and
    # fb_Assert is reachable with nothing declaring it at all.
    "builtins": '''
sub B( )
    dim as any ptr p = allocate( 16 )
    dim as any ptr q = callocate( 4, 8 )
    dim as any ptr r = reallocate( p, 32 )
    deallocate( q )
    dim as any ptr m = mutexcreate( )
    mutexlock( m )
    mutexunlock( m )
    mutexdestroy( m )
    fb_Assert( __FILE__, __LINE__, __FUNCTION__, "e" )
end sub
''',
    # CLOSE with no operand closes every open file, which is its own entry point.
    # ERROR raises a runtime error; its return value is the address of the installed
    # handler, so its signature is only visible where fbc emits the call.
    "fileerr": '''
sub F( )
    dim as string ln
    close #1
    close
    line input #1, ln
    error( 5 )
end sub
''',
    "print": '''
sub P( )
    dim as string s
    print s
    print 1
    print
    print "lit"
    print s; 1
    print s, 1
end sub
''',
    # Every scalar type has its OWN print entry point; there is no generic one. A
    # POINTER has no entry of its own and goes through fb_PrintULongint.
    "printtypes": '''
sub Q( )
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint li : dim as ulongint uli
    dim as single f : dim as double d : dim as boolean bo
    dim as any ptr pp
    print b : print ub : print sh : print ush
    print l : print ul : print li : print uli
    print f : print d : print bo : print pp
end sub
''',
    "array": '''
sub P( )
    dim as long a( )
    redim a(0 to 3)
    redim preserve a(0 to 7)
    erase a
end sub
''',
    "mem": '''
type U
    as long v
end type
sub P( )
    dim as U ptr p = new U
    delete p
end sub
''',
    "file": '''
sub P( )
    dim as string s
    open "f" for input as #1
    line input #1, s
    close #1
end sub
''',
}


# A declaration, not a call: ends in ');' and has no assignment or body. win32 adds
# '__stdcall' and an asm() alias carrying the DECORATED name -- '_fb_StrAssign@20' --
# which is exactly what fbx has to emit there, so it is captured rather than stripped.
# NOT ONLY 'fb_*'. DELETE lowers to libc's 'free' -- fbc emits 'void free( void* );'
# with no prefix at all -- so the pattern names the extra functions explicitly rather
# than assuming every runtime entry point is prefixed.
DECL = re.compile(
    r"([A-Za-z_][\w \*]*?)\s+(?:__stdcall\s+)?((?:fb_\w+|free|malloc|calloc|realloc))"
    r"\s*\(([^;{]*?)\)"
    r"(?:\s*asm\(\"([^\"]*)\"\))?\s*;")


def one_target(label, fbc, lib, out, work, extra) -> int:
    if not fbc.exists():
        print(f"rtl-truth: {label}: no fbc at {fbc}", file=sys.stderr)
        return 3
    work.mkdir(parents=True, exist_ok=True)

    sigs = {}
    for name, body in PROBES.items():
        src = work / (name + ".bas")
        src.write_text(body.lstrip(), encoding="utf-8")
        cmd = [str(fbc), "-c", "-r", str(src), "-o", str(work / (name + ".o"))] + extra
        if name in MAIN_MODULE:
            cmd += ["-m", name]
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=str(work))
        c = work / (name + ".c")
        if not c.exists():
            print(f"rtl-truth: {label}: {name}: no C intermediate\n"
                  + (proc.stdout or "") + (proc.stderr or ""), file=sys.stderr)
            continue
        for line in c.read_text(encoding="utf-8", errors="replace").splitlines():
            m = DECL.fullmatch(line.strip())
            if m:
                ret, fn, args = m.group(1).strip(), m.group(2), m.group(3).strip()
                # 'fb_ctor__<module>' is the per-translation-unit constructor fbc
                # generates and defines ITSELF. It is not a runtime import, and
                # counting it made the libfb cross-check report five false absences.
                if fn.startswith("fb_ctor__") or ret.startswith("static"):
                    continue
                args = " ".join(args.split())
                # No asm() clause means fbc did not decorate it, which on win32 is the
                # VARIADIC functions -- cdecl, because varargs need caller cleanup. They
                # still take the leading underscore: the archive holds '_fb_ArrayRedimEx'
                # with no '@N'. The C intermediate never spells that, so it is supplied
                # here rather than left looking like an undecorated symbol.
                sym = m.group(4)
                if sym is None:
                    sym = ("_" + fn) if label == "win32" else fn
                sigs.setdefault(fn, (ret, args, sym))

    if not sigs:
        print(f"rtl-truth: {label}: no runtime declarations found", file=sys.stderr)
        return 1

    # Cross-check every name against the runtime archive. A name absent from libfb is
    # a signature fbx would emit and the linker would then reject.
    libdata = lib.read_bytes() if lib.exists() else b""
    rows, missing = [], []
    for fn in sorted(sigs):
        ret, args, sym = sigs[fn]
        present = sym.encode("ascii") in libdata
        if not present:
            missing.append(fn)
        rows.append(f"{fn}\t{ret}\t{args}\t{'lib' if present else 'ABSENT'}\t{sym}")

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"rtl-truth: {label}: {len(rows)} runtime functions -> {out.name}")
    if missing:
        print(f"rtl-truth: {label}: {len(missing)} NOT in libfb.a: " + ", ".join(missing))
    return 0


def main() -> int:
    rc = 0
    for label, (fbc, lib, out, work, extra) in TARGETS.items():
        if one_target(label, fbc, lib, out, work, extra) not in (0,):
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
