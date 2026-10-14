[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **None**

# None

## Syntax

```freebasic
None( of T )
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim o as Optional( of integer ) = None( of integer )( )

print o.HasValue( )          '' false

'' The type argument must be written: there is no parameter to infer
'' from. A default-constructed Optional is already empty, so this is for
'' saying "absent" out loud, typically in a return.
dim d as Optional( of integer )
print d.HasValue( )          '' false
```

---

**Library:** [Optional](Category-Optional)  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members
