[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Extends Zstring**

# Extends Zstring

Specifies a type which inherits a Zstring behavior

## Syntax

```freebasic
Type|Union typename Extends Zstring [, base_typename]
...
End Type|Union
```

## Description

`Extends Zstring` declares `typename` to inherit properties and behaviors of a [`ZString`](Zstring). Purpose is to allow users to create custom string types (with i.e. dynamic memory management) that can integrate well in to existing fbc compiler built ins (good interoperability with fbc's [`ZString`](Zstring) type).

 This declaration of such a UDT with a suitable [`Cast`](Operator-Cast) operator will instruct compiler to convert the UDT to a [`ZString`](Zstring) (in addition, other suitable operators as [`Let`](Operator-Let-Assign), [`[] (Pointer Index)`](Operator-Pointer-Index), [`Len`](Len), ..., can be also declared).

 [`ZString`](Zstring) behaviour can be inherited directly, or indirectly and singly from a base-type.  
 [`ZString`](Zstring) behaviour can be inherited by a UDT also extending `base_typename` (a kind of pseudo multiple-inheritance).

 By declaring a type (directly or indirectly) as `Extends Zstring` (in addition to defining a suitable [`Cast`](Operator-Cast) operator only), this promotes it fully [`ZString`](Zstring) type compatible, even with [`StrPtr`](Operator-Strptr-String-Pointer)/[`SAdd`](Sadd), [`LSet`](Lset)/[`RSet`](Rset), and [`Select Case`](procedures-Select-Case).

## Remarks

### Version

- Before fbc 1.09.0, this promotion was not yet fully [`ZString`](Zstring) type compatible with the built in functions [`Val`](Val)/[`ValInt`](Valint)/[`ValLng`](Vallng)/[`ValUInt`](Valuint)/[`Valunlg`](Valulng) and [`Left`](Left)/[`Right`](Right).
  Since fbc 1.07.0

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Extends __Zstring`, but unusable because no member procedure is allowed in this dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)
- [`Union`](Union)
- [`Extends`](Extends)
- [`ZString`](Zstring)
- [`Extends Wstring`](Extends-Wstring)

## Examples

```freebasic
Type myZstring Extends ZString

  Public:

    Declare Constructor (ByRef z As Const ZString = "")

    Declare Operator Cast () ByRef As Const ZString

    Declare Operator Let (ByRef z As Const ZString)

  Private:

    Dim As String s

End Type

Constructor myZstring (ByRef z As Const ZString = "")

  This.s = z

End Constructor

Operator myZstring.Cast () ByRef As Const ZString

  Return *StrPtr(This.s)

End Operator

Operator myZstring.Let (ByRef z As Const ZString)

  This.s = z

End Operator

Dim As myZstring z = "FreeBASIC"

Print "'" & z & "'"

z &= " compiler"

Print "'" & z & "'"

Sleep
```

```freebasic
Type vZstring Extends ZString

  Public:

    Declare Constructor (ByVal pz As Const ZString Ptr = 0)

    Declare Operator Cast () ByRef As ZString

    Declare Operator Let (ByVal pz As Const ZString Ptr)

    Declare Operator [] (ByVal index As Integer) ByRef As UByte

    Declare Destructor ()

  Private:

    Dim As ZString Ptr p

    Dim As UInteger l

End Type

Constructor vZstring (ByVal pz As Const ZString Ptr = 0)

  This.l = Len(*pz)

  This.p = CAllocate(This.l + 1, SizeOf(ZString))

  *This.p = *pz

End Constructor

Operator vZstring.Cast () ByRef As ZString

  Return *This.p

End Operator

Operator vZstring.Let (ByVal pz As Const ZString Ptr)

  If This.l < Len(*pz) Then

    Deallocate(This.p)

    This.l = Len(*pz)

    This.p = CAllocate(This.l + 1, SizeOf(ZString))

  End If

  *This.p = *pz

End Operator

Operator vZstring.[] (ByVal index As Integer) ByRef As UByte

  Return This.p[index]

End Operator

Destructor vZstring ()

  Deallocate(This.p)

End Destructor

Operator Len (ByRef v As vZstring) As Integer

  Return Len(Type<String>(v))        '' found nothing better than this

End Operator                         ''     (or: 'Return Len(Str(v))')

Dim As vZstring v = "FreeBASIC"

Print "'" & v & "'", Len(v)

Dim As ZString * 256 z

z = *StrPtr(v)                       '' 'error 24: Invalid data types' without 'Extends Zstring'

Print "'" & z & "'", Len(z)

v &= Space(2)

Print "'" & v & "'", Len(v)

RSet v, "FreeBASIC"                  '' 'error 24: Invalid data types' without 'Extends Zstring'

Print "'" & v & "'", Len(v)          ''     ('Cast' must return a modifiable reference)

Select Case v                        '' 'error 24: Invalid data types' without 'Extends Zstring'

Case Type<vZstring>(Trim(v) & "  ")

  Print "Left justified"

Case Type<vZstring>("  " & Trim(v))

  Print "Right justified"

End Select

v[0] = Asc("-")

Print "'" & v & "'", Len(v)

Print "'" & Right(v, 5) & "'"        '' since fbc 1.09.0, 'Right' supports types with 'Extends Zstring'

'Print "'" & Right(Str(v), 5) & "'"  '' before fbc 1.09.0, use this workaround (or: 'Right(Type<String>(v), 5)')

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
