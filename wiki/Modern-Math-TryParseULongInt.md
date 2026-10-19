[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryParseULongInt**

# TryParseULongInt

Parses a whole string as a ULongInt, returning an empty Optional if invalid or too big.

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
