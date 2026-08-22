#!/usr/bin/env python3
"""Extract FBC's VIRTUAL METHOD TABLES: what is in each slot, in order.

    python tools/gen/vtable-truth.py

Writes tests/types/expected/fbc-vtable.txt and fbc-vtable-win32.txt.

Read straight out of the C fbc generates -- 'static void* _ZTVN1AE[6] = { ... };' -- so
this measures the table fbc actually emits rather than what documentation says it emits.
fbc's own compiler sources are never read.

THE TWO LEADING SLOTS ARE DROPPED. Every table starts with a null word and a pointer to
the type's RTTI record, and the stored vptr points PAST both -- 'ZTV + 16' on win64, '+ 8'
on win32 -- so slot 0 as a call site indexes it is the THIRD initialiser. Keeping them
here would make every index in the file two larger than the one a call site uses.

An abstract method is a real slot holding NULL, not an absent one, and it is recorded as
'0' so that a compiler which simply omitted it would not pass.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import fbxtargets

OUT = ROOT / "tests/types/expected/fbc-vtable.txt"
WORK = ROOT / "build/.vt"

# Each case is (name, source). The shapes are the ones where a slot table goes wrong
# quietly: an override that reuses a slot, an abstract that occupies one, a destructor
# whose position is its declaration position rather than a fixed end, a non-virtual
# method that must NOT appear, and a type that extends object with no virtuals at all.
CASES = [
    ("Simple", """
type VSimple extends object
    declare virtual function f( ) as long
    declare virtual sub g( )
end type
function VSimple.f( ) as long : return 1 : end function
sub VSimple.g( ) : end sub
"""),
    # A non-virtual method and a constructor are NOT in the table.
    ("Mixed", """
type VMixA extends object
    declare virtual function f( ) as long
    declare sub plain( )
    declare constructor( )
end type
function VMixA.f( ) as long : return 1 : end function
sub VMixA.plain( ) : end sub
constructor VMixA( ) : end constructor
"""),
    # An override REUSES the base slot; a new virtual appends after everything
    # inherited, whatever order it was declared in.
    ("Override", """
type VOvrA extends object
    declare virtual function f( ) as long
    declare virtual sub g( )
end type
function VOvrA.f( ) as long : return 1 : end function
sub VOvrA.g( ) : end sub
type VOvrB extends VOvrA
    declare function f( ) as long override
    declare virtual sub h( )
end type
function VOvrB.f( ) as long : return 2 : end function
sub VOvrB.h( ) : end sub
"""),
    # ABSTRACT is a NULL slot, and the override fills that same slot.
    ("Abstract", """
type VAbsA extends object
    declare abstract sub a( )
    declare virtual sub b( )
end type
sub VAbsA.b( ) : end sub
type VAbsB extends VAbsA
    declare sub a( ) override
end type
sub VAbsB.a( ) : end sub
"""),
    # THE DESTRUCTOR'S SLOT IS ITS DECLARATION POSITION. Declared FIRST it is slot 0,
    # and a derived type's destructor inherits that slot rather than appending.
    ("DtorFirst", """
type VDtF extends object
    declare virtual destructor( )
    declare virtual function f( ) as long
end type
destructor VDtF( ) : end destructor
function VDtF.f( ) as long : return 1 : end function
type VDtFB extends VDtF
    declare destructor( )
    declare virtual sub g( )
end type
destructor VDtFB( ) : end destructor
sub VDtFB.g( ) : end sub
"""),
    # ...and declared LAST it is the last slot. Same rule, opposite spelling.
    ("DtorLast", """
type VDtL extends object
    declare virtual function f( ) as long
    declare virtual destructor( )
end type
function VDtL.f( ) as long : return 1 : end function
destructor VDtL( ) : end destructor
"""),
    # THREE LEVELS, so an override two levels down still finds the slot.
    ("ThreeDeep", """
type V3A extends object
    declare virtual function f( ) as long
end type
function V3A.f( ) as long : return 1 : end function
type V3B extends V3A
    declare virtual sub g( )
