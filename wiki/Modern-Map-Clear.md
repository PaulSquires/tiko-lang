[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Clear**

# Clear

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "grace", 45 )

ages.Clear( )
print ages.Count                 '' 0
print ages.Contains( "ada" )     '' false
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
