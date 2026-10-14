# Strings and Text

Text is where a program meets people, and it is where most of the assumptions a programmer carries
turn out to be wrong. A string is not a sequence of characters. A character is not a byte. The
length of a word depends on what you are counting.

This chapter is long because that is the honest size of the subject, and because getting it wrong
is silent: text that looks right on your machine arrives as nonsense on someone else's.

The short version, which the rest of the chapter earns: **use `ustring`, and keep bytes and text
apart in your head.**

## Five ways to hold text

```tiko
{{#include ../examples/ch08/types.tiko}}
```

```text
{{#include ../examples/ch08/types.out}}
```

| Type | Holds | Sized |
|---|---|---|
| `ustring` | UTF-16 code units | grows |
| `string` | bytes | grows |
| `zstring * n` | bytes, NUL-terminated | fixed room |
| `wstring * n` | wide characters | fixed room |
| `string * n` | bytes, **padded** to `n` | fixed length |

**`ustring` is the one to reach for.** It is the type this book uses everywhere, it holds text
rather than bytes, and `len` on it is a single read rather than a walk.

`string` is the byte type. It is right for file contents, network payloads and anything you do not
intend to interpret — and wrong for anything a person will read, unless you also know its encoding.

`zstring` and `wstring` exist for talking to C, which Chapter 28 covers. They are the shapes a C
library expects: a pointer to bytes ending in a NUL, or the platform's wide character.

```admonish danger title="Pitfall"
**A `string * n` is always exactly `n` characters.** Assigning `"hello"` to a `string * 8` gives
you `"hello   "` — padded with spaces — and `len` reports 8, not 5.

That is the point of the type, and it is a trap when one arrives from a record layout or a
fixed-width file and gets compared against text that was not padded. `"hello   " = "hello"` is
false. Wrap it in `rtrim( )` at the boundary, once, rather than at every comparison.
```

```admonish info title="On Windows and Linux"
A `wstring` character is **2 bytes on Windows and 4 bytes on Linux**, because it follows the
platform's `wchar_t`. `len` counts characters on both, so code that uses `len` is portable and code
that assumes a byte width is not.

`ustring` is UTF-16 on every target, which is one reason to prefer it: its storage does not change
underneath you when the target does.
```

## Text that spans lines

A line ends a statement in tiko, so an ordinary string literal ends where its line does. A query,
a usage message or a block of JSON is several lines of text, and writing it as one literal per
line, glued with `&` and `chr( 10 )`, buries the text under the punctuation. A **block string**
holds it the way it reads:

```tiko
{{#include ../examples/ch08/blockstrings.tiko:all}}
```

```text
{{#include ../examples/ch08/blockstrings.out}}
```

**`"""` at the end of a line opens one, and the first line that starts with `"""` closes it.**
Only spaces may follow the opening `"""`. Anything after the closing one is ordinary code, so a
block string can sit inside an expression or an argument list like any other literal.

**The closing line's indentation is the margin.** It is removed from the front of every line, so
the text indents with the code around it, while indentation that belongs to the text — the two
extra spaces before `from` — is kept. A blank line is always allowed. Any other line that starts
left of the margin is an error:

```tiko
{{#include ../examples/ch08/blockmargin.tiko}}
```

```
blockmargin.tiko(4,1): error TKO0208: block string line does not start with the closing line's indentation
     |
   4 |   second
     | ^~~~~~~~~
```

**The line breaks at the two ends are not part of the text.** `query` is 48 characters and does
not end in a line feed. To end with one, leave an empty line before the closing line, as `poem`
does — which is why `print poem;` still put `---` on a line of its own.

**Inside the block, nothing needs escaping.** A `"` is an ordinary character, so `"Ada"` is
written as it reads. Every line break is a single line feed, `chr( 10 )`, whatever line endings
the file was saved with, so the same source gives the same string on every machine.

**`!"""` reads escapes**, exactly as `!"…"` does: `\t` became the tab `instr` found at position 5.
A backslash at the very end of a line joins it to the next with no line break, for a long line
you want to wrap in the source.

