[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Capacity**

# Capacity

## Syntax

```freebasic
Capacity( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
print ages.Capacity              '' 0 -- nothing allocated yet

ages.Put( "ada", 36 )
print ages.Capacity              '' 8 -- the minimum

'' Capacity is a power of two and doubles at a load factor of 0.75,
'' so it is always well above Count
for i as integer = 1 to 7
    ages.Put( "k" & i, i )
next
print ages.Count & " of " & ages.Capacity    '' 8 of 16
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
