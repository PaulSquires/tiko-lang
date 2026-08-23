#!/usr/bin/env python3
r"""Compare the bytes tiko-lang puts in a string literal with the bytes fbc puts there.

    python tools/gen/check-escape.py

Truth from tools/gen/escape-truth.py, which MEASURED each row by running fbc's own
output. Each case is compiled ALONE -- one file per literal -- because two different
spellings can produce the same bytes ('!"\101"' and '!"\x41"' are both "A") and a
shared probe would let literal pooling merge them into one row.

tiko-lang's answer is read out of '--dump-ir': the 'global str' line carries the bytes and
the fb_StrInit call carries the count. The dump is read as BYTES, not as text, since a
correct answer contains control characters and byte 255.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/types/expected/fbc-escape.txt"
WORK = ROOT / "build/.esc"
TKO = ROOT / "bin/tiko.exe"


def rows():
    out = []
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.strip() or line.startswith("#"):
            continue
        lit, n, codes = line.split("\t")
        out.append((lit, int(n), [int(c) for c in codes.split()] if codes.strip() else []))
    return out


def tiko_bytes(lit, idx):
    probe = WORK / f"esc-{idx}.bas"
    probe.write_bytes(("dim shared as string s\ns = " + lit + "\n").encode("utf-8"))
    r = subprocess.run([str(TKO), "--dump-ir", str(probe)], capture_output=True)
    dump = r.stdout or b""
    if b": error TKO" in dump or b": fatal TKO" in dump:
        return None, "tiko-lang reported a diagnostic"
    m = re.search(rb'^global str \$str\d+ "(.*)"$', dump, re.MULTILINE | re.DOTALL)
    if not m:
        # No global at all is the right answer for an EMPTY literal.
        return [], None
    body = m.group(1)
    # DOTALL made the match greedy across any later globals; cut at the last quote of
    # the first line-ish run. The dumper emits one global per line.
    body = body.split(b'"\n')[0]
    return list(body), None


def main() -> int:
    if not TRUTH.exists():
        print("check-escape: no truth file; run tools/gen/escape-truth.py", file=sys.stderr)
        return 3
    if not TKO.exists():
        print("check-escape: bin/tiko.exe not built", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    total = bad = 0
    for i, (lit, n, codes) in enumerate(rows()):
        total += 1
        got, err = tiko_bytes(lit, i)
        if err is not None:
            bad += 1
            print(f"check-escape:   {lit}  -- {err}")
            continue
        if got != codes:
            bad += 1
            print(f"check-escape:   {lit}  want [{' '.join(str(c) for c in codes)}]  "
                  f"got [{' '.join(str(c) for c in got)}]")
    if bad:
        print(f"check-escape: {total - bad}/{total} literals match fbc")
        return 1
    print(f"check-escape: {total}/{total} literals byte-identical to fbc")
    return 0


if __name__ == "__main__":
    sys.exit(main())
