#!/usr/bin/env python3
"""prep_admonish.py -- turn mdbook-admonish fences into pandoc fenced divs.

    ```admonish danger title="Pitfall"        ::: {.admonish style="danger" title="Pitfall"}
    body                               -->    body
    ```                                       :::

mdBook reads the first form natively. pandoc cannot: an info string that is more than one word is
not a valid code-block class, so pandoc falls back to an INLINE code span and the whole admonition
comes out as raw text. The PDF build therefore rewrites the fences before pandoc sees them, and
tools/filters/admonish.lua turns the resulting divs into the template's callouts.

An admonition may contain fenced code, so the outer fence is longer (four or more backticks); the
closing fence is the first later line of at least that many backticks and nothing else. Anything
inside a DIFFERENT code fence is left alone, so an example that quotes an admonition survives.

    prep_admonish.py FILE > OUT
"""
import re
import sys

OPEN = re.compile(r'^(?P<ticks>`{3,})admonish(?:[ \t]+(?P<style>[A-Za-z]+))?(?:[ \t]+title="(?P<title>[^"]*)")?[ \t]*$')
FENCE = re.compile(r"^(?P<ticks>`{3,}|~{3,})")


def convert(text):
    lines = text.split("\n")
    out = []
    i = 0
    in_code = None  # the fence string of an ordinary code block we are inside
    while i < len(lines):
        line = lines[i]
        if in_code:
            out.append(line)
            m = FENCE.match(line)
            if m and m.group("ticks")[0] == in_code[0] and len(m.group("ticks")) >= len(in_code) and line.strip() == m.group("ticks"):
                in_code = None
            i += 1
            continue
        m = OPEN.match(line)
        if m:
            n = len(m.group("ticks"))
            j = i + 1
            while j < len(lines) and not re.fullmatch(r"`{%d,}[ \t]*" % n, lines[j]):
                j += 1
            if j >= len(lines):
                raise SystemExit("prep_admonish: unterminated admonish fence opened at line %d" % (i + 1))
            attrs = ['.admonish', 'style="%s"' % (m.group("style") or "note")]
            if m.group("title") is not None:
                attrs.append('title="%s"' % m.group("title"))
            if out and out[-1].strip():
                out.append("")  # a fenced div must be set off from the text before it
            out.append("::: {%s}" % " ".join(attrs))
            out.append("")
            out.extend(lines[i + 1:j])
            out.append("")
            out.append(":::")
            out.append("")
            i = j + 1
            continue
        m = FENCE.match(line)
        if m:
            in_code = m.group("ticks")
        out.append(line)
        i += 1
    return "\n".join(out)


if __name__ == "__main__":
    data = open(sys.argv[1], encoding="utf-8", newline="").read().replace("\r\n", "\n")
    sys.stdout.buffer.write(convert(data).encode("utf-8"))
