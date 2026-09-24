[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Lock**

# Lock

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Lock( ) as SharedPtr( of T )
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

dim w as WeakPtr( of Node )

scope
    dim p as SharedPtr( of Node ) = MakeShared( of Node )( )
    p.Ref( ).id = 7
    w = p

    '' Lock( ) promotes the observer back to an owner, if the object is
    '' still alive. This is the ONLY safe way to use a WeakPtr.
    dim s as SharedPtr( of Node ) = w.Lock( )
    print s.IsNull( )        '' false
    print s.Ref( ).id        '' 7
end scope

'' The last strong handle is gone, so the object is destroyed and the
'' promotion fails rather than handing back a dangling pointer
dim s2 as SharedPtr( of Node ) = w.Lock( )
print s2.IsNull( )           '' true
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
