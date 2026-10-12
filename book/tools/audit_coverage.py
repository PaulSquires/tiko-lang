#!/usr/bin/env python3
"""Check that every name in tiko's own tables is placed somewhere in the book's plan.

The book claims to cover every major feature of the language. That claim is only worth
anything if it is mechanical, so this re-extracts the compiler's vocabulary and looks each
entry up in C:\\dev\\docs\\tiko-book\\02-coverage.md, which maps names to chapters.

    python tools/audit_coverage.py [--tiko-src ...] [--coverage ...]

Run it whenever the pin moves. A name the compiler grew and the plan has not placed is a
TOC defect, and this exits 1 for it.
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys

import pin as pinlib

KW_RE = re.compile(r'KW\(\s*KW_[A-Z0-9_]+,\s*"([A-Z0-9_]+)"')
OPT_RE = re.compile(r'OPT\(\s*OPT_\w+,\s*"([^"]+)"')
DIAG_RE = re.compile(r"DIAG\(\s*(TKO\d{4})\s*,")
PPSYM_RE = re.compile(r'PpDefine[A-Za-z]*\(\s*e,\s*"([A-Za-z0-9_]+)"')
PRELUDE_RE = re.compile(r"declare\s+(?:function|sub)\s+([A-Za-z_0-9]+)", re.I)
INTRINSIC_RE = re.compile(r'"([a-z_0-9]+)"')

# Two test tokens in intrinsicname.bas, not language surface.
SKIP_BUILTINS = {"42", "abc"}


def main() -> int:
    ap = argparse.ArgumentParser()
    pinlib.add_arguments(ap)
    ap.add_argument("--coverage", default="C:/dev/docs/tiko-book/02-coverage.md")
    args = ap.parse_args()

    pin = pinlib.read_pin(args.tiko_src, args.rev, args.worktree)
    pinlib.announce(pin, "audit_coverage")
    cov = pathlib.Path(args.coverage).read_text(encoding="utf-8", errors="replace").lower()

    def read(rel: str) -> str:
        return pinlib.read_source(pin, rel)

    groups: dict[str, list[str]] = {
        "keywords": [w.lower() for w in KW_RE.findall(read("src/lexer/keywords.ti"))],
        "builtins": sorted(
            {w for w in INTRINSIC_RE.findall(read("src/symbols/intrinsicname.tiko"))} - SKIP_BUILTINS
        ),
        "prelude": sorted({w.lower() for w in PRELUDE_RE.findall(read("src/parser/prelude.tiko"))}),
        "pp symbols": sorted({w.lower() for w in PPSYM_RE.findall(read("src/pp/directive.tiko"))}),
        "cli options": sorted({w.lower() for w in OPT_RE.findall(read("src/driver/options.ti"))}),
        # The headers are gitignored build products, so they come from the packaged
        # toolchain -- which check-listings.sh has already matched to this same pin.
        "fb headers": sorted(
            p.stem.lower() for p in pinlib.toolchain_dir(pin, "inc", "fb").glob("*.bi")
        ),
    }

    counts = {
        "diagnostics": len(DIAG_RE.findall(read("src/diag/diagids.ti"))),
    }

    bad = 0
    for name, words in groups.items():
        missing = [w for w in words if w not in cov]
        status = "ok" if not missing else f"MISSING {len(missing)}"
        print(f"{name:12} {len(words):4}  {status}")
        if missing:
            bad += len(missing)
            print("             " + " ".join(sorted(set(missing))))

    print(f"{'diagnostics':12} {counts['diagnostics']:4}  (count only; Appendix B is generated)")

    if bad:
        print(
            f"\naudit_coverage: {bad} name(s) the compiler has and the plan does not place.\n"
            "Place each one in a chapter in 02-coverage.md, or list it as excluded.",
            file=sys.stderr,
        )
        return 1
    print("\naudit_coverage: every name is placed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
