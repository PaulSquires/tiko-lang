[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **LeadingZeros**

# LeadingZeros

returns the operand's FULL WIDTH

## Syntax

```freebasic
LeadingZeros( 0 )
```

## Notes

- returns the operand's FULL WIDTH

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

'' How many zero bits before the highest set one
dim as ulong x = 1
print LeadingZeros( x )      '' 31 -- in a 32-bit operand

dim as ulong y = &hFFFFFFFF
print LeadingZeros( y )      '' 0

'' ZERO ANSWERS THE OPERAND'S FULL WIDTH, rather than being undefined
'' the way the raw CPU instruction is
dim as ulong z = 0
print LeadingZeros( z )      '' 32
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
