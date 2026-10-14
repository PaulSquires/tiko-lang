[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsFinite**

# IsFinite

## Syntax

```freebasic
IsFinite( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print IsFinite( 1.0 )         '' true
print IsFinite( Infinity( ) ) '' false
print IsFinite( NaN( ) )      '' false

'' Neither infinite NOR NaN -- the check to make before trusting a value
'' to be arithmetic
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
