#!/usr/bin/env python3
"""The pin: which tiko the book is written against, and how to read its source.

Every generated page in this book -- the diagnostics catalogue, the command-line reference,
the syntax definitions -- is built from a table inside the compiler. Reading those tables
from the tiko **working tree** is wrong, because the tree moves (about thirty commits a day
during active work) while the book is verified against a **packaged toolchain** that was
built from one commit. The book would then print, say, diagnostics that the compiler the
reader has does not implement. That is not hypothetical: the diagnostics table went from 294
rows to 415 in the week this book was scaffolded.

So the generators read their tables with `git show <pinned commit>:<path>`, and the pin comes
from book.yaml -- the same pin `tools/check-listings.sh` asserts against each toolchain's
MANIFEST before it runs a single listing.

Two things are deliberately NOT read from the commit:

- the `inc/fb` headers, which are gitignored build products. They come from the packaged
  toolchain directory instead, which the harness has already matched to the pin.
- anything under `--worktree`, which exists so the generators stay usable while a change to
  the compiler is still in a working tree. It prints a warning, because a page generated
  that way does not match what the reader has.
"""
from __future__ import annotations

import dataclasses
import pathlib
import re
import subprocess
import sys


@dataclasses.dataclass(frozen=True)
class Pin:
    commit: str                 # as written in book.yaml (possibly abbreviated)
    sha: str                    # the full sha it resolves to
    tiko_src: pathlib.Path      # the tiko-lang repository
    windows_root: pathlib.Path  # the packaged Windows toolchain
    packaged: str               # the date book.yaml records


def book_root() -> pathlib.Path:
    return pathlib.Path(__file__).resolve().parent.parent


def _yaml_scalar(text: str, section: str, key: str) -> str | None:
    """book.yaml's pin block is flat enough that a real YAML parser is not worth a dependency."""
    in_section = False
    for line in text.splitlines():
        if re.match(rf"^  {re.escape(section)}:\s*$", line):
            in_section = True
            continue
        if in_section:
            if re.match(r"^  [a-z_]+:", line):        # the next sibling key ends the block
                break
            m = re.match(rf"^\s+{re.escape(key)}:\s*\"?([^\"\s]+)\"?", line)
            if m:
                return m.group(1)
    return None


def read_pin(tiko_src: str | pathlib.Path | None = None,
             rev: str | None = None,
             worktree: bool = False) -> Pin:
    root = book_root()
    text = (root / "book.yaml").read_text(encoding="utf-8")

    commit = rev or _yaml_scalar(text, "windows", "commit")
    if not commit:
        sys.exit("pin: book.yaml has no pin.windows.commit")
    win_root = _yaml_scalar(text, "windows", "root") or ""
    packaged = _yaml_scalar(text, "windows", "packaged") or "?"

    # The book lives inside the compiler's repository (book/), so the default is its
    # parent -- no absolute path, and a clone anywhere still works.
    src = pathlib.Path(tiko_src) if tiko_src else book_root().parent
    if not (src / ".git").exists():
        sys.exit(f"pin: {src} is not a git repository")

    if worktree:
        return Pin(commit="(working tree)", sha="", tiko_src=src,
                   windows_root=pathlib.Path(win_root), packaged=packaged)

    got = subprocess.run(["git", "-C", str(src), "rev-parse", "--verify", f"{commit}^{{commit}}"],
                         capture_output=True, text=True)
    if got.returncode != 0:
        sys.exit(
            f"pin: the pinned commit {commit} is not in {src}.\n"
            f"  Fetch it (git -C {src} fetch), or move the pin in book.yaml deliberately\n"
            f"  and re-verify the listings with tools/check-listings.sh."
        )
    return Pin(commit=commit, sha=got.stdout.strip(), tiko_src=src,
               windows_root=pathlib.Path(win_root), packaged=packaged)


def read_source(pin: Pin, rel_path: str) -> str:
    """One file of the compiler, as it was at the pinned commit."""
    if not pin.sha:                                   # --worktree
        p = pin.tiko_src / rel_path
        if not p.exists():
            sys.exit(f"pin: {p} does not exist")
        return p.read_text(encoding="utf-8", errors="replace")

    got = subprocess.run(["git", "-C", str(pin.tiko_src), "show", f"{pin.sha}:{rel_path}"],
                         capture_output=True, text=True, errors="replace")
    if got.returncode != 0:
        sys.exit(
            f"pin: {rel_path} does not exist at {pin.commit} ({pin.sha[:8]}).\n"
            f"  The compiler may have moved or renamed it; check before changing the generator."
        )
    return got.stdout


def toolchain_dir(pin: Pin, *parts: str) -> pathlib.Path:
    """A path inside the packaged toolchain, which is a build product and not in git.

    The harness has already checked this toolchain's MANIFEST against the same pin, so it
    is the pinned artefact even though it cannot be read out of a commit.
    """
    p = pin.windows_root.joinpath(*parts)
    if not p.exists():
        sys.exit(f"pin: {p} does not exist -- is the pinned toolchain installed?")
    return p


def add_arguments(ap) -> None:
    """The three flags every generator shares."""
    ap.add_argument("--tiko-src", default=None,
                    help="the tiko-lang repository (default: the book's parent directory)")
    ap.add_argument("--rev", default=None,
                    help="read a different commit than book.yaml's pin")
    ap.add_argument("--worktree", action="store_true",
                    help="read the working tree instead of the pin (for development only)")


def announce(pin: Pin, what: str) -> None:
    if not pin.sha:
        print(f"{what}: WARNING -- reading the working tree, not the pin. "
              f"The result may not match the compiler the reader has.", file=sys.stderr)
    else:
        print(f"{what}: at pin {pin.commit} ({pin.packaged})")
