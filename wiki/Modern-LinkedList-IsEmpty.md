[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **IsEmpty**

# IsEmpty

Returns true if the list has no values.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of int32 )
print q.IsEmpty          '' true

dim as int32 x = 1
q.PushBack( x )
print q.IsEmpty          '' false

'' Worth checking before Front/Back/Pop*, which answer with a blank T
'' rather than an error on an empty list
q.Clear( )
print q.IsEmpty          '' true
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
