#!/usr/bin/env python3
"""genwinfacade.py -- write pkg/sys/windows, the FACADE over windows.bi (ADR 0017 §19).

The module an importer reaches the Windows API through:

    #import "sys/windows" as win
    win.MessageBox( 0, "text", "caption", win.MB_OK )

is windows.bi and nothing else. The header's names are global, so each is re-exported as
'..NAME', the global scope's own spelling: a 'win.RECT' IS the 'RECT' of a program, or of
AfxNova, that includes windows.bi itself, and the two mix freely.

UNICODE IS NOT ASKED. An unsuffixed name is the W one, whatever the importer defines -- the
facade is compiled without UNICODE and re-read in each importer's macro environment, so a
name that followed UNICODE would mean one thing in the module and another beside it. So
'win.MessageBox' is 'MessageBoxW', 'win.WNDCLASSEX' is 'WNDCLASSEXW', 'win.TCHAR' is WCHAR
and 'win.TEXT( "x" )' is wide. The A and W names are exported as well, as spelled.

THE NAMES ARE THE COMPILER'S. windows.bi is scanned twice by 'tiko --dump-scan', without and
with UNICODE: a declaration the two place on different lines follows UNICODE. Its W name is
the one with a 'W' added, when the header declares that; otherwise the UNICODE declaration's
own line says what it is ('type LPTSTR as LPWSTR'). Macros are no symbols, so their names
come from the headers' '#define' lines, and the same front end says which of them windows.bi
leaves defined ('--pp-only' will not do: its '#if _WIN32_WINNT' cannot see that constant). A macro written under a condition that names UNICODE follows it, and its W
form is the '#ifdef UNICODE' branch's.

Left out: names beginning '_' (MinGW's plumbing), the C runtime headers windows.bi pulls in,
and the few names that are tiko keywords (the header already renames the ones its users call:
Sleep_, Beep_, BGR, ERROR_, CTRUE).

Run it from the repository root whenever windows.bi changes, and commit what it writes:

    python build/genwinfacade.py [--tiko bin/tiko.exe] [--inc toolchains/tiko-windows/inc]
    python build/genwinfacade.py --check      # exit 1 if the facade would change
"""
import argparse
import concurrent.futures
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from genfacades import keywords  # noqa: E402

OUT = os.path.join(ROOT, "pkg", "sys", "windows", "windows.bas")
HEADER = "windows.bi"
# MinGW's own plumbing: in win/, but no part of the API.
NOT_API = {"_mingw.bi", "_mingw_unicode.bi", "crtdefs.bi"}
# windef.h's macros that FreeBASIC defines itself, so windows.bi does not: exported as they are.
# RGB is not one of them -- FreeBASIC's is not Windows' (the header's is BGR).
BUILTINS = ["LOWORD", "HIWORD", "LOBYTE", "HIBYTE"]
KINDS = {"type", "union", "enum", "typedef", "function", "sub", "const", "var"}
SYM = re.compile(r"^\s*\[(\d+)\] (\S+) (\S+)(.*?)\s+@(\d+):(\d+):\d+\s+parent=(-?\d+)")
FILE = re.compile(r"^\s*\[(\d+)\] (\S+)$")
IDENT = re.compile(r"^[A-Za-z][A-Za-z0-9_]*$")
DEFINE = re.compile(r"^\s*#\s*define\s+([A-Za-z_][A-Za-z0-9_]*)(\()?(.*)$", re.IGNORECASE)
COND = re.compile(r"^\s*#\s*(ifdef|ifndef|if|elseif|else|endif)\b(.*)$", re.IGNORECASE)
UNICODE_WORD = re.compile(r"\bUNICODE\b")


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8",
                          errors="replace")


def probe_file(d, body):
    p = os.path.join(d, "probe.bas")
    with open(p, "w", encoding="utf-8") as f:
        f.write('#include once "%s"\n' % HEADER + body)
    return p


