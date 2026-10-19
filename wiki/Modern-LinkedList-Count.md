[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Count**

# Count

Returns the number of values in the list.

## Syntax

```freebasic
Count( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of int32 )
print q.Count            '' 0

for i as int32 = 1 to 3
    q.PushBack( i )
next
print q.Count            '' 3

q.PopFront( )
print q.Count            '' 2
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
