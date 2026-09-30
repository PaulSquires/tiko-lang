[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **IsOk**

# IsOk

## Syntax

```freebasic
IsOk( ) as boolean
```

## Examples

```freebasic
#import "std/outcome"
using FB

dim r as Result( of int32, ustring ) = Ok( of int32, ustring )( 42 )

'' The guard, and it costs nothing. READING THE WRONG SIDE RAISES:
'' Value( ) on a failure and Failure( ) on a success both raise
'' 'illegal function call', symmetrically.
if r.IsOk( ) then
    print r.Value( )         '' 42
else
    print r.Failure( )
end if

dim bad as Result( of int32, ustring ) = Fail( of int32, ustring )( "nope" )
print bad.IsOk( )            '' false
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
