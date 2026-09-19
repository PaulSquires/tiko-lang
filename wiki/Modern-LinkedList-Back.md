[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Back**

# Back

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Back( ) byref as T
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of string )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.Back( )          '' b
q.Back( ) = "z"          '' byref, so this assigns in place
print q.Back( )          '' z

'' An empty list yields a reference to a shared blank, not an error
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
