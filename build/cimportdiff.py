"""cimportdiff.py -- compare two -cimport bindings of one header, fbc-modern's and tiko's.

    python build/cimportdiff.py <fbc.bi> <tiko.bi> <label> [--all]

Prints one summary line, the explained classes that fired, and every UNEXPLAINED
difference (the first 25 unless --all). Exits 1 when anything is unexplained.

A LINE DIFF IS THE WRONG INSTRUMENT. One record the two importers order differently
moves every ledger line after it, and windows.h's 36,000 declarations diffed by line
read as 6,000 differences where there were a few hundred. The bindings are compared as
SETS instead: declarations by name, the rename and skip ledgers as multisets of lines.

Forward pointer aliases -- 'type X__ptr as X ptr' -- are spelling, not declarations:
each file's aliases are resolved to what that file says they stand for before anything
is compared, and the alias lines themselves are dropped.

EVERY EXPLAINED CLASS IS A PREDICATE, not a list of names: a difference is explained
only when the rule that explains it can be checked against the two files. The classes
and their causes are in build/cimportdiff.sh.
"""
import re
import sys
import collections

LEDGER_REN = re.compile(r"^'' \d+ names were changed")
LEDGER_SKIP = re.compile(r"^'' \d+ declarations were skipped")
ALIAS = re.compile(r"^type (\w+__ptr) as (.*)$")
BLOCK = re.compile(r"^(type|union) (\w+)( field = \d+)?$")
SIMPLE = [re.compile(p) for p in (
    r"^type (\w+) as ",
    r"^declare (?:function|sub) (\w+)",
    r"^extern (?:import )?(\w+)",
    r"^const (\w+) = ",
    r"^#define (\w+)",
)]

# fbc-modern's skip reasons for a shape tiko imports: an array parameter, an anonymous
# member whose record has no name, and the cascade from either.
TIKO_HANDLES = (
    "FreeBASIC has no array typedef; declare the array at its use",
    "unnamed record cannot be referred to",
    "was not imported, so this member cannot be",
)


class Binding:
    def __init__(self, path):
        self.decl = collections.OrderedDict()   # name -> text
        self.ren = []
        self.skip = []                          # (kind, name, reason, line)
        alias = {}
        lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
        sect = None
        i = 0
        while i < len(lines):
            ln = lines[i]
            i += 1
            if LEDGER_REN.match(ln):
                sect = "ren"
                continue
            if LEDGER_SKIP.match(ln):
                sect = "skip"
                continue
            if ln.startswith("''"):
                if sect and ln.startswith("''     "):
                    if sect == "ren":
                        self.ren.append(ln)
                    else:
                        # kind is 9 wide, then the name and reason -- split below
                        body = ln[7:]
                        self.skip.append([body[:10].strip(), body[10:], "", ln])
                continue
            sect = None
            m = ALIAS.match(ln)
            if m:
                alias[m.group(1)] = m.group(2)
                continue
            m = BLOCK.match(ln)
            if m:
                body = [ln]
                close = "end " + m.group(1)
                while i < len(lines) and lines[i] != close:
                    body.append(lines[i])
                    i += 1
                body.append(close)
                i += 1
                self.decl[m.group(2)] = "\n".join(body)
                continue
            if ln == "enum":
                while i < len(lines) and lines[i] != "end enum":
                    e = lines[i].strip()
                    self.decl[e.split(" ")[0]] = "enum " + e
                    i += 1
                i += 1
                continue
            for rx in SIMPLE:
                m = rx.match(ln)
                if m:
                    self.decl[m.group(1)] = ln
                    break
        # THE SKIP LEDGER PADS A NAME TO 28 COLUMNS and a longer one runs straight into its
        # reason: 'CryptInstallOIDFunctionAddressFreeBASIC has no...'. Split those at the
        # longest name whose remainder starts the way some padded reason does -- a whole
        # first word, since 'no ...' would otherwise split '...INFORMATIONanonymous'.
        starts = set()
        for sk in self.skip:
            rest = sk[1]
            if len(rest) > 28 and rest[27] == " ":
                r = rest[28:].strip()
                starts.add("'" if r.startswith("'") else r.split(" ")[0] + " ")
        for sk in self.skip:
            rest = sk[1]
            if len(rest) > 28 and rest[27] == " ":
                sk[1], sk[2] = rest[:28].strip(), rest[28:].strip()
                continue
            m = re.match(r"^\w+", rest)
            k = m.end() if m else 0
            while k > 1 and not any(rest[k:].startswith(p) for p in starts):
                k -= 1
            sk[1], sk[2] = rest[:k], rest[k:].strip()
        self.skip = [tuple(sk) for sk in self.skip]
        fwd = re.compile(r"\b(\w+__ptr)\b")
        for k in self.decl:
            self.decl[k] = fwd.sub(lambda m: alias.get(m.group(1), m.group(1)), self.decl[k])
        self.skipped = {s[1] for s in self.skip}


