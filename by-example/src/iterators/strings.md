# for each and strings

Text can be walked in three units, and each needs a different loop: words,
characters and bytes.

```tiko
{{#include ../../examples/iterators/strings.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/strings.out}}
```

- **Words.** `strings.Split( csv, "," )` returns a `containers.Array` of
  `ustring`, and `for each` walks that like any array.
- **Characters.** A `ustring` is indexed with `for` and `mid`. Each
  `mid( word, i, 1 )` is one character, so `café` has four.
- **Bytes.** A `string` is a sequence of bytes, and `for each` over it yields
  each byte as a number. Converted to a `string`, `é` is encoded as UTF-8, two
  bytes, 195 and 169, so the same word is five bytes long.

A `ustring` itself cannot be walked by `for each`:

```tiko
{{#include ../../examples/iterators/walkustring.tiko}}
```

```text
walkustring.tiko(2,1): error TKO0688: 'for each' cannot walk a ustring; index it with 'for' and 'mid' instead
     |
   2 | for each ch in word                 '' a ustring cannot be walked
     | ^
```

```admonish danger title="Pitfall"
`for each` over a `string` compiles and runs for any text, and for ASCII it
looks right: one step per letter. The first accented letter makes the count
wrong without a diagnostic. Use it to parse bytes, and use a `ustring` with
`mid` for anything a reader would call a character.
```

[Strings](../strings/index.md) covers `ustring` and `std/strings` in full.

### Activities

1. Split `"one two  three"` on `" "`. How many elements are there, and why?
2. Count the vowels in a `ustring` with a `for` loop and `mid`.
