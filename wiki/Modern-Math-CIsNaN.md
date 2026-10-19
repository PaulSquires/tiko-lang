[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsNaN**

# CIsNaN

Returns true if a complex number is NaN; one infinite part makes it infinite instead.

## Syntax

```freebasic
CIsNaN( byref z as Complex ) as boolean
```

## Notes

- **This is not 'either component is NaN'.** It is *neither infinite nor finite*, which is .NET's definition and the right one: a complex number with one infinite part and one NaN part is **infinite**, because the infinity already answers every question anyone asks of it.
- Never test for a NaN with `=`. A NaN is not equal to itself.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CIsNaN( CNaN( ) )                      '' true
print CIsNaN( CSet( Infinity( ), NaN( ) ) )  '' false   -- infinite, so NOT NaN
print CIsNaN( CSet( 1.0, NaN( ) ) )          '' true   -- this one is
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
