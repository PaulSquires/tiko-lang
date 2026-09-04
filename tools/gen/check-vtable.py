#!/usr/bin/env python3
"""Compare tiko-lang's virtual method tables with fbc's, slot by slot, on BOTH targets.

    python tools/gen/check-vtable.py

Reads tests/types/expected/fbc-vtable.txt -- produced by
vtable-truth.py from the C fbc leaves behind -- and compares each with
'tiko-lang --dump-vtable' over the same source.

A slot at the wrong index does not fail loudly. It calls the WRONG METHOD, with the
right number of arguments and a plausible answer, so a table either matches completely
or the disagreeing slots are named.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import tkotargets
import importlib

vtruth = importlib.import_module("vtable-truth".replace("-", "_")) \
    if False else None

TKO = ROOT / "bin/tiko.exe"
TRUTH = ROOT / "tests/types/expected/fbc-vtable.txt"
WORK = ROOT / "build/.vtc"


def load_cases():
    """The probe sources, taken from the generator so the two cannot drift apart."""
    src = (ROOT / "tools/gen/vtable-truth.py").read_text(encoding="utf-8")
    # Only the CASES literal is executed. The generator's own preamble imports fbc paths
    # and resolves __file__, neither of which exists here, and neither is needed to read
    # a list of strings.
    body = src.split("CASES = [", 1)[1].split("\n]", 1)[0]
    return eval("[" + body + "\n]")



def one_target(label, truth, tgtargs) -> int:
    if not truth.exists():
        print(f"check-vtable: {label}: no truth file; run tools/gen/vtable-truth.py",
              file=sys.stderr)
        return 3

    want = {}
    for line in truth.read_text(encoding="utf-8").splitlines():
        p = line.split("\t")
        if len(p) == 3 and p[1] == "count":
            want.setdefault(p[0], {})["count"] = int(p[2])
        elif len(p) == 4 and p[1] == "slot":
            want.setdefault(p[0], {})[int(p[2])] = p[3]

    WORK.mkdir(parents=True, exist_ok=True)
    src = WORK / "vt.bas"
    src.write_text("\n".join(s.strip() for _, s in load_cases()) + "\n"
                   + "dim as long __vt_keep\n", encoding="utf-8")
    proc = subprocess.run([str(TKO), "--dump-vtable", str(src)] + tgtargs,
                          capture_output=True, text=True)

    # 'vsimple vtable 2 slot(s)' then '  slot 0 _ZN7VSIMPLE1FEv'
    got, cur = {}, None
    for line in (proc.stdout or "").splitlines():
        line = " ".join(line.split())
        m = re.fullmatch(r"(\S+) vtable (\d+) slot\(s\)", line)
        if m:
            cur = m.group(1)
            got[cur] = {"count": int(m.group(2))}
            continue
        m = re.fullmatch(r"slot (\d+) (\S+)", line)
        if m and cur is not None:
            got[cur][int(m.group(1))] = m.group(2)

    # tiko-lang names a table by its TYPE; fbc by the mangled '_ZTVN...E' global. Matching is
    # by the SLOT CONTENTS' owner rather than by decoding one spelling into the other:
    # each fbc table is found by the tiko-lang table whose type name it encodes.
    def fbc_type_of(table):
        m = re.fullmatch(r"_ZTVN?(\d+)(\w+?)E?", table)
        if not m:
            return None
        n = int(m.group(1))
        return m.group(2)[:n].lower()

    bad, checked = [], 0
    for table, slots in sorted(want.items()):
        ty = fbc_type_of(table)
        if ty is None or ty not in got:
            bad.append(f"    {table}: tiko-lang has no table for '{ty}'")
            continue
        g = got[ty]
        checked += 1
        if g["count"] != slots["count"]:
            bad.append(f"    {ty}: fbc has {slots['count']} slot(s), tiko-lang {g['count']}")
            continue
        for i in range(slots["count"]):
            w = slots[i]
            # An abstract slot is a real slot holding NULL in fbc's initialiser.
            v = g.get(i, "<missing>")
            if w == "0":
                w = "<abstract>"
            if v != w:
                bad.append(f"    {ty}.slot{i}: fbc={w} tiko={v}")

    if bad:
        print(f"check-vtable: {label} {checked - len(set(b.split(chr(46))[0] for b in bad))}"
              f"/{len(want)} tables match")
        print(f"check-vtable: {label} {len(bad)} disagreement(s):")
        for b in bad[:40]:
            print(b)
        return 1
    print(f"check-vtable: {label} {len(want)}/{len(want)} tables match fbc slot for slot")
    return 0


def main() -> int:
    if not TKO.exists():
        print("check-vtable: bin/tiko.exe not built", file=sys.stderr)
        return 3
    rc = 0
    for label, truth, tgtargs in tkotargets.check_targets(TRUTH):
        rc |= one_target(label, truth, tgtargs)
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
