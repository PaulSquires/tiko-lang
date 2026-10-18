# Unicode

A `ustring` stores text as UTF-16 *code units*, 16-bit numbers. Almost every
character in use, from Latin and Cyrillic to Chinese, is one code unit. The
characters above U+FFFF, which include emoji and many historic scripts, need
two. Most of the time you can ignore the difference; this page shows when you
cannot.

```tiko
{{#include ../../examples/strings/unicode.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/unicode.out}}
```

`wchr( ... )` builds a string from code points, which keeps the source file
plain ASCII and makes it obvious which character you mean. It takes several
code points at once, too: `wchr( 72, 105 )` is `"Hi"`.

`café` is four characters and four code units. `face`, which is `a`, U+1F600
and `b`, is three characters but **four** code units: U+1F600 is stored as
the *surrogate pair* `D83D DE00`. `len`, `asc( s, i )`, `mid` and every other
position in the string functions count code units, not characters.

```admonish danger title="Pitfall"
A position you compute, such as "the first 20 characters", can land in the
middle of a pair, and `mid` then returns half a character: `D83D` on its own
is not text. Positions that come from a search (`instr`, `Split`, a delimiter
you put there) are safe, because a search only matches whole characters.
```

`CharCount` shows the way to walk characters rather than units: the second
unit of a pair is always in the range `DC00` to `DFFF`, so skipping those
counts each character once.

Assigning a `ustring` to the byte type `string` encodes it as UTF-8, where
U+1F600 takes four bytes, and assigning it back decodes it again; the round
trip loses nothing. That is the conversion to use when text leaves the
program as bytes.

`ucase` and `lcase` know the case of letters well beyond ASCII: `é` becomes
`É` and Greek alpha U+3B1 becomes U+391.

```admonish warning title="Status in this version"
`wchr` itself returns a `wstring`, not a `ustring`. Printing that directly,
as in `print wchr( 233 )`, writes raw wide characters instead of UTF-8 when
the output is redirected to a file or a pipe. Store the result in a
`ustring` first, as the example does, and it prints correctly everywhere.
```

### Activities

1. Write `CharAt( s, n )`, which returns the *n*th character of a string as a
   `ustring`, keeping a surrogate pair together.
2. Print the UTF-8 length of `café`, then of a plain ASCII word of the same
   length. When do `len` of the `string` and of the `ustring` agree?
