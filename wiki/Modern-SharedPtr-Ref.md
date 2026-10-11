[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Ref**

# Ref

## Syntax

```freebasic
Ref( ) byref as T
Ref( )
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
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

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