def scan(tiko, inc, unicode):
    """{lower name: record} of the global declarations windows.bi makes, and its files."""
    with tempfile.TemporaryDirectory() as d:
        cmd = [tiko, "--dump-scan", "-i", inc] + (["-d", "UNICODE"] if unicode else [])
        out = run(cmd + [probe_file(d, "")]).stdout
    files, syms, section = {}, [], None
    for ln in out.splitlines():
        if ln.startswith("files:"):
            section = "files"
        elif ln.startswith("symbols:"):
            section = "symbols"
        elif section == "files":
            m = FILE.match(ln)
            if m:
                files[int(m.group(1))] = m.group(2)
        elif section == "symbols":
            m = SYM.match(ln)
            if m:
                syms.append(dict(id=int(m.group(1)), kind=m.group(2), name=m.group(3),
                                 rest=re.sub(r"tmp\$\d+", "tmp$", m.group(4).strip()), file=files.get(int(m.group(5)), ""),
                                 line=int(m.group(6)), parent=int(m.group(7))))
    if not syms:
        sys.exit("genwinfacade: '%s' produced no symbols" % " ".join(cmd))
    return syms


def api_file(inc, base):
    """A header of the API: in win/, not a C runtime header of the same name."""
    return (base not in NOT_API and os.path.isfile(os.path.join(inc, "win", base))
            and not os.path.isfile(os.path.join(inc, "crt", base)))


def declared(syms, inc):
    """{lower name: record} of what an importer may name: top-level declarations in the
    API's headers, and the members of their enums (which FreeBASIC puts at top level)."""
    top = {s["id"]: s for s in syms if s["parent"] == -1 and api_file(inc, s["file"])}
    enums = {i for i, s in top.items() if s["kind"] == "enum"}
    out = {}
    for s in syms:
        if s["parent"] == -1 and s["id"] in top and s["kind"] in KINDS:
            out.setdefault(s["name"].lower(), s)
        elif s["kind"] == "enumval" and s["parent"] in enums:
            out.setdefault(s["name"].lower(), s)
    return out


def closure_files(syms, inc):
    return sorted({s["file"] for s in syms if api_file(inc, s["file"])})


def macro_lines(inc, files):
    """Every '#define' of the API's headers: (name, is function-like, body, file, line,
    whether a condition around it names UNICODE, whether it is the '#ifdef UNICODE' branch)."""
    out = []
    for base in files:
        with open(os.path.join(inc, "win", base), encoding="utf-8", errors="replace") as f:
            lines = f.read().splitlines()
        stack = []   # [names UNICODE, the '#ifdef UNICODE' first branch]
        for no, ln in enumerate(lines, 1):
            m = COND.match(ln)
            if m:
                d, rest = m.group(1).lower(), m.group(2)
                if d in ("ifdef", "ifndef", "if"):
                    uni = bool(UNICODE_WORD.search(rest))
                    stack.append([uni, uni and d == "ifdef" and rest.strip() == "UNICODE"])
                elif d in ("else", "elseif") and stack:
                    stack[-1][0] = stack[-1][0] or bool(UNICODE_WORD.search(rest))
                    stack[-1][1] = False
                elif d == "endif" and stack:
                    stack.pop()
                continue
            m = DEFINE.match(ln)
            if m:
                out.append(dict(name=m.group(1), fn=bool(m.group(2)),
                                body=(m.group(2) or "") + m.group(3), file=base, line=no,
                                uni=any(s[0] for s in stack),
                                wbranch=bool(stack) and stack[-1][1]))
    return out


def enum_members(inc, files):
    """The members of the headers' anonymous enums, which the scan does not list: fbc spells
    C's 'typedef enum { ... } X' as 'type X as long' and an 'enum' with no name."""
    out = []
    for base in files:
        with open(os.path.join(inc, "win", base), encoding="utf-8", errors="replace") as f:
            inside = False
            for ln in f:
                t = ln.strip()
                if re.match(r"^enum$", t, re.IGNORECASE):
                    inside = True
                elif re.match(r"^end\s+enum$", t, re.IGNORECASE):
                    inside = False
                elif inside and t and not t.startswith(("#", "''")):
                    m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)", t)
                    if m:
                        out.append(m.group(1))
    return out


