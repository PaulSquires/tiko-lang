[Home](Home) › [Smart Pointers](Category-Smart-Pointers) › [SharedPtr and WeakPtr](Category-Smart-Pointers) › **Get**

# Get

Returns the raw pointer to the object, or 0 if null, without adding an owner.

## Syntax

```freebasic
Get( ) as T
```

## Examples

```freebasic
#import "std/memory"
using memory

type Node
    as int32 id
end type

dim p as SharedPtr( of Node ) = MakeShared( of Node )( )
p.Ref( ).id = 7

'' The raw pointer, for passing to code that does not know about handles.
'' It does NOT extend the lifetime -- the SharedPtr still owns the object.
dim as Node ptr raw = p.Get( )
print raw->id                '' 7

'' There are no comparison operators; compare Get( ) for identity
dim q as SharedPtr( of Node ) = p
print ( q.Get( ) = p.Get( ) )      '' -1 (true) -- the same object
```

---

**Library:** [SharedPtr and WeakPtr](Category-Smart-Pointers)  
**Category:** [Smart Pointers](Category-Smart-Pointers)  
**Documented under:** Members
