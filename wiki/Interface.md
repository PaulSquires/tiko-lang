[Home](Home) › [Interfaces](Category-Interfaces) › **Interface**

# Interface

Declares a contract: a list of methods and properties that a type promises to provide.

## Syntax

```freebasic
interface name [ ( of T [ as constraint ] [ , ... ] ) ]
    [ inherits base_interface [ , base_interface ... ] ]
    [ declare ] { sub | function | property } member ( parameters ) [ as type ]
    ...
end interface
```

## Parameters

- `name`: the interface's name. By convention it starts with `I`.
- `T`: a type parameter, making a generic interface. See [Generic interfaces](#generic-interfaces).
- `base_interface`: an interface this one includes. Any number, on one `inherits` line or several.
- `member`: a method or property every implementing type must supply.

## Description

An interface says *what* a type can do and nothing about *how*. It has no fields, no code and no constructor, and it is never created on its own. A type takes it on with an [`Implements`](Implements) line in its body and maps a method of its own to each member.

Every member is public and abstract, so a member declaration carries no `virtual`, `abstract`, `static` or access word (TKO0429), and `declare` is optional. Only member declarations and `inherits` lines may appear in the body (TKO0428). The `inherits` lines come first (TKO0435).

**An interface is a type.** A variable, parameter, result, field or array element can be of an interface type. Its value is a **reference**: the address of an object that implements the interface, and that type's dispatch table for it. It is 16 bytes, and copying it copies the reference, never the object. An object of any implementing type converts to it implicitly, and so does a pointer to one. Members are called with `.`:

```freebasic
interface INamed
    function Name( ) as ustring
end interface

interface IShape
    inherits INamed                       '' an IShape is an INamed too
    function Area( ) as float64
    property Scale( ) as float64          '' a getter...
    property Scale( byval s as float64 )  '' ...and a setter
end interface

type Square
    implements IShape
    as float64 side = 2, k = 1
    declare function Name( ) as ustring implements INamed.Name
    declare function Area( ) as float64 implements IShape.Area
    declare property Scale( ) as float64 implements IShape.Scale
    declare property Scale( byval s as float64 ) implements IShape.Scale
end type
function Square.Name( ) as ustring
    return "square"
end function
function Square.Area( ) as float64
    return ( side * k ) ^ 2
end function
property Square.Scale( ) as float64
    return k
end property
property Square.Scale( byval s as float64 )
    k = s
end property

dim as Square sq
dim as IShape s = sq                      '' the object's address and Square's dispatch table
s.Scale = 3
print s.Name( ); " area"; s.Area( )
dim as INamed n = s                       '' widening to a base interface
print n.Name( ); ", size of an interface value:"; sizeof( IShape )
```

```
square area 36
square, size of an interface value: 16
```

An interface value does not own its object: the object must outlive every interface value that refers to it. A temporary such as a function result therefore cannot be converted (TKO1012), and `delete` through an interface is refused (TKO1013). An interface itself cannot be created: `new IShape` is refused (TKO1007). A `dim` of an interface type declares an empty reference, equal to `nullptr` until something is assigned to it.

**`inherits` makes the base's members part of this interface.** A type that implements `IShape` above implements `INamed` too, and an `IShape` converts to an `INamed` implicitly. A member reached through two bases that both declare it must be called through one of them (TKO1010).

**Properties** are listed with their accessors: a getter, a setter, or both. Assigning to a property through the interface needs its setter in the contract (TKO0680), and compound assignment (`s.Scale += 1`) uses both.

## Generic interfaces

```freebasic
interface IComparer( of T )
    function Compare( byval a as T, byval b as T ) as int32
end interface
```

Each instance, `IComparer( of ustring )` or `IComparer( of float64 )`, is an interface of its own. A type implements an instance by naming it (`implements IComparer( of ustring )`), and maps a member with `implements IComparer( of ustring ).Compare`. A generic class can implement instances that use its own parameter: `implements IComparer( of T )`. The interface name alone, without type arguments, is an error (TKO0815), as is the wrong number of them (TKO0816).

A generic procedure that takes an `IComparer( of T )` infers `T` from an argument that implements one instance of it. The [Interfaces Tutorial](Interfaces-Tutorial) builds a sort on this, and [Generics](Category-Generics) covers constraints, `of T as IComparable( of T )`.

## Remarks

- `interface` is recognised only where a declaration can start and the body ends in `end interface`; elsewhere it remains an ordinary name.
- An interface value compares equal to another when both refer to the same object (`=`, `<>`), and to `nullptr` when it refers to none.
- `is` and [`TryCast`](TryCast) ask what the object behind an interface value really is.
- Interfaces are not COM interfaces. A COM interface is a binary layout, written as a `type` that extends `object` with `abstract` methods.

### See also

- [`Implements`](Implements)
- [`Inherits`](Inherits)
- [`Class`](Class)
- [`TryCast`](TryCast)
- [`Operator Is`](Operator-Is-Run-Time-Type-Information)
- [Interfaces Tutorial](Interfaces-Tutorial)

---

**Category:** [Interfaces](Category-Interfaces)
**Kind:** keyword
