# Slices

`mid`, `left` and `Split` hand back new strings: each one allocates and
copies. A *slice* names part of a string where it already is, so taking text
apart costs nothing until you decide to keep a piece.

```tiko
{{#include ../../examples/strings/slices.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/slices.out}}
```

**`s[lo to hi]` counts from 0 and includes both ends**, the same counting as
`s[i]`. `s[0 to 2]` is the first three units; `mid( s, 1, 3 )` is the same
text counted from 1, and copied. `s[3 to 2]`, whose end is one before its
start, is empty, so `s[0 to len( s ) - 1]` is the whole string even when `s`
is empty. A range outside the string is runtime error 6, checked every time
a slice is made.

There is one slice type for each width of text:

| Type | Slices | Unit |
|---|---|---|
| `uslice` | `ustring` | a UTF-16 code unit |
| `slice` | `string`, `zstring`, a `zstring ptr` | a byte |
| `wslice` | `wstring`, a `wstring ptr` | a wide character |

**A slice is as writable as its source.** `first[0] = asc( "R" )` changed
`s`. A slice of a constant, a literal or a temporary is `const`, and writing
through it is refused.

**Assigning a slice to a `ustring` copies it.** That is the moment to do it:
when the text has to outlive the string it came from.

`std/strings` has functions that take and return slices: `Find`, `Equals`,
`StartsWith`, `EndsWith`, `TrimStart`, `TrimEnd`, `TrimSpace`, and
`SplitSlices`, which hands the parts to `for each` one at a time instead of
building an array. Their positions count from 0, and `Find` answers -1 when
there is no match. Any string can be passed where they want a slice.

```admonish tip
Pass `s[0 to len( s ) - 1]` rather than `s` when a `ustring` meets a literal
in a call such as `SplitSlices( s, "," )`. With a `ustring` and a literal
the compiler has two equally good ways to convert, and refuses to guess.
```

The rules that keep a slice from outliving its text are on the next page,
[Slices and lifetime](slicelife.md).

### Activities

1. Print every word of `"the quick brown fox"` using `SplitSlices`, then
   print only those that `StartsWith` `"b"`.
2. Use `Find` to print the part of `"key=value"` after the `=`, without
   calling `mid`.
