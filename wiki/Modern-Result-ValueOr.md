[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **ValueOr**

# ValueOr

## Syntax

```freebasic
ValueOr( byref dflt as T ) byref as T
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim good as Result( of long, ustring ) = Ok( of long, ustring )( 42 )
dim bad  as Result( of long, ustring ) = Fail( of long, ustring )( "nope" )

dim as long fallback = -1

print good.ValueOr( fallback )     '' 42
print bad.ValueOr( fallback )      '' -1

'' The branch-free alternative to Value( ): never raises, whichever side
'' the Result is on
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
