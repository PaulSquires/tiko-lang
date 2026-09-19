[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **PopFront**

# PopFront

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
PopFront( ) as T
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of string )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.PopFront( )      '' a -- removes and returns the front
print q.Count            '' 1

'' Popping an EMPTY list returns a default-constructed T. There is no
'' error channel and nothing to throw, so check IsEmpty first when the
'' difference between "empty" and "a blank element" matters.
dim e as LinkedList( of string )
print "[" & e.PopFront( ) & "]"      '' []
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
