[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **SubWrapping**

# SubWrapping

A - b, **wrapping** on overflow -- deliberately.

## Syntax

```freebasic
SubWrapping( byval a as T, byval b as T ) as T
```

## Notes

- Exactly what `a - b` already does. It exists so that **deliberate** wrapping -- a hash mix, a checksum, a ring index -- can be spelled as deliberate, and so a reader does not have to guess whether the author knew.
- No cost: it compiles to the same instruction as the operator.
- `SubChecked` is the one that reports overflow and `SubSaturating` the one that clamps.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as byte a = -100, b = 100

print SubWrapping( a, b )        '' 56 -- wrapped below -128, and that is
                                 '' the point

'' The ordinary case is just subtraction
print SubWrapping( cbyte( 100 ), cbyte( 40 ) )         '' 60

'' The value of this over the bare operator is that the INTENT is on
'' the page: a reader does not have to work out whether the overflow
'' was known about
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
