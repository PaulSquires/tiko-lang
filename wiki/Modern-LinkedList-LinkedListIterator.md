[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **LinkedListIterator**

# LinkedListIterator

Holds a position in a LinkedList; it survives changes elsewhere in the list.

## Syntax

```freebasic
LinkedListIterator( of T )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- **It stays valid across insertions and removals elsewhere in the list**, which is the property Array's iterator cannot offer and one of the two reasons this container exists.
- It holds a node pointer, so removing the node it is sitting on does invalidate it.
- `Value( )` is byref.

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of int32 )
for i as int32 = 1 to 3
    q.PushBack( i )
next

dim it as LinkedListIterator( of int32 ) = q.GetIterator( )
while it.IsValid( )
    it.Value( ) *= 10        '' byref, so this assigns in place
    it.MoveNext( )
wend

print q.Front( )             '' 10
print q.Back( )              '' 30
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members
