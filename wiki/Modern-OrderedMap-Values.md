[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Values**

# OrderedMap.Values

Returns a copy of all the values as an Array, in the order of their keys.

## Syntax

```freebasic
Values( ) as Array( of TV )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' In ascending order OF THEIR KEYS, not of the values themselves
dim vs as Array( of integer ) = ages.Values( )
for i as int32 = 0 to vs.Count - 1
    print vs[ i ]                      '' 36 / 41
next
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
