#!/usr/bin/env python3
"""make-wikihelp.py -- keywords/wikihelp.txt, Help > Keyword Help's (F1) word -> wiki page table.

Read from tiko-lang's wiki/Keyword-Index.md (every wiki page, A-Z). Run it again whenever the wiki
gains or renames pages:

    python tkedit/tools/make-wikihelp.py            (from the tiko-lang checkout)

One line per lookup key, sorted:  key <TAB> page <TAB> member-page
  key          lower case: what F1 is pressed on ("print", "#include", "select case")
  page         the best page for the word on its own
  member-page  the best Modern-* (library) page, for the word after a "." ("m.Put"); may be empty
A key comes from an index name in four ways, best first: the name itself ("Print"), the name
without its "(...)" note ("Alias (Modifier)" -> "alias"), the member of "Type.Member"
("Channel.Close" -> "close"), the first word of a statement's spelling ("If...Then" -> "if",
"Select Case" -> "select"). Among equals the index's own order wins. "A | B" is two names.
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TREE = os.path.normpath(os.path.join(HERE, "..", ".."))
SRC = os.path.join(TREE, "wiki", "Keyword-Index.md")
OUT = os.path.join(TREE, "tkedit", "keywords", "wikihelp.txt")

ROW = re.compile(r"^\| \[([^\]]+)\]\(([^)#]+)\)")
WORD = re.compile(r"^#?[A-Za-z_][A-Za-z0-9_]*\$?$")


def keys_of(name):
    """(key, rank) pairs for one index name."""
    out = []
    for alt in [a.strip() for a in name.split(" | ")]:
        if not alt or ":" in alt:          # "Compiler Option: -c" is not a word in code
            continue
        out.append((alt.lower(), 0))
        base = re.sub(r"\s*\([^)]*\)\s*$", "", alt)
        if base != alt and base:
            out.append((base.lower(), 1))
        if "." in base and "..." not in base:
            member = base.rsplit(".", 1)[1]
            if WORD.match(member):
                out.append((member.lower(), 2))
        first = re.split(r"\.\.\.| ", base, maxsplit=1)[0]
        if first != base and WORD.match(first):
            out.append((first.lower(), 3))
    return out


def main():
    best = {}      # key -> (rank, order, page)
    member = {}    # key -> (rank, order, page), Modern-* pages only
    order = 0
    with open(SRC, encoding="utf-8") as f:
        for line in f:
            m = ROW.match(line)
            if not m:
                continue
            name, page = m.group(1), m.group(2)
            order += 1
            for key, rank in keys_of(name):
                cand = (rank, order, page)
                if key not in best or cand < best[key]:
                    best[key] = cand
                if page.startswith("Modern-") and (key not in member or cand < member[key]):
                    member[key] = cand
    lines = []
    for key in sorted(best):
        mp = member.get(key)
        lines.append("%s\t%s\t%s" % (key, best[key][2], mp[2] if mp else ""))
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    print("%s: %d keys from %d index rows" % (os.path.relpath(OUT, TREE), len(lines), order))
    return 0


if __name__ == "__main__":
    sys.exit(main())
