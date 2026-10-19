[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **GetIterator**

# GetIterator

Returns an iterator over the values that stays valid when others are added.

## Syntax

```freebasic
GetIterator( ) as LinkedListIterator( of T )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of int32 )
for i as int32 = 1 to 3
    q.PushBack( i )
next

for each v in q
    print v
next

'' The protocol underneath. A LinkedList iterator stays valid across
'' insertions elsewhere in the list, which an Array iterator cannot.
dim it as LinkedListIterator( of int32 ) = q.GetIterator( )
while it.IsValid( )
    it.Value( ) *= 10    '' Value( ) is BYREF
    it.MoveNext( )
wend
print q.Front( )         '' 10
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
