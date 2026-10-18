# Block strings

An ordinary string literal ends with its line. A query, a usage message or a
template is several lines of text, and gluing it together from one literal
per line buries the text under punctuation. A *block string* holds it the
way it reads.

```tiko
{{#include ../../examples/strings/blockstrings.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/blockstrings.out}}
```

**`"""` at the end of a line opens a block string, and the first line that
starts with `"""` closes it.** Only spaces may follow the opening quotes.
After the closing quotes the line carries on as ordinary code, which is how
the last example passes a block string straight to `ucase( ... )`.

**The closing line's indentation is the margin.** It is removed from every
line, so the text can be indented along with the code around it, while
indentation that belongs to the text, such as the extra spaces before `from`,
is kept.

**The line breaks next to the quotes are not part of the text.** `query` is 48
characters and ends with `"Ada"`, not with a line feed. To end the text with
one, leave an empty line before the closing `"""`, as `list` does. Every line
break inside is a single line feed, `chr( 10 )`, however the source file was
saved.

**Nothing inside needs escaping**: a `"` is an ordinary character. Write
`!"""` to read [escape sequences](escapes.md) inside the block, where a
backslash at the very end of a line also joins it to the next.

A line that starts to the left of the margin is an error, because there is
no way to remove a margin it does not have:

```tiko
{{#include ../../examples/strings/blockmargin.tiko}}
```

```text
blockmargin.tiko(4,1): error TKO0208: block string line does not start with the closing line's indentation
     |
   4 |   second
     | ^~~~~~~~~
```

Blank lines are always allowed, whatever their indentation.

```admonish danger title="Pitfall"
The closing line sets the margin, not the first line. Put the closing `"""`
at the left edge and nothing is removed: the spaces that only indented the
code become part of the text.
```

### Activities

1. Move the closing `"""` of `query` to the left edge and see where the
   spaces go.
2. Write a usage message for a command-line program as one block string and
   print it.
