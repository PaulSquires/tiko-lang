[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **ValueOr**

# ValueOr

## Syntax

```freebasic
ValueOr( byref dflt as T ) byref as T
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim some_ as Optional( of integer ) = Some( 42 )
dim none_ as Optional( of integer ) = None( of integer )( )

dim as integer fallback = -1

print some_.ValueOr( fallback )    '' 42
print none_.ValueOr( fallback )    '' -1

'' Never raises, so no HasValue( ) guard is needed
```

---

**Library:** [Optional](Category-Optional)  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members