```admonish danger title="Pitfall"
**The closing line sets the margin, not the first line.** `shifted` closes at the left edge, so
nothing is removed: the four spaces that were only there to indent the code are now part of the
text. It compiles, and the output above shows them, inside the brackets. When a block string comes
out shifted right, look at where its closing `"""` sits.
```

## The operations that come with the language

```tiko
{{#include ../examples/ch08/intrinsics.tiko}}
```

```text
{{#include ../examples/ch08/intrinsics.out}}
```

Two conventions to absorb, because everything else follows from them.

**Positions start at 1.** `mid( s, 5, 5 )` means five characters starting at the fifth. This is not
an accident to be worked around — it is consistent across every intrinsic here, and mixing it with
zero-based thinking is the single commonest source of off-by-one bugs in string code.

**Not found is 0.** `instr` returns 0 when the needle is absent, which is never a valid position,
so `if instr( s, x ) > 0` is the test. There is no separate "not found" value to remember.

`mid` also works on the left of an assignment, where it overwrites in place:

```tiko
{{#include ../examples/ch08/midstatement.tiko}}
```

```text
{{#include ../examples/ch08/midstatement.out}}
```

The `mid` **statement** never changes the length. A replacement longer than the room available is
truncated, as the third case shows. That is what makes it cheap: nothing is reallocated. It works
the same on a `ustring`, counting UTF-16 units.

## Numbers and text

```tiko
{{#include ../examples/ch08/numbers.tiko}}
```

```text
{{#include ../examples/ch08/numbers.out}}
```

`str` converts a number to text with no padding. `print` is different — it reserves a column for
the sign, which is why printed positive numbers appear with a leading space throughout this book.

`hex`, `oct` and `bin` render a value in another base, and a second argument sets the width:
`hex( 255, 4 )` is `00FF`.

`print using` lays out a line against a picture: `###.##` is a number with two decimals, `&` is a
string. It is the quickest way to get a column to line up. For a line that mixes widths, bases and
decimals, `strings.Format`, later in this chapter, says it in one place.

```admonish danger title="Pitfall"
**`val( )` cannot fail.** It reads as far as it can and returns what it got, so `val( "42abc" )` is
42, and `val( "abc" )` is 0 — indistinguishable from the text `"0"`.

That is fine for input you produced and dangerous for input you did not. When a program has to know
whether the text *was* a number, `val` alone cannot tell it. `strings.IsNumeric( )` answers that
question, and Chapter 17's `Outcome` type carries the answer and the failure together, which is the
shape to reach for once parsing can go wrong in more than one way.
```

## What `len` is actually counting

Here is the idea the rest of the chapter depends on. A string has three different lengths, and
which one you get depends on the type holding it.

```tiko
{{#include ../examples/ch08/codeunits.tiko}}
```

```text
{{#include ../examples/ch08/codeunits.out}}
```

The listing builds its text from explicit byte values, so nothing depends on how the file was
saved — those really are the UTF-8 bytes.

Read the two cases:

- **`café`** is 4 characters. As UTF-8 bytes it is **5** — `é` needs two. As a `ustring` it is
  **4** code units. Here characters and code units agree.
- **`a` + U+1F600 + `b`** is 3 characters. As UTF-8 bytes it is **6**. As a `ustring` it is **4**
  code units — because U+1F600 is outside the Basic Multilingual Plane and UTF-16 stores it as a
  *surrogate pair*, two units that mean one character.

```admonish danger title="Pitfall"
**`len` on a `ustring` counts code units, not characters**, and `mid` indexes them.

For the Basic Multilingual Plane — which is every European, Cyrillic, Greek, Hebrew, Arabic, CJK
and Hangul character — those are the same number, which is why the bug hides. Emoji, historic
scripts, many mathematical symbols and some rarer CJK are outside it, and there one character is
two units.

So `mid( face, 2, 1 )` hands back **half a surrogate pair**: a value that is not a character and
renders as the replacement character U+FFFD. Splitting a `ustring` at an arbitrary position can cut a character in two.

When the positions come from searching — `instr`, `Split`, a delimiter you put there yourself —
you are safe, because those land on boundaries. When they come from arithmetic, such as "the first
20 characters", they are not.
```

Conversion between `string` and `ustring` is **UTF-8 in both directions, on every target**, and it
is lossless: the round trip in the listing compares equal.

That is the rule worth memorising. A `ustring` assigned to a `string` is encoded as UTF-8; a
`string` assigned to a `ustring` is decoded as UTF-8. There is no locale involved and no target
dependence.

## Bytes that are not UTF-8

```tiko
{{#include ../examples/ch08/ansibytes.tiko}}
```

```text
{{#include ../examples/ch08/ansibytes.out}}
```

Both of those `string`s hold the word *café*. One was written by something that used Latin-1, where
`é` is the single byte `E9`. The other is UTF-8, where it is `C3 A9`.

Converting each to `ustring` decodes as UTF-8 — because that is the only rule — so the Latin-1 byte
is not valid input and becomes **65533**, U+FFFD, the replacement character. The text it stood for
is gone, and nothing was reported.

```admonish danger title="Pitfall"
**A `string` does not know its encoding, and the conversion does not ask.**

Bytes from a file written years ago, from a Windows API that returns the ANSI code page, or from a
database column configured for Latin-1, are not UTF-8 — and assigning them to a `ustring` destroys
every non-ASCII character in them, silently and unrecoverably.

Convert at the boundary, with knowledge of what the bytes are, and keep everything inside the
program as `ustring`. `utf_conv.bi` has the routines for encodings other than UTF-8. The one thing
never to do is assume.
```

## The standard library

```tiko
{{#include ../examples/ch08/stdstrings.tiko}}
```

```text
{{#include ../examples/ch08/stdstrings.out}}
```

`#import "std/strings"` brings in around forty-five operations that the language itself does not
have. The ones above are the everyday set; the module also carries `Extract`, `Remain`, `Tally`,
`InsertAt`, `DeleteAt`, `Shrink`, `VerifySet`, the `*Chars` family that works on sets of characters
rather than substrings, and `Unescape`/`Unwrap` to undo their opposites.

`Split` hands back an `Array( of ustring )` — the container Chapter 23 covers. Here it is only
asked for `.Count( )` and `[ i ]`, which is all you need to walk it.

`Join( Split( s, d ), d )` gives back `s`, for every `s` and every non-empty `d`. That round-trip
property is worth knowing, because it tells you what `Split` does with the awkward cases: `"a,,c"`
is three fields with an empty one in the middle, and `"a,"` is two.

## Laying out a line

`str`, `hex` and `print using` each do one job. A line that wants a name padded to a width, a
number in hexadecimal and a price to two decimals becomes three calls glued with `&`, and the shape
of the line disappears into them. `strings.Format` takes the shape as one string — a **format
string** — and the values to put in it:

```tiko
{{#include ../examples/ch08/format.tiko}}
```

```text
{{#include ../examples/ch08/format.out}}
```

Each `{}` is replaced by the next value. `{0}`, `{1}` and so on name a value by position, counting
from 0, so the same value can appear twice or the order can change; a format string uses one style
or the other, never both. `{{` and `}}` are literal braces. Values left over are not an error.

After a `:` comes the **spec**, a run of optional fields in a fixed order:

| Field | Meaning |
|---|---|
| fill and align | `<` left, `>` right, `^` centre, padded with the fill character — a space unless one is written before the alignment, as in `{:*^9}` |
| sign | `+` puts a sign on every number |
| `#` | `0x`, `0b` or `0` before a hexadecimal, binary or octal number |
| `0` | pads a number with zeros after its sign: `{:+06}` |
| width | the least number of characters |
| `.precision` | digits after the point for a float; the most characters taken from a string |
| type | `d`, `b`, `o`, `x`, `X` and `c` for integers; `f`, `e`, `g` and `a` for floats; `s` for text |

Numbers align right and everything else left unless the spec says otherwise. A `boolean` is the
word `true` or `false`, or `1` and `0` under `d`.

The spec language is C++'s `std::format`, so a format string written for one reads the same in the
other.

**A float with no type is printed as the shortest text that reads back as the same value.** That
is why `0.1 + 0.2` appears with its last digit, `0.30000000000000004`: the sum is not `0.3`, and
`Format` does not hide that. Give it a precision — `{:.2f}` — when a reader wants two decimals.

A width can come from a value as well, with `{:{}}`. That is what makes a table line up when the
widest entry is known only at run time:

```tiko
{{#include ../examples/ch08/formattable.tiko}}
```

```text
{{#include ../examples/ch08/formattable.out}}
```

### Checked when it compiles

A format string written as a literal is read by the compiler, and checked against the values that
follow it:

```tiko
{{#include ../examples/ch08/formatcheck.tiko}}
```

```text
formatcheck.tiko(6,30): error TKO0851: format string: no argument 1 (1 given)
     |
   6 | print strings.Format( "{} of {} done", done )   '' error: one value
     |                              ^
```

The caret is on the field that has no value. Every way a format string can be wrong has its own id,
`TKO0847` to `TKO0858` in Appendix B: a `{` with no `}`, a spec that does not parse, a type the value
cannot take — `{:x}` on text, `{:f}` on an integer — and a precision on an integer, among others.

````admonish danger title="Pitfall"
**A format string held in a variable is checked only when it runs — and a bad one stops the
program.**

The compiler can read a literal. It cannot read a variable, so a format string that arrives in one
— built by concatenation, loaded from a file — is not checked until `Format` meets it. `Format`
then treats it as the bug it would have been in a literal: it writes the reason and the offset to
the error output and stops the program with runtime error 1, which Chapter 17 explains.

That is right for a format string the program wrote. It is wrong for one that came from outside,
where a mistake is somebody else's and the program should carry on.
````

### Format strings that are data

A format string read from a translation file or a user's settings is data, and a bad one is not a
bug in the program. `strings.TryFormat` returns the text or the reason, and never stops anything:

```tiko
{{#include ../examples/ch08/tryformat.tiko}}
```

```text
{{#include ../examples/ch08/tryformat.out}}
```

The answer is a `Result` — Chapter 17's type for a value or the reason there isn't one. `IsOk( )`
says which, `Value( )` is the text, and `Failure( )` carries a `message`, an `offset` into the
format string counted from 0, and a `code` to test against. `TryFormat` takes a plain `ustring`, so
even a literal passed to it is left for run time.

## Reading a table

```tiko
{{#include ../examples/ch08/csvreport.tiko}}
```

```text
{{#include ../examples/ch08/csvreport.out}}
```

CSV looks like a job for `Split` and is not. A field may be quoted, and a quoted field may contain
the delimiter — `"London, UK"` is one field, not two. Anything that splits on commas gets that
wrong, and gets it wrong on exactly the rows a test file does not contain.

`strings.SplitCsv( text )` parses a whole table and returns rows, each with a `.fields` array.
`strings.SplitCsvRow( line )` parses a single record and returns the fields directly. Both handle
quoting, embedded delimiters and embedded newlines.

## A string as bytes

```tiko
{{#include ../examples/ch08/binary.tiko}}
```

```text
{{#include ../examples/ch08/binary.out}}
```

The `mk*` family packs a number into its raw bytes and `cv*` reads it back: `mkl`/`cvl` for 32-bit,
`mkshort`/`cvshort` for 16, `mkd`/`cvd` and `mks`/`cvs` for floating point, `mki`/`cvi` for the
pointer-sized `integer`. This is how a record gets written to a binary file, which Chapter 24 comes
back to.

`lset` and `rset` align text within a fixed-length string. `strptr` and `sadd` give the address of
the characters themselves, which is what a C function needs — and what makes it your
responsibility to keep the string alive while the pointer is in use.

## Working with letters

```tiko
{{#include ../examples/ch08/caesar.tiko}}
```

```text
{{#include ../examples/ch08/caesar.out}}
```

`asc` and `chr` move between a character and its number, which turns text into arithmetic. The
`+ 26` before the `mod` is there because Chapter 4's rule still applies: `mod` takes the sign of its
left operand, so shifting backwards past `a` would otherwise give a negative answer.

This works for ASCII letters and stops there. It is a cipher exercise, not a text-processing
technique — `ucase` on a `ustring` already knows about every alphabet, and hand-rolled arithmetic
does not.

## A value with no printable form

```tiko
print "X["; Box( 7 ); "]Y"      '' refused
```

A type that has no conversion to text has nothing for `print` to show, whether it arrives as a
variable or as a temporary like `Box( 7 )`: both are refused with `TKO0871: a 'box' has no printable
form`. Give the type an `operator cast( ) as ustring` — Chapter 12 — and it prints.

## What it costs

- **`len` on a `ustring` is O(1).** So is `len` on a `string`. Neither walks the text.
- **`ustring` uses 2 bytes per code unit**, so ASCII text costs twice what it would as a `string`.
  That is the price of not having to think about encoding, and it is almost always worth paying.
- **`&` builds a new string.** Appending in a loop copies what is there each time; for a large
  result, build into one string and overwrite with the `mid` statement, or let the library do it.
- **Converting between `string` and `ustring` is a re-encode**, not a cast. Do it at the boundary,
  once, not inside a loop.
- **`instr` is a scan.** Finding *n* things in a long string costs *n* scans unless you carry the
  position forward with `instr( start, s, x )`.
- **`Format` reads its format string on every call**, and copies each text value it is given. In a
  loop over millions of lines that is measurable; for a report it is not.

## Summary

- Five types: **`ustring` for text**, `string` for bytes, `zstring`/`wstring` for C, `string * n`
  fixed and **space-padded**.
- `wstring` is 2 bytes per character on Windows and 4 on Linux; `ustring` is UTF-16 everywhere.
- **A block string** opens with `"""` at the end of a line and closes at the first line starting
  with `"""`; **that closing line's indentation is the margin** removed from every line.
  `!"""` reads escapes, and every line break inside is `chr( 10 )`.
- **Positions start at 1, and "not found" is 0.**
- The `mid` statement overwrites in place and never changes the length, on `string` and `ustring`
  alike.
- `str` has no padding; `print` reserves a column for the sign. `hex`/`oct`/`bin` take a width.
- **`val( )` cannot fail** — it returns 0 for text that is not a number. Use `IsNumeric`, or
  Chapter 17's `Outcome`, when it matters.
- **`len` on a `ustring` counts code units.** Outside the BMP one character is two units, so
  arithmetic positions can cut a character in half.
- **Converting between `string` and `ustring` is UTF-8 in both directions, on every
  target**, and lossless.
- **Bytes that are not UTF-8 become U+FFFD, silently.** Convert at the boundary, knowing what you
  have.
- `#import "std/strings"` adds ~45 operations including `Split`/`Join`, `Replace`, the `Pad*`
  family, `Between` and the CSV parsers. `Join( Split( s, d ), d )` is `s`.
