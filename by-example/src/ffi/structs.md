# Structs and layout

A `type` lays its fields out the way C lays out a `struct` on the same
platform. So a `type` with the same fields in the same order as a C struct has
the same size and offsets, and C can fill one in, read one, or return one.

```tiko
{{#include ../../examples/ffi/structs.tiko}}
```

**Output**

```text
{{#include ../../examples/ffi/structs.out}}
```

C's `div` returns a `div_t`, a struct of two `int`s, by value. `DivResult` has
the same two fields, so the declaration can say it returns a `DivResult`, and
tiko passes it back by the platform's rules exactly as a C compiler would. The
field names do not have to match C's, only the types and the order; `rem` is
the one name that cannot be used, because `rem` starts a comment.

**Alignment.** Each field sits on a boundary of its own size, with padding
before it where needed, and the whole type is rounded up to its largest
alignment. That is why `Natural` is 8 bytes and not 5. `offsetof( T, field )`
gives a field's offset, to check against the C header.

**Packing.** `field = 1` removes the padding, as C's `#pragma pack( 1 )` does;
`field = 2` and `field = 4` limit the alignment the same way. Use them only to
match a C struct that is packed. An unpacked C struct read through a packed
type is garbage.

A fixed-size `zstring * n` is an inline array of `n` characters, like C's
`char name[ n ]`. A `ustring` field is not: it holds a pointer to its text, and
never belongs in a struct that C will read.

### Activities

1. Add an `int64` field after `value` in `Natural` and predict the new size.
2. Declare C's `lldiv`, which returns two `long long`s, and call it.
