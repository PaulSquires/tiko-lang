[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Byref (Variables)**

# Byref (Variables)

Declares a reference

## Syntax

```freebasic
(Dim | Static) [Shared] ByRef name1 As DataType = variable1 [, ByRef name2 As DataType = variable2, ...]
(Dim | Static) [Shared] ByRef As DataType name1 = variable1 [, name2 = variable2, ...]
[Static] Var [Shared] ByRef name1 = variable1 [, ByRef name2 = variable2, ...]
```

## Parameters

- `name`
- `variable`

## Description

Declares a reference (by name) to a variable.

 A reference is an entity that is a way to access data located in memory. A reference is not the data itself but only information about its location. A reference can be thought of as a pointer that is implicitly dereferenced. In many cases, it can be used as an alternative to pointer.

 A reference must always be initialized with a variable when it is created.  
 DataType must be the same type as that of the variable, or a compatible type (for example one from the types of its Bases in case of inheritance):

For example, a base type reference referring to a derived type object allows to activate polymorphism when a virtual method is called on it, similarly to a base type pointer referring to a derived type object. One can do the same operations through such a reference as one can do with a dereferenced pointer of same type (but for both not the same operations as using directly the derived type instance).

A reference can be reassigned to refer to another variable (of compatible type) by doing:

@*refname* = @*othervariable*

NOTE: The arrays of references and the non-static reference fields for UDT are not supported yet.

## Remarks

### Dialect Differences

- Only supported in *[-lang fb](Compiler-Option-Lang)*, *[-lang fblite](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC.

### See also

- [`Dim`](Dim)
- [`Static`](procedures-Static)
- [`Var`](Var)
- [`Shared`](Shared)
- [`Byref (Parameters)`](Byref-Parameters)
- [`Byref (Function Results)`](Byref-Function-Results)

## Examples

```freebasic
'' Comparison between:

''   - a copy ('ci') of a variable ('i')

''   - a reference ('ri') to a variable ('i')

Dim As Integer i = 12

Print @i, i

Dim As Integer ci = i  '' or Var ci = i

Print @ci, ci

Dim ByRef As Integer ri = i  '' or Var Byref ri = i

Print @ri, ri

Print

Print i, ci, ri

i = 34

Print i, ci, ri

ci = 56

Print i, ci, ri

ri = 78

Print i, ci, ri

Sleep
```

```freebasic
'' Use reference allows to simplify expressions compared to pointer

'' (avoid to use operator '@' and especially '*')

Function fp () As ZString Ptr

    Static As ZString * 256 z

    Return @z

End Function

Dim As ZString Ptr pz = fp()

*pz = "FreeBASIC Zstring Ptr"

Print *pz

*pz &= " 1.3.0"

Print *pz

Print

Function fr () ByRef As ZString

    Static As ZString * 256 z

    Return z

End Function

Dim ByRef As ZString rz = fr()  '' or Var Byref rz = fr()

rz = "FreeBASIC Zstring Ref"

Print rz

rz &= " 1.4.0"

Print rz

Sleep
```

```freebasic
'' It is possible to reassign a reference.

'' An example with an UDT to control the successive constructions & destructions of objects handled with one only reference.

Type UDT

  Declare Constructor ()

  Declare Destructor ()

  Dim As Integer I

End Type

Constructor UDT ()

  Static As Integer nb

  nb += 1

  This.I = nb

  Print "UDT.Constructor()"

End Constructor

Destructor UDT ()

  Print "UDT.Destructor()"

End Destructor

Var ByRef ru = *New UDT  '' or Dim Byref As UDT ru = *New UDT

Print ru.I

Delete @ru

Print

@ru = New UDT

Print ru.I

Delete @ru

Sleep
```

```freebasic
'' Polymorphism (by using inheritance and virtuality) can be activated through any of the 3 following kinds of entities:

''   - base-type pointers referring to derived-type objects,

''   - dereferenced base-type pointers referring to derived-type objects,

''   - base-type references referring to derived-type objects.

'

'' If in the first line of the below code, FALSE is put instead TRUE, the polymorphism by virtuality is no more activated.

#define virtuality True

Type myBase Extends Object

  #if virtuality = True

    Declare Virtual Sub hello()

  #else

    Declare Sub Hello()

  #endif

End Type

Sub myBase.hello()

  Print "myBase.hello()"

End Sub

Type myDerived Extends myBase

  Declare Sub hello()

End Type

Sub myDerived.hello()

  Print "myDerived.hello()"

End Sub

Dim As myBase mb

Dim As myBase Ptr pmb = @mb

Dim ByRef As myBase rmb = mb  '' or Var Byref rmb = mb

pmb->hello()    '' pmb is a base-type pointer referring to a base-type object

(*pmb).hello()  '' *pmb is a dereferenced base-type pointer referring to a base-type object

rmb.hello()     '' rmb is a base-type reference referring to a base-type object

Print

Dim As myDerived md

Dim As myBase Ptr pmd = @md

Dim ByRef As myBase rmd = md  '' only syntax because the reference data-type must be different from the one of object

pmd->hello()    '' pmd is a base-type pointer referring to a derived-type object

(*pmd).hello()  '' *pmd is a dereferenced base-type pointer referring to a derived-type object

rmd.hello()     '' rmd is a base-type reference referring to a derived-type object

Sleep
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
