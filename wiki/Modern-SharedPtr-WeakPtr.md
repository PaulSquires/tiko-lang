[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **WeakPtr**

# WeakPtr

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [SharedPtr and WeakPtr](Category-Smart-Pointers), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

An observer of a SharedPtr's object that does not keep it alive.

## Syntax

```freebasic
WeakPtr( of T )
```

## Notes

- **The only way to break a cycle**: two objects holding SharedPtrs to each other never reach zero, and one of them holding a WeakPtr instead is what fixes it.
- It cannot be dereferenced. `Lock( )` promotes it to a SharedPtr, or answers null if the object is gone -- and that is the only safe way to use one.
- `Expired( )` is a question about the instant it was asked; between it and a later use the object may go. Lock and test the handle instead.
- The **control block outlives the object**, which is why a WeakPtr can safely read a count for something already destroyed: strong reaching 0 destroys the object, weak reaching 0 frees the block.

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
    print w.Expired( )       '' false

    '' Lock is the ONLY safe way to use one
    dim s as SharedPtr( of Node ) = w.Lock( )
    print s.Ref( ).id        '' 7
end scope

print w.Expired( )           '' true
print w.Lock( ).IsNull( )    '' true -- no dangling pointer handed back
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the tiko-lang repository.
