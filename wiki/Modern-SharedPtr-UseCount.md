[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **UseCount**

# UseCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
UseCount( ) as long
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

dim p as SharedPtr( of Node ) = MakeShared( of Node )( )
print p.UseCount( )          '' 1

scope
    dim q as SharedPtr( of Node ) = p      '' a second handle
    print p.UseCount( )      '' 2
end scope

'' q left scope, so its reference was dropped
print p.UseCount( )          '' 1

'' Under -mt the counts are touched through the rtlib atomics. That covers
'' the CONTROL BLOCK, never the pointee: two threads mutating the object
'' itself still need their own lock.
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the tiko-lang repository.
