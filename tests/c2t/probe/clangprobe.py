#!/usr/bin/env python3
"""c2t P0 probes 1-3: libclang facts the c2t design relies on (docs/tiko-c2t RFC-0001 §10).

usage: python clangprobe.py <libclang path> <probe dir>

Runs header-free fixtures (comments.h, skip.h, extents.h) through libclang via ctypes and prints
what it reports. Output is deterministic; results-clang<N>.txt holds one run per clang version.
"""
import ctypes as C
import os
import sys


class CXString(C.Structure):
    _fields_ = [("data", C.c_void_p), ("flags", C.c_uint)]


class CXCursor(C.Structure):
    _fields_ = [("kind", C.c_int), ("xdata", C.c_int), ("data", C.c_void_p * 3)]


class CXSourceLocation(C.Structure):
    _fields_ = [("ptr", C.c_void_p * 2), ("i", C.c_uint)]


class CXSourceRange(C.Structure):
    _fields_ = [("ptr", C.c_void_p * 2), ("b", C.c_uint), ("e", C.c_uint)]


class CXToken(C.Structure):
    _fields_ = [("i", C.c_uint * 4), ("p", C.c_void_p)]


class CXSourceRangeList(C.Structure):
    _fields_ = [("count", C.c_uint), ("ranges", C.POINTER(CXSourceRange))]


DETAILED = 0x01
PREAMBLE = 0x04
SKIPBODIES = 0x40
TOKEN_KINDS = {0: "Punct", 1: "Keyword", 2: "Ident", 3: "Literal", 4: "Comment"}
VISITOR = C.CFUNCTYPE(C.c_int, CXCursor, CXCursor, C.c_void_p)


def bind(lib):
    def f(name, res, *args):
        fn = getattr(lib, name)
        fn.restype = res
        fn.argtypes = list(args)
        return fn
    P = C.c_void_p
    U = C.c_uint
    return {
        "version": f("clang_getClangVersion", CXString),
        "cstr": f("clang_getCString", C.c_char_p, CXString),
        "dispose": f("clang_disposeString", None, CXString),
        "index": f("clang_createIndex", P, C.c_int, C.c_int),
        "parse": f("clang_parseTranslationUnit", P, P, C.c_char_p, C.POINTER(C.c_char_p), C.c_int, P, U, U),
        "reparse": f("clang_reparseTranslationUnit", C.c_int, P, U, P, U),
        "reparseopts": f("clang_defaultReparseOptions", U, P),
        "disposetu": f("clang_disposeTranslationUnit", None, P),
        "ndiag": f("clang_getNumDiagnostics", U, P),
        "diag": f("clang_getDiagnostic", P, P, U),
        "fmtdiag": f("clang_formatDiagnostic", CXString, P, U),
        "tucursor": f("clang_getTranslationUnitCursor", CXCursor, P),
        "visit": f("clang_visitChildren", U, CXCursor, VISITOR, P),
        "kind": f("clang_getCursorKind", C.c_int, CXCursor),
        "kindname": f("clang_getCursorKindSpelling", CXString, C.c_int),
        "spelling": f("clang_getCursorSpelling", CXString, CXCursor),
        "extent": f("clang_getCursorExtent", CXSourceRange, CXCursor),
        "loc": f("clang_getCursorLocation", CXSourceLocation, CXCursor),
        "rstart": f("clang_getRangeStart", CXSourceLocation, CXSourceRange),
        "rend": f("clang_getRangeEnd", CXSourceLocation, CXSourceRange),
        "expansion": f("clang_getExpansionLocation", None, CXSourceLocation, C.POINTER(P),
                       C.POINTER(U), C.POINTER(U), C.POINTER(U)),
        "spellingloc": f("clang_getSpellingLocation", None, CXSourceLocation, C.POINTER(P),
                         C.POINTER(U), C.POINTER(U), C.POINTER(U)),
        "mainfile": f("clang_Location_isFromMainFile", C.c_int, CXSourceLocation),
        "getfile": f("clang_getFile", P, P, C.c_char_p),
        "skipped": f("clang_getSkippedRanges", C.POINTER(CXSourceRangeList), P, P),
        "allskipped": f("clang_getAllSkippedRanges", C.POINTER(CXSourceRangeList), P),
        "disposeranges": f("clang_disposeSourceRangeList", None, C.POINTER(CXSourceRangeList)),
        "guarded": f("clang_isFileMultipleIncludeGuarded", U, P, P),
        "tokenize": f("clang_tokenize", None, P, CXSourceRange, C.POINTER(C.POINTER(CXToken)), C.POINTER(U)),
        "tokkind": f("clang_getTokenKind", C.c_int, CXToken),
        "tokspell": f("clang_getTokenSpelling", CXString, P, CXToken),
        "disposetok": f("clang_disposeTokens", None, P, C.POINTER(CXToken), U),
        "filerange": f("clang_getRange", CXSourceRange, CXSourceLocation, CXSourceLocation),
        "locforoffset": f("clang_getLocationForOffset", CXSourceLocation, P, P, U),
        "fileeq": f("clang_File_isEqual", C.c_int, P, P),
    }


