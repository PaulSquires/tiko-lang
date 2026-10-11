[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseULongInt**

# TryParseULongInt

## Syntax

```freebasic
TryParseULongInt( s )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

var r = TryParseULongInt( "18446744073709551615" )
print r.HasValue( )          '' true
print r.Value( )             '' 18446744073709551615

print TryParseULongInt( "-1" ).HasValue( )    '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
