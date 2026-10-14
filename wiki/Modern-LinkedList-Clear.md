[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Clear**

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

dim q as LinkedList( of ustring )
q.PushBack( "a" ) : q.PushBack( "b" )

q.Clear( )               '' frees every node
print q.Count            '' 0
print q.IsEmpty          '' true
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
