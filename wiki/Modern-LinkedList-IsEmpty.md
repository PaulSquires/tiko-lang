[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **IsEmpty**

# IsEmpty

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of long )
print q.IsEmpty          '' true

dim as long x = 1
q.PushBack( x )
print q.IsEmpty          '' false

'' Worth checking before Front/Back/Pop*, which answer with a blank T
'' rather than an error on an empty list
q.Clear( )
print q.IsEmpty          '' true
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
