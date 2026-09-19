[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **LinkedList**

# LinkedList

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A doubly-linked list: O(1) at both ends, and iterators that survive insertion elsewhere.

## Syntax

```freebasic
LinkedList( of T )
```

## Notes

- It exists for the two things `Array` cannot do: **O(1) insertion at the front**, and an iterator that stays valid across an insertion somewhere else in the list.
- **Prefer Array** unless one of those is what you actually need -- this is the least important of the four containers.
- Unlike Array, Map and Set, whose storage is a dynamic array the language copies and frees for you, this holds **raw node pointers**. So the destructor, the copy constructor and `operator let` are all written out: a default copy would give two lists sharing one chain, and then a double free.
- Copies are therefore **deep**, and cost a node allocation per element.

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of string )

q.PushBack( "b" )
q.PushFront( "a" )           '' O(1) at the front, which Array cannot do
print q.Front( ) & q.Back( ) '' ab

'' A DEEP copy with its own chain -- not two handles on one list
dim copy_ as LinkedList( of string ) = q
copy_.Front( ) = "z"
print q.Front( ) & " " & copy_.Front( )       '' a z
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
