[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **IsNull**

# IsNull

## Syntax

```freebasic
IsNull( ) as boolean
```

## Examples

```freebasic
#include once "fb/sharedptr.bi"
using FB

type Node
    as long id
end type

dim p as SharedPtr( of Node )
print p.IsNull( )            '' true -- a default-constructed handle owns nothing

p = MakeShared( of Node )( )
print p.IsNull( )            '' false

p.Reset( )
print p.IsNull( )            '' true -- back to owning nothing
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
