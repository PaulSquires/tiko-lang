#!/usr/bin/env python3
"""syswinrename.py -- RFC-0001's identifier pass over sys/win: drop the tk / fbx prefixes.

Applies build/syswinrename.json, the RFC's name map (C:/dev/docs/tiko-syswin/tools/mapping.py,
generated from the compiler's own module interfaces), to

    pkg/sys/win          (default)   the library itself: definitions and its own references
    --user DIR                       a user's tree: every sys/win name to its QUALIFIED new form,
                                     with the alias the file's own #import gives the module

THIS VERSION ONLY REPORTS (I1). It reads, resolves and lists every edit the rename would make,
and every prefixed identifier the map does not cover; it writes nothing under the tree.
--apply is phases I2/I3 and is refused here.

    python build/syswinrename.py [--root pkg/sys/win] [--user DIR] --report OUT.txt [--edits OUT.tsv]

The map's actions, per old name (module-scoped -- tkMsg is a different name in win and com):
    rename    tkName -> Name                          the name changes, nothing else
    overload  tkGetWindowText -> GetWindowText        rule K: also needs OVERLOAD at the definition
    member    tkButton_SetDarkMode -> Button.SetDarkMode   moves into a family namespace
    drop      removed: definition deleted, every caller rewritten BY HAND (args differ)
    private   PUBLIC removed, name unchanged
FreeBASIC names are case-blind, and so is every match here.
"""
import argparse, collections, io, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
MOD_ALIAS = {"sys.win": "win", "sys.win.com": "com", "sys.win.gui": "gui",
             "sys.win.richedit": "richedit", "sys.win.gdiplus": "gdiplus",
             "sys.win.direct2d": "direct2d", "sys.win.webview2": "webview2"}
IMPORT_MOD = {"sys/" + m.replace("sys.", "").replace(".", "/"): m for m in MOD_ALIAS}
PREFIX_RE = re.compile(r"^(tkl[A-Z_]|tk[A-Z_]|TK_|fbx[A-Z]|FBX_|Afx[A-Z])")
MARKER_RE = re.compile(r"\[pkg/(fbx|tkl|sys)\]")
STALE_FBX = re.compile(r"\bfbx(NewCom|Guid|Advise|GetCom|AnyCom|SafeRelease|OleCreateFontDisp|ImageStreamFromRes)\b")
DEF_KW = {"function", "sub"}
DEF_PRE = {"public", "private", "static", "declare", "overload"}

# ------------------------------------------------------------------------- the tokenizer
class Tok:
    __slots__ = ("kind", "text", "line", "col", "pos")
    def __init__(s, kind, text, line, col, pos):
        s.kind, s.text, s.line, s.col, s.pos = kind, text, line, col, pos

def tokenize(src):
    """FreeBASIC tokens: ident, str, comment, nl, punct. Strings: "..." with "" doubled,
    !"..." with backslash escapes; comments: ' to end of line, REM, nestable /' ... '/."""
    toks, i, n, line, lstart = [], 0, len(src), 1, 0
    def add(kind, a, b):
        toks.append(Tok(kind, src[a:b], line, a - lstart + 1, a))
    while i < n:
        c = src[i]
        if c == "\n":
            add("nl", i, i + 1); i += 1; line += 1; lstart = i; continue
        if c in " \t\r":
            i += 1; continue
        if c == "/" and src.startswith("/'", i):
            a, depth, i = i, 1, i + 2
            sl, sls = line, lstart
            while i < n and depth:
                if src.startswith("/'", i): depth += 1; i += 2
                elif src.startswith("'/", i): depth -= 1; i += 2
                else:
                    if src[i] == "\n": line += 1; lstart = i + 1
                    i += 1
            toks.append(Tok("comment", src[a:i], sl, a - sls + 1, a)); continue
        if c == "'":
            a = i
            while i < n and src[i] != "\n": i += 1
            add("comment", a, i); continue
        if c == '"' or (c in "!$" and i + 1 < n and src[i + 1] == '"'):
            a = i; esc = (c == "!")
            i += 1 if c == '"' else 2
            while i < n:
                if esc and src[i] == "\\": i += 2; continue
                if src[i] == '"':
                    if i + 1 < n and src[i + 1] == '"': i += 2; continue
                    i += 1; break
                if src[i] == "\n": break
                i += 1
            add("str", a, i); continue
        if c.isalpha() or c == "_":
            a = i
            while i < n and (src[i].isalnum() or src[i] == "_"): i += 1
            w = src[a:i]
            if w.lower() == "rem" and (not toks or toks[-1].kind == "nl" or toks[-1].text == ":"):
                while i < n and src[i] != "\n": i += 1
                add("comment", a, i); continue
            add("ident", a, i); continue
        if c.isdigit():
            a = i
            while i < n and (src[i].isalnum() or src[i] in "._"): i += 1
            add("num", a, i); continue
        if c == "&" and i + 1 < n and src[i + 1] in "hHoObB":
            a = i; i += 2
            while i < n and src[i].isalnum(): i += 1
            add("num", a, i); continue
        add("punct", i, i + 1); i += 1
    return toks

