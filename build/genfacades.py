#!/usr/bin/env python3
"""genfacades.py -- write pkg/std's FACADE modules from the toolchain's headers (RFC-0009).

A facade is a module that includes one header library and re-exports its names:

    #module "fs"
    #include once "fb/filesystem.bi"
    #define PathJoin FB.PathJoin
    #export PathJoin, ...

so an importer writes 'fs.PathJoin( ... )'. The header stays the one source of the code --
the seed builds tiko-lang from it -- and the facade adds nothing but names (M28).

THE NAMES ARE THE COMPILER'S, not a header parser's: each facade's headers are scanned by
'tiko --dump-scan', which sees what their own generator macros declare (vector.bi's Vec2f).
A name is exported when it is declared directly in namespace FB, in one of the facade's own
headers (a dependency's names are its own facade's), is an identifier, is no tiko keyword,
and is not internal by the headers' conventions (EXCLUDE_*). An enum's members go too:
no enum here is explicit, so 'FB.FS_OK' is how a header's own users write them.

Run it from the repository root whenever a header changes, and commit what it writes:

    python build/genfacades.py [--tiko bin/tiko.exe] [--inc toolchains/tiko-windows/inc]
    python build/genfacades.py --check      # exit 1 if a facade would change

The pairing of a header with its facade is checked by 'package.sh --verify', which imports
every facade (RFC-0009 §7).
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# module -> (headers to include, every header whose names are the facade's, needs -mt)
FACADES = {
    "fs": (["fb/filesystem.bi"],
           ["filesystem.bi", "fserror.bi", "fspath.bi", "fsinfo.bi", "fsdir.bi", "fsops.bi",
            "fsglob.bi", "fslink.bi", "fsvolume.bi", "fsadvanced.bi"], False),
    "containers": (["containers.bi"],
                   ["containers.bi", "hash.bi", "array.bi", "map.bi", "set.bi", "linkedlist.bi",
                    "orderedmap.bi", "orderedset.bi", "sort.bi"], False),
    "chrono": (["fb/chrono.bi"], ["chrono.bi"], False),
    # select.bi is left out whole: its own header says it is "not meant to be written by
    # hand" -- it is what a SELECT statement lowers to.
    "tasks": (["fb/scheduler.bi", "fb/channel.bi", "fb/sync.bi"],
              ["scheduler.bi", "channel.bi", "sync.bi"], True),
    "outcome": (["fb/optional.bi", "fb/result.bi"], ["optional.bi", "result.bi"], False),
    "numeric": (["fb/math.bi", "fb/mathint.bi", "fb/complex.bi", "fb/mathtext.bi",
                 "fb/random.bi", "fb/stats.bi", "fb/fenv.bi", "fb/vector.bi"],
                ["math.bi", "mathint.bi", "complex.bi", "mathtext.bi", "random.bi", "stats.bi",
                 "fenv.bi", "vector.bi"], False),
}
# Real modules now (build/stdport.py, 2026-10-10), no longer written here: strings, tui, money, logs.

# std/path's names, kept in std/fs when std/path was folded into it (RFC-0009 M30). Each is
# the header's function, with the header's behaviour -- see pkg/std/README.md.
EXTRA_ALIASES = {
    "fs": [("Separator", "PathSeparator"), ("JoinPath", "PathJoin"), ("DirName", "PathParent"),
           ("BaseName", "PathFileName"), ("Extension", "PathExtension"),
           ("IsAbsolute", "PathIsAbsolute")],
}

# Internal by the headers' own conventions: 'h' helpers, C kernels and their prefixes. A
# trailing '_' is NOT one of them: vector.bi's factories (Vec2f_), TuiMin_ and TUIKEY_END_
# are public, the '_' only keeping them apart from a type or a keyword.
EXCLUDE_PATTERNS = [r"^h[A-Z]", r"Raw$", r"^c_", r"^fb_", r"^tui_", r"^__", r"^mny",
                    r"^FsSizeof", r"^TUI_REC_", r"^dt[A-Z]", r"^FB_LOG_", r"^fenv_"]
# ...and by what their comments say.
EXCLUDE_NAMES = {
    # the namespace string.bi calls "Internal"
    "Detail",
    # fs kernels and ABI mirrors not caught above
    "FsDirEntName", "FsFreeBuf",
    # sort.bi: "internal ... not the interface"
    "SortInsertionBy", "SortSiftDownBy", "SortHeapBy", "SortPartitionBy", "SortIntroBy",
    "SortMergeBy",
    # map/set slot states
    "MAP_EMPTY", "MAP_USED", "MAP_TOMB", "SET_EMPTY", "SET_USED", "SET_TOMB",
    # what a 'spawn' statement and a SELECT lower to, and the channel plumbing beneath them
    "SpawnWork", "SpawnTrampoline", "ChanWaiterCore", "ChanWaiter", "ChanCore", "ChanState",
    "ChanPushSend", "ChanPushRecv", "ChanUnlink", "ChanCommitRecvLocked", "ChanCommitSendLocked",
    "WgWaiter", "CtxState", "CtxTimerArg", "CTX_MAXCHILDREN",
    # numeric: bit-pattern unions, the Windows RNG import
    "DoubleBits", "SingleBits", "SystemFunction036",
    # money: the 192-bit intermediate, a locale snapshot, a libc shim
    "DecWide", "MoneySnapshot_", "llabs_",
    # logs: users write Logger, the alias. (Phase 4's FB.Log( ) needed excluding too -- LOG is
    # tiko's natural-log intrinsic -- until fbc-modern renamed it FB.DefaultLogger( ): inside
    # namespace FB it took log( x ) from fb/random.bi, complex.bi and fintvm.bi.)
    "Logger_",
    # tui: terminal state, signal handlers, generated width tables
    "TuiSavedMode", "TuiSaved", "TuiResizeFlag", "TuiEmergencyRestore", "TuiCtrlHandler",
    "TuiSignalHandler", "TuiWinchHandler", "TuiWidthTabWide", "TuiWidthTabZero",
    "TuiWidthTabAmb",
}

KINDS = {"type", "union", "enum", "typedef", "function", "sub", "const", "namespace", "var"}
SYM = re.compile(r"^\s*\[(\d+)\] (\S+) (\S+).*?@(\d+):(\d+):\d+\s+parent=(-?\d+)")
FILE = re.compile(r"^\s*\[(\d+)\] (\S+)$")
IDENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def keywords():
    """tiko's keywords, and which of them are word-shaped operators ('mod', 'shl')."""
    words, ops = set(), set()
    with open(os.path.join(ROOT, "src", "lexer", "keywords.bi"), encoding="utf-8") as f:
        for ln in f:
            m = re.search(r'KW\(\s*KW_\w+,\s*"([A-Z0-9_]+)",\s*(\w+)', ln)
            if m:
                words.add(m.group(1).lower())
                if m.group(2) == "KWCLASS_OPERATOR":
                    ops.add(m.group(1).lower())
    return words, ops


