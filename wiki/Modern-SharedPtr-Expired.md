[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Expired**

# Expired

## Syntax

```freebasic
Expired( ) as boolean
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
    w = p
    print w.Expired( )       '' false -- a strong handle still holds it
end scope

print w.Expired( )           '' true -- the object is gone

'' Expired( ) is a question about the PAST instant it was asked. Lock( )
'' and then test the handle when the answer must still hold afterwards.
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