# ------------------------------------------------------------------------- the map
class Map:
    def __init__(s, path):
        rows = json.load(io.open(path, encoding="utf-8"))
        s.by = collections.defaultdict(dict)          # lower old -> {module: row}
        for r in rows:
            s.by[r["old"].lower()][r["module"]] = r
        s.rows = rows
        # family -> its member names (lower), for the '..' check
        s.fam_members = collections.defaultdict(set)
        for r in rows:
            if r["act"] == "member":
                f, m = r["new"].split(".", 1)
                s.fam_members[f].add(m.lower())
    def resolve(s, name, mod, imported):
        """The row a bare reference means: this module's, else an imported one's, else the
        only one; None if not in the map; 'ambiguous' if it cannot be told."""
        c = s.by.get(name.lower())
        if not c: return None
        if mod in c: return c[mod]
        imp = [m for m in c if m in imported]
        if len(imp) == 1: return c[imp[0]]
        if len(c) == 1: return next(iter(c.values()))
        if "sys.win" in c: return c["sys.win"]
        return "ambiguous"

# ------------------------------------------------------------------------- one file
class Edit:
    __slots__ = ("file", "line", "col", "where", "kind", "old", "new", "note")
    def __init__(s, file, line, col, where, kind, old, new, note=""):
        s.file, s.line, s.col, s.where, s.kind, s.old, s.new, s.note = file, line, col, where, kind, old, new, note

def file_module(path, src, user):
    m = re.search(r'^\s*#module\s+"(\w+)"', src, re.M | re.I)
    if user or not m: return None
    name = m.group(1).lower()
    return "sys.win" if name == "win" else "sys.win." + name

def file_imports(src):
    """{module: alias} from the file's #import lines; the default alias is the last segment."""
    out = {}
    for m in re.finditer(r'^\s*#import\s+"([^"]+)"(?:\s+as\s+(\w+))?', src, re.M | re.I):
        mod = IMPORT_MOD.get(m.group(1).lower())
        if mod: out[mod] = m.group(2) or MOD_ALIAS[mod]
    return out

def prev_code(toks, k):
    j = k - 1
    while j >= 0 and toks[j].kind == "comment": j -= 1
    return j

