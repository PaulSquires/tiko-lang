# Built-in functions

The everyday operations on text are built into the language: no `#import`
is needed for any of them, and they all work on `ustring`.

```tiko
{{#include ../../examples/strings/intrinsics.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/intrinsics.out}}
```

Two conventions run through every one of them:

- **Positions start at 1.** `mid( s, 5, 5 )` is five characters starting at
  the fifth.
- **Not found is 0.** `instr` returns 0 when the text is absent, which is
  never a valid position, so `if instr( s, x ) > 0` is the test.

| Function | Gives |
|---|---|
| `left( s, n )`, `right( s, n )` | the first or last `n` characters |
| `mid( s, start, n )` | `n` characters from `start`; leave out `n` for the rest |
| `instr( s, t )`, `instr( start, s, t )` | where `t` first appears, searching from `start` |
| `instrrev( s, t )` | where `t` last appears |
| `ucase( s )`, `lcase( s )` | the text in upper or lower case |
| `trim`, `ltrim`, `rtrim` | the text without surrounding spaces; `any "chars"` strips those characters instead |
| `space( n )`, `string( n, c )` | `n` spaces, or `n` copies of a character |
| `chr( n )`, `asc( s, i )` | a character from its code, and the code of the character at `i` |
| `str( n )`, `val( s )` | a number as text, and text as a number |

None of these change their argument: each returns a new string. The
exception is `mid` written on the *left* of `=`, the `mid` statement, which
overwrites characters inside an existing string. It never changes the
string's length, so it is also how [Building strings](building.md) fills a
buffer without reallocating.

Converting between numbers and text in more depth, including what `val`
does with text that is not a number, is in
[Conversion](../conversion/index.md).

### Activities

1. Use `instr` in a `do` loop to count how many times `"o"` appears in `s`,
   passing the position after each match as the start of the next search.
2. Print `s` with its first letter in lower case and the rest in upper case,
   using `left`, `mid`, `lcase` and `ucase`.
