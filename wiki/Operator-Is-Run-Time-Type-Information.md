[Home](Home) › [Operators](Category-Operators) › **Operator Is (Run-Time Type Information)**

# Operator Is (Run-Time Type Information)

Check if an object is compatible to a type derived from its compile-time type (in the context of inheritance)

## Syntax

```freebasic
result = expression Is typename
```

## Parameters

- `expression`
- `typename`

## Description

The `Is` operator must be used in conjunction with inheritance in order to check compatibility between objects and types from an inheritance structure extending the built-in [`Object`](Object) type.

 The `Is` operator is a binary operator that checks whether an object is compatible to its derived types at run-time. Because `Is` relies on Run-Time Type Information (RTTI), it can only be used with types that are derived from the built-in [`Object`](Object) type using [`Extends`](Extends). The compiler disallows using `Is` for checks that can be solved at compile-time.

 The `Is` operator is successful not only for the real-type (the "lowest"), but also for its base-types, as long as they are still below the type of *expression* (the compile-time type). In order to determine the real-type, all possibilities from lowest to highest must be checked.

 Extending the built-in [`Object`](Object) type allows to add an extra hidden vtable pointer field at the top of the [`Type`](Type-Udt). The vtable is used to access information for run-time type identification used by the `Is` operator.

 **With an interface on either side** the question is about the object behind it. `ifc is Circle` asks whether the object an interface value refers to is a `Circle` or derives from one, whatever the interface's own type; `obj is IShape` and `ifc is IShape` ask whether the object implements `IShape`. Neither needs the type to be derived from the expression's type, and a type with no vtable gets its answer at compile time, with a warning that says so (TKO1016). [`TryCast`](TryCast) answers the same questions with the converted value.

 This operator cannot be overloaded.

## Return Value

Returns negative one (`-1`) if the expression is an object of real-type `typename` or one of its base-types derived from the *expression* type, or zero (`0`) if it's an object of an incompatible type.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Object`](Object)
- [`Is (Select Case)`](Is)
- [`TypeOf`](Typeof)
- [`TryCast`](TryCast)
- [`Interface`](Interface)

## Examples

```freebasic
Type Vehicle Extends Object

    As String Name

End Type

Type Car Extends Vehicle

End Type

Type Cabriolet Extends Car

End Type

Type Bike Extends Vehicle

End Type

Sub identify(ByVal p As Object Ptr)

    Print "Identifying:"

    '' Not a Vehicle object?

    If Not (*p Is Vehicle) Then

        Print , "unknown object"

        Return

    End If

    '' The cast is safe, because we know it's a Vehicle object

    Print , "name: " & CPtr(Vehicle Ptr, p)->Name

    If *p Is Car Then

        Print , "It's a car"

    End If

    If *p Is Cabriolet Then

        Print , "It's a cabriolet"

    End If

    If *p Is Bike Then

        Print , "It's a bike"

    End If

End Sub

Dim As Car ford

ford.name = "Ford"

identify(@ford)

Dim As Cabriolet porsche

porsche.name = "Porsche"

identify(@porsche)

Dim As Bike mountainbike

mountainbike.name = "Mountain Bike"

identify(@mountainbike)

Dim As Vehicle v

v.name = "some unknown vehicle"

identify(@v)

Dim As Object o

identify(@o)
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
