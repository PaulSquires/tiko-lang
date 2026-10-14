[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Expired**

# Expired

## Syntax

```freebasic
Expired( ) as boolean
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
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