def scan(path, rel, mp, user, edits, uncovered, notes):
    src = io.open(path, encoding="utf-8", errors="replace").read()
    toks = tokenize(src)
    mod = file_module(path, src, user)
    imports = file_imports(src)
    imported = set(imports) | ({mod} if mod else set())
    aliases = {a.lower(): m for m, a in imports.items()}
    for m, a in MOD_ALIAS.items(): aliases.setdefault(a, m)
    cur_member_family = None          # inside the body of a family member's definition
    cur_def = None
    for k, t in enumerate(toks):
        if t.kind == "comment":
            if MARKER_RE.search(t.text):
                edits.append(Edit(rel, t.line, t.col, "comment", "marker", MARKER_RE.search(t.text).group(0), "", "delete the conversion marker (RFC 5.5)"))
            for m in STALE_FBX.finditer(t.text):
                edits.append(Edit(rel, t.line, t.col, "comment", "stale-doc", m.group(0), "", "doc names a function that no longer exists (RFC 5.5)"))
            for m in re.finditer(r"[A-Za-z_]\w*", t.text):
                w = m.group(0)
                r = mp.resolve(w, mod, imported) if (mod or user) else None
                if r and r != "ambiguous":
                    edits.append(Edit(rel, t.line, t.col + m.start(), "comment", r["act"], w, newform(r, user, imports), "doc text"))
                elif PREFIX_RE.match(w) and r is None:
                    uncovered[(w.lower(), "comment")].append((rel, t.line))
            continue
        if t.kind != "ident": continue
        w, lw = t.text, t.text.lower()
        # the end of a definition's body
        if lw == "end" and k + 1 < len(toks) and toks[k + 1].kind == "ident" and toks[k + 1].text.lower() in DEF_KW:
            cur_member_family = None; cur_def = None
            continue
        j = prev_code(toks, k)
        pt = toks[j] if j >= 0 else None
        # qualified: X.name / X->name / ..name
        qual = None
        arrow = False
        if pt is not None and pt.kind == "punct" and pt.text == ">":
            jj = prev_code(toks, j)
            arrow = jj >= 0 and toks[jj].kind == "punct" and toks[jj].text == "-" and toks[jj].pos == pt.pos - 1
        if pt is not None and pt.kind == "punct" and (pt.text == "." or arrow):
            jj = prev_code(toks, j)
            p2 = toks[jj] if jj >= 0 else None
            if pt.text == "." and p2 is not None and p2.kind == "punct" and p2.text == ".":
                qual = "global"
            elif pt.text == "." and p2 is not None and p2.kind == "ident" and p2.text.lower() in aliases:
                qual = aliases[p2.text.lower()]
            else:
                qual = "member-access"
        # a definition: [public|private|static|declare] function|sub NAME, #define NAME, type NAME ...
        is_def = False
        if pt is not None and pt.kind == "ident" and pt.text.lower() in DEF_KW:
            jj = prev_code(toks, j)
            is_def = not (jj >= 0 and toks[jj].kind == "ident" and toks[jj].text.lower() == "end")
        if pt is not None and pt.kind == "ident" and pt.text.lower() in ("define", "type", "union", "enum", "const", "class"):
            is_def = True
        # resolve
        if qual == "member-access":
            r = mp.resolve(w, mod, imported)
            if r and r != "ambiguous":
                notes["member-access"].append((rel, t.line, w))
            continue
        if qual == "global":
            continue
        if qual:
            r = mp.by.get(lw, {}).get(qual)
        else:
            r = mp.resolve(w, mod, imported)
        if r == "ambiguous":
            edits.append(Edit(rel, t.line, t.col, "code", "ambiguous", w, "", "the name is in more than one module and this file's imports do not decide it"))
            continue
        if r is None:
            # '..' check: a bare call inside a family member's body to a name the family now owns
            nk = k + 1
            while nk < len(toks) and toks[nk].kind == "comment": nk += 1
            is_call = nk < len(toks) and toks[nk].kind == "punct" and toks[nk].text == "("
            if cur_member_family and not qual and is_call and lw in mp.fam_members.get(cur_member_family, ()):
                edits.append(Edit(rel, t.line, t.col, "code", "needs-global", w, ".." + w,
                                  "inside namespace %s this name is the member; the Windows one needs '..'" % cur_member_family))
            if PREFIX_RE.match(w):
                uncovered[(lw, "code")].append((rel, t.line, "def" if is_def else "ref"))
            continue
        act = r["act"]
        if is_def:
            note = ""
            if act == "member":
                cur_member_family = r["new"].split(".")[0]
                note = "definition moves into 'namespace %s'" % cur_member_family
            elif act == "overload":
                note = "rule K: the definition needs OVERLOAD" if not has_overload(toks, k) else "rule K: already OVERLOAD"
            elif act == "drop":
                note = "delete the definition"
            elif act == "private":
                note = "remove PUBLIC"
            cur_def = r
            edits.append(Edit(rel, t.line, t.col, "def", act, w, defform(r), note))
        else:
            if user:
                new = newform(r, user, imports, qualified=True, already=qual)
            else:
                new = refform(r, mod)
            note = "manual: the replacement's arguments differ" if act == "drop" else ""
            if act == "drop" and on_define_line(toks, k):
                note = "an ALIAS MACRO over a dropped name: drop the alias too, or retarget it"
            if act == "member" and not user and r["module"] != mod:
                note = "cross-module reference to a family member"
            edits.append(Edit(rel, t.line, t.col, "code", act, w, new, note))
    return src

def on_define_line(toks, k):
    j = k - 1
    while j >= 0 and toks[j].kind != "nl": j -= 1
    a = j + 1
    return a + 1 < len(toks) and toks[a].text == "#" and toks[a + 1].text.lower() == "define"

