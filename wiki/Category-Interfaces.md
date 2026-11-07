[Home](Home) › [All Categories](Categories) › **Interfaces**

# Interfaces

```freebasic
interface IShape
    function Area( ) as float64
    function Name( ) as ustring
end interface

class Circle
    implements IShape
    declare function Area( ) as float64 implements IShape.Area
    declare function Name( ) as ustring implements IShape.Name
    as float64 r = 1
end class
' ... method bodies ...

sub Report( byval s as IShape )
    print s.Name( ); ":"; s.Area( )
end sub
```

An interface is a contract: a list of methods and properties, with no data and no code. Any `type` or `class` can take on any number of them with `implements` lines, mapping one of its own methods to each member. Code written against the interface works with every type that implements it, including types written later.

An interface value is a **reference**: the object's address and a dispatch table, 16 bytes, passed and copied like any small value. The object it refers to can be anything that implements the interface: a class with a vtable, or a plain `type` with none.

## Why It Exists

A contract written as an abstract base type (`type Shape extends object` with `abstract` methods) uses up the one base a type can have. A type cannot follow two such contracts, a library type that already extends something cannot follow one at all, and every value pays for a vtable pointer.

An interface is not a base. A type lists as many as it needs, keeps its own base class if it has one, and a plain `type` with no vtable can implement one. Two contracts can even ask for members of the same name and mean different things; the type maps each to its own method.

## The Pieces

| Page | What it is |
|---|---|
| [Interface](Interface) | Declares an interface, generic or not, with `inherits` lines for the interfaces it includes |
| [Class](Class) | A type that always extends `object`: `inherits` names its base, `implements` its interfaces |
| [Implements](Implements) | The body line that lists interfaces, and the clause that maps a method to a member |
| [Inherits](Inherits) | A class's base class, or an interface's base interfaces |
| [TryCast](TryCast) | A checked conversion: a cross cast between interfaces, or a downcast to a type |
| [Operator Is](Operator-Is-Run-Time-Type-Information) | `x is T` with an interface on either side |
| [Interfaces Tutorial](Interfaces-Tutorial) | The same program written with abstract base types and with interfaces, then properties, generic interfaces and constraints |

## Conversions

| From | To | |
|---|---|---|
| an object of a type that implements `I`, or a pointer to one | `I` | implicit |
| `J`, an interface that inherits `I` | `I` | implicit, free or one load |
| `nullptr` | `I` | implicit: the empty reference |
| `I` | another interface | `trycast` or `cast`: the same object, or a null reference when it does not implement the target |
| `I` | `T ptr` | `trycast` (checked: `nullptr` when it is no `T`) or `cast` (unchecked) |
| a function result or other temporary | `I` | refused (TKO1012): the reference would outlive it |

Nothing converts *out* of an interface implicitly (TKO1009, which suggests `trycast`). Two interface values compare equal when they refer to the same object.

## Generic Interfaces and Constraints

```freebasic
interface IComparer( of T )
    function Compare( byval a as T, byval b as T ) as int32
end interface

sub SortWith( of T )( a( ) as T, byval cmp as IComparer( of T ) )
    ' ...
end sub

function Largest( of T as IComparable( of T ) )( a( ) as T ) as T
    ' ...
end function
```

Each instance of a generic interface is an interface of its own. A class maps an instance's member as `implements IComparer( of ustring ).Compare`, and a generic class gets one mapping per instance. A generic procedure infers `T` from an argument that implements one instance of the interface it asks for.

A **constraint**, `of T as I` or `of T as { I, J }`, requires the type argument to implement the interfaces. It is checked once, where the generic is used (TKO1022), and the body calls `T`'s own methods directly: no interface value, no indirect call. See [Generics](Category-Generics).

## What It Costs

- **An interface value is 16 bytes**: the object's address and its itable for that interface.
- **A call through an interface is one indirect call** through the itable. A class whose implementing method is `virtual` adds a small thunk that follows the object's vtable, so an override is reached.
- **Converting is free or one load.** Implementing an interface adds nothing to an object: a plain `type` stays the size of its fields.
- **`trycast` and `is` search a small table** at run time; a type with no vtable gets the answer at compile time (TKO1016).
- **Mappings, signature checks and constraints are compile-time only.**

## Diagnostics

| | |
|---|---|
| TKO0427 | a class has one base class |
| TKO0428 | an interface body holds only `inherits` lines and member declarations |
| TKO0429 | an interface member takes no `virtual`, `static` or access word |
| TKO0430 | a method's `implements` names `IName.Member` |
| TKO0432, TKO0433 | a class's base is an `inherits` line; a type's is `extends` on its header |
| TKO0434 | a body for an interface member, `sub IFoo.Bar( ) ... end sub`: write it in a type that implements the interface |
| TKO0435 | `inherits` and `implements` lines come first in the body |
| TKO0436 | `implements` is a line in the body, not a word on the header |
| TKO0437 | a class cannot be `extern` |
| TKO0438 | the `implements` clause goes on the declaration inside the type |
| TKO1000 | an interface member is not implemented |
| TKO1001 | a method's signature differs from the member it maps |
| TKO1002 | the name is not an interface |
| TKO1003 | the interface has no such member |
| TKO1004 | a method maps a member of an interface the type does not list |
| TKO1005 | a member is mapped twice |
| TKO1006 | an interface is listed twice |
| TKO1007 | an interface cannot be created |
| TKO1008 | an interface inherits itself |
| TKO1009 | the value does not convert to (or from) the interface |
| TKO1010 | a member name is ambiguous between two base interfaces |
| TKO1011 | the base class already implements the member |
| TKO1012 | an interface value cannot refer to a temporary |
| TKO1013 | `delete` cannot destroy through an interface |
| TKO1014 | a `static` method cannot implement a member |
| TKO1015 | an interface type cannot appear in a foreign declaration |
| TKO1016 | warning: `is` or `trycast` has a compile-time answer |
| TKO1018 | warning: the method's default arguments differ from the member's |
| TKO1021 | `trycast` converts to an interface or a type pointer |
| TKO1022 | a type argument does not implement an interface its parameter requires |

## Known Limits

- **`cast` from an interface to a type pointer is unchecked**, in every build. Use `trycast`, or test with `is` first.
- **An interface value does not keep its object alive.** Keep the owning variable for as long as any interface value refers to it.
- **Interfaces are not COM interfaces.** COM layouts are written as a `type` that extends `object` with `abstract` methods.
- **A constrained generic body calls `T`'s methods by their own names.** A method mapped to `IComparable.CompareTo` under another name satisfies the constraint but is not reachable as `.CompareTo` inside the body.
- **An interface has no method bodies and no events.** Shared behaviour is a free procedure taking the interface.

See also: [Generics](Category-Generics), [User Defined Types](Category-User-Defined-Types), [`Object`](Object), [`Virtual`](Virtual), [`Abstract`](Abstract).

---

[Home](Home) · [Keyword Index](Keyword-Index)
