[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Ref**

# Ref

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Ref( ) byref as T
Ref( )
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

dim p as SharedPtr( of Node ) = MakeShared( of Node )( )

'' A reference to the pointee, so members read without the -> dance
p.Ref( ).id = 7
print p.Ref( ).id            '' 7

'' Ref( ) on a NULL handle has nothing to refer to -- guard with IsNull
dim empty_ as SharedPtr( of Node )
print empty_.IsNull( )       '' true
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the tiko-lang repository.