def defined_names(tiko, inc, names, unicode):
    """Which of 'names' windows.bi leaves defined, by the compiler's word: the front end's
    '#ifdef' sees a macro, a declaration and an enum's member alike."""
    body = "".join("#ifdef %s\n#print tkoprobe_%s\n#endif\n" % (n, n) for n in names)
    with tempfile.TemporaryDirectory() as d:
        cmd = [tiko, "--dump-scan", "-i", inc] + (["-d", "UNICODE"] if unicode else [])
        r = run(cmd + [probe_file(d, body)])
    got = set(re.findall(r"#print tkoprobe_(\w+)", r.stdout + r.stderr))
    if not got:
        sys.exit("genwinfacade: '%s' printed no names" % " ".join(cmd))
    return got


def global_ref(text, kw):
    """A declaration's type as the header wrote it, each name in it made global: 'WCHAR ptr'
    is '..WCHAR ptr'."""
    return re.sub(r"\b[A-Za-z_][A-Za-z0-9_]*\b",
                  lambda m: m.group(0) if m.group(0).lower() in kw else ".." + m.group(0), text)


def build(tiko, inc):
    kw = keywords()[0]
    with concurrent.futures.ThreadPoolExecutor(2) as ex:     # a minute or more each
        ansi_f, uni_f = ex.submit(scan, tiko, inc, False), ex.submit(scan, tiko, inc, True)
        ansi_syms, uni_syms = ansi_f.result(), uni_f.result()
    ansi, uni = declared(ansi_syms, inc), declared(uni_syms, inc)
    files = closure_files(ansi_syms, inc)
    skipped = []

    def usable(n):
        if not IDENT.match(n):
            return False
        if n.lower() in kw:
            skipped.append(n)
            return False
        return True

    # ---- macros: the '#define' lines, and which the preprocessor keeps
    mlines = [m for m in macro_lines(inc, files)
              if m["name"].lower() not in ansi and m["name"].lower() not in uni]
    cands = sorted({m["name"] for m in mlines if usable(m["name"])}, key=str.lower)
    macnames = {n.lower() for n in cands}
    members = sorted({n for n in enum_members(inc, files)
                      if n.lower() not in ansi and n.lower() not in uni
                      and n.lower() not in macnames and usable(n)}, key=str.lower)
    with concurrent.futures.ThreadPoolExecutor(2) as ex:
        a_f = ex.submit(defined_names, tiko, inc, cands + members, False)
        u_f = ex.submit(defined_names, tiko, inc, cands + members, True)
        mac_a, mac_u = a_f.result(), u_f.result()
    follows = {m["name"] for m in mlines if m["uni"]}
    spell = {}
    for m in mlines:
        spell.setdefault(m["name"].lower(), m["name"])

    def w_name(n):
        """The W counterpart's spelling and whether it is a macro, or None."""
        w = (n + "W").lower()
        if w in uni:
            return uni[w]["name"], False
        if w in spell and spell[w] in mac_u:
            return spell[w], True
        return None

    # A name the header declares in one mode only has no meaning in the other: left out.
    plain, unicode_map, problems, oneside = {}, {}, [], []

    texts = {}

    def source(s):
        """The header line a declaration is on, as written."""
        if s["file"] not in texts:
            with open(os.path.join(inc, "win", s["file"]), encoding="utf-8",
                      errors="replace") as f:
                texts[s["file"]] = f.read().splitlines()
        return texts[s["file"]][s["line"] - 1].strip()

    # ---- declarations
    for key, s in ansi.items():
        n = s["name"]
        if not usable(n):
            continue
        u = uni.get(key)
        if u is None:
            oneside.append(n)
            continue
        if u["rest"] == s["rest"] and source(u) == source(s):
            plain[n] = "..%s" % n     # the same declaration, if on another line
            continue
        w = w_name(n)
        if w:
            unicode_map[n] = (False, w[0] if w[1] else ".." + w[0], False)
            continue
        src = source(u)
        m = re.match(r"^\s*type\s+" + re.escape(n) + r"\s+as\s+(.+?)\s*$", src, re.IGNORECASE)
        if m and s["kind"] == "typedef":
            unicode_map[n] = (False, global_ref(m.group(1), kw), False)
        else:
            problems.append("%s (%s:%d): follows UNICODE and has no W form" %
                            (n, u["file"], u["line"]))
    for key, u in uni.items():
        if key not in ansi and usable(u["name"]):
            oneside.append(u["name"])

    # ---- macros that follow UNICODE: the '#ifdef UNICODE' branch's definition, or the W name
    def w_form(n):
        """(the W definition, whether it is function-like) of a macro that follows UNICODE."""
        w = w_name(n)
        branch = [m for m in mlines if m["name"] == n and m["wbranch"]]
        if w and (not branch or not branch[0]["fn"]):
            return (w[0] if w[1] else ".." + w[0]), False
        if branch:
            return branch[0]["body"].strip(), branch[0]["fn"]
        return None

    # WHAT A NAME THAT FOLLOWS UNICODE BECOMES INSIDE ANOTHER MACRO'S BODY. An exported macro
    # expands in the importer, where 'IDC_ARROW' would reach the importer's MAKEINTRESOURCE,
    # so its body is written out with the W forms: its W name, a declaration's W type, or
    # the function a one-to-one function-like macro calls ('__TEXT( q )' is 'wstr( q )').
    subst = {n: e[1] for n, e in unicode_map.items()}
    wforms = {}
    for n in sorted(follows):
        f = w_form(n)
        if f is None:
            continue
        wforms[n] = f
        if not f[1]:
            subst[n] = f[0]
            continue
        m = re.match(r"^\(([^)]*)\)\s*([A-Za-z_]\w*)\s*\(([^)]*)\)$", f[0])
        if m and [a.strip() for a in m.group(1).split(",")] ==                 [a.strip() for a in m.group(3).split(",")]:
            subst[n] = m.group(2)

    for n in cands:
        if n in follows:
            if n in wforms:
                unicode_map[n] = (n in mac_a, wforms[n][0], wforms[n][1])
            elif n in mac_a and n in mac_u:
                plain[n] = None     # under a UNICODE condition, but the same either way
            elif n in mac_u:
                problems.append("%s: a macro only under UNICODE, with no '#ifdef UNICODE' "
                                "definition to copy" % n)
        elif n in mac_a:
            plain[n] = None

    # ---- the anonymous enums' members: constants, the same with UNICODE or without
    for n in members:
        if n in mac_a and n in mac_u:
            plain[n] = "..%s" % n
        elif n in mac_a or n in mac_u:
            oneside.append(n)

    # ---- macros that follow UNICODE through another name: IDC_ARROW, SE_DEBUG_NAME ...
    word = re.compile(r'"[^"]*"|\b[A-Za-z_][A-Za-z0-9_]*\b')
    defs = {}
    for m in mlines:
        defs.setdefault(m["name"], set()).add((m["fn"], m["body"].strip()))
    deps = {}
    grew = True
    while grew:
        grew = False
        for n in [n for n in plain if plain[n] is None and n not in deps]:
            words = {w for _, b in defs.get(n, ()) for w in word.findall(b)}
            if not words & (set(subst) | set(deps)):
                continue
            if len(defs[n]) != 1:
                problems.append("%s: follows UNICODE through another macro, and has %d "
                                "definitions" % (n, len(defs[n])))
                deps[n] = None
            else:
                deps[n] = next(iter(defs[n]))
            grew = True

    def split_fn(body):
        """'(a, b) text' -> (['a', 'b'], ' text')."""
        m = re.match(r"^\(([^)]*)\)(.*)$", body)
        return [a.strip() for a in m.group(1).split(",")], m.group(2)

    def call_args(text, at):
        """The arguments of the call whose '(' is at text[at], and the index past its ')'."""
        args, depth, start, i = [], 0, at + 1, at
        while i < len(text):
            c = text[i]
            if c == '"':
                i = text.index('"', i + 1)
            elif c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    args.append(text[start:i].strip())
                    return args, i + 1
            elif c == "," and depth == 1:
                args.append(text[start:i].strip())
                start = i + 1
            i += 1
        return None, at

    def rewrite(text, params, n, depth=0):
        """'text' with every name that follows UNICODE replaced by its W form; a macro that
        follows it through another is expanded in place, arguments and all."""
        out, pos = [], 0
        for m in word.finditer(text):
            if m.start() < pos:
                continue
            out.append(text[pos:m.start()])
            pos = m.end()
            w = m.group(0)
            if w.startswith('"') or w in params:
                out.append(w)
            elif w in subst:
                out.append(subst[w])
            elif w in deps and deps[w] is not None and depth < 8:
                fn, body = deps[w]
                if not fn:
                    out.append(rewrite(body, (), n, depth + 1))
                    continue
                at = pos + len(text[pos:]) - len(text[pos:].lstrip())
                args, end = (call_args(text, at) if text[at:at + 1] == "(" else (None, at))
                names, inner = split_fn(body)
                if args is None or len(args) != len(names):
                    problems.append("%s: cannot expand its call of %s" % (n, w))
                    out.append(w)
                    continue
                args = [rewrite(a, params, n, depth + 1) for a in args]
                inner = rewrite(inner, set(names), n, depth + 1)
                amap = dict(zip(names, args))
                out.append(word.sub(lambda k: amap.get(k.group(0), k.group(0)), inner).strip())
                pos = end
            else:
                out.append(w)
        out.append(text[pos:])
        return "".join(out)

    for n, d in deps.items():
        if d is None:
            continue
        fn, body = d
        if fn:
            names, inner = split_fn(body)
            text = "(%s)%s" % (", ".join(names), rewrite(inner, set(names), n))
        else:
            text = " " + rewrite(body, (), n).strip()
        del plain[n]
        unicode_map[n] = (True, text, True)

    if problems:
        sys.exit("genwinfacade: the facade cannot say what these are:\n  " +
                 "\n  ".join(sorted(problems)))
    for n in oneside:
        plain.pop(n, None)
        unicode_map.pop(n, None)
    for n in BUILTINS:
        plain.setdefault(n, None)
    return plain, unicode_map, sorted(set(skipped), key=str.lower), sorted(oneside, key=str.lower)


