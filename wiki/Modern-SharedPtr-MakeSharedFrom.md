[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **MakeSharedFrom**

# MakeSharedFrom

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MakeSharedFrom( of T )
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

dim seed as Node
seed.id = 42

'' Copy-constructs the heap object from an existing value
dim p as SharedPtr( of Node ) = MakeSharedFrom( seed )

print p.Ref( ).id            '' 42

'' It is a COPY -- changing the original does not touch the owned object
seed.id = 99
print p.Ref( ).id            '' 42
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
