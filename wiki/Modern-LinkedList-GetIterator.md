[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetIterator( ) as LinkedListIterator( of T )
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of long )
for i as long = 1 to 3
    q.PushBack( i )
next

for each v in q
    print v
next

'' The protocol underneath. A LinkedList iterator stays valid across
'' insertions elsewhere in the list, which an Array iterator cannot.
dim it as LinkedListIterator( of long ) = q.GetIterator( )
while it.IsValid( )
    it.Value( ) *= 10    '' Value( ) is BYREF
    it.MoveNext( )
wend
print q.Front( )         '' 10
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
