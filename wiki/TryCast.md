[Home](Home) › [Interfaces](Category-Interfaces) › **TryCast**

# TryCast

Converts to an interface or a typed pointer if the object really is one, and answers null if it is not.

## Syntax

```freebasic
result = trycast( interface, expression )
result = trycast( typename ptr, expression )
```

## Parameters

- `interface`: the interface wanted.
- `typename ptr`: a pointer to the type wanted.
- `expression`: an interface value, or a pointer or reference to an object whose type extends `object`.

## Return Value

With an interface: a value of that interface referring to the same object, or a null interface value (equal to `nullptr`) when the object does not implement it.

With a pointer type: a pointer to the object, or `nullptr` when the object is not of that type or one derived from it.

## Description

`trycast` asks the object at run time. It is the checked counterpart of [`Cast`](Cast): `cast( Note ptr, v )` takes the programmer's word for it, and a wrong one is undefined behaviour; `trycast( Note ptr, v )` looks, and answers `nullptr` when the object is something else.

From an interface value it does two things no other operator does:

- **A cross cast**: `trycast( ISize, v )` asks whether the object behind an `IShow` *also* implements `ISize`, and if so gives an `ISize` for the same object.
- **A downcast to the concrete type**: `trycast( Note ptr, v )`.

```freebasic
interface IShow
    function Show( ) as ustring
end interface
interface ISize
    function Size( ) as int32
end interface

class Note
    implements IShow, ISize
    declare function Show( ) as ustring implements IShow.Show
    declare function Size( ) as int32 implements ISize.Size
    as ustring text = "remember the milk"
end class
function Note.Show( ) as ustring
    return text
end function
function Note.Size( ) as int32
    return len( text )
end function

class Label
    implements IShow
    declare function Show( ) as ustring implements IShow.Show
end class
function Label.Show( ) as ustring
    return "label"
end function

sub Describe( byval v as IShow )
    print v.Show( );
    dim as ISize sz = trycast( ISize, v )         '' does this object ALSO implement ISize?
    if sz <> nullptr then print ","; sz.Size( ); " characters";
    dim as Note ptr np = trycast( Note ptr, v )   '' is it a Note?
    if np <> nullptr then print " (a Note)";
    print
end sub

dim as Note n
dim as Label l
Describe( n )
Describe( l )
```

```
remember the milk, 17 characters (a Note)
label
```

Converting *up* never needs `trycast`: a `Note` converts to `IShow` implicitly, and an interface to any interface it inherits. Converting *out* of an interface implicitly is an error that suggests `trycast` (TKO1009).

## Remarks

- The target must be an interface or a pointer to a type (TKO1021).
- `trycast` is a run-time search through a small table, so test once and keep the result rather than casting inside a hot loop.
- `expression is typename` is the yes/no form of the same question; see [`Operator Is`](Operator-Is-Run-Time-Type-Information). When the answer is known at compile time the compiler says so (TKO1016).

### See also

- [`Cast`](Cast)
- [`Operator Is`](Operator-Is-Run-Time-Type-Information)
- [`Interface`](Interface)
- [Interfaces Tutorial](Interfaces-Tutorial)

---

**Category:** [Interfaces](Category-Interfaces)
**Kind:** operator
