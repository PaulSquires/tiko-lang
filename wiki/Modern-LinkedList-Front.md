[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Front**

# Front

## Syntax

```freebasic
Front( ) byref as T
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of ustring )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.Front( )         '' a -- peek without removing
print q.Count            '' 2, unchanged

'' Returns BYREF, so it assigns in place
q.Front( ) = "z"
print q.Front( )         '' z

'' On an EMPTY list it returns a reference to a shared blank -- a
'' reference has to refer to something. Check IsEmpty first.
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
