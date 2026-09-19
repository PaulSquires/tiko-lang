[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Property**

# Property

Declares or defines a property in a type or class

## Syntax

```freebasic
{ Type | Class } typename
Declare Property fieldname () [ ByRef ] As datatype
Declare Property fieldname ( [ ByRef | ByVal ] new_value As datatype )
Declare Property fieldname ( [ ByRef | ByVal ] index As datatype ) [ ByRef ] As datatype
Declare Property fieldname ( [ ByRef | ByVal ] index As datatype, [ ByRef | ByVal ] new_value As datatype )
End { Type | Class }
Property typename.fieldname () [ ByRef ] As datatype [ Export ]
statements
```

## Parameters

- `typename`
- `fieldname`
- `new_value`
- `index`

## Description

`Property` fields are used to get and set values of a [`Type`](Type-Udt) or [`Class`](Class) in the same way as other data fields except instead of a simple assignment to a field or a value retrieved from field, a procedure is executed.

 `typename` is the name of the type for which the `Property` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 A **Property** may optionally have one `index` parameter. When indexed, properties are accessed as `fieldname(Index) [ = value ]`.  
 A **Property** without `index` parameter must always be used without empty parentheses after `fieldname`.  
 A get-**Property** can also return a reference by specifying `ByRef As return_type`.

 A hidden [`This`](This) parameter having the same type as `typename` is passed to the property procedure. [`This`](This) is used to access the fields of the [`Type`](Type-Udt) or [`Class`](Class).

 **Note:** A standard **Property** (get & set) does not work with combination operators (as "+="). But a result byref get-**Property** (as more generally any result byref function) works with combination operators.

 **Note:** When a get-**Property** is defined with one `index` parameter, the `fieldname=` syntax can not be used to return a value. For such a get-**Property**, the `property=` syntax (in addition to the [`Return`](Return-From-Procedure) syntax) is only the one allowed.

## Remarks

### See also

- [`Class`](Class)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type Vector2D

  As Single x, y

  Declare Operator Cast() As String

  Declare Property Length() As Single

  Declare Property Length( ByVal new_length As Single )

End Type

Operator Vector2D.cast () As String

  Return "(" + Str(x) + ", " + Str(y) + ")"

End Operator

Property Vector2D.Length() As Single

  Length = Sqr( x * x + y * y )

End Property

Property Vector2D.Length( ByVal new_length As Single )

  Dim m As Single = Length

  If m <> 0 Then

    '' new vector = old / length * new_length

    x *= new_length / m

    y *= new_length / m

  End If

End Property

Dim a As Vector2D = ( 3, 4 )

Print "a = "; a

Print "a.length = "; a.length

Print

a.length = 10

Print "a = "; a

Print "a.length = "; a.length
```

 Output:

```freebasic
a = (3, 4)
a.length =  5

a = (6, 8)
a.length =  10
```

Property Indexing:

```freebasic
'' True/False

Namespace BOOL

  Const False = 0

  Const True = Not False

End Namespace

Type BitNum

  Num As UInteger

    '' Get/Set Properties each with an Index.

  Declare Property NumBit( ByVal Index As Integer ) As Integer

  Declare Property NumBit( ByVal Index As Integer, ByVal Value As Byte )

End Type

  '' Get a bit by it's index.

Property BitNum.NumBit( ByVal Index As Integer ) As Integer

  Return Bit( This.Num, Index )

End Property

  '' Set a bit by it's index.

Property BitNum.NumBit( ByVal Index As Integer, ByVal Value As Byte )

    '' Make sure index is in Integer range.

  If Index >= ( SizeOf(This.Num) * 8 ) Then

    Print "Out of uInteger Range!"

    Exit Property

  Else

    If Index < 0 Then Exit Property

  End If

  If Value = BOOL.FALSE Then

    This.Num = BitReset( This.Num, Index )

  End If

  If Value = BOOL.TRUE Then

    This.Num = BitSet( This.Num, Index )

  End If

End Property

Dim As BitNum Foo

Print "Testing property indexing with data types:"

Print "FOO Number's Value: " & Foo.Num

  '' Set the bit in the number as true.

Foo.NumBit(31) = BOOL.TRUE

Print "Set the 31st bit of FOO"

  '' Print to see if our bit has been changed.

Print "FOO Number's Value: " & Foo.Num

Print "FOO 31st Bit Set? " & Foo.NumBit(31)

Sleep

Print ""
```

 Output:

```freebasic
Testing property indexing with data types:
FOO Number's Value: 0
Set the 31st bit of FOO
FOO Number's Value: 2147483648
FOO 31st Bit Set? -1
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** property

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
