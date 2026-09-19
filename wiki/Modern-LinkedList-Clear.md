[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Clear**

# Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of string )
q.PushBack( "a" ) : q.PushBack( "b" )

q.Clear( )               '' frees every node
print q.Count            '' 0
print q.IsEmpty          '' true
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
