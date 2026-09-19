[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Destructor**

# Destructor

Called automatically when a class or user defined type goes out of scope or is destroyed

## Syntax

```freebasic
Type typename
field declarations
Declare Destructor ( )
End Type
Destructor typename ( ) [ Export ]
statements
End Destructor
```

## Parameters

- `typename`

## Description

The destructor method is called when a user defined [`Type`](Type-Udt) or [`Class`](Class) variable goes out of scope or is destroyed explicitly with the [`Delete Statement`](Operator-Delete-Statement) operator.

 `typename` is the name of the type for which the `Destructor` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 The `Destructor` method is passed a hidden [`This`](This) parameter having the same type as `typename`.

 The destructor in a type is called before the destructors on any of its fields. Therefore, all fields are accessible with the hidden [`This`](This) parameter in the destructor body.

 Only one destructor may be declared and defined per type (but several destructors can be called in a chained way if the type contains or inherits other types with their own destructors).

 Since the [`End`](End-Statement) statement does not close any scope, object destructors will not automatically be called if the [`End`](End-Statement) statement is used to terminate the program.

 `Destructor` can be also called directly from the `typename` instance like the other member methods ([`Sub`](Sub)) and with the same syntax, i.e. using a member access operator, e.g. `obj.Destructor()`. The object, and all its members, are assumed to be constructed and in a valid state, otherwise its effects are undefined and may cause crashes. This syntax is useful in cases where `obj` has been constructed manually, e.g. with `obj.Constructor()` or [`Placement New`](Operator-Placement-New).

## Remarks

### Dialect Differences

- Object-related features are supported only in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Class`](Class)
- [`Constructor`](Constructor)
- [`Delete Statement`](Operator-Delete-Statement)
- [`Destructor (Module)`](Destructor-Module)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type T

  value As ZString * 32

  Declare Constructor ( init_value As String )

  Declare Destructor ()

End Type

Constructor T ( init_value As String )

  value = init_value

  Print "Creating: "; value

End Constructor

Destructor T ()

  Print "Destroying: "; value

End Destructor

Sub MySub

  Dim x As T = ("A.x")

End Sub

Dim x As T = ("main.x")

Scope

  Dim x As T = ("main.scope.x")

End Scope

MySub
```

 Output:

```freebasic
Creating: main.x
Creating: main.scope.x
Destroying: main.scope.x
Creating: A.x
Destroying: A.x
Destroying: main.x
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
