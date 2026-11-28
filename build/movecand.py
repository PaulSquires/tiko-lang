#!/usr/bin/env python3
# movecand.py -- RFC 0018 P0: which vendored fbc tests OBSERVE structor counts.
#
#   python -I build/movecand.py > tests/semantic/moves/vendored-candidates.tsv
#
# A HEURISTIC, AND IT SAYS SO IN ITS OUTPUT. A file is listed when one of its constructor,
# destructor or 'operator let' BODIES prints or counts something (+= 1, = x + 1, print,
# inc): such a file can see a copy that a move removes. Column 4 narrows it: MOVE-SITE
# when the file also returns one of those types BY VALUE, or takes one by value -- the
# sites RFC 0018's V2 turns into moves -- so P1 may change its output. '-' observes
# structors but has no such site by this test. P1's suite run replaces this guess with the
# real list; until then it says where to look first.
#
# Reads tests/vendor/fbc-tests and never writes there.

import os
import re
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'tests', 'vendor', 'fbc-tests')

HEAD = re.compile(r'^\s*(constructor|destructor|operator\s+[\w.]+\s*\.\s*let)\b', re.I)
TAIL = re.compile(r'^\s*end\s+(constructor|destructor|operator)\b', re.I)
OBSERVES = re.compile(r'(\+=\s*1\b|=\s*\w+\s*\+\s*1\b|\bprint\b|\binc\b)', re.I)


def observed_structors(lines):
    """The structor kinds whose bodies print or count; empty when none do."""
    kinds, cur, inside = set(), None, False
    for ln in lines:
        s = ln.split("'")[0]
        if not inside:
            m = HEAD.match(s)
            if not m or re.match(r'^\s*declare', s, re.I):
                continue
            inside = True
            cur = m.group(1).lower().split()[0]
            if cur == 'constructor' and re.search(r'byref\s+\w+\s+as\s+(const\s+)?\w+\s*\)', s, re.I):
                cur = 'copy'
        elif TAIL.match(s):
            inside = False
        elif OBSERVES.search(s):
            kinds.add(cur)
    return kinds


def move_sites(code):
    """By-value returns and by-value parameters of a type the file gives structors."""
    names = set(n.lower() for n in re.findall(r'^\s*(?:constructor|destructor)\s+(\w+)', code, re.I | re.M))
    names |= set(n.lower() for n in re.findall(r'^\s*operator\s+(\w+)\s*\.\s*let', code, re.I | re.M))
    sites = set()
    for n in names:
        if re.search(r'^\s*(?:function|operator|property)\b[^\n]*\)\s*as\s+' + n + r'\b', code, re.I | re.M):
            sites.add('ret:' + n)
        if re.search(r'\bbyval\s+\w+\s+as\s+' + n + r'\b', code, re.I):
            sites.add('byval:' + n)
        if re.search(r'\(\s*\w+\s+as\s+' + n + r'\s*[,)]', code, re.I):
            sites.add('param:' + n)
    return sites


def main():
    rows = []
    for dp, _dn, fn in os.walk(ROOT):
        if 'fbcunit' in dp:
            continue
        for f in fn:
            if not f.lower().endswith('.bas'):
                continue
            p = os.path.join(dp, f)
            txt = open(p, encoding='latin-1').read()
            lines = txt.splitlines()
            kinds = observed_structors(lines)
            if not kinds:
                continue
            code = '\n'.join(l.split("'")[0] for l in lines)
            mode = 'suite' if 'END_SUITE' in txt else ('run' if 'COMPILE_AND_RUN_OK' in txt else 'other')
            sites = move_sites(code)
            rel = os.path.relpath(p, ROOT).replace(os.sep, '/')
            rows.append((0 if sites else 1, rel, mode, ','.join(sorted(kinds)),
                         'MOVE-SITE' if sites else '-', ' '.join(sorted(sites))))
    rows.sort()
    print('# RFC 0018 P0 -- vendored files whose structor bodies print or count. A HEURISTIC:')
    print('# see build/movecand.py. MOVE-SITE = also returns or takes such a type by value.')
    print('# file\tmode\tstructors observed\tmove site?\tsites')
    for r in rows:
        print('\t'.join(r[1:]))
    n_site = sum(1 for r in rows if r[0] == 0)
    print(f'# {len(rows)} files observe structors; {n_site} have a move site', file=sys.stderr)


main()
