[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Fail**

# Fail

## Syntax

```freebasic
Fail( of T, E )
Fail( of int32, ustring )
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim r as Result( of int32, ustring ) = Fail( of int32, ustring )( "not a number" )

print r.IsOk( )              '' false
print r.Failure( )           '' not a number

'' T and E MAY BE THE SAME TYPE -- Result( of ustring, ustring ) is a normal
'' thing to want. The slots stay distinct because they are two fields,
'' not a union.
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members