end type
sub V3B.g( ) : end sub
type V3C extends V3B
    declare function f( ) as long override
end type
function V3C.f( ) as long : return 3 : end function
"""),
    # OVERLOADS of one virtual name are separate slots, and an override matches by
    # PARAMETER TYPES rather than by name alone.
    ("Overloads", """
type VOvlA extends object
    declare virtual sub f( byval a as long )
    declare virtual sub f( byval a as double )
end type
sub VOvlA.f( byval a as long ) : end sub
sub VOvlA.f( byval a as double ) : end sub
type VOvlB extends VOvlA
    declare sub f( byval a as double ) override
end type
sub VOvlB.f( byval a as double ) : end sub
"""),
    # A type that extends object and declares NO virtual at all still gets a table --
    # the two leading slots and nothing else, so zero here.
    ("NoVirt", """
type VNone extends object
    x as long
end type
"""),
]


def one_target(label, fbc, out, work) -> int:
    if not fbc.exists():
        print(f"vtable-truth: {label}: fbc not found at {fbc}", file=sys.stderr)
        return 3
    work.mkdir(parents=True, exist_ok=True)

    lines = []
    for _, src in CASES:
        lines.append(src.strip())
    lines.append("dim as long __vt_keep")

    src = work / "vt.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")
    args = [str(fbc), "-r", "-gen", "gcc", "vt.bas"]
    if label == "win32":
        args += ["-target", "win32"]
    proc = subprocess.run(args, cwd=work, capture_output=True, text=True)
    cfile = work / "vt.c"
    if not cfile.exists():
        print(f"vtable-truth: {label}: fbc produced no C\n{proc.stdout}{proc.stderr}",
              file=sys.stderr)
        return 3
    text = cfile.read_text(encoding="utf-8", errors="replace")

    # ON WIN32 THE C IDENTIFIER IS NOT THE SYMBOL. fbc declares each method
    #
    #   int32 __stdcall _ZN7VSIMPLE1FEv( ... ) asm("__ZN7VSIMPLE1FEv@4");
    #
    # so the vtable initialiser names a C identifier that the assembler then spells
    # differently. What fbx emits -- and what a linker resolves -- is the asm name, so
    # the table is recorded in those terms. A function with NO asm name is cdecl and
    # takes the plain leading underscore; fbc emits DESTRUCTORS that way even where
    # every other method is stdcall, which is measured here rather than assumed.
    asmname = {}
    if label == "win32":
        for m in re.finditer(r'(\w+)\s*\([^;]*\)\s*asm\("([^"]+)"\)', text):
            asmname[m.group(1)] = m.group(2)

    def symbol_of(nm):
        if nm == "0" or label != "win32":
            return nm
        return asmname.get(nm, "_" + nm)

    # 'static void* _ZTVN1AE[6] = { (void*)0ull, (void*)&_ZTSN1AE, (void*)&_ZN1A3VF1Ev };'
    rows = []
    for m in re.finditer(r"static void\* (_ZTV\w+)\[(\d+)\] = \{([^}]*)\};", text):
        table, entries = m.group(1), m.group(3)
        slots = []
        for e in entries.split(","):
            e = e.strip()
            if not e:
                continue
            n = re.search(r"&\s*(\w+)", e)
            slots.append(n.group(1) if n else "0")
        # Drop the leading null and RTTI pointer: the stored vptr points past both.
        slots = [symbol_of(x) for x in slots[2:]]
        rows.append((table, slots))

    out.parent.mkdir(parents=True, exist_ok=True)
    body = []
    for table, slots in sorted(rows):
        body.append(f"{table}\tcount\t{len(slots)}")
        for i, s in enumerate(slots):
            body.append(f"{table}\tslot\t{i}\t{s}")
    out.write_text("\n".join(body) + "\n", encoding="utf-8")
    print(f"vtable-truth: {label}: {len(rows)} tables -> {out.name}")
    return 0


def main() -> int:
    rc = 0
    for label, fbc, out, work in fbxtargets.truth_targets(OUT, WORK):
        rc |= one_target(label, fbc, out, work)
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
