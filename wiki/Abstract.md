[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Abstract**

# Abstract

Declare abstract methods

## Syntax

```freebasic
Type typename Extends base_typename
Declare Abstract Sub|Function|Property|Operator ...
End Type
```

## Description

`Abstract` is a special form of [`Virtual`](Virtual). The difference is that abstract methods do not have a body, but just the declaration. Essentially this allows the declaration of an interface which can be implemented by various derived types.

 In order to call an abstract method, it must have been overridden and implemented by a derived data type, or else the program will abort.  
 As a result, only types that implement all the abstract methods are allowed to create objects. For the same reason, a constructor should not call an unimplemented method.

 [Constructors](Constructor) cannot be abstract, since they cannot be virtual. In addition, abstract [Destructors](Destructor) are not supported either, because a destructor body (no matter whether implicit or explicit) is needed in order to call base and field destructors.

 Abstracts are called "pure virtual" in C++ (unlike FreeBASIC, C++ allows pure virtuals to have a body, but accessible only statically).

 **Note:** In a multi-level inheritance, a same named method (same identifier and signature) can be declared `Abstract`, [`Virtual`](Virtual) or normal (without specifier) at each inheritance hierarchy level. When there is mixing of specifiers, the usual order is abstract -> virtual -> normal, from top to bottom of the inheritance hierarchy.
 The access control ([`Public`](Public-Access-Control)/[`Protected`](Protected-Access-Control)/[`Private`](Private-Access-Control)) of an overriding method is not taken into account by the internal polymorphism process, but only for the initial call at compile-time.  
 A derived static method cannot override a base virtual/abstract method, but can shadow any base method (including virtual/abstract).

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Virtual`](Virtual)
- [`Type`](Type-Udt)
- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Object`](Object)
- [`Override`](Override)

## Examples

```freebasic
Type Hello Extends Object

    Declare Abstract Sub hi( )

End Type

Type HelloEnglish Extends Hello

    Declare Sub hi( )

End Type

Type HelloFrench Extends Hello

    Declare Sub hi( )

End Type

Type HelloGerman Extends Hello

    Declare Sub hi( )

End Type

Sub HelloEnglish.hi( )

    Print "hello!"

End Sub

Sub HelloFrench.hi( )

    Print "Salut!"

End Sub

Sub HelloGerman.hi( )

    Print "Hallo!"

End Sub

    Randomize( Timer( ) )

    Dim As Hello Ptr h

    For i As Integer = 0 To 9

        Select Case( Int( Rnd( ) * 3 ) + 1 )

        Case 1

            h = New HelloFrench

        Case 2

            h = New HelloGerman

        Case Else

            h = New HelloEnglish

        End Select

        h->hi( )

        Delete h

    Next
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
