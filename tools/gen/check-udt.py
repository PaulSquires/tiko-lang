#!/usr/bin/env python3
"""Compare fbx's UDT layout with fbc's, shape by shape.

    python tools/gen/check-udt.py

Reads tests/types/expected/fbc-udt.txt -- produced by udt-truth.py, which compiles and
RUNS a probe under fbc -- rebuilds the same declarations as fbx source, and compares
every size, alignment and field offset.

A field at the wrong offset does not fail loudly; it reads the neighbouring field's
bytes. So a shape either matches completely or it is reported, and shapes fbx does not
support yet are listed by name rather than quietly skipped.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

TRUTH = ROOT / "tests/types/expected/fbc-udt.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.ud"
FBX = ROOT / "bin/fbx.exe"

sys.path.insert(0, str(ROOT / "tools/gen"))
from importlib import import_module
CASES = import_module("udt_truth_cases").CASES if False else None

# The declarations are re-derived from udt-truth.py so the two cannot drift.
import re as _re
SRC = (ROOT / "tools/gen/udt-truth.py").read_text(encoding="utf-8")
m = _re.search(r"CASES = \[(.*?)\n\]", SRC, _re.S)
CASES = eval("[" + m.group(1) + "\n]")


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-udt: {LABEL} no truth file; run tools/gen/udt-truth.py", file=sys.stderr)
        return 3
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print(f"check-udt: {LABEL} fbx not built", file=sys.stderr)
        return 3

    want = {}
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        p = line.split("\t")
        if p[1] == "size":
            want[(p[0].lower(), "size")] = (int(p[2]), int(p[3]))
        else:
            want[(p[0].lower(), "off", p[2].lower())] = int(p[3])

    WORK.mkdir(parents=True, exist_ok=True)
    decls, seen = [], set()
    for name, decl, fields in CASES:
        if decl not in seen:
            decls.append(decl)
            seen.add(decl)
    probe = WORK / "udt-fbx.bas"
    probe.write_text("\n".join(decls) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(fbx), "--dump-udt"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    cur = None
    for line in (proc.stdout or "").splitlines():
        line = " ".join(line.split())
        m = re.fullmatch(r"(\w+) size (\d+) align (\d+)", line)
        if m:
            got[(m.group(1), "size")] = (int(m.group(2)), int(m.group(3)))
            continue
        # 'inherited' is a field the type gets from its base -- 'extends' is one
        # field holding the whole base, so an inherited name is not in the type's own
        # list and every inheritance shape read as "fbx has no offset" without this.
        m = re.fullmatch(r"(\w+) (?:off|inherited) (\S+) (\d+)", line)
        if m:
            got[(m.group(1), "off", m.group(2))] = int(m.group(3))

    ok = bad = absent = 0
    diffs, missing = [], []
    for name, decl, fields in CASES:
        n = name.lower()
        if (n, "size") not in got:
            absent += 1
            missing.append(name)
            continue
        shape_ok = True
        gs, ga = got[(n, "size")]
        ws, wa = want[(n, "size")]
        if (gs, ga) != (ws, wa):
            shape_ok = False
            diffs.append(f"{name}: fbc size={ws} align={wa}, fbx size={gs} align={ga}")
        for f in fields:
            key = (n, "off", f.lower())
            if key not in want:
                continue
            gf = got.get((n, "off", f.split("(")[0].lower()))
            if gf is None:
                shape_ok = False
                diffs.append(f"{name}.{f}: fbx has no offset")
            elif gf != want[key]:
                shape_ok = False
                diffs.append(f"{name}.{f}: fbc={want[key]} fbx={gf}")
        if shape_ok:
            ok += 1
        else:
            bad += 1

    print(f"check-udt: {LABEL} {ok}/{len(CASES)} shapes match exactly")
    if absent:
        print(f"check-udt: {LABEL} {absent} shapes fbx does not lay out at all: "
              + ", ".join(missing))
    if diffs:
        print(f"check-udt: {LABEL} {len(diffs)} disagreements:")
        for d in diffs[:25]:
            print("   ", d)
    return 0 if (not diffs and not absent) else 1


def main() -> int:
    """Every target, against its own expectations file."""
    global TRUTH, TGT, LABEL
    rc = 0
    for LABEL, TRUTH, TGT in fbxtargets.check_targets(TRUTH):
        if one_target() != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
