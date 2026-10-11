[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ByteSwap**

# ByteSwap

Reverses the order of the bytes.

## Syntax

```freebasic
ByteSwap( byval x as T ) as T
```

## Notes

- Endianness conversion: what turns a big-endian value from a file or a socket into a native one, and back.
- Reverses **bytes**, not bits -- `BitReverse` is the other one, and they are not interchangeable.
- Its own inverse: swapping twice returns the input.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as uint32 x = &h12345678
print hex( ByteSwap( x ) )   '' 78563412

'' Its own inverse
print ByteSwap( ByteSwap( x ) ) = x           '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
