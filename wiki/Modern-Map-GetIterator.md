[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **GetIterator**

# GetIterator

Returns an iterator over the entries, each a pair read through .key and .value.

## Syntax

```freebasic
GetIterator( ) as MapIterator( of K, V )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

'' Iteration yields a KeyValuePair, read through .key and .value
for each kv in ages
    print kv.key & " " & kv.value        '' ada 36
next

'' The protocol underneath, if a `for each` will not do
dim it as MapIterator( of ustring, integer ) = ages.GetIterator( )
while it.IsValid( )
    print it.Value( ).key
    it.MoveNext( )
wend
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