def main():
    fb, tk, label = Binding(sys.argv[1]), Binding(sys.argv[2]), sys.argv[3]
    show_all = "--all" in sys.argv
    fired = collections.Counter()
    unexplained = []

    def explain(cls):
        fired[cls] += 1

    # LAYOUT-REFUSED: what tiko's own layout check refused, and what held it by value.
    layout_refused = {s_ for k, s_, r, _ in tk.skip if "in tiko's layout" in r or "tiko lays it out" in r}
    grew = True
    while grew:
        grew = False
        for k, s_, r, _ in tk.skip:
            m = re.search(r"uses '(\w+)', which was skipped", r)
            if m and m.group(1) in layout_refused and s_ not in layout_refused:
                layout_refused.add(s_)
                grew = True

    # NESTED-NAMED: a named record declared inside another. tiko keeps its C name, which
    # is file scope in C; fbc-modern names it Parent_field_t. Paired through the PARENT --
    # a record both declare whose field, line for line, names a record only one side
    # declares -- and confirmed by the two bodies being the same.
    rename = {}
    field = re.compile(r"^(\s*\w+(?:\(.*\))? as )(\w+)$")
    for n, t in fb.decl.items():
        u = tk.decl.get(n)
        if u is None or u == t or "\n" not in t:
            continue
        fl, tl = t.split("\n"), u.split("\n")
        if len(fl) != len(tl):
            continue
        for a, b in zip(fl, tl):
            ma, mb = field.match(a), field.match(b)
            if not (ma and mb) or ma.group(1) != mb.group(1):
                continue
            fn, tn = ma.group(2), mb.group(2)
            if fn != tn and fn in fb.decl and tn in tk.decl and fn not in tk.decl and tn not in fb.decl:
                # its own synthetic members are named after it, on both sides
                if fb.decl[fn].split("\n", 1)[-1].replace(fn, tn) == tk.decl[tn].split("\n", 1)[-1]:
                    rename[fn] = tn
                    for c in fb.decl:
                        if c.startswith(fn + "_") and c not in tk.decl and tn + c[len(fn):] in tk.decl:
                            rename[c] = tn + c[len(fn):]
    if rename:
        rx = re.compile(r"\b(" + "|".join(map(re.escape, rename)) + r")\b")
        for k in fb.decl:
            fb.decl[k] = rx.sub(lambda m: rename[m.group(1)], fb.decl[k])

    fb_consts = {n: t.split(" = ", 1)[1] for n, t in fb.decl.items() if t.startswith("const ")}
    fb_skipped_imported = {n for n in fb.skipped if n in tk.decl and n not in fb.decl}

    def cascade(ftext, ttext):
        # fbc's text, with each record fbc skipped and tiko imported spelled 'any'
        for r in fb_skipped_imported:
            ttext = re.sub(r"\b(?:const )?" + re.escape(r) + r" ptr\b", "any ptr", ttext)
        return ttext == ftext

    for n, t in fb.decl.items():
        if n in rename:
            explain("NESTED-NAMED")
            continue
        if n in tk.decl:
            u = tk.decl[n]
            if u == t:
                continue
            if re.sub(r"\bconst ", "", u) == re.sub(r"\bconst ", "", t) and len(u) > len(t):
                explain("ALIAS-CONST")
            elif cascade(t, u):
                explain("TIKO-IMPORTS")
            elif re.sub(r"\b(?:const )?(\w+) ptr\b", "any ptr", u) == t and \
                    all(r in fb.skipped and r in tk.skipped for r in re.findall(r"\b(\w+) ptr\b", u)):
                explain("STALE-ALIAS")
            else:
                unexplained.append("changed   %s\n      fbc : %s\n      tiko: %s" % (n, t[:300], u[:300]))
            continue
        m = re.match(r"^(\w+)_(\d+)$", n)
        if t.startswith("const ") and m and fb_consts.get(m.group(1)) == fb_consts[n]:
            explain("DUP-MACRO")
            continue
        m = re.match(r"^#define \w+ (\w+)$", t)
        if m and m.group(1) not in fb.decl:
            explain("DANGLING-ALIAS")
            continue
        if "\n" in t and any(n.startswith(s + "_") for s in fb.skipped if s in tk.skipped):
            explain("ORPHAN")
            continue
        if n in layout_refused:
            explain("LAYOUT-REFUSED")
            continue
        unexplained.append("fbc only  %s: %s" % (n, t.split("\n")[0][:200]))

    # What tiko imports because it imported a record fbc-modern skipped: that record's
    # synthetic member records, and the records it names.
    grown = {n for n in fb_skipped_imported
             if any(h in r for k, s, r, _ in fb.skip if s == n for h in TIKO_HANDLES)}
    fs = collections.Counter((k, s, r) for k, s, r, _ in fb.skip)
    ts = collections.Counter((k, s, r) for k, s, r, _ in tk.skip)
    dup_alias = set()
    for (k, s, r), c in fs.items():
        m = re.match(r"^'(\w+)' cannot be aliased", r)
        if k == "define" and c >= 2 and m and tk.decl.get(s) == "#define %s %s" % (s, m.group(1)):
            dup_alias.add(s)
    # A named record C declared inside another is written just BEFORE its parent -- with
    # its own nested and synthetic records before it -- so it is followed, past other
    # records only tiko has, by a record both importers declare.
    order = list(tk.decl)
    nested_kept = set()
    for i, n in enumerate(order):
        if n in fb.decl or "\n" not in tk.decl[n]:
            continue
        for m_ in order[i + 1:]:
            if "\n" not in tk.decl[m_]:
                break
            if m_ in fb.decl:
                nested_kept.add(n)
                break
    for n, t in tk.decl.items():
        if n in fb.decl or n in rename.values():
            continue
        if n in grown or any(n.startswith(p + "_") or re.search(r"\b" + re.escape(n) + r"\b", tk.decl[p])
                             for p in grown):
            explain("TIKO-IMPORTS")
            continue
        if n in dup_alias:
            explain("DUP-MACRO")
            continue
        if "\n" in t and any(n.startswith(s + "_") for s in tk.skipped if s not in tk.decl):
            explain("ORPHAN")
            continue
        if n in nested_kept:
            explain("NESTED-KEPT")
            continue
        unexplained.append("tiko only %s: %s" % (n, t.split("\n")[0][:200]))

    fr, tr = collections.Counter(fb.ren), collections.Counter(tk.ren)
    for ln in (fr - tr).elements():
        m = re.search(r"constant\s+(\w+) -> (\w+)_(\d+)  \(case-insensitive collision\)$", ln)
        if m and m.group(1) == m.group(2):
            explain("DUP-MACRO")
        else:
            unexplained.append("fbc renamed  " + ln.strip("' "))
    for ln in (tr - fr).elements():
        unexplained.append("tiko renamed " + ln.strip("' "))

    WORDING = [
        (r"^FreeBASIC has no array typedef; declare the array at its use$",
         r"^an array of unknown size has no FreeBASIC spelling$"),
        (r"^(.*)'(\w+)' was not imported, so this member cannot be$",
         r"^(.*)uses '(\w+)', which was skipped$"),
    ]
    tk_only = list((ts - fs).elements())
    for k, s, r in (fs - ts).elements():
        other = [x for x in tk_only if x[0] == k and x[1] == s]
        if s in dup_alias:
            explain("DUP-MACRO")
            continue
        if (k, s, r) in ts:
            explain("DUP-SKIP")
            continue
        if r == "record has no importable members" and s in fb.decl:
            explain("SPURIOUS-SKIP")
            continue
        if other:
            tr_ = other[0][2]
            same = False
            for fw, tw in WORDING:
                a, b = re.match(fw, r), re.match(tw, tr_)
                if a and b and a.groups() == b.groups():
                    same = True
            if same:
                explain("REASON-WORDING")
            elif any(h in r for h in TIKO_HANDLES):
                explain("TIKO-DEEPER")
            else:
                unexplained.append("skip reason %s %s\n      fbc : %s\n      tiko: %s" % (k, s, r, tr_))
            tk_only.remove(other[0])
            continue
        if s in tk.decl and any(h in r for h in TIKO_HANDLES + ("record has no importable members",)):
            explain("TIKO-IMPORTS")
            continue
        unexplained.append("fbc skipped  %s %s: %s" % (k, s, r))
    for k, s, r in tk_only:
        if s in layout_refused:
            explain("LAYOUT-REFUSED")
            continue
        unexplained.append("tiko skipped %s %s: %s" % (k, s, r))

    total = sum(fired.values()) + len(unexplained)
    print("%s: %d declarations (fbc %d), %d differences, %d explained, %d unexplained" % (
        label, len(tk.decl), len(fb.decl), total, sum(fired.values()), len(unexplained)))
    for cls, c in sorted(fired.items()):
        print("    %-15s %d" % (cls, c))
    for u in unexplained if show_all else unexplained[:25]:
        print("  " + u)
    if len(unexplained) > 25 and not show_all:
        print("  ... %d more (--all)" % (len(unexplained) - 25))
    return 1 if unexplained else 0


if __name__ == "__main__":
    sys.exit(main())
