[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **FloorMod**

# FloorMod

Returns the remainder with the divisor's sign, so FloorMod(-1, 5) is 4.

## Syntax

```freebasic
FloorMod(-7,3)
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The remainder with the SIGN OF THE DIVISOR, which is what a wrapping
'' index wants -- unlike MOD, which follows the dividend
dim as int32 a = -1, b = 5
print FloorMod( a, b )       '' 4
print a mod b                '' -1 -- the built-in, for comparison

'' Which makes it the right one for "wrap this index into range"
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
