[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **AbsChecked**

# AbsChecked

Returns the absolute value as an Optional, empty for the most negative value.

## Syntax

```freebasic
AbsChecked( byval a as T ) as Optional( of T )
```

## Notes

- There is exactly one failing case, and it is the reason this exists: the **most negative value of a two's-complement type has no positive counterpart**. `abs( -128 )` on a BYTE is -128.
- Every other input returns its magnitude.
- `AbsSaturating` clamps that one case to the maximum instead.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int8 worst = -128

var r = AbsChecked( worst )
print r.HasValue( )          '' false -- there is no +128 in a BYTE

'' Which is what the bare operator gets silently wrong
print abs( worst )           '' -128

dim as int8 ordinary = -5
print AbsChecked( ordinary ).Value( )         '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
