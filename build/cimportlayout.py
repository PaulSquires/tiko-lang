"""cimportlayout.py -- a clang-compiled program's layout of every imported record.

    python build/cimportlayout.py gen  <manifest> <header> <out.c>
    python build/cimportlayout.py want <manifest> <out.txt>

'gen' writes a C program that includes the header and prints, for every record the
manifest names with a C spelling, its sizeof and _Alignof and the bit offset of each
ordinary member through offsetof. 'want' writes what the manifest says the program must
print. build/cimportlayout.sh compiles the one, runs it, and compares it with the other.

Bit-fields have no offsetof and are left to the manifest's own check; a record C cannot
spell (a synthetic 'Parent_field_t') is left out. The manifest's lines are

    record <fb-name> <size> <align> <C spelling...>
      field <fb-name> <bit> <width> <C name>
"""
import sys


def records(path):
    recs = []
    for ln in open(path, encoding="utf-8", errors="replace").read().split("\n"):
        w = ln.split()
        if not w:
            continue
        if w[0] == "record" and len(w) >= 5:
            recs.append([w[1], w[2], w[3], " ".join(w[4:]), []])
        elif w[0] == "field" and len(w) >= 5 and recs:
            recs[-1][4].append((w[1], w[2], w[3], w[4]))
    return [r for r in recs if r[3] != "-"]


def gen(man, header, out):
    o = ['#include <stdio.h>', '#include <stddef.h>', '#include "%s"' % header]
    recs = records(man)
    # A MEMBER NAME THAT IS ALSO A MACRO -- MinGW's objidl.h: IUriBuilderVtbl's SetPort
    # beside '#define SetPort SetPortA' -- would be rewritten inside offsetof. Past the
    # include this program only asks about layout, so every member name is undefined.
    keep = {"printf", "offsetof", "main", "size_t"}
    names = sorted({cn for r in recs for (fn, bit, width, cn) in r[4]
                    if cn != "-" and cn not in keep})
    for n in names:
        o.append("#undef %s" % n)
    o.append('int main(void) {')
    for fb, size, align, cty, fields in recs:
        o.append('    printf("record %%s %%zu %%zu\\n", "%s", sizeof(%s), _Alignof(%s));'
                 % (fb, cty, cty))
        for fn, bit, width, cn in fields:
            if width != "0" or cn == "-":
                continue
            o.append('    printf("  field %%s %%zu\\n", "%s", offsetof(%s, %s) * 8);'
                     % (fn, cty, cn))
    o.append('    return 0;')
    o.append('}')
    open(out, "w", newline="\n").write("\n".join(o) + "\n")


def want(man, out):
    o = []
    for fb, size, align, cty, fields in records(man):
        o.append("record %s %s %s" % (fb, size, align))
        for fn, bit, width, cn in fields:
            if width == "0" and cn != "-":
                o.append("  field %s %s" % (fn, bit))
    open(out, "w", newline="\n").write("\n".join(o) + "\n")


if __name__ == "__main__":
    if sys.argv[1] == "gen":
        gen(sys.argv[2], sys.argv[3], sys.argv[4])
    else:
        want(sys.argv[2], sys.argv[3])
