[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PushBack**

# PushBack

Adds a value at the back of the list.

## Syntax

```freebasic
PushBack( byref v as T )
```

## Notes

- O(1)

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of ustring )

q.PushBack( "a" )
q.PushBack( "b" )        '' O(1) at the back, like Array.Push

print q.Back( )          '' b
print q.Count            '' 2
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
