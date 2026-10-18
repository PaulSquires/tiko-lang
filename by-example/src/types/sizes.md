# Sizes

Every type occupies a fixed number of bytes, and `sizeof` reports it. Most
of the time you do not need the number, but it matters when you read binary
data, call C code, or keep a large array of records in memory.

```tiko
{{#include ../../examples/types/sizes.tiko}}
```

**Output**

```text
{{#include ../../examples/types/sizes.out}}
```

`sizeof` takes a type or a value. `len` given a type means the same thing;
given text, it means the number of characters.

`integer` and pointers have the width of an address: 8 bytes on both 64-bit
targets. Use the fixed-width names (`int32`, `int64`) when the width matters
and `integer` when a value has to match the machine's word, such as an index
into something very large.

A `ustring` variable is a fixed-size value that manages its text elsewhere,
so `sizeof` is the same for short and long text. `len` is the one that
changes.

A record's fields are laid out in order, each at an offset that is a
multiple of its own size, and the whole record is rounded up to a multiple of
its largest field. `Loose` puts a 1-byte field before a 4-byte one, so three
bytes of padding go in between and the record takes 12 bytes. `Tight` has
the same fields largest first and takes 8. `offsetof( T, field )` shows where
each field starts.

### Activities

1. Add an `int64` field to the end of `Tight` and predict its `sizeof` before
   you run it.
2. Print `sizeof( Loose ) * 1000000` and `sizeof( Tight ) * 1000000`: the
   memory an array of a million of each would take.
