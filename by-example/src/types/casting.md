# Casting

A cast converts a value to a type you name. tiko converts between number
types on assignment anyway, so a cast is for the places where the type would
otherwise be wrong: forcing floating-point arithmetic, choosing an integer
width, or making a narrowing conversion visible.

```tiko
{{#include ../../examples/types/casting.tiko}}
```

**Output**

```text
{{#include ../../examples/types/casting.out}}
```

`cast( T, value )` works for any target type. For the common ones there is a
shorter function:

| Function | Result type |
|---|---|
| `cint` | `integer` |
| `clng` | `int32` |
| `clngint` | `int64` |
| `cubyte`, `cbyte` | `uint8`, `int8` |
| `cushort`, `cshort` | `uint16`, `int16` |
| `culng` | `uint32` |
| `csng` | `float32` |
| `cdbl` | `float64` |
| `cbool` | `boolean` |

A floating-point value converted to an integer is **rounded**, not cut off:
`cint( 2.6 )` is 3. [Rounding](../conversion/rounding.md) has the exact rule
and the functions that round other ways.

Converting to a narrower integer keeps only the low bits, so a value that
does not fit wraps around with no error: 300 in eight bits is 44, and 200 as
a signed `int8` is -56. Unsigned arithmetic wraps the same way, which is why
`0 - 1` in a `uint32` is 4294967295.

`cbool` maps 0 to `false` and every other number to `true`. In the other
direction `true` is -1, the value a comparison produces.

### Activities

1. Print `cast( int16, 40000 )` and `cast( uint16, 40000 )`. Why does one
   change and not the other?
2. Print `cdbl( 7 ) / 2`, `7 \ 2` and `cint( 7 / 2 )`.
