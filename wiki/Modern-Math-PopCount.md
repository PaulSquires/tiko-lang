[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **PopCount**

# PopCount

How many bits are set.

## Syntax

```freebasic
PopCount( byval x as T ) as int32
```

## Notes

- The population count, and the primitive underneath a bitset's size, a Hamming distance and a parity check.
- Counts the bits of `T`, so the same numeric value gives the same answer whatever the width -- it is the value that is counted, not the storage.
- `Parity` is this modulo 2, computed without the full count.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as uint32 x = &b1011
print PopCount( x )          '' 3

dim as uint32 zero_ = 0
print PopCount( zero_ )      '' 0

'' A Hamming distance is a xor and a PopCount
dim as uint32 a = &b1100, b = &b1010
print PopCount( a xor b )    '' 2
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
