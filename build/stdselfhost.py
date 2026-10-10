#!/usr/bin/env python3
"""stdselfhost.py -- move tiko-lang's own source from inc/fb's headers to the std modules.

Phase C of the std conversion (2026-10-10). Run ONCE, then deleted with inc/fb:

  - in code (not comments, not strings) 'FB.Array' becomes 'containers.Array', 'FB.IsDir'
    'fs.IsDir', and so on for every name a std module exports;
  - '#include once "fb/array.bi"' (and filesystem.bi, sort.bi) goes;
  - each compilation root -- build/sources.txt, src/api/tikoparser.bas and the tools that
    build against src -- gets '#import "std/<m>"' at its top for every module its include
    closure now names, because an import belongs to the file that is compiled.

    python build/stdselfhost.py [--check]
"""
import argparse
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "build"))
from stdtests import public_names  # noqa: E402

MODS = ["containers", "fs", "strings", "chrono", "outcome", "numeric", "tasks", "memory", "logs", "money", "tui"]
DROP = {"fb/array.bi", "fb/filesystem.bi", "fb/sort.bi", "containers.bi"}
EXTRA_ROOTS = ["src/api/tikoparser.bas", "tools/tiko-test/tikotest.bas", "tools/tkpdump/tkpdump.bas"]


def split_code(ln):
    """(code, rest): the line up to its comment, outside strings."""
    q = False
    for i, c in enumerate(ln):
        if c == '"':
            q = not q
        elif not q and c == "'":
            return ln[:i], ln[i:]
    return ln, ""


def rewrite_code(code, owner):
    out, i, q = [], 0, False
    # Strings are left alone: walk, and substitute only outside quotes.
    parts = re.split(r'("[^"]*")', code)
    for k, p in enumerate(parts):
        if k % 2 == 1:
            out.append(p)
            continue
        out.append(re.sub(r"\bFB\.([A-Za-z_]\w*)",
                          lambda m: (owner[m.group(1).lower()] + "." + m.group(1))
                          if m.group(1).lower() in owner else m.group(0), p))
    return "".join(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    owner = {}
    for m in MODS:
        for n in public_names(m):
            owner.setdefault(n, m)
    files = []
    for top in ("src", "tools/tiko-test", "tools/tkpdump"):
        for dp, _, fs in os.walk(os.path.join(ROOT, top)):
            for f in fs:
                if f.endswith((".bas", ".bi")):
                    files.append(os.path.relpath(os.path.join(dp, f), ROOT).replace("\\", "/"))
    texts, changed = {}, set()
    for rel in files:
        p = os.path.join(ROOT, rel)
        s = io.open(p, encoding="utf-8", newline="").read()
        nl = "\r\n" if "\r\n" in s else "\n"
        lines = s.split(nl)
        out = []
        for ln in lines:
            m = re.match(r'\s*#include\s+once\s+"([^"]+)"', ln)
            if m and m.group(1) in DROP:
                changed.add(rel)
                continue
            code, rest = split_code(ln)
            new = rewrite_code(code, owner)
            if new != code:
                changed.add(rel)
            out.append(new + rest)
        texts[rel] = (nl.join(out), nl)
    # Which module each file names, and the include graph.
    uses, incs = {}, {}
    for rel, (t, nl) in texts.items():
        u = set()
        for ln in t.split(nl):
            code, _ = split_code(ln)
            code = re.sub(r'"[^"]*"', '""', code)
            for m in MODS:
                if re.search(r"\b%s\.[A-Za-z_]" % m, code, re.I):
                    u.add(m)
            if re.match(r"\s*using\s+FB\s*$", code, re.I):
                u.add("using-fb")
        uses[rel] = u
        incs[rel] = []
        for m in re.finditer(r'(?m)^\s*#include\s+once\s+"([^"]+)"', t):
            for base in (os.path.dirname(rel), "src"):
                cand = os.path.normpath(os.path.join(base, m.group(1))).replace("\\", "/")
                if cand in texts:
                    incs[rel].append(cand)
                    break
    roots = [l.strip() for l in io.open(os.path.join(ROOT, "build", "sources.txt"), encoding="utf-8")
             if l.strip() and not l.startswith("#")] + EXTRA_ROOTS
    for r in roots:
        seen, work, need = set(), [r], set()
        while work:
            f = work.pop()
            if f in seen or f not in texts:
                continue
            seen.add(f)
            need |= uses[f]
            work.extend(incs[f])
        need.discard("using-fb")
        if not need:
            continue
        t, nl = texts[r]
        lines = t.split(nl)
        at = 0
        while at < len(lines) and (lines[at].strip() == "" or lines[at].lstrip().startswith("'")):
            at += 1
        imp = ['#import "std/%s"' % m for m in MODS if m in need]
        texts[r] = (nl.join(lines[:at] + imp + lines[at:]), nl)
        changed.add(r)
    # tikotest wrote 'using FB' for Array, Sort and the fs names.
    t, nl = texts["tools/tiko-test/tikotest.bas"]
    if re.search(r"(?m)^using FB\s*$", t):
        t = re.sub(r"(?m)^using FB(\s*)$", r"using containers, fs\1", t)
        texts["tools/tiko-test/tikotest.bas"] = (t, nl)
        changed.add("tools/tiko-test/tikotest.bas")
    for rel in sorted(changed):
        if not a.check:
            t, nl = texts[rel]
            io.open(os.path.join(ROOT, rel), "w", encoding="utf-8", newline="").write(t)
    print("stdselfhost: %d files %s" % (len(changed), "would change" if a.check else "changed"))


if __name__ == "__main__":
    main()
