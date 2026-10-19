[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **ValueOr**

# ValueOr

Returns the value, or the fallback you pass if the Result failed.

## Syntax

```freebasic
ValueOr( byref dflt as T ) byref as T
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim good as Result( of int32, ustring ) = Ok( of int32, ustring )( 42 )
dim bad  as Result( of int32, ustring ) = Fail( of int32, ustring )( "nope" )

dim as int32 fallback = -1

print good.ValueOr( fallback )     '' 42
print bad.ValueOr( fallback )      '' -1

'' The branch-free alternative to Value( ): never raises, whichever side
'' the Result is on
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members