def scan(tiko, inc, includes, mt):
    with tempfile.TemporaryDirectory() as d:
        probe = os.path.join(d, "probe.bas")
        with open(probe, "w", encoding="utf-8") as f:
            for h in includes:
                f.write('#include once "%s"\n' % h)
        cmd = [tiko, "--dump-scan", "-i", inc] + (["-mt"] if mt else []) + [probe]
        out = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8",
                             errors="replace").stdout
    files, syms, section = {}, {}, None
    for ln in out.splitlines():
        if ln.startswith("files:"):
            section = "files"
            continue
        if ln.startswith("symbols:"):
            section = "symbols"
            continue
        if section == "files":
            m = FILE.match(ln)
            if m:
                files[int(m.group(1))] = m.group(2)
        elif section == "symbols":
            m = SYM.match(ln)
            if m:
                syms[int(m.group(1))] = dict(kind=m.group(2), name=m.group(3),
                                             file=files.get(int(m.group(4)), ""),
                                             parent=int(m.group(6)))
    if not syms:
        sys.exit("genfacades: '%s' produced no symbols for %s" % (" ".join(cmd), includes))
    return syms


def spelling(name, texts):
    """The name as the header spells it: the scan lower-cases what a macro declared."""
    e = re.escape(name)
    # A declaration first -- 'function Count', 'enum X', a member or const at a line's
    # start -- and only then any use, where a parameter may spell it 'count'. A name a
    # macro pasted together ('Mat4##S##Identity') is nowhere whole, and stays as scanned.
    pats = [re.compile(r"\b(?:function|sub|type|union|enum|const|namespace)\s+(" + e + r")\b",
                       re.IGNORECASE),
            re.compile(r"^\s*(" + e + r")\b", re.IGNORECASE),
            re.compile(r"\b(" + e + r")\b", re.IGNORECASE)]
    for pat in pats:
        for t in texts:
            for ln in t.splitlines():
                if ln.lstrip().startswith("#"):
                    continue
                code = re.sub(r'"[^"]*"', '""', ln.split("''", 1)[0])
                m = pat.search(code)
                if m:
                    return m.group(1)
    return name


