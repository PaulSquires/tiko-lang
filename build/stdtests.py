#!/usr/bin/env python3
"""stdtests.py -- port fbc's tests of the standard library from the headers to the modules.

108 files of tests/vendor/fbc-tests test what pkg/std is made of, through the headers:

    #include once "fb/string.bi"
    using FB
    ... FB.Split( s ) ...

tests/vendor is fbc's own suite and is never edited, so each file is COPIED to tests/std
and rewritten there, for every module that is already real:

    #import "std/strings"
    using strings
    ... strings.Split( s ) ...

A header of a module that is still a facade stays included, with 'using FB'. The copies
are GENERATED -- re-run this whenever a module converts, and never edit one by hand; a
port that needs more than this rewrite gets an entry in PATCHES.

Beside each copy it writes a .test that builds and runs it the way build/stdsuite.sh does,
expecting what tests/std/baseline/ recorded for the original: the same exit codes, the
same fbcunit summary line, the same diagnostic ids for a file that must not compile.

    python build/stdtests.py            write tests/std
    python build/stdtests.py --check    exit 1 if anything would change
"""
import argparse
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "build"))
from stdport import HDR_MODULE, MODULES  # noqa: E402

VENDOR = os.path.join(ROOT, "tests", "vendor", "fbc-tests")
OUT = os.path.join(ROOT, "tests", "std")
DRIVER = "tests/vendor/fbc-tests/fbcunit/tests/tests.bas"

# file (area/name.bas) -> [(old, new)], applied after the rewrite, each exactly once.
PATCHES = {
}
# file -> [(regex, replacement)], applied after PATCHES; each must match at least once.
#
# CONTAINS IS TWO NAMES NOW. Under 'using FB' strings' Contains and containers' generic
# Contains( of T ) were one overload set in one namespace; as two modules, a bare call under
# both 'using's is TKO0919 (ambiguous), which is the module rule, so the port qualifies it.
RPATCHES = {
    "string/fbstr_search.bas": [(r"(?<![.\w])Contains\(", "strings.Contains(")],
}

RX_INC = re.compile(r'^\s*#include(?:\s+once)?\s+"(fb/[\w]+\.bi|containers\.bi)"[^\n]*\n?', re.I | re.M)


def converted():
    out = set()
    for m in MODULES:
        d = os.path.join(ROOT, "pkg", "std", m)
        if os.path.isdir(d) and not os.path.isfile(os.path.join(d, m + ".bas")) \
                and any(f.endswith(".tiko") for f in os.listdir(d)):
            out.add(m)
    return out


def public_names(mod):
    """A real module's public names, lower-cased -> spelling."""
    names = {}
    d = os.path.join(ROOT, "pkg", "std", mod)
    for f in sorted(os.listdir(d)):
        if not f.endswith(".tiko"):
            continue
        inenum = False
        for ln in io.open(os.path.join(d, f), encoding="utf-8"):
            code = ln.split("''")[0]
            if inenum:
                if re.match(r"\s*end\s+enum\b", code, re.I):
                    inenum = False
                    continue
                for m in re.finditer(r"(?:^|,)\s*([A-Za-z_]\w*)", code):
                    names.setdefault(m.group(1).lower(), m.group(1))
                continue
            m = re.match(r"\s*public\s+(?:declare\s+)?(?:function|sub|type|union|enum|const)"
                         r"\s+(?:as\s+\w+\s+)?(\w+)", code, re.I)
            if m:
                names.setdefault(m.group(1).lower(), m.group(1))
                if re.match(r"\s*public\s+enum\b", code, re.I):
                    inenum = True
            m = re.match(r"\s*#export\s+(.*)", code)
            if m:
                for n in re.findall(r"\w+", m.group(1)):
                    names.setdefault(n.lower(), n)
    return names


_INCS = {}


def includes_of(hdr):
    """The fb/ headers (and containers.bi) one header includes, as 'fb/x.bi' paths."""
    if hdr not in _INCS:
        p = os.path.join(ROOT, "inc", hdr)
        text = io.open(p, encoding="utf-8").read() if os.path.isfile(p) else ""
        _INCS[hdr] = [m.group(1) for m in RX_INC.finditer(text)
                      if not m.group(0).lstrip().startswith("'")]
    return _INCS[hdr]


def port(text, conv, pub):
    mods = []
    keep_fb = False
    removed = []
    for m in RX_INC.finditer(text):
        hdr = os.path.basename(m.group(1))
        mod = HDR_MODULE.get(hdr)
        if mod in conv:
            if mod not in mods:
                mods.append(mod)
            removed.append(m.group(1))
        else:
            keep_fb = True
    if not mods:
        return None
    # WHAT A REMOVED HEADER BROUGHT WITH IT: 'fb/string.bi' included 'fb/array.bi', and the
    # test wrote 'Array' through 'using FB'. A header of a converted module is an import;
    # one of a module still a facade is included again.
    readd, seen = [], set(removed)
    work = list(removed)
    while work:
        h = work.pop(0)
        for d in includes_of(h):
            if d in seen:
                continue
            seen.add(d)
            dm = HDR_MODULE.get(os.path.basename(d))
            if dm in conv:
                if dm not in mods:
                    mods.append(dm)
                work.append(d)
            elif dm is not None:
                readd.append(d)
                keep_fb = True
    text = RX_INC.sub(lambda m: "" if HDR_MODULE.get(os.path.basename(m.group(1))) in conv else m.group(0), text)
    if readd:
        text = re.sub(r"(?im)^(\s*)using\s+FB\s*$",
                      lambda m: "".join('%s#include once "%s"\n' % (m.group(1), d) for d in readd) + m.group(0),
                      text, count=1)
    using = ", ".join(mods)
    text = re.sub(r"(?im)^(\s*)using\s+FB\s*$",
                  lambda m: m.group(1) + "using " + using + (("\n" + m.group(1) + "using FB") if keep_fb else ""),
                  text)

    def qual(m):
        n = m.group(1)
        for mod in mods:
            if n.lower() in pub[mod]:
                return mod + "." + n
        return m.group(0)
    text = re.sub(r"\bFB\.(\w+)", qual, text)
    # The imports go first: before any code, after the opening comments.
    lines = text.split("\n")
    at = 0
    while at < len(lines) and (lines[at].strip() == "" or lines[at].lstrip().startswith("'")):
        at += 1
    imp = ['#import "std/%s"' % m for m in mods]
    return "\n".join(lines[:at] + imp + lines[at:])


