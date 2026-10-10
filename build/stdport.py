#!/usr/bin/env python3
"""stdport.py -- turn one of pkg/std's header libraries into a real module (transitional).

Until 2026-10-10 each std module was a FACADE (build/genfacades.py): '#define Replace
FB.Replace' over a header in inc/fb. This script writes the module itself instead, one
file per header, from the header:

    inc/fb/string.bi            ->  pkg/std/strings/string.tiko

and is run ONCE per module, after which the module's files are the source and the header
is frozen until inc/fb is deleted. What it does to each header:

  - '#module "<m>"' first; '#pragma once' and the 'namespace FB' wrapper go (the module IS
    the namespace). A nested namespace ('Detail') stays.
  - VISIBILITY, from the facade it replaces: a name the facade exported is 'public'; any
    other 'private' procedure, and every 'private' member body, loses the keyword and is
    module-private -- an external symbol, which a generic's body compiled in an importer
    can still reach. A free operator is public: it is found by its operands, not a name.
  - '#include "fb/X.bi"' of a header of the SAME module goes: a module's files see each
    other. One of a module already converted becomes '#import "std/<dep>"' plus 'using
    <dep>'; one of a module not converted yet stays, with 'using FB' (transitional).
  - Leading tabs become four spaces (lint rule 5).

Anything it cannot map is reported, not guessed: 'dim shared', 'common shared', 'extern'
globals and '#define's an importer used are the module's hand edits.

    python build/stdport.py strings [--converted tui,money,...] [--check]
"""
import argparse
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INC = os.path.join(ROOT, "inc")

# module -> its headers, in include order (dependencies first). An umbrella header that
# only includes the others becomes the module's '<m>.tiko', its comment and nothing else.
MODULES = {
    "strings": ["string.bi"],
    "tui": ["tuiwidthtab.bi", "tuiwidth.bi", "tuicore.bi", "tuiterm.bi", "tuibuffer.bi",
            "tuiinput.bi", "tuilayout.bi", "tuiwidget.bi", "tuiwidgets.bi", "tuidraw.bi",
            "tuiform.bi", "tuichrome.bi", "tuiapp.bi", "tui.bi"],
    "money": ["currency.bi", "decimal.bi", "moneyformat.bi", "finerror.bi", "fincore.bi",
              "finsolve.bi", "fintvm.bi", "fincash.bi", "findeprec.bi", "finloan.bi",
              "finport.bi", "finance.bi"],
    "logs": ["logrecord.bi", "logrender.bi", "logerror.bi", "logsink.bi", "logger.bi",
             "logdefault.bi", "logfile.bi", "logasync.bi", "logging.bi", "logmacros.bi"],
    "fs": ["fserror.bi", "fspath.bi", "fsinfo.bi", "fsdir.bi", "fsops.bi", "fsglob.bi",
           "fslink.bi", "fsvolume.bi", "fsadvanced.bi", "filesystem.bi"],
    "numeric": ["math.bi", "mathint.bi", "mathtext.bi", "complex.bi", "random.bi",
                "stats.bi", "fenv.bi", "vector.bi"],
    "tasks": ["scheduler.bi", "channel.bi", "sync.bi", "select.bi"],
    "memory": ["sharedptr.bi"],
    "chrono": ["chrono.bi"],
    "outcome": ["optional.bi", "result.bi"],
    "containers": ["hash.bi", "array.bi", "linkedlist.bi", "map.bi", "set.bi",
                   "orderedmap.bi", "orderedset.bi", "sort.bi", "../containers.bi"],
}
UMBRELLAS = {"tui.bi", "finance.bi", "logging.bi", "filesystem.bi", "../containers.bi"}
# The names a module exports beyond its facade's list.
EXTRA_PUBLIC = {
    "memory": {"sharedptr", "weakptr", "makeshared"},
}

HDR_MODULE = {}
for _m, _hs in MODULES.items():
    for _h in _hs:
        HDR_MODULE[os.path.basename(_h)] = _m

