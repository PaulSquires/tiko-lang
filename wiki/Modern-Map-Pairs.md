[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Pairs**

# Pairs

for 'for each (k, v)'

## Syntax

```freebasic
Pairs( ) as MapPairView( of K, V )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

'' Pairs( ) yields a TUPLE instead of a KeyValuePair, so the loop can
'' destructure into two named variables
for each (who, age) in ages.Pairs( )
    print who & " is " & age             '' ada is 36
next

'' The default `for each kv in ages` form names its halves kv.key and
'' kv.value and costs one copy fewer
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