def has_overload(toks, k):
    for t in toks[k + 1:k + 4]:
        if t.kind == "ident" and t.text.lower() == "overload": return True
        if t.kind == "punct" and t.text == "(": return False
    return False

def defform(r):
    if r["act"] == "member": return r["new"].split(".", 1)[1]
    if r["act"] in ("rename", "overload"): return r["new"]
    if r["act"] == "private": return r["old"]
    return ""

def refform(r, mod):
    """A reference inside the library: same-module members by Family.Member, others bare."""
    a = r["act"]
    if a == "member": return r["new"]
    if a in ("rename", "overload"): return r["new"]
    if a == "private": return r["old"]
    return "<drop> " + (r["new"] or "")

def newform(r, user, imports, qualified=False, already=None):
    a = r["act"]
    if a == "drop": return "<drop> " + (r["new"] or "")
    if a == "private": return r["old"]
    if not user or not qualified: return r["new"]
    alias = imports.get(r["module"], MOD_ALIAS[r["module"]])
    return alias + "." + r["new"] if not already else r["new"]

# ------------------------------------------------------------------------- the report
def family_runs(edits):
    """Per family and file: are its member definitions one contiguous run of definitions?"""
    defs = collections.defaultdict(list)
    for e in edits:
        if e.where == "def": defs[e.file].append(e)
    out = []
    for f, ds in defs.items():
        ds.sort(key=lambda e: e.line)
        runs = collections.Counter(); last = None
        for e in ds:
            fam = e.new and e.kind == "member" and e.note.split("'namespace ")[-1].rstrip("'")
            fam = fam if e.kind == "member" else None
            if fam and fam != last: runs[fam] += 1
            last = fam
        for fam, n in runs.items():
            out.append((f, fam, n))
    return sorted(out)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--map", default=os.path.join(HERE, "syswinrename.json"))
    ap.add_argument("--root", default=os.path.join(HERE, "..", "pkg", "sys", "win"))
    ap.add_argument("--user")
    ap.add_argument("--report", required=True)
    ap.add_argument("--edits")
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()
    if a.apply:
        sys.exit("syswinrename: --apply is RFC-0001 phases I2/I3 and is not implemented yet -- this is the dry run")
    mp = Map(a.map)
    root = os.path.abspath(a.user or a.root)
    user = bool(a.user)
    edits, uncovered, notes = [], collections.defaultdict(list), collections.defaultdict(list)
    files = []
    for d, _, fs in os.walk(root):
        for f in sorted(fs):
            if f.lower().endswith((".tiko", ".ti", ".bas", ".bi")):
                files.append(os.path.join(d, f))
    for p in sorted(files):
        rel = os.path.relpath(p, root).replace("\\", "/")
        scan(p, rel, mp, user, edits, uncovered, notes)
    write_report(a, mp, root, user, files, edits, uncovered, notes)

