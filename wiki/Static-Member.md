[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Static (Member)**

# Static (Member)

Declare a static member procedure or variable

## Syntax

```freebasic
Type typename
Static variablename As DataType [, ...]
Declare Static Sub|Function procedurename ...
...
End Type
Dim typename.variablename As DataType [= initializer] [, ...]
[Static] Sub|Function typename.procedurename ...
...
```

## Description

- Static member procedures

`Static` methods do not have an implicit [`This`](This) instance argument passed to them. This allows them to be used like normal non-member procedures (for example with callback procedure pointers). An advantage of `Static` methods are that they are encapsulated in the `typename` namespace, and therefore have the ability to access the [`Private`](Private-Access-Control) or [`Protected`](Protected-Access-Control) members or methods of instances of `typename`.

 `Static` methods can be called directly anywhere in code, like normal non-member procedures, or on objects of type `typename`, similar to non-static methods, however either way there is no implicit or explicit [`This`](This) (or explicit [`Base (Member Access)`](Base-Member-Access)) access possible from within a static method.

 For member procedures with a `Static` declaration, `Static` may also be specified on the corresponding procedure bodies, for improved code readability.

- Static member variables

`Static` member variables are created and initialized only once independently of any object construction, in contrast to non-static ("instance") member variables which are created again and again for each separate object. `Static` members are always [`Shared`](Shared), even if [`Shared`](Shared) was not specified in the declaration. Thus, `Static` member variables are similar to global variables, except that they are declared in a `Type` namespace.

 Each `Static` member variable declared in a Type must be explicitly allocated somewhere outside the type by using a [`Dim`](Dim) statement. The declaration inside the Type is the prototype that is visible to every module seeing the Type declaration. The definition outside the Type allocates and optionally initializes the `Static` member variable. There can only be one definition per `Static` member variable: it can only be allocated in a single module, not in multiple ones. This is the same as for [`Extern`](Extern) variables.

 A `Static` member variable is subject to member access control except for its definition outside the Type. If a private `Static` member variable is to be explicitly initialized outside the Type's member procedures, an initializer must be provided with the definition.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Class`](Class)
- [`Declare`](Declare)
- [`Type`](Type-Udt)
- [`Static`](procedures-Static)

## Examples

```freebasic
'' Example showing how the actual procedure invoked by a member can be set at runtime.

'' using static member procedures.

Type _Object

  Enum handlertype

    ht_default

    ht_A

    ht_B

  End Enum

  Declare Constructor( ByVal ht As handlertype = ht_default)

  Declare Sub handler()

Private:

  Declare Static Sub handler_default( ByRef obj As _Object )

  Declare Static Sub handler_A( ByRef obj As _Object )

  Declare Static Sub handler_B( ByRef obj As _Object )

  handler_func As Sub( ByRef obj As _Object )

End Type

Constructor _Object( ByVal ht As handlertype )

  Select Case ht

  Case ht_A

    handler_func = @_Object.handler_A

  Case ht_B

    handler_func = @_Object.handler_B

  Case Else

    handler_func = @_Object.handler_default

  End Select

End Constructor

Sub _Object.handler()

  handler_func(This)

End Sub

Sub _Object.handler_default( ByRef obj As _Object )

  Print "Handling using default method"

End Sub

Sub _Object.handler_A( ByRef obj As _Object )

  Print "Handling using method A"

End Sub

Sub _Object.handler_B( ByRef obj As _Object )

  Print "Handling using method B"

End Sub

Dim objects(1 To 4) As _Object => _

  { _

    _Object.handlertype.ht_B, _

    _Object.handlertype.ht_default, _

    _Object.handlertype.ht_A _

  }

  '' 4th array item will be _Object.handlertype.ht_default

For i As Integer = 1 To 4

  Print i,

  objects(i).handler()

Next i
```

```freebasic
'' Assign an unique ID to every instance of a Type (ID incremented in order of creation)

Type UDT

  Public:

    Declare Property getID () As Integer

    Declare Constructor ()

  Private:

    Dim As Integer ID

    Static As Integer countID

End Type

Dim As Integer UDT.countID = 0

Property UDT.getID () As Integer

  Property = This.ID

End Property

Constructor UDT ()

  This.ID = UDT.countID

  UDT.countID += 1

End Constructor

Dim As UDT uFirst

Dim As UDT uSecond

Dim As UDT uThird

Print uFirst.getID

Print uSecond.getID

Print uThird.getID
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** member

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