PROC = r"(?:function|sub|operator|property|constructor|destructor)"
RX_MEMBER = re.compile(r"^(\s*)private\s+((?:(?:static|const|virtual|abstract)\s+)*)(" + PROC + r")(\s+)([\w]+\s*(?:\(\s*of\b[^)]*\))?\s*\.)", re.I)
RX_CTOR = re.compile(r"^(\s*)private\s+((?:(?:virtual|abstract)\s+)*(?:constructor|destructor)\s+\w+\s*(?:\(\s*of\b[^)]*\))?\s*[(:]?)", re.I)
RX_FREEPROC = re.compile(r"^(\s*)private\s+(function|sub)(\s+)(\w+)", re.I)
RX_FREEOP = re.compile(r"^(\s*)private\s+operator\b", re.I)
RX_DECL = re.compile(r"^(\s*)declare\s+(function|sub)\s+(\w+)", re.I)
RX_DECLOP = re.compile(r"^(\s*)declare\s+operator\b", re.I)
RX_TYPE = re.compile(r"^(\s*)(type|union|enum)\s+(\w+)", re.I)
RX_CONST = re.compile(r"^(\s*)const\s+(?:as\s+\w+(?:\s+ptr)*\s+)?(\w+)", re.I)
RX_OPENPROC = re.compile(r"^\s*(?:(?:private|public)\s+)?(?:static\s+)?" + PROC + r"\b(?!\s*[(\[])", re.I)
RX_ENDPROC = re.compile(r"^\s*end\s+" + PROC + r"\b", re.I)
RX_OPENTYPE = re.compile(r"^\s*(?:(?:private|public)\s+)?(?:type|union)\b(?!\s+\w+\s+as\b)(?!\s*\()", re.I)
RX_ENDTYPE = re.compile(r"^\s*end\s+(?:type|union)\b", re.I)
RX_NS = re.compile(r"^\s*namespace\s+(\w+)\s*(?:''.*)?$", re.I)
RX_ENDNS = re.compile(r"^\s*end\s+namespace\b", re.I)
RX_INC = re.compile(r'^\s*#include(\s+once)?\s+"([^"]+)"', re.I)
RX_FBNS_INC = {"fberror.bi", "fbpark.bi", "fbclaim.bi", "fblimits.bi", "fbatomic.bi"}


def api_names(mod):
    """The facade's exported names, lower-cased."""
    # Frozen in tests/std/api when the facades went: '<name> <header name>' per line.
    p = os.path.join(ROOT, "tests", "std", "api", mod + ".txt")
    names = set(EXTRA_PUBLIC.get(mod, set()))
    if os.path.isfile(p):
        for ln in io.open(p, encoding="utf-8"):
            f = ln.split()
            if len(f) == 2 and f[0] == f[1]:
                names.add(f[0].lower())
    return names


def code_of(ln):
    """The line without its comment, near enough: '' and ' start a comment outside a string."""
    out, q = [], False
    i = 0
    while i < len(ln):
        c = ln[i]
        if c == '"':
            q = not q
        elif not q and c == "'":
            break
        out.append(c)
        i += 1
    return "".join(out)


def header_lines(hdr):
    path = os.path.normpath(os.path.join(INC, "fb", hdr))
    src = io.open(path, encoding="utf-8", newline="").read().replace("\r\n", "\n")
    lines = src.split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    return lines


def carried_includes(mod, hdr, seen):
    """WHAT A SAME-MODULE HEADER BROUGHT WITH IT. A module's files do not share includes --
    each is preprocessed alone -- so the file that included 'fb/tuiterm.bi' and got
    windows.bi through it must include windows.bi itself. Its include lines, and each
    top-level '#if' block that holds nothing but includes, verbatim; a same-module header
    inside is followed in turn. Each header once."""
    if hdr in seen:
        return []
    seen.add(hdr)
    out = []
    lines = header_lines(hdr)
    i = 0
    depth = 0
    while i < len(lines):
        code = code_of(lines[i]).strip()
        lo = code.lower()
        if depth == 0 and re.match(r"#if(n?def)?\b", lo):
            # A block of includes only?
            j, d, ok = i + 1, 1, True
            while j < len(lines) and d > 0:
                c = code_of(lines[j]).strip().lower()
                if re.match(r"#if(n?def)?\b", c):
                    d += 1
                elif c.startswith("#endif"):
                    d -= 1
                elif c and not (c.startswith("#include") or c.startswith("#else")
                                or c.startswith("#elseif")):
                    ok = False
                j += 1
            if ok:
                out.extend(ln.replace("\t", "    ") for ln in lines[i:j])
            i = j
            continue
        if re.match(r"#if(n?def)?\b", lo):
            depth += 1
        elif lo.startswith("#endif"):
            depth -= 1
        elif depth == 0:
            mi = RX_INC.match(code)
            if mi:
                inc = mi.group(2)
                base = os.path.basename(inc)
                dep = HDR_MODULE.get(base) if (inc.startswith("fb/") or inc == "containers.bi") else None
                if dep == mod:
                    out.extend(carried_includes(mod, base, seen))
                else:
                    out.append(code)
        i += 1
    return out


