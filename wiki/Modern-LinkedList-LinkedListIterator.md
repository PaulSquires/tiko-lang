[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **LinkedListIterator**

# LinkedListIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator `for each` uses over a `LinkedList( of T )`.

## Syntax

```freebasic
LinkedListIterator( of T )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- **It stays valid across insertions and removals elsewhere in the list**, which is the property Array's iterator cannot offer and one of the two reasons this container exists.
- It holds a node pointer, so removing the node it is sitting on does invalidate it.
- `Value( )` is byref.

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of long )
for i as long = 1 to 3
    q.PushBack( i )
next

dim it as LinkedListIterator( of long ) = q.GetIterator( )
while it.IsValid( )
    it.Value( ) *= 10        '' byref, so this assigns in place
    it.MoveNext( )
wend

print q.Front( )             '' 10
print q.Back( )              '' 30
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
