[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Count**

# Count

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Count( ) as long
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of long )
print q.Count            '' 0

for i as long = 1 to 3
    q.PushBack( i )
next
print q.Count            '' 3

q.PopFront( )
print q.Count            '' 2
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
