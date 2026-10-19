# Binary formats

A binary file format puts each number at a known place, in a known width and
**byte order**. `std/codec` reads and writes them in a
`containers.Array( of ubyte )`, which `fs.WriteAllBytes` and `fs.ReadAllBytes`
move to and from a file.

```tiko
{{#include ../../examples/files/binary.tiko}}
```

**Output**

```text
{{#include ../../examples/files/binary.out}}
```

Every name says what it does: `Get`, `Put` or `Append`, then the type — `U16`,
`U32`, `U64`, `I16`, `I32`, `I64`, `F32`, `F64` — then `LE` for little-endian
(least significant byte first) or `BE` for big-endian. Offsets count bytes from
0. `Append` writes at the end; `Put` writes at an offset and grows the array if
it has to; `Get` past the end stops the program, as indexing an array does.

`AppendUVarint` writes a whole number in as few bytes as it needs, seven bits
per byte — here the label's length, 3, takes one byte. `ReadUVarint( buf, at )`
reads one and moves `at` past it, so the next field starts where `at` now
points. `AppendVarint` and `ReadVarint` do the same for numbers that can be
negative.

### Activities

1. Write the id big-endian instead, and see which bytes of the record change.
2. Make the label 200 characters long. How many bytes does its length take now?
