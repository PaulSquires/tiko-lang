[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSwap**

# CSwap

Exchanges two complex numbers.

## Syntax

```freebasic
CSwap( byref a as Complex, byref b as Complex )
```

## Notes

- A **sub**. Both arguments are modified.
- FreeBASIC's `swap` statement does the same for two `Complex` variables; this exists so that the operation has a name in the same family as the rest.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex a = CSet( 1, 2 ), b = CSet( 5, 6 )
CSwap( a, b )

print CToString( a )  '' 5+6i   -- after the swap
print CToString( b )  '' 1+2i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