def port(mod, hdr, api, converted, notes):
    lines = header_lines(hdr)
    out = ['#module "%s"' % mod]
    imports, nsstack = [], []
    inproc = intype = 0
    inmacro = False
    cont = False             # this physical line continues the previous one
    usingfb = False
    need_fb = False
    placed_using = False
    carried = set([os.path.basename(hdr)])
    dedent = False
    lines = list(lines)
    k = 0
    while k < len(lines):
        raw = lines[k]
        k += 1
        ln = raw
        # Leading tabs -> spaces.
        m = re.match(r"^(\t+)", ln)
        if m:
            ln = "    " * len(m.group(1)) + ln[len(m.group(1)):]
        # One level less inside what was 'namespace FB' -- when the header indented it.
        if dedent and nsstack[:1] == ["FB"] and ln.startswith("    "):
            ln = ln[4:]
        code = code_of(ln)
        stmt = not cont
        cont = code.rstrip().endswith(" _") or code.rstrip() == "_"
        t = code.strip()
        lo = t.lower()
        if not stmt:
            out.append(ln)
            continue
        if lo.startswith("#macro"):
            inmacro = True
        elif lo.startswith("#endmacro"):
            inmacro = False
        if lo == "#pragma once":
            continue
        mi = RX_INC.match(code)
        if mi:
            inc = mi.group(2)
            base = os.path.basename(inc)
            dep = HDR_MODULE.get(base) if (inc.startswith("fb/") or inc == "containers.bi") else None
            if dep == mod:
                # Its own includes come instead, processed as if written here.
                if hdr not in UMBRELLAS:
                    lines[k:k] = carried_includes(mod, base, carried)
                continue
            if dep and dep in converted:
                if dep not in imports:
                    imports.append(dep)
                continue
            if dep or base in RX_FBNS_INC:
                need_fb = True
            out.append(ln)
            continue
        mn = RX_NS.match(code)
        if mn and not inproc and not intype:
            if mn.group(1).upper() == "FB" and not nsstack:
                nsstack.append("FB")
                # Did the header indent what it put inside the namespace?
                for nxt in lines[k:]:
                    c = code_of(nxt)
                    if c.strip() and not c.strip().startswith("#"):
                        dedent = c[:1] in (" ", "	")
                        break
                if need_fb and not placed_using:
                    out.append("using FB")
                    placed_using = True
                continue
            nsstack.append(mn.group(1))
            out.append(ln)
            continue
        if RX_ENDNS.match(code) and nsstack and not inproc and not intype:
            if nsstack.pop() == "FB":
                continue
            out.append(ln)
            continue
        top = (not inproc) and (not intype) and nsstack[:1] == ["FB"] and len(nsstack) == 1
        intop = (not inproc) and (not intype)
        # -- visibility
        if intop:
            m = RX_MEMBER.match(ln)
            if m:
                ln = RX_MEMBER.sub(lambda g: g.group(1) + (g.group(2) or "")
                                   + g.group(3) + g.group(4) + g.group(5), ln, count=1)
            elif RX_CTOR.match(ln):
                # A type's constructor or destructor body: a member, as a dotted name is.
                ln = RX_CTOR.sub(lambda g: g.group(1) + g.group(2), ln, count=1)
            else:
                m = RX_FREEPROC.match(ln)
                if m:
                    pub = (m.group(4).lower() in api or inmacro) and top
                    ln = RX_FREEPROC.sub(lambda g: g.group(1) + ("public " if pub else "")
                                         + g.group(2) + g.group(3) + g.group(4), ln, count=1)
                elif RX_FREEOP.match(ln):
                    ln = RX_FREEOP.sub(lambda g: g.group(1) + "public operator", ln, count=1)
                elif top and RX_DECLOP.match(ln):
                    ln = RX_DECLOP.sub(lambda g: g.group(1) + "public declare operator", ln, count=1)
                elif top:
                    m = RX_DECL.match(ln) or RX_TYPE.match(ln) or RX_CONST.match(ln)
                    if m:
                        name = m.group(m.lastindex).lower()
                        if (name in api or inmacro) and not re.match(r"\s*public\b", ln, re.I):
                            ln = re.sub(r"^(\s*)", r"\1public ", ln, count=1)
                # A header's per-includer global is the module's one: 'private dim shared'.
                ln = re.sub(r"^(\s*)private\s+(dim\s+shared\b)", r"\1\2", ln, count=1, flags=re.I)
                if re.match(r"^\s*common\b|^\s*extern\s+(?!\")", ln, re.I):
                    notes.append("%s: global, by hand: %s" % (hdr, ln.strip()[:90]))
                if re.match(r"^\s*private\s", ln, re.I) and not RX_MEMBER.match(ln):
                    notes.append("%s: 'private' left: %s" % (hdr, ln.strip()[:90]))
        # -- block tracking
        if not inmacro or True:
            if RX_ENDPROC.match(code):
                inproc = max(0, inproc - 1)
            elif RX_ENDTYPE.match(code):
                intype = max(0, intype - 1)
            elif not inproc and RX_OPENPROC.match(code) and not re.match(r"^\s*declare\b", code, re.I) \
                    and not re.search(r"\bend\s+" + PROC + r"\b", code, re.I) and not intype:
                inproc += 1
            elif not inproc and RX_OPENTYPE.match(code):
                intype += 1
        out.append(ln)
    if nsstack:
        notes.append("%s: namespaces left open: %s" % (hdr, nsstack))
    if need_fb and not placed_using:
        notes.append("%s: needs 'using FB' but has no 'namespace FB' to put it at" % hdr)
    # Imports go straight after '#module'.
    hdrlines = []
    for d in imports:
        hdrlines.append('#import "std/%s"' % d)
    for d in imports:
        hdrlines.append("using %s" % d)
    return "\n".join([out[0]] + hdrlines + out[1:]) + "\n"


