[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseDouble**

# TryParseDouble

## Syntax

```freebasic
TryParseDouble( s [, flags] )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' An Optional, so failure is absence rather than a zero that cannot be
'' told apart from a parsed "0"
var r = TryParseDouble( "1.5" )
print r.HasValue( )          '' true
print r.Value( )             '' 1.5

print TryParseDouble( "" ).HasValue( )        '' false
print TryParseDouble( "12abc" ).HasValue( )   '' false -- trailing junk

'' STRICT BY DEFAULT: no locale, no partial acceptance
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
