[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseLong**

# TryParseLong

## Syntax

```freebasic
TryParseLong( s )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

var r = TryParseLong( "42" )
print r.HasValue( )          '' true
print r.Value( )             '' 42

'' RANGE IS CHECKED: a value too big for the type is absent, not wrapped
print TryParseLong( "99999999999999" ).HasValue( )        '' false
print TryParseLong( "1.5" ).HasValue( )                    '' false -- not an integer
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
