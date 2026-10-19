[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Clear**

# Clear

Removes every value.

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

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

seen.Clear( )
print seen.Count             '' 0
print seen.Contains( x )     '' false
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members
