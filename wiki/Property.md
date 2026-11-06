[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Property**

# Property

Declares or defines a property in a type or class

## Syntax

```freebasic
{ Type | Class } typename
Declare [ Static ] Property fieldname () [ ByRef ] As datatype
Declare [ Static ] Property fieldname ( [ ByRef | ByVal ] new_value As datatype )
Declare [ Static ] Property fieldname ( index_list ) [ ByRef ] As datatype
Declare [ Static ] Property fieldname ( index_list, [ ByRef | ByVal ] new_value As datatype )
Declare [ Static ] Property fieldname As datatype [ = initializer ] Get [, [ Private | Protected | Public ] { Set | Init } ]
End { Type | Class }

Property typename.fieldname [ ( index_list ) ] [ ByRef ] As datatype [ Export ]
statements
End Property

Property typename.fieldname [ ( index_list ) ] As datatype
[ Get
statements
End Get ]
[ Set
statements
End Set ]
End Property
```

`index_list` is one or more parameters, `[ ByRef | ByVal ] index As datatype [, ...]`.

## Parameters

- `typename`
- `fieldname`
- `new_value`
- `index_list`
- `initializer`

## Description

`Property` fields are used to get and set values of a [`Type`](Type-Udt) or [`Class`](Class) in the same way as other data fields except instead of a simple assignment to a field or a value retrieved from field, a procedure is executed.

 `typename` is the name of the type for which the `Property` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 A **Property** may have any number of `index` parameters. When indexed, properties are accessed as `fieldname(index1 [, index2 ...]) [ = value ]`, and a set-**Property** takes its `new_value` after the indices.  
 A **Property** without `index` parameter must always be used without empty parentheses after `fieldname`.  
 A get-**Property** can also return a reference by specifying `ByRef As return_type`.

 A hidden [`This`](This) parameter having the same type as `typename` is passed to the property procedure. [`This`](This) is used to access the fields of the [`Type`](Type-Udt) or [`Class`](Class).

### Static properties

 A **Property** declared `Static` has no [`This`](This): it belongs to the type, not to an object, like a [`Static`](Static-Member) member procedure. It is used as `typename.fieldname`, through any object of the type, or by its bare name inside the type's own procedures.

### Properties outside a type

 A **Property** may also be declared in a [`Namespace`](Namespace), or at module level, and defined as `Property namespace.fieldname ...` or `Property fieldname ...`. Its get and set procedures share the name, as a type's do, and it has no [`This`](This). It is used as `namespace.fieldname`, or by its bare name inside the namespace or after [`Using`](Using-Namespaces).

### Auto-properties

 A declaration that ends in an accessor list, `Get`, `Get, Set` or `Get, Init`, is an **auto-property**. The compiler gives it a hidden private field and writes both accessors itself: the getter returns the field, and the setter stores its value in the field. No accessor of an auto-property may be written by hand; a property that needs code of its own is an ordinary **Property** over a field of its own.

- `Get, Set` is read and written like a field.
- `Get, Private Set` (or `Protected Set`) may be read anywhere and written only where that access level allows. The setter may not be more visible than the getter.
- `Get` alone, and `Get, Init`, may be read anywhere and assigned only by the type's own constructors. A `Static` one is set by its `= initializer` only.
- `= initializer` gives the field its first value, as a field's initializer does.

 A `Static` auto-property keeps its value in a hidden static member of the type. One cannot be declared in a generic type.

### Property blocks

 A **Property** may be defined in one block that holds both accessors, a `Get` section and a `Set` section, each of which may be left out. The type still declares the get and set procedures in the usual way. Inside either section, **`value`** is the value crossing the boundary:

- In `Set`, `value` is the incoming value, typed as the property. It may be changed, as a `ByVal` parameter may.
- In `Get`, `value` is the result. It starts at the type's default (`0`, `""`), and whatever it holds is returned at the end of the section, or at `Exit Property`. A [`Return`](Return-From-Procedure) returns its own value instead.

 `Get` and `Set` start a section only when they stand alone on their line, so `Get #1, , buffer` in the body of an ordinary getter is still the file statement. A block's getter cannot return `ByRef`, and `property` may not be used inside a section: in a block it names a backing field, which a property written by hand does not have.

### Notes

 **Note:** Combination operators (as "+=", "*=", "shl=") work on a **Property** that has both a get and a set accessor: `obj.Size += 2` calls the getter, applies the operator and calls the setter. On a numeric **Property** the object and any index expression are evaluated once. On a string **Property** (`obj.Name &= "!"`, `+=`), they are evaluated once for the get and again for the set. On a result byref get-**Property** with no setter, the operators work on the referenced variable directly.

 **Note:** [`Swap`](Swap) works on a numeric or pointer **Property** with both accessors, on either side or both: it calls the two getters, then the two setters. A string or UDT **Property** cannot be swapped; swap through a temporary variable instead. A result byref get-**Property** with no setter swaps the variable it references.

 **Note:** The address of a **Property** (`@obj.Size`, `VarPtr( obj.Size )`) is only available from a result byref get-**Property**, where it is the address of the referenced variable. A get-**Property** that returns a value has no address.

 **Note:** The get and set accessors of one **Property** may be declared under different access sections, for example a `Public` getter and a `Private` setter. Each use is checked against the accessor it calls: an assignment against the setter, a read against the getter, a combination operator against both.

 **Note:** A **Property** passed to a [`ByRef`](Byref-Parameters) parameter is passed as a temporary holding the getter's value. When the parameter is not `Const` and the setter may be called at that point, the temporary is written back through the setter after the call returns, so `Inc( obj.Size )` changes `obj.Size`. This covers numeric, string and pointer properties, and UDT properties whose type needs no destructor. The object and any index expression are evaluated again for the set. Otherwise the temporary is simply discarded: for a `Const` parameter, a property with no setter, an init-only auto-property outside its type's constructors, and a `Private` or `Protected` setter used from outside the type.

 **Note:** When a get-**Property** is defined with `index` parameters, the `fieldname=` syntax can not be used to return a value. For such a get-**Property**, the `property=` syntax (in addition to the [`Return`](Return-From-Procedure) syntax) is only the one allowed.

## Remarks

### See also

- [`Class`](Class)
- [`Type`](Type-Udt)
- [`Static (Member)`](Static-Member)
- [`Namespace`](Namespace)
- [`Byref (Parameters)`](Byref-Parameters)

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

Auto-properties: a read/write one, one with a private setter and an initializer, and one assigned only by the constructor:

```freebasic
Type Person
  Declare Property Name As String Get, Set
  Declare Property Age As Long = 18 Get, Private Set
  Declare Property Id As Long Get, Init
  Declare Constructor( ByVal id_ As Long )
  Declare Sub Birthday()
End Type

Constructor Person( ByVal id_ As Long )
  Id = id_
End Constructor

Sub Person.Birthday()
  Age += 1
End Sub

Dim p As Person = Person( 42 )
p.Name = "Ann"
p.Birthday()
Print p.Name; p.Age; p.Id
```

 Output:

```freebasic
Ann 19 42
```

A property block: `value` is the incoming value in `Set` and the result in `Get`, and a get-only block may use [`Return`](Return-From-Procedure):

```freebasic
Type Temperature
  Private:
  c As Double
  Public:
  Declare Property Celsius() As Double
  Declare Property Celsius( ByVal value As Double )
  Declare Property Fahrenheit() As Double
End Type

Property Temperature.Celsius As Double
  Get
    value = c
  End Get
  Set
    If value < -273.15 Then value = -273.15
    c = value
  End Set
End Property

Property Temperature.Fahrenheit As Double
  Get
    Return c * 9 / 5 + 32
  End Get
End Property

Dim t As Temperature
t.Celsius = 100
Print t.Celsius; t.Fahrenheit
t.Celsius = -500
Print t.Celsius
```

 Output:

```freebasic
 100 212
-273.15
```

Two indices, a static auto-property, a property in a namespace, and a property passed to a `ByRef` parameter:

```freebasic
Type Grid
  Declare Property Cell( ByVal r As Long, ByVal c As Long ) As Long
  Declare Property Cell( ByVal r As Long, ByVal c As Long, ByVal value As Long )
  Declare Static Property Created As Long Get, Private Set
  Declare Constructor()
  cells( 0 To 2, 0 To 2 ) As Long
End Type

Constructor Grid()
  Created += 1
End Constructor

Property Grid.Cell( ByVal r As Long, ByVal c As Long ) As Long
  Return cells( r, c )
End Property

Property Grid.Cell( ByVal r As Long, ByVal c As Long, ByVal value As Long )
  cells( r, c ) = value
End Property

Namespace Settings
  Dim Shared As Long level_
  Declare Property Level() As Long
  Declare Property Level( ByVal value As Long )
End Namespace

Property Settings.Level() As Long
  Return level_
End Property

Property Settings.Level( ByVal value As Long )
  level_ = IIf( value > 10, 10, value )
End Property

Sub Bump( ByRef n As Long )
  n += 5
End Sub

Dim As Grid a, b
a.Cell( 1, 2 ) = 7
Bump( a.Cell( 1, 2 ) )
Print a.Cell( 1, 2 ); Grid.Created
Settings.Level = 50
Print Settings.Level
```

 Output:

```freebasic
 12 2
 10
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** property

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
