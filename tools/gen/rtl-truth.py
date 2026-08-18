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

ROOT = Path(__file__).resolve().parents[2]
FBC = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe")
LIB = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows\lib\win64\libfb.a")
OUT = ROOT / "tests/expected/fbc-rtl.txt"
WORK = ROOT / "build/.rt"

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


def main() -> int:
    if not FBC.exists():
        print(f"rtl-truth: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    sigs = {}
    for name, body in PROBES.items():
        src = WORK / (name + ".bas")
        src.write_text(body.lstrip(), encoding="utf-8")
        cmd = [str(FBC), "-c", "-r", str(src), "-o", str(WORK / (name + ".o"))]
        if name in MAIN_MODULE:
            cmd += ["-m", name]
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=str(WORK))
        c = WORK / (name + ".c")
        if not c.exists():
            print(f"rtl-truth: {name}: no C intermediate\n"
                  + (proc.stdout or "") + (proc.stderr or ""), file=sys.stderr)
            continue
        for line in c.read_text(encoding="utf-8", errors="replace").splitlines():
            line = line.strip()
            # A declaration, not a call: ends in ');' and has no assignment or body.
            m = re.fullmatch(r"([A-Za-z_][\w \*]*?)\s+(fb_\w+)\s*\(([^;{]*)\)\s*;", line)
            if m:
                ret, fn, args = m.group(1).strip(), m.group(2), m.group(3).strip()
                # 'fb_ctor__<module>' is the per-translation-unit constructor fbc
                # generates and defines ITSELF. It is not a runtime import, and
                # counting it made the libfb cross-check report five false absences.
                if fn.startswith("fb_ctor__") or ret.startswith("static"):
                    continue
                args = " ".join(args.split())
                sigs.setdefault(fn, (ret, args))

    if not sigs:
        print("rtl-truth: no runtime declarations found", file=sys.stderr)
        return 1

    # Cross-check every name against the runtime archive. A name absent from libfb is
    # a signature fbx would emit and the linker would then reject.
    libdata = LIB.read_bytes() if LIB.exists() else b""
    rows, missing = [], []
    for fn in sorted(sigs):
        ret, args = sigs[fn]
        present = fn.encode("ascii") in libdata
        if not present:
            missing.append(fn)
        rows.append(f"{fn}\t{ret}\t{args}\t{'lib' if present else 'ABSENT'}")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"rtl-truth: {len(rows)} runtime functions -> tests/expected/fbc-rtl.txt")
    if missing:
        print(f"rtl-truth: {len(missing)} NOT found in libfb.a: " + ", ".join(missing))
    return 0


if __name__ == "__main__":
    sys.exit(main())
