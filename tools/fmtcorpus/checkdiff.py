"""checkdiff.py <seed> <count> --tiko <exe> [--keep] -- the compiler's format check against the library.

The randomised half of the shared corpus (corpus.txt is the hand-written half; see gen.py). One
run generates <count> random format strings, each with random arguments from gen.py's prelude,
and writes them twice: as strings.TryFormat calls, compiled and RUN, and as strings.Format
calls, only compiled. Every case's refusal at run time must be the compiler's at compile time --
the same code's TKO id, at the column of the same offset -- and an accepted case must draw no
diagnostic.

The arguments never make a VALUE refusal (a negative width, 'c' out of range, a null zstring
ptr, a Formattable's '!'), which the compiler cannot see and which would hide a later field's
refusal from the run-time side; nor is a FormatArg passed as itself. So the two must agree
exactly. The same seed always writes the same cases. Exit 0 when nothing differs.
"""
import os
import random
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib.util
spec = importlib.util.spec_from_file_location("gen", os.path.join(os.path.dirname(os.path.abspath(__file__)), "gen.py"))

args = sys.argv[1:]
keep = "--keep" in args
if keep:
    args.remove("--keep")
i = args.index("--tiko")
tiko = args[i + 1]
del args[i:i + 2]
seed, count = int(args[0]), int(args[1])
sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")
gen = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen)
R = random.Random(seed)

ARGS = ["7", "3", "i", "ui", "ub", "col", "d", "sg", "b", "who", '"s"', "z", "p", "nn", "m"]
TYPES = list("dbBoxXcsfFeEgGaAp?P") + ["q", "L", "", "", "", ""]
TEXT = ["ab", "{{", "}}", " ", "é", "x"]


def dyn(manual):
    if R.random() < 0.08:
        return "{" + R.choice(["x", "01", "", "1"]) + ("" if R.random() < 0.1 else "}")
    return "{" + (str(R.randint(0, 4)) if manual else "") + "}"


def spec_text(manual):
    s = ""
    if R.random() < 0.3:
        s += R.choice(["", "*", "é", "{", "<", "0"]) + R.choice("<>^")
    if R.random() < 0.2:
        s += R.choice("+- ")
    if R.random() < 0.15:
        s += "#"
    if R.random() < 0.15:
        s += "0"
    if R.random() < 0.35:
        s += str(R.randint(0, 12)) if R.random() < 0.7 else dyn(manual)
    if R.random() < 0.3:
        s += "." + (str(R.randint(0, 6)) if R.random() < 0.6 else (dyn(manual) if R.random() < 0.8 else ""))
    s += R.choice(TYPES)
    if R.random() < 0.05:
        s += R.choice(["x", " ", "}", "L"])
    return s


def field(manual):
    f = "{"
    if manual or R.random() < 0.05:
        f += str(R.randint(0, 4)) if R.random() < 0.95 else R.choice(["01", "x", " "])
    if R.random() < 0.6:
        f += ":" + spec_text(manual if R.random() < 0.95 else not manual)
    if R.random() > 0.04:
        f += "}"
    return f


def case():
    manual = R.random() < 0.3
    parts = []
    for _ in range(R.randint(1, 4)):
        parts.append(field(manual) if R.random() < 0.7 else R.choice(TEXT))
    if R.random() < 0.03:
        parts.insert(R.randint(0, len(parts)), "}")
    lit = '"' + "".join(parts).replace('"', '""') + '"'
    a = ", ".join(R.choice(ARGS) for _ in range(R.randint(0, 5)))
    return dict(line=0, lit=lit, args=a, code="OK", off=0, run=False)


def main():
    cases = [case() for _ in range(count)]
    tmp = os.path.join(os.environ.get("TEMP", "/tmp"), "fmtcheckdiff_%d" % seed)
    os.makedirs(tmp, exist_ok=True)
    for n, c in enumerate(cases):
        c["line"] = n
    # Run time: each case's code and offset.
    rsrc = gen.runtime_test(cases).replace(
        'print "corpus.txt(" & ln & "): got " & gc & " " & go',
        'print "R " & ln & " " & gc & " " & go')
    rsrc = rsrc.replace("passed += 1", 'print "R " & ln & " 0 0" : passed += 1')
    rpath = os.path.join(tmp, "r.tiko")
    gen.write(rpath, rsrc)
    subprocess.run([tiko, rpath, "-o", os.path.join(tmp, "r.exe")], check=True)
    out = subprocess.run([os.path.join(tmp, "r.exe")], capture_output=True, text=True).stdout
    got = {}
    for m in re.finditer(r"^R (\d+) (\d+) (\d+)", out, re.M):
        got[int(m.group(1)) - 1] = (int(m.group(2)), int(m.group(3)))
    # Compile time: each case's diagnostic, by line.
    csrc, _ = gen.compile_test(cases)
    cpath = os.path.join(tmp, "format-check.tiko")
    gen.write(cpath, csrc)
    cres = subprocess.run([tiko, "-fmax-errors=100000", cpath, "-o", os.path.join(tmp, "c.exe")],
                          capture_output=True, text=True, encoding="utf-8", errors="replace")
    diags = {}
    for m in re.finditer(r"format-check\.tiko\((\d+),(\d+)\): error (TKO\d+)", cres.stdout + cres.stderr):
        diags.setdefault(int(m.group(1)), []).append((int(m.group(2)), m.group(3)))
    first = len(gen.PRELUDE.rstrip("\n").split("\n")) + 2   # the header line, then 1-based
    bad = 0
    refused = 0
    for n, c in enumerate(cases):
        line = first + n
        gc, go = got.get(n, (None, None))
        if gc is None:
            print("NO RUN RESULT", n, c["lit"], c["args"])
            bad += 1
            continue
        want = []
        if gc != 0:
            refused += 1
            name = gen.CODES[gc]
            assert name in gen.TKO, ("a value refusal was generated", c, name)
            want = [(gen.column(c["lit"], go), gen.TKO[name])]
        have = diags.get(line, [])
        if have != want:
            bad += 1
            print("DIFF %s | %s : run %s@%s, want %s, compiler %s" % (c["lit"], c["args"], gen.CODES[gc], go, want, have))
    print("checkdiff seed %d: %d cases (%d refused), %d differ" % (seed, count, refused, bad))
    if not keep:
        for f in os.listdir(tmp):
            os.remove(os.path.join(tmp, f))
        os.rmdir(tmp)
    sys.exit(1 if bad else 0)


main()
