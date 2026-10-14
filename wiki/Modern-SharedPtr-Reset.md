[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Reset**

# Reset

Drops this handle's share of the object, leaving the handle null.

## Syntax

```freebasic
Reset( )
```

## Notes

- The object is destroyed when the LAST strong handle goes away -- `Reset( )` on one of several just decrements the count.
- Afterwards [IsNull](Modern-SharedPtr-IsNull) is true and [UseCount](Modern-SharedPtr-UseCount) is 0 for this handle.
- The same thing happens automatically at scope exit and on reassignment; `Reset( )` is for releasing early.

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
end type

dim p as SharedPtr( of Node ) = MakeShared( of Node )( )
dim q as SharedPtr( of Node ) = p
print p.UseCount( )          '' 2

q.Reset( )                   '' drop just this handle
print p.UseCount( )          '' 1
print q.IsNull( )            '' true

p.Reset( )                   '' the last handle -- the object is destroyed now
print p.IsNull( )            '' true
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members
