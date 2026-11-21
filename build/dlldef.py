"""dlldef.py -- a .def for one DLL, from the DLL's own export table (docs/tiko-cpp C2).

    python -I build/dlldef.py <name.dll> <out.def> [--exclude <regex>]

For a DLL mingw-w64 ships no import library for -- the Visual C++ runtime's vcruntime140,
vcruntime140_1 and msvcp140 family -- so build/implibs.sh export has no archive to read.
The DLL in System32 is the only input, and the same one mkmsvcdef.py already trusts for the
code/data split: an export whose RVA lands in an executable section is code, anything else
DATA (mkmsvcdef.dll_truth, whose docstring says why the characteristic and not the name).

--exclude drops matching names. vcruntime140.dll also exports a slice of the C library
(memcpy, strchr, longjmp, ...), which ucrtbase.dll exports too; an import library ordered
ahead of ucrtbase's must not carry those, or every tiko program would bind memcpy to a
Visual C++ redistributable DLL instead of the system's ucrtbase.

Prints "<code> <data>" and exits 2 when the DLL is missing or exports nothing.
"""
import os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mkmsvcdef import dll_truth   # noqa: E402


def main():
    a = sys.argv[1:]
    exclude = None
    if "--exclude" in a:
        i = a.index("--exclude")
        exclude = re.compile(a[i + 1])
        del a[i:i + 2]
    if len(a) != 2:
        print(__doc__)
        return 2
    dll, out = a
    truth = dll_truth(dll)
    if not truth:
        print("dlldef: %s: not in System32, or no exports" % dll, file=sys.stderr)
        return 2
    names = sorted(n for n in truth if not (exclude and exclude.fullmatch(n)))
    code = sum(1 for n in names if truth[n])
    with open(out, "w", newline="\n") as f:
        f.write("LIBRARY %s\nEXPORTS\n" % dll)
        for n in names:
            f.write("  %s%s\n" % (n, "" if truth[n] else " DATA"))
    print(code, len(names) - code)
    return 0


sys.exit(main())
