# Pointers

A *pointer* holds the address of a value. Through it you can read and write
the value from somewhere that does not know its name, which is how heap memory
is reached and how linked structures are built.

```tiko
{{#include ../../examples/memory/pointers.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/pointers.out}}
```

| Written | Means |
|---|---|
| `int32 ptr` | the type: an address of an `int32` |
| `@n` | the address of `n` |
| `*p` | the value at `p`, for reading or writing |
| `p->x` | field `x` of the record at `p`; the same as `( *p ).x` |
| `p[i]` | the element `i` places after `p`; the same as `*( p + i )` |

Writing through `*p` changed `n`, because `p` holds `n`'s address: there is
one value and two ways to reach it.

**Pointer arithmetic counts elements, not bytes.** `first + 1` is the next
`int32`, four bytes on; the same step on a `uint8 ptr` is one byte. That is
why a pointer to an array's first element can be indexed like the array, and
why subtracting two pointers into one array gives the number of elements
between them, 4 here.

```admonish danger title="Pitfall"
`@v + 3`, with `v` an `int32`, is not three bytes past `v`: it is three
`int32`s, twelve bytes, outside `v` altogether. Reading there returns
whatever is next in memory and nothing reports it. To step in bytes, step
through a byte pointer: `cast( uint8 ptr, @v ) + 3`.
```

`cast( uint8 ptr, first )` reinterprets an address as a pointer to another
type. `any ptr` is an address with no type at all: every pointer converts to
it and back without a cast, and it cannot be dereferenced until you convert it
to a typed pointer.

### Activities

1. Print the bytes of the `int32` value 258 through a `uint8 ptr`. Which byte
   comes first?
2. Walk `a` backwards with a pointer, from `lastOne` down to `first`.
