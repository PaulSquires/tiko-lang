[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Back**

# Back

Returns a reference to the back value without removing it.

## Syntax

```freebasic
Back( ) byref as T
```

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of ustring )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.Back( )          '' b
q.Back( ) = "z"          '' byref, so this assigns in place
print q.Back( )          '' z

'' An empty list yields a reference to a shared blank, not an error
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
