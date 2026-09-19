[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **Front**

# Front

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [LinkedList](Category-LinkedList), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Front( ) byref as T
```

## Examples

```freebasic
#include once "fb/linkedlist.bi"
using FB

dim q as LinkedList( of string )
q.PushBack( "a" ) : q.PushBack( "b" )

print q.Front( )         '' a -- peek without removing
print q.Count            '' 2, unchanged

'' Returns BYREF, so it assigns in place
q.Front( ) = "z"
print q.Front( )         '' z

'' On an EMPTY list it returns a reference to a shared blank -- a
'' reference has to refer to something. Check IsEmpty first.
```

---

**Library:** [LinkedList](Category-LinkedList) ✨  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Members  
**Source:** `docs/linkedlist/linkedlist.txt` in the tiko-lang repository.