def names_for(mod, tiko, inc, kw):
    includes, own, mt = FACADES[mod]
    syms = scan(tiko, inc, includes, mt)
    fbns = {i for i, s in syms.items() if s["kind"] == "namespace" and s["name"].upper() == "FB"
            and s["parent"] == -1}
    texts = []
    for h in own:
        for p in (os.path.join(inc, "fb", h), os.path.join(inc, h)):
            if os.path.isfile(p):
                with open(p, encoding="utf-8", errors="replace") as f:
                    texts.append(f.read())
                break

    def excluded(n):
        return n in EXCLUDE_NAMES or any(re.search(p, n) for p in EXCLUDE_PATTERNS)

    picked, enums = {}, set()
    for i, s in syms.items():
        if s["parent"] not in fbns or s["file"] not in own or s["kind"] not in KINDS:
            continue
        n = s["name"]
        if not IDENT.match(n) or excluded(n):
            continue
        # An overload of a word-shaped operator, 'operator mod': found with no qualifier
        # wherever its operands are (M26), and no name to export.
        if s["kind"] in ("function", "sub") and n.lower() in kw[1]:
            continue
        if s["kind"] == "enum":
            enums.add(i)
        picked.setdefault(n.lower(), n)
    for i, s in syms.items():
        if s["kind"] == "enumval" and s["parent"] in enums and not excluded(s["name"]):
            picked.setdefault(s["name"].lower(), s["name"])
    bad = sorted(n for n in picked if n in kw[0])
    if bad:
        sys.exit("genfacades: %s would export tiko keywords %s: 'alias.KEYWORD' never expands"
                 % (mod, bad))
    if mod in picked:
        sys.exit("genfacades: %s would export its own name (TKO0870)" % mod)
    spelled = [spelling(n, texts) for n in picked.values()]
    # A PASTED NAME, 'M4##Identity' with M4 = Mat4f: the longest name already spelled that
    # begins it, and the rest as written after a '##'.
    known = [s for s in spelled if s != s.lower()]
    for i, s in enumerate(spelled):
        if s != s.lower():
            continue
        heads = [k for k in known if s.startswith(k.lower()) and len(k) < len(s)]
        if not heads:
            continue
        head = max(heads, key=len)
        rest = s[len(head):]
        m = re.search(r"##(" + re.escape(rest) + r")\b", "\n".join(texts), re.IGNORECASE)
        if m:
            spelled[i] = head + m.group(1)
    return sorted(spelled, key=str.lower)


def render(mod, names):
    includes = FACADES[mod][0]
    heads = ", ".join(includes)
    out = []
    out.append("'' std/%s -- a FACADE over %s (RFC-0009). GENERATED by build/genfacades.py" % (mod, heads))
    out.append("'' from the toolchain's headers: do not edit by hand, re-run it when a header changes.")
    out.append("'' Every name is the header's FB.<name>, written %s.<name>. The header travels with" % mod)
    out.append("'' the interface (ADR 0017, required headers), so FB.<name> is the same thing.")
    if FACADES[mod][2]:
        out.append("'' The goroutine headers need the multithreaded runtime: build with -mt.")
    out.append('#module "%s"' % mod)
    if FACADES[mod][2]:
        # THE HEADERS' OWN GUARD NEVER FIRES (T75): they test 'defined( __FB_MT__ )', and
        # __FB_MT__ is always defined -- 0 or -1 -- so a build without -mt compiled and
        # then crashed or hung. Its value is what says.
        out.append("#if __FB_MT__ = 0")
        out.append('    #error "std/%s needs the multithreaded runtime: build with -mt"' % mod)
        out.append("#endif")
    for h in includes:
        out.append('#include once "%s"' % h)
    out.append("")
    extras = EXTRA_ALIASES.get(mod, [])
    for n in names:
        out.append("#define %s FB.%s" % (n, n))
    if extras:
        out.append("")
        out.append("'' std/path's names, folded into std/fs (RFC-0009 M30): the header's functions.")
        for a, target in extras:
            out.append("#define %s FB.%s" % (a, target))
    out.append("")
    allnames = names + [a for a, _ in extras]
    line = "#export"
    lines = []
    for n in allnames:
        piece = (" " if line == "#export" else ", ") + n
        if len(line) + len(piece) > 92 and line != "#export":
            lines.append(line)
            line = "#export " + n
        else:
            line += piece
    lines.append(line)
    out.extend(lines)
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser()
    exe = "tiko.exe" if os.name == "nt" else "tiko"
    ap.add_argument("--tiko", default=os.path.join(ROOT, "bin", exe))
    # THE TREE'S OWN HEADERS (phase H) when it has them; a packaged toolchain's otherwise.
    _treeinc = os.path.join(ROOT, "inc")
    ap.add_argument("--inc", default=_treeinc if os.path.isdir(_treeinc)
                    else os.path.join(ROOT, "toolchains", "tiko-windows", "inc"))
    ap.add_argument("--check", action="store_true")
    ap.add_argument("modules", nargs="*")
    a = ap.parse_args()
    kw = keywords()
    changed = []
    for mod in (a.modules or list(FACADES)):
        text = render(mod, names_for(mod, a.tiko, a.inc, kw))
        path = os.path.join(ROOT, "pkg", "std", mod, mod + ".bas")
        old = open(path, encoding="utf-8").read() if os.path.isfile(path) else None
        if old == text:
            continue
        changed.append(mod)
        if not a.check:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w", encoding="utf-8", newline="\n") as f:
                f.write(text)
        print("genfacades: %s %s (%d names)" % ("would change" if a.check else "wrote",
                                               path, text.count("#define ")))
    if a.check and changed:
        sys.exit(1)


if __name__ == "__main__":
    main()
