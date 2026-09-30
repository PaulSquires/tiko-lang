[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **BitReverse**

# BitReverse

Reverses the order of the bits.

## Syntax

```freebasic
BitReverse( byval x as T ) as T
```

## Notes

- Every bit of the type, not just the significant ones -- so the answer depends on the width and reversing a `uint32` 1 gives the top bit set.
- Used by FFTs, by some CRC formulations and by Gray-code addressing.
- **Not** `ByteSwap`: that reorders bytes and leaves each byte's bits alone.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as uint32 x = 1
print hex( BitReverse( x ) ) '' 80000000 -- the bit moved to the top

'' Its own inverse, like ByteSwap
print BitReverse( BitReverse( x ) ) = x       '' -1 (true)

'' And NOT the same operation
print hex( ByteSwap( x ) )   '' 1000000
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
