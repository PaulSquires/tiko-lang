[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **WeakPtr**

# WeakPtr

Holds a link to a shared object that does not keep it alive, to break cycles.

## Syntax

```freebasic
WeakPtr( of T )
```

## Notes

- **The only way to break a cycle**: two objects holding SharedPtrs to each other never reach zero, and one of them holding a WeakPtr instead is what fixes it.
- It cannot be dereferenced. `Lock( )` promotes it to a SharedPtr, or answers null if the object is gone -- and that is the only safe way to use one.
- `Expired( )` is a question about the instant it was asked; between it and a later use the object may go. Lock and test the handle instead.
- The **control block outlives the object**, which is why a WeakPtr can safely read a count for something already destroyed: strong reaching 0 destroys the object, weak reaching 0 frees the block.

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
    p.Ref( ).id = 7
    w = p
    print w.Expired( )       '' false

    '' Lock is the ONLY safe way to use one
    dim s as SharedPtr( of Node ) = w.Lock( )
    print s.Ref( ).id        '' 7
end scope

print w.Expired( )           '' true
print w.Lock( ).IsNull( )    '' true -- no dangling pointer handed back
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members
