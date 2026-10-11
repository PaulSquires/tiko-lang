[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **UseCount**

# UseCount

## Syntax

```freebasic
UseCount( ) as int32
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
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

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
