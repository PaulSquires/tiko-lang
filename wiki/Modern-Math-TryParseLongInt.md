[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseLongInt**

# TryParseLongInt

Parses a whole string as a LongInt, in an optional base; empty if invalid or too big.

## Syntax

```freebasic
TryParseLongInt( s [, base] )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

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
