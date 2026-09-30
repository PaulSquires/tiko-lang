[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Keys**

# OrderedMap.Keys

## Syntax

```freebasic
Keys( ) as Array( of TK )
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' A snapshot, already SORTED -- no sort needed afterwards, which is
'' the difference from Map.Keys( )
dim ks as Array( of ustring ) = ages.Keys( )
for i as int32 = 0 to ks.Count - 1
    print ks[ i ]                      '' ada / bob
next
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