- **`strings.Format` lays out a line from a format string**: `{}` or `{n}` for each value, then
  `:` and a spec — fill, alignment, sign, width, precision, type. A float with no type is the
  shortest text that reads back exactly.
- **A literal format string is checked when the program compiles** (`TKO0847` to `TKO0858`). One held
  in a variable is checked when it runs, and a bad one stops the program; for format strings that
  are data, `TryFormat` returns a `Result` instead.
- **CSV is not a `Split` problem** — use `SplitCsv` or `SplitCsvRow`, which understand quoting.
- `mk*`/`cv*` pack numbers into bytes; `lset`/`rset` align in a fixed-length string; `strptr`/`sadd`
  reach the characters for C.
- **A value with no printable form is refused by `print`** (`TKO0871`), variable or temporary.

## Exercises

1. Write `TitleCase`, which uppercases the first letter of each word and lowercases the rest, then
   check it against `strings.MCase` on a sentence, a shouted one, one with double spaces and an
   empty string. {solution="ex08-01"}
2. Parse a block of `key = value` lines into pairs, skipping blanks and lines with no `=`. A value
   may itself contain an `=`; make sure yours survives that. {solution="ex08-02"}
3. Take the `café` bytes from `codeunits.tiko` and print `len` of the `string` and of the `ustring`.
   Then do the same for a string of pure ASCII. When do the two numbers agree, and why?
4. `mid( face, 2, 1 )` on the emoji text returns half a character. Write a loop that walks a
   `ustring` and prints each *character*, treating a surrogate pair as one. What does it need to
   check?
5. Read a CSV line with `SplitCsvRow`, then split the same line on commas with `Split`, and print
   both field counts. Construct a line where they differ.
6. Print a multiplication table for 1 to 12 with `strings.Format`, every column right-aligned.
   Then make the column width depend on the largest product, so the table still lines up for 1 to
   99.
