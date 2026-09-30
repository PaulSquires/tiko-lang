[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseLongInt**

# TryParseLongInt

## Syntax

```freebasic
TryParseLongInt( s [, base] )
```

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

var r = TryParseLongInt( "9223372036854775807" )
print r.HasValue( )          '' true
print r.Value( )             '' 9223372036854775807

'' One past the top is rejected rather than wrapped
print TryParseLongInt( "9223372036854775808" ).HasValue( ) '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
