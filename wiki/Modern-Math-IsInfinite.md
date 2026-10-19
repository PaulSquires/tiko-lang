[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsInfinite**

# IsInfinite

Returns true if the value is plus or minus infinity.

## Syntax

```freebasic
IsInfinite( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print IsInfinite( Infinity( ) )       '' true
print IsInfinite( NegInfinity( ) )    '' true -- either sign
print IsInfinite( NaN( ) )            '' false
print IsInfinite( 1.0 )               '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
