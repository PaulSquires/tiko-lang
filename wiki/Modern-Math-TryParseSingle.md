[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseSingle**

# TryParseSingle

## Syntax

```freebasic
TryParseSingle( s [, flags] )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

var r = TryParseSingle( "1.5" )
print r.HasValue( )          '' true
print r.Value( )             '' 1.5

'' A magnitude too large for a SINGLE is still accepted -- it becomes
'' an infinity rather than being rejected, so check IsFinite when that
'' matters
print TryParseSingle( "1e300" ).HasValue( )   '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