def fix_comments(text, mod):
    """The header's own words, said of the module: its title line, and a usage example's
    '#include once "fb/x.bi"' (and the 'using FB' after it) as '#import "std/<m>"'. Safe
    to run again, and on files edited by hand since."""
    out = []
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        ln = lines[i]
        m = re.match(r"^'' (?:fb/)?(\w+)\.bi -- (.*)$", ln)
        if m and i <= 2:
            ln = "'' std/%s: %s -- %s" % (mod, m.group(1), m.group(2))
        m = re.match(r"^(''\s+)#include once \"(fb/\w+\.bi|containers\.bi)\"\s*$", ln)
        if m and HDR_MODULE.get(os.path.basename(m.group(2))) == mod:
            ln = m.group(1) + '#import "std/%s"' % mod
            if i + 1 < len(lines) and re.match(r"^''\s+using FB\s*$", lines[i + 1]):
                lines[i + 1] = m.group(1) + "using " + mod
        out.append(ln)
        i += 1
    return "\n".join(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("module")
    ap.add_argument("--converted", default="", help="modules already real, comma separated")
    ap.add_argument("--out", default=os.path.join(ROOT, "pkg", "std"))
    ap.add_argument("--check", action="store_true", help="print notes, write nothing")
    ap.add_argument("--comments", action="store_true",
                    help="only normalise the comments of the module's existing files, in place")
    a = ap.parse_args()
    mod = a.module
    if a.comments:
        d = os.path.join(a.out, mod)
        for f in sorted(os.listdir(d)):
            if f.endswith(".tiko"):
                p = os.path.join(d, f)
                t = io.open(p, encoding="utf-8", newline="").read()
                n = fix_comments(t, mod)
                if n != t:
                    io.open(p, "w", encoding="utf-8", newline="").write(n)
                    print("stdport: comments in " + f)
        return
    converted = set(x for x in a.converted.split(",") if x)
    api = api_names(mod)
    notes = []
    outs = {}
    for h in MODULES[mod]:
        base = os.path.basename(h)
        name = mod if base in UMBRELLAS else os.path.splitext(base)[0]
        outs[name + ".tiko"] = fix_comments(port(mod, h, api, converted, notes), mod)
    for n in notes:
        print("stdport: " + n)
    if a.check:
        return
    d = os.path.join(a.out, mod)
    os.makedirs(d, exist_ok=True)
    for name, text in outs.items():
        with io.open(os.path.join(d, name), "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
    print("stdport: wrote %d files to %s" % (len(outs), d))


if __name__ == "__main__":
    main()
