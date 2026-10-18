# Escape sequences

In an ordinary string literal a backslash is an ordinary character, which is
what you want for Windows paths and regular expressions. When you need a tab,
a line feed or a character you cannot type, put `!` in front of the literal
and it reads *escape sequences*.

```tiko
{{#include ../../examples/strings/escapes.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/escapes.out}}
```

Without a prefix, the only special thing inside quotes is the quote itself:
write it twice, `""`, for one `"` in the text.

With `!`, a backslash starts an escape:

| Escape | Character |
|---|---|
| `\t` | tab |
| `\n` | line feed |
| `\r` | carriage return |
| `\\` | a backslash |
| `\"` | a quote |
| `\xHH`, `\&hHH` | the character with that hexadecimal code |
| `\NNN` | the character with that decimal code |
| `\uXXXX` | the Unicode code point U+XXXX |
| `\UXXXXXXXX` | any code point, including those above U+FFFF |

A `$` prefix marks a literal that never reads escapes. It says the same as no
prefix at all, but states it, which is useful in code that also uses `!`
literals nearby.

`\u` and `\U` give you any Unicode character while the source itself stays
plain ASCII. A code point above U+FFFF, such as U+1F600, becomes two UTF-16
code units in a `ustring`, which [Unicode](unicode.md) explains.

The same escapes work in a [block string](block.md) opened with `!"""`.

### Activities

1. Print a three-column table using `\t` between the columns.
2. Spell the word "naive" with an i-diaeresis, written `\u00EF`, print it and
   its `len`.
