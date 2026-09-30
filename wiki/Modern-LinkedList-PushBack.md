[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PushBack**

# PushBack

O(1)

## Syntax

```freebasic
PushBack( byref v as T )
```

## Notes

- O(1)

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

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
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