class Probe:
    def __init__(self, libpath, probedir):
        self.lib = C.CDLL(libpath)
        self.x = bind(self.lib)
        self.dir = probedir
        self.idx = self.x["index"](0, 0)

    def s(self, cxs):
        v = self.x["cstr"](cxs)
        self.x["dispose"](cxs)
        return v.decode("utf-8", "replace") if v else ""

    def parse(self, name, triple, options):
        path = os.path.join(self.dir, name)
        args = [b"-x", b"c", b"-std=c11", ("--target=" + triple).encode()]
        argv = (C.c_char_p * len(args))(*args)
        tu = self.x["parse"](self.idx, path.encode(), argv, len(args), None, 0, options)
        if not tu:
            raise SystemExit("parse failed: " + name)
        diags = [self.s(self.x["fmtdiag"](self.x["diag"](tu, i), 0)) for i in range(self.x["ndiag"](tu))]
        with open(path, "rb") as fh:
            text = fh.read()
        return tu, path, text, diags

    def where(self, loc, spelling=False):
        fl, ln, col, off = C.c_void_p(), C.c_uint(), C.c_uint(), C.c_uint()
        fn = self.x["spellingloc"] if spelling else self.x["expansion"]
        fn(loc, C.byref(fl), C.byref(ln), C.byref(col), C.byref(off))
        return ln.value, col.value, off.value

    # ---- probe 1 ------------------------------------------------------------------------------
    def comments(self, triple):
        tu, path, text, diags = self.parse("comments.h", triple, DETAILED)
        f = self.x["getfile"](tu, path.encode())
        a = self.x["locforoffset"](tu, f, 0)
        b = self.x["locforoffset"](tu, f, len(text))
        toks = C.POINTER(CXToken)()
        n = C.c_uint()
        self.x["tokenize"](tu, self.x["filerange"](a, b), C.byref(toks), C.byref(n))
        kinds = {}
        comments = []
        for i in range(n.value):
            k = TOKEN_KINDS.get(self.x["tokkind"](toks[i]), "?")
            kinds[k] = kinds.get(k, 0) + 1
            if k == "Comment":
                comments.append(self.s(self.x["tokspell"](tu, toks[i])))
        self.x["disposetok"](tu, toks, n.value)
        self.x["disposetu"](tu)
        print("== probe 1: clang_tokenize over comments.h [%s]" % triple)
        print("diagnostics: %d" % len(diags))
        print("token kinds: " + ", ".join("%s=%d" % kv for kv in sorted(kinds.items())))
        for c in comments:
            print("  comment token: " + c)

    # ---- probe 2 ------------------------------------------------------------------------------
    def skipped(self, triple, options, label):
        tu, path, text, diags = self.parse("skip.h", triple, options)
        if options & PREAMBLE:
            self.x["reparse"](tu, 0, None, self.x["reparseopts"](tu))
        f = self.x["getfile"](tu, path.encode())
        lst = self.x["skipped"](tu, f)
        lines = text.split(b"\n")
        print("== probe 2: skipped ranges in skip.h [%s, %s]" % (triple, label))
        print("diagnostics: %d" % len(diags))
        for i in range(lst.contents.count):
            r = lst.contents.ranges[i]
            sl, sc, so = self.where(self.x["rstart"](r))
            el, ec, eo = self.where(self.x["rend"](r))
            print("  %d:%d (ofs %d) .. %d:%d (ofs %d)   first=%r last=%r" % (
                sl, sc, so, el, ec, eo, lines[sl - 1].decode(), lines[el - 1].decode()))
        self.x["disposeranges"](lst)
        self.x["disposetu"](tu)

    # ---- probe 3 ------------------------------------------------------------------------------
    def extents(self, triple):
        tu, path, text, diags = self.parse("extents.h", triple, DETAILED | SKIPBODIES)
        print("== probe 3: top-level cursor extents in extents.h [%s]" % triple)
        print("diagnostics: %d" % len(diags))
        for d in diags:
            print("  diag: " + d.replace(self.dir, "<probe>"))
        f = self.x["getfile"](tu, path.encode())
        print("include-guarded (clang_isFileMultipleIncludeGuarded): %d" % self.x["guarded"](tu, f))
        rows = []

        def visitor(c, parent, data):
            loc = self.x["loc"](c)
            via = ""
            if not self.x["mainfile"](loc):
                # isFromMainFile said no: is the cursor's EXPANSION location in the main file?
                # (a declaration produced by a macro invocation written in this file)
                ef = C.c_void_p()
                self.x["expansion"](loc, C.byref(ef), None, None, None)
                if not (ef.value and self.x["fileeq"](ef, f)):
                    return 1
                via = "[expansion only] "
            ext = self.x["extent"](c)
            sl, sc, so = self.where(self.x["rstart"](ext))
            el, ec, eo = self.where(self.x["rend"](ext))
            ssl, ssc, sso = self.where(self.x["rstart"](ext), spelling=True)
            k = self.x["kind"](c)
            rows.append((so, eo, via + self.s(self.x["kindname"](k)), self.s(self.x["spelling"](c)),
                         sl, sc, el, ec, ssl, ssc))
            return 1

        cb = VISITOR(visitor)
        self.x["visit"](self.x["tucursor"](tu), cb, None)
        for so, eo, kname, spell, sl, sc, el, ec, ssl, ssc in rows:
            slice_ = text[so:eo].decode("utf-8", "replace").replace("\n", "\\n")
            tail = text[eo:eo + 3].decode("utf-8", "replace").replace("\n", "\\n")
            print("  %-22s %-14s exp %d:%d..%d:%d  spellstart %d:%d  text=%r  next=%r" % (
                kname, spell or "-", sl, sc, el, ec, ssl, ssc, slice_, tail))
        self.x["disposetu"](tu)


def main():
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    p = Probe(sys.argv[1], os.path.abspath(sys.argv[2]))
    print("libclang: " + p.s(p.x["version"]()))
    msvc, gnu = "x86_64-pc-windows-msvc", "x86_64-pc-linux-gnu"
    p.comments(msvc)
    for t in (msvc, gnu):
        p.skipped(t, DETAILED, "DetailedPreprocessingRecord")
    p.skipped(gnu, 0, "no options")
    p.skipped(gnu, DETAILED | PREAMBLE, "Detailed + PrecompiledPreamble, after one reparse")
    p.extents(msvc)
    p.extents(gnu)


if __name__ == "__main__":
    main()
