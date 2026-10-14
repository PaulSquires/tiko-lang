[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PushFront**

# PushFront

O(1)

## Syntax

```freebasic
PushFront( byref v as T )
```

## Notes

- O(1)

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of ustring )

q.PushBack( "b" )
q.PushFront( "a" )       '' O(1) at the front -- the reason this type exists,
                         '' since an Array cannot insert at 0 in constant time
print q.Front( )         '' a
print q.Count            '' 2
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
