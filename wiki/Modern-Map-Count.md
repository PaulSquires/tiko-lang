[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Count**

# Count

## Syntax

```freebasic
Count( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
print ages.Count                 '' 0

ages.Put( "ada", 36 )
ages.Put( "ada", 37 )            '' an overwrite, not an insertion
print ages.Count                 '' 1

'' Watch for the indexer: reading an absent key INSERTS it
print ages[ "nobody" ]           '' 0
print ages.Count                 '' 2
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
