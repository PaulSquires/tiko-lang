[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Ok**

# Ok

Returns a successful Result holding the value; both types must be written out.

## Syntax

```freebasic
Ok( of T, E )
Ok( of int32, ustring )
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim r as Result( of int32, ustring ) = Ok( of int32, ustring )( 42 )

print r.IsOk( )              '' true
print r.Value( )             '' 42

'' Both type arguments are written out because only T appears in the
'' parameter list -- E cannot be inferred from anything
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members
