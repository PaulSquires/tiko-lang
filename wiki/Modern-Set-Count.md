[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Count**

# Count

Returns the number of values in the set.

## Syntax

```freebasic
Count( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
print seen.Count             '' 0

dim as integer x = 1
seen.Add( x )
seen.Add( x )                '' a duplicate is not an insertion
print seen.Count             '' 1
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members
