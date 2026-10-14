[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PopFront**

# PopFront

## Syntax

```freebasic
PopFront( ) as T
```

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim q as LinkedList( of ustring )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.PopFront( )      '' a -- removes and returns the front
print q.Count            '' 1

'' Popping an EMPTY list returns a default-constructed T. There is no
'' error channel and nothing to throw, so check IsEmpty first when the
'' difference between "empty" and "a blank element" matters.
dim e as LinkedList( of ustring )
print "[" & e.PopFront( ) & "]"      '' []
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
