[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **LinkedNode**

# LinkedNode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LinkedNode( of T )
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

'' The node the list is built from: a value and two raw pointers.
'' Ordinary code never touches it -- Push*/Pop*/Front/Back and the
'' iterator are the interface -- but it is what makes the ownership
'' rules visible.
dim q as LinkedList( of long )
dim as long x = 42
q.PushBack( x )

'' The list holds RAW NODE POINTERS, unlike Array/Map/Set whose storage
'' is a dynamic array the language copies and frees for you. So the copy
'' constructor, `operator let` and destructor are all written out: a
'' default copy would share one chain between two lists and double-free.
dim copy_ as LinkedList( of long ) = q      '' deep copy, own chain
copy_.Front( ) = 99
print q.Front( ) & " " & copy_.Front( )     '' 42 99
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Implementation  
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