def test_for(rel, base, has_mod2):
    """The .test for one ported file, from its baseline record."""
    area, fn = rel.split("/")
    name = fn[:-4]
    rec = base.split("\n", 1)
    head = rec[0]
    body = rec[1] if len(rec) > 1 else ""
    kv = dict(x.split("=", 1) for x in head.split())
    mode = kv["mode"]
    exe = "tests/std/%s/%s.exe" % (area, name)
    src = "tests/std/%s/%s" % (area, fn)
    extra = (" tests/std/%s/%s_mod2.bas" % (area, name)) if has_mod2 else ""
    t = ["'' tests/vendor/fbc-tests/%s ported to the std modules (build/stdtests.py, generated)." % rel,
         "'' Expected: what tests/std/baseline/%s/%s.txt recorded for the original." % (area, name),
         "'' TEST: cli"]
    if mode == "SUITE":
        t.append("'' ARGS: -target win64-msvc -mt -i toolchains/tiko-windows/inc %s %s%s -o %s"
                 % (DRIVER, src, extra, exe))
    else:
        t.append("'' ARGS: -target win64-msvc -i toolchains/tiko-windows/inc %s%s -o %s" % (src, extra, exe))
    t.append("'' ENV: TKO_LIBPATH=toolchains/tiko-windows/lib/win64-msvc")
    t.append("'' EXPECT-EXIT: %s" % kv["build"])
    if mode == "COMPILE_ONLY_FAIL":
        for ln in body.split("\n"):
            if ln.strip():
                t.append("'' EXPECT-OUT: %s" % ln.strip())
    elif kv["build"] == "0":
        t.append("'' RUN: %s" % exe)
        if kv.get("run", "0") != "0":
            t.append("'' EXPECT-RUN-EXIT: %s" % kv["run"])
        if mode == "SUITE":
            for ln in body.split("\n"):
                if re.match(r"\s+\d+\s+\d+\s+\d+\s+fbc_tests\.", ln):
                    t.append("'' EXPECT-RUN-OUT: %s" % ln.strip())
    return "\n".join(t) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    conv = converted()
    pub = {m: public_names(m) for m in conv}
    want = {}
    for dp, _, fs in os.walk(VENDOR):
        for f in fs:
            if not (f.endswith(".bas") or f.endswith(".bi")):
                continue
            p = os.path.join(dp, f)
            rel = os.path.relpath(p, VENDOR).replace("\\", "/")
            raw = open(p, "rb").read()
            if b'"fb/' not in raw and b'"containers.bi"' not in raw:
                continue
            text = raw.decode("utf-8").replace("\r\n", "\n")
            if not RX_INC.search(text):
                continue
            ported = port(text, conv, pub)
            if ported is None:
                continue
            for old, new in PATCHES.get(rel, []):
                assert ported.count(old) == 1, (rel, old)
                ported = ported.replace(old, new)
            for rx, new in RPATCHES.get(rel, []):
                ported, k = re.subn(rx, new, ported)
                assert k > 0, (rel, rx)
            want[rel] = ported
    for rel in sorted(want):
        if not rel.endswith(".bas") or rel.endswith("_mod2.bas"):
            continue
        area, fn = rel.split("/")
        basef = os.path.join(OUT, "baseline", area, fn[:-4] + ".txt")
        if not os.path.isfile(basef):
            continue
        base = io.open(basef, encoding="utf-8").read()
        want[rel[:-4] + ".test"] = test_for(rel, base, (rel[:-4] + "_mod2.bas") in want)
    changed = []
    for rel, text in sorted(want.items()):
        p = os.path.join(OUT, rel)
        old = io.open(p, encoding="utf-8", newline="").read() if os.path.isfile(p) else None
        if old != text:
            changed.append(rel)
            if not a.check:
                os.makedirs(os.path.dirname(p), exist_ok=True)
                io.open(p, "w", encoding="utf-8", newline="\n").write(text)
    for rel in changed:
        print("stdtests: %s %s" % ("would write" if a.check else "wrote", rel))
    print("stdtests: %d files for modules %s, %d changed" % (len(want), ",".join(sorted(conv)), len(changed)))
    # API PARITY: every name the module's facade exported (frozen in tests/std/api/<m>.txt
    # when the facades went) is still a public name of the real module.
    bad = 0
    for m in sorted(conv):
        apif = os.path.join(OUT, "api", m + ".txt")
        if not os.path.isfile(apif):
            continue
        for ln in io.open(apif, encoding="utf-8"):
            n = ln.split()[0] if ln.strip() else ""
            if n and n.lower() not in pub[m]:
                print("stdtests: API %s.%s is not public any more" % (m, n))
                bad += 1
    if (a.check and changed) or bad:
        sys.exit(1)


if __name__ == "__main__":
    main()
