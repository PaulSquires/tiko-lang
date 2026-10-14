[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **IsNull**

# IsNull

## Syntax

```freebasic
IsNull( ) as boolean
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
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
