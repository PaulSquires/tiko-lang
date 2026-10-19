[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TrailingZeros**

# TrailingZeros

Counts the zero bits below the lowest set bit; zero gives the type's full width.

## Syntax

```freebasic
TrailingZeros( byval x as T ) as int32
```

## Notes

- The index of the lowest set bit, which is how a bitset finds its first member and how a power of two reports its exponent.
- **Zero answers the operand's full width**, rather than being undefined the way the raw CPU instruction is.
- `LeadingZeros` is the same idea from the top.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as uint32 x = 8
print TrailingZeros( x )     '' 3 -- 8 is 1 shifted left three times

dim as uint32 odd_ = 7
print TrailingZeros( odd_ )  '' 0 -- the lowest bit is set

'' ZERO gives the full width instead of being undefined
dim as uint32 zero_ = 0
print TrailingZeros( zero_ ) '' 32
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
