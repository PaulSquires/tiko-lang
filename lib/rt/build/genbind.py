"""genbind.py -- tiko-rt's C library binding, cut from a whole -cimport binding.

    python lib/rt/build/genbind.py <full.bi> <src-dir> <target> <out.bi>

The importer's binding of the C library headers (lib/rt/build/sysbind.h) declares some
fifteen hundred things; tiko-rt calls about a hundred. This keeps what the runtime's own
sources NAME -- every identifier in lib/rt/src outside a comment -- and whatever those
declarations need in turn, in the importer's order, so the committed file is short enough
to read and review, and diffs only when the runtime's use of libc does.

Some names are the residue's and never come from here -- see NOT_HERE. They are what no
importer carries: the three streams (a macro over a call), errno (a macro over a call),
and jmp_buf with longjmp (an array type, declared by the residue at its measured size).
"""
import os
import re
import sys

NOT_HERE = {"jmp_buf", "longjmp", "setjmp", "_setjmp", "stdin", "stdout", "stderr",
            "errno", "_errno", "__errno_location", "__iob_func", "__acrt_iob_func"}

HEADER = """'' {target}.bi -- tiko-rt's C library binding for {target}. GENERATED: do not edit.
''
'' Made by lib/rt/build/genbind.sh: tiko's own C importer (-cimport, decision 0016) over
'' lib/rt/build/sysbind.h against {origin}, cut by lib/rt/build/genbind.py
'' to the declarations tiko-rt's sources name and what those need. Regenerate after the
'' runtime starts using another C function; lib/rt/src/inc/sysbind.bi holds the rest.

#pragma once
"""


def items(text):
    """The binding's top-level declarations, in order: (names declared, text)."""
    lines = text.split("\n")
    out = []
    i = 0
    inside = False
    while i < len(lines):
        ln = lines[i]
        i += 1
        if ln.startswith('extern "C"'):
            inside = True
            continue
        if ln.startswith("end extern"):
            inside = False
            continue
        if not inside or not ln.strip():
            continue
        m = re.match(r"^(type|union) (\w+)( field = \d+)?$", ln)
        if m:
            body = [ln]
            close = "end " + m.group(1)
            while i < len(lines) and lines[i] != close:
                body.append(lines[i])
                i += 1
            body.append(close)
            i += 1
            out.append(({m.group(2).lower()}, "\n".join(body)))
            continue
        if ln == "enum":
            body = [ln]
            names = set()
            while i < len(lines) and lines[i] != "end enum":
                body.append(lines[i])
                names.add(lines[i].strip().split(" ")[0].lower())
                i += 1
            body.append("end enum")
            i += 1
            out.append((names, "\n".join(body)))
            continue
        m = (re.match(r"^type (\w+) as ", ln) or re.match(r"^declare (?:function|sub) (\w+)", ln)
             or re.match(r"^extern (?:import )?(\w+)", ln) or re.match(r"^const (\w+)", ln)
             or re.match(r"^#define (\w+)", ln))
        if m:
            out.append(({m.group(1).lower()}, ln))
    return out


DECL_RE = re.compile(r"^\s*(?:declare\s+(?:function|sub)|extern(?:\s+import)?|(?:private\s+)?(?:function|sub)|type|const)\s+(\w+)", re.I)


def own_names(src_dir):
    """What the runtime declares ITSELF -- 'declare function strcasecmp alias ...', its own
    types and constants. Those are its decisions (an alias per ABI, a narrower type) and
    never come from the binding, which would be a second definition beside them."""
    own = set()
    for dp, dn, fn in os.walk(src_dir):
        for f in fn:
            if not (f.endswith(".bas") or f.endswith(".bi")):
                continue
            if os.path.abspath(dp).replace("\\", "/").endswith("inc/sysbind"):
                continue
            for ln in open(os.path.join(dp, f), encoding="utf-8", errors="replace"):
                m = DECL_RE.match(ln.split("''")[0])
                if m and m.group(1).lower() not in ("as", "cdecl", "function", "sub"):
                    own.add(m.group(1).lower())
    return own


def used_names(src_dir):
    used = set()
    for dp, dn, fn in os.walk(src_dir):
        for f in fn:
            if not (f.endswith(".bas") or f.endswith(".bi")):
                continue
            if os.path.abspath(dp).replace("\\", "/").endswith("inc/sysbind"):
                continue
            for ln in open(os.path.join(dp, f), encoding="utf-8", errors="replace"):
                # outside comments and string literals
                ln = re.sub(r'"[^"]*"', '""', ln.split("''")[0])
                for w in re.findall(r"[A-Za-z_]\w*", ln):
                    used.add(w.lower())
    return used


def main():
    full, src_dir, target, out = sys.argv[1:5]
    text = open(full, encoding="utf-8").read()
    its = items(text)
    declares = {}
    for k, (names, body) in enumerate(its):
        for n in names:
            declares.setdefault(n, k)
    used = used_names(src_dir) - own_names(src_dir)
    want = [k for k, (names, body) in enumerate(its)
            if (names & used) and not (names & NOT_HERE)]
    keep = set()
    stack = list(want)
    while stack:
        k = stack.pop()
        if k in keep:
            continue
        keep.add(k)
        # what this one names, past its own name
        for w in re.findall(r"[A-Za-z_]\w*", its[k][1]):
            d = declares.get(w.lower())
            if d is not None and d not in keep and not (its[d][0] & NOT_HERE):
                stack.append(d)
    origin = {"win64": "MinGW-w64's headers", "linux-x86_64": "the system's glibc headers"}.get(target, target)
    o = [HEADER.format(target=target, origin=origin)]
    if '#include once "crt/long.bi"' in text:
        o.append('#include once "crt/long.bi"\n')
    o.append('extern "C"   \'\' NON-FBCALL: the C library, not rtlib entry points.\n')
    for k in sorted(keep):
        o.append(its[k][1])
    o.append('\nend extern\n')
    open(out, "w", newline="\n").write("\n".join(o))
    print("%s: %d of %d declarations" % (out, len(keep), len(its)))


if __name__ == "__main__":
    main()