def write_report(a, mp, root, user, files, edits, uncovered, notes):
    L = []
    code = [e for e in edits if e.where in ("code", "def")]
    com = [e for e in edits if e.where == "comment"]
    L.append("syswinrename.py DRY RUN -- %s %s" % ("--user" if user else "library", root.replace("\\", "/")))
    L.append("map: %d names (%s)" % (len(mp.rows), ", ".join("%s %d" % kv for kv in sorted(collections.Counter(r["act"] for r in mp.rows).items()))))
    L.append("files scanned: %d" % len(files))
    L.append("")
    L.append("SUMMARY")
    L.append("  edits in code: %d (definitions %d, references %d)" % (len(code), sum(e.where == "def" for e in code), sum(e.where == "code" for e in code)))
    for (w, k), n in sorted(collections.Counter((e.where, e.kind) for e in code).items()):
        L.append("    %-5s %-13s %6d" % (w, k, n))
    L.append("  edits in comments: %d" % len(com))
    for k, n in sorted(collections.Counter(e.kind for e in com).items()):
        L.append("    %-19s %6d" % (k, n))
    defined = {e.old.lower() for e in edits if e.where == "def"}
    unused = sorted({r["old"] for r in mp.rows if r["old"].lower() not in defined and r["kind"] in ("proc",)} ) if not user else []
    if not user:
        L.append("  map names with no definition found in the tree: %d" % len(unused))
    L.append("  prefixed identifiers the map does NOT cover: %d names in code, %d in comments" % (
        len({k[0] for k in uncovered if k[1] == "code"}), len({k[0] for k in uncovered if k[1] == "comment"})))
    L.append("")
    def section(title, rows):
        L.append(title); L.extend(rows if rows else ["  (none)"]); L.append("")
    # what needs a hand
    section("NEEDS A HAND -- references to dropped names (rewrite each with the replacement; arguments differ)",
            ["  %s:%d  %s  ->  %s%s" % (e.file, e.line, e.old, e.new, ("   [" + e.note + "]") if "ALIAS" in e.note else "") for e in code if e.kind == "drop" and e.where == "code"])
    section("NEEDS A HAND -- ambiguous names (in more than one module; the file's imports do not decide)",
            ["  %s:%d  %s" % (e.file, e.line, e.old) for e in code if e.kind == "ambiguous"])
    section("NEEDS '..' -- inside a family namespace, a bare call to the Windows function the family now shadows",
            ["  %s:%d  %s -> %s   (%s)" % (e.file, e.line, e.old, e.new, e.note) for e in code if e.kind == "needs-global"])
    section("CROSS-MODULE references to family members (need the namespace reachable: gui.Family.Member, or 'using gui')",
            ["  %s:%d  %s -> %s" % (e.file, e.line, e.old, e.new) for e in code if "cross-module" in e.note])
    section("MEMBER ACCESS on a mapped name (obj.tkX / p->tkX) -- left alone; check it is not one of ours",
            ["  %s:%d  %s" % x for x in notes["member-access"]])
    if not user:
        section("DEFINITIONS TO DELETE (drop)", ["  %s:%d  %s" % (e.file, e.line, e.old) for e in code if e.where == "def" and e.kind == "drop"])
        section("DEFINITIONS THAT NEED OVERLOAD (rule K)", ["  %s:%d  %s -> %s   %s" % (e.file, e.line, e.old, e.new, e.note) for e in code if e.where == "def" and e.kind == "overload"])
        section("DEFINITIONS THAT LOSE PUBLIC", ["  %s:%d  %s" % (e.file, e.line, e.old) for e in code if e.where == "def" and e.kind == "private"])
        runs = family_runs(edits)
        section("FAMILY NAMESPACES -- each family's member definitions per file (runs = contiguous blocks to wrap)",
                ["  %-44s %-12s runs %d%s" % (f, fam, n, "" if n == 1 else "   <- interleaved") for f, fam, n in runs])
        section("MAP NAMES WITH NO DEFINITION IN THE TREE (renamed only where referenced)", ["  " + x for x in unused])
    # uncovered
    rows = []
    for (lw, where), occ in sorted(uncovered.items()):
        if where != "code": continue
        defs = [o for o in occ if o[2] == "def"]
        first = defs[0] if defs else occ[0]
        rows.append("  %-40s %4d use(s)%s  first %s:%d" % (occ[0] and lw, len(occ), "  defined here" if defs else "", first[0], first[1]))
    section("NOT IN THE MAP -- prefixed identifiers in code (private procs, locals, fields, constants: the RFC maps only the PUBLIC interface)", rows)
    rows = ["  %-40s %4d" % (lw, len(occ)) for (lw, where), occ in sorted(uncovered.items()) if where == "comment"]
    section("NOT IN THE MAP -- prefixed words in comments", rows)
    section("STALE DOC NAMES AND CONVERSION MARKERS (RFC 5.5)",
            ["  %s:%d  %s" % (e.file, e.line, e.old) for e in com if e.kind in ("marker", "stale-doc")])
    io.open(a.report, "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")
    if a.edits:
        with io.open(a.edits, "w", encoding="utf-8", newline="\n") as f:
            f.write("file\tline\tcol\twhere\taction\told\tnew\tnote\n")
            for e in sorted(edits, key=lambda e: (e.file, e.line, e.col)):
                f.write("%s\t%d\t%d\t%s\t%s\t%s\t%s\t%s\n" % (e.file, e.line, e.col, e.where, e.kind, e.old, e.new, e.note))
    print("syswinrename: dry run, %d files, %d code edits, %d comment edits -> %s" % (len(files), len(code), len(com), a.report))

if __name__ == "__main__":
    main()