def render(plain, unicode_map, skipped, oneside):
    out = [
        "'' sys/windows -- a FACADE over windows.bi (ADR 0017 §19). GENERATED by",
        "'' build/genwinfacade.py from the toolchain's headers: do not edit by hand, re-run it when",
        "'' windows.bi changes. Every name is the header's global name, written win.<name> (or",
        "'' whatever the import's alias is). The header travels with the interface (ADR 0017,",
        "'' required headers), so win.RECT is the RECT of any code that includes windows.bi.",
        "'' An unsuffixed name is the W one whatever UNICODE says: win.MessageBox is MessageBoxW.",
    ]
    if skipped:
        out.append("'' Not exported, being tiko keywords: %s." % ", ".join(skipped))
    if oneside:
        out.append("'' Not exported, windows.bi declaring them only with UNICODE or only without: %s."
                   % ", ".join(oneside))
    out += ['#module "windows"', '#include once "%s"' % HEADER, ""]
    names = sorted(set(plain) | set(unicode_map), key=str.lower)
    out.append("'' The header's declarations, by their global names.")
    for n in sorted(plain, key=str.lower):
        if plain[n] is not None:
            out.append("#define %s %s" % (n, plain[n]))
    out.append("")
    out.append("'' The W form of every name that follows UNICODE.")
    for n in sorted(unicode_map, key=str.lower):
        e = unicode_map[n]
        if e[0]:
            out.append("#undef %s" % n)
        if e[2]:
            out.append("#define %s%s" % (n, e[1]))
        else:
            out.append("#define %s %s" % (n, e[1]))
    out.append("")
    line, lines = "#export", []
    for n in names:
        piece = (" " if line == "#export" else ", ") + n
        if len(line) + len(piece) > 92 and line != "#export":
            lines.append(line)
            line = "#export " + n
        else:
            line += piece
    lines.append(line)
    out.extend(lines)
    return "\n".join(out) + "\n", len(names)


def main():
    ap = argparse.ArgumentParser()
    exe = "tiko.exe" if os.name == "nt" else "tiko"
    ap.add_argument("--tiko", default=os.path.join(ROOT, "bin", exe))
    ap.add_argument("--inc", default=os.path.join(ROOT, "toolchains", "tiko-windows", "inc"))
    ap.add_argument("--out", default=OUT)
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    text, count = render(*build(a.tiko, a.inc))
    old = open(a.out, encoding="utf-8").read() if os.path.isfile(a.out) else None
    if old == text:
        return
    if a.check:
        print("genwinfacade: would change %s (%d names)" % (a.out, count))
        sys.exit(1)
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    with open(a.out, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    print("genwinfacade: wrote %s (%d names)" % (a.out, count))


if __name__ == "__main__":
    main()
