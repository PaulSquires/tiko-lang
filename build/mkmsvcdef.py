"""mkmsvcdef.py -- a .def for one DLL, from fbc's GNU import library.

    python build/mkmsvcdef.py <lib<name>.dll.a> <name.dll> <out.def>

Prints "<code> <data> <source>" and exits 2 when the archive exports nothing.

WHICH EXPORTS ARE DATA is the only hard question here, and getting it wrong is
silent: a function marked DATA links, and the caller loads a pointer where it
should have called a thunk.

THE ARCHIVE CANNOT ALWAYS SAY. A GNU import member defines __imp_X, and a code
import usually also defines the thunk X in the same member -- so "no thunk"
looks like data. That holds for most of fbc's import libraries and not for all
of them: libucrtbase.dll.a carries 2589 thunks for 2652 imports, and 63 of the
exports with no thunk are functions. floor and floorf are two, which is how
this was found -- a link against our own ucrtbase.lib reported both undefined
while ucrtbase.dll exports them.

THE DLL IS THE SOURCE OF TRUTH. An export whose RVA lands in a section marked
executable is code. Measured: floor is at RVA 0xf8040 in ucrtbase.dll, which
falls in 'fothk' -- a forwarder-thunk section that is NOT .text but IS marked
IMAGE_SCN_CNT_CODE. A test on the section NAME would have got it wrong too; the
characteristic is what decides.

WHEN THE DLL IS NOT ON THIS MACHINE -- and many in fbc's tree are for Windows
components that no longer ship -- the archive heuristic stands, and anything
with no evidence either way is called CODE. That is the safe error: a function
marked DATA breaks every call, while data marked CODE leaves an unused thunk
and __imp_X still resolves to the right slot.
"""
import subprocess, sys, os, re

LLVM = os.environ.get("LLVM_BIN", r"C:/Program Files/LLVM/bin")


def dll_truth(dll):
    """{name: is_code} read from the DLL itself, or None if unavailable."""
    root = os.environ.get("SystemRoot", os.path.join("C:" + os.sep, "Windows"))
    path = os.path.join(root, "System32", dll)
    if not os.path.isfile(path):
        return None
    try:
        sec = subprocess.run([LLVM + "/llvm-readobj.exe", "--sections", path],
                             capture_output=True, text=True, timeout=180).stdout
        exp = subprocess.run([LLVM + "/llvm-objdump.exe", "-p", path],
                             capture_output=True, text=True, timeout=180).stdout
    except Exception:
        return None

    ranges = []
    name = va = vs = None
    iscode = False

    def flush():
        if name is not None and va is not None:
            ranges.append((va, va + (vs or 0), iscode))

    for line in sec.splitlines():
        t = line.strip()
        m = re.match(r"Name: (\S+)", t)
        if m:
            flush()
            name, va, vs, iscode = m.group(1), None, None, False
        elif t.startswith("VirtualAddress:"):
            va = int(t.split()[1], 16)
        elif t.startswith("VirtualSize:"):
            vs = int(t.split()[1], 16)
        elif "IMAGE_SCN_CNT_CODE" in t or "IMAGE_SCN_MEM_EXECUTE" in t:
            iscode = True
    flush()
    if not ranges:
        return None

    out = {}
    for line in exp.splitlines():
        m = re.match(r"\s*\d+\s+0x([0-9a-fA-F]+)\s+(\S+)\s*$", line)
        if m:
            rva, nm = int(m.group(1), 16), m.group(2)
            code = True
            for lo, hi, c in ranges:
                if lo <= rva < hi:
                    code = c
                    break
            out[nm] = code
            continue
        # A FORWARDED EXPORT has no RVA of its own -- kernel32's
        # EnterCriticalSection is "(forwarded to NTDLL.RtlEnterCriticalSection)".
        # It is a real export and it is code. Missing these would have deleted
        # most of kernel32 from the generated library.
        m = re.match(r"\s*\d+\s+(\S+) \(forwarded to ", line)
        if m:
            out[m.group(1)] = True
    return out or None


def scan_archive(archive):
    out = subprocess.run([LLVM + "/llvm-nm.exe", "--no-demangle", archive],
                         capture_output=True, text=True).stdout
    members, cur = [], None
    for line in out.splitlines():
        s = line.strip()
        if not s:
            continue
        if s.endswith(":") and " " not in s:
            cur = {"imp": set(), "text": set()}
            members.append(cur)
            continue
        if cur is None:
            continue
        p = s.split()
        if len(p) == 2:
            typ, name = p[0], p[1]
        elif len(p) >= 3:
            typ, name = p[-2], p[-1]
        else:
            continue
        # DEFINED only. 'U __imp_X' is a REFERENCE from a real object inside the
        # archive, not an export of it -- counting those reported msvcrt's
        # GetProcAddress and EnterCriticalSection as data exports.
        if typ == "I" and name.startswith("__imp_"):
            cur["imp"].add(name[6:])
        elif typ == "T":
            cur["text"].add(name)
    code, data = set(), set()
    for m in members:
        for n in m["imp"]:
            (code if n in m["text"] else data).add(n)
    return code, data


def main():
    archive, dll, out = sys.argv[1], sys.argv[2], sys.argv[3]
    code, data = scan_archive(archive)
    if not (code or data):
        return 2
    truth = dll_truth(dll)
    src = "archive"
    dropped = 0
    if truth:
        src = "dll"
        for n in sorted(data):
            if truth.get(n, True):
                data.discard(n)
                code.add(n)
        # AN EXPORT THE DLL DOES NOT HAVE IS WORSE THAN A MISSING ONE. fbc's
        # libucrtbase.dll.a lists 'fileno'; ucrtbase.dll exports only '_fileno'.
        # Reproducing that name gave a binary the loader refused to start, with
        # no message -- a graphics program built fine and exited 127 while the
        # same program without graphics ran. Harmless in fbc's tree because
        # nothing there references it; fatal here because tiko-rt does.
        for bucket in (code, data):
            for n in sorted(bucket):
                if n not in truth:
                    bucket.discard(n)
                    dropped += 1
    lines = ["LIBRARY " + dll, "EXPORTS"]
    lines += ["  " + n for n in sorted(code)]
    lines += ["  " + n + "  DATA" for n in sorted(data)]
    open(out, "w").write("\n".join(lines) + "\n")
    print("%d %d %s %d" % (len(code), len(data), src, dropped))
    return 0


if __name__ == "__main__":
    sys.exit(main())
