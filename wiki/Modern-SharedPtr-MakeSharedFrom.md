[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **MakeSharedFrom**

# MakeSharedFrom

## Syntax

```freebasic
MakeSharedFrom( of T )
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
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

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members
