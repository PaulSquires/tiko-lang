[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Items**

# OrderedSet.Items

Returns a copy of all the values as an Array, already sorted.

## Syntax

```freebasic
Items( ) as Array( of T )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

'' A snapshot, already SORTED -- the difference from Set.Items( ),
'' which comes out in no particular order
dim xs as Array( of integer ) = s.Items( )
for i as int32 = 0 to xs.Count - 1
    print xs[ i ];
next
print                    '' 10 20 30
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
