[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **HasValue**

# HasValue

Returns true if the Optional holds a value.

## Syntax

```freebasic
HasValue( ) as boolean
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true

o.Clear( )
print o.HasValue( )          '' false

'' The guard before Value( ), which RAISES on an empty Optional.
'' This replaces the sentinel idiom, where -1 might be "absent" or might
'' be a legitimate index and nothing in the type says which.
```

---

**Library:** [Optional](Category-Optional)  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members
