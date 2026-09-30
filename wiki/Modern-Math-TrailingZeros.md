[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TrailingZeros**

# TrailingZeros

How many zero bits sit below the lowest set one.

## Syntax

```freebasic
TrailingZeros( byval x as T ) as long
```

## Notes

- The index of the lowest set bit, which is how a bitset finds its first member and how a power of two reports its exponent.
- **Zero answers the operand's full width**, rather than being undefined the way the raw CPU instruction is.
- `LeadingZeros` is the same idea from the top.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as ulong x = 8
print TrailingZeros( x )     '' 3 -- 8 is 1 shifted left three times

dim as ulong odd_ = 7
print TrailingZeros( odd_ )  '' 0 -- the lowest bit is set

'' ZERO gives the full width instead of being undefined
dim as ulong zero_ = 0
print TrailingZeros( zero_ ) '' 32
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
