[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **MakeShared**

# MakeShared

## Syntax

```freebasic
MakeShared( of T )
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

'' Allocates a default-constructed T and returns the only handle to it
dim p as SharedPtr( of Node ) = MakeShared( of Node )( )

p.Ref( ).id = 7
print p.Ref( ).id            '' 7
print p.UseCount( )          '' 1

'' The object is destroyed exactly once, when the last handle goes away --
'' no DELETE at the call site and no ownership convention to document
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
