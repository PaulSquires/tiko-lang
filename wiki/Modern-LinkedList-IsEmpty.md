[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **IsEmpty**

# IsEmpty

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of long )
print q.IsEmpty          '' true

dim as long x = 1
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
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
