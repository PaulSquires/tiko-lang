[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PopBack**

# PopBack

Removes and returns the back value, or a default value if the list is empty.

## Syntax

```freebasic
PopBack( ) as T
```

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim q as LinkedList( of ustring )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.PopBack( )       '' b
print q.Count            '' 1

'' PushBack + PopBack is a stack; PushBack + PopFront is a queue
dim e as LinkedList( of ustring )
print "[" & e.PopBack( ) & "]"       '' [] -- empty gives a blank T
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
