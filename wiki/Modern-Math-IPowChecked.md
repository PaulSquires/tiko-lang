[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IPowChecked**

# IPowChecked

Raises an integer to a power, returning an empty Optional if the result overflows.

## Syntax

```freebasic
IPowChecked( base, exp )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The overflow-safe form: an Optional, empty when the result does not
'' fit rather than wrapping silently
dim as int64 b = 2, e = 10
var r = IPowChecked( b, e )

print r.HasValue( )          '' true
print r.Value( )             '' 1024

dim as int64 big = 1000000
var over = IPowChecked( big, big )
print over.HasValue( )       '' false -- it would have overflowed
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
