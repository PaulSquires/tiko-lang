[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **SharedPtr**

# SharedPtr

Shared ownership of a heap object, by reference count.

## Syntax

```freebasic
SharedPtr( of T )
```

## Notes

- The object is destroyed **exactly once**, when the last handle goes away -- at scope exit, on reassignment, or when a container holding it is destroyed. No `delete` at the call site and no ownership convention to document.
- **Two allocations per object**, not C++'s one: the control block and the object are separate. Fusing them would make the control block generic, and since every member of a generic is instantiated whether called or not, that would require `T` to be default-constructible for every use -- including the ones that adopt an already-built pointer.
- Under `-mt` the counts are atomic. **That covers the control block, never the pointee**: two threads may copy and destroy handles freely, but two threads calling a mutating member of the object still need their own lock. Exactly C++'s contract.
- No comparison operators -- compare `Get( )` for identity.

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
end type

dim p as SharedPtr( of Node ) = MakeShared( of Node )( )
p.Ref( ).id = 7
print p.UseCount( )          '' 1

scope
    dim q as SharedPtr( of Node ) = p
    print p.UseCount( )      '' 2
end scope

print p.UseCount( )          '' 1 -- and the object is still alive
print p.Ref( ).id            '' 7
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members  
**Source:** `docs/sharedptr/sharedptr.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
