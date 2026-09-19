[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Operator**

# Operator

Declares or defines an overloaded operator.

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare Operator Cast () [ ByRef ] As datatype
Declare Operator @ () [ ByRef ] As datatype Ptr
Declare Operator assignment_op ( [ ByRef | ByVal ] rhs As datatype )
Declare Operator [] ( index As datatype ) [ ByRef ] As datatype
Declare Operator New ( size As UInteger ) As Any Ptr
Declare Operator New[] ( size As UInteger ) As Any Ptr
Declare Operator Delete ( buf As Any Ptr )
```

## Parameters

- `typename`
- `assignment_op`
- `unary_op`
- `binary_op`

## Description

The built in operators like `=`, `+`, and `cast` have predefined behaviors when used in expressions. These operators can be overloaded to do something other than predefined operations when at least one of the arguments to the operator is a [`Type`](Type-Udt), [`Class`](Class), [`Enum`](Enum), or [`Union`](Union) data type.

 Operators are just functions. The operator '+' has functionality like `Function Plus( A as DataType, B as DataType ) as DataType`. See *[Operator Overloading](Operator-Overloading)* for more information. Operators can be overloaded to accept different data types as parameters. The [`Cast`](Operator-Cast) Operator is the only operator (or function) that can be declared multiple times when only the return type differs, but not the same as the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union) it is declared in (for not explicit usage, the compiler may decide which cast overload to call based on how the object is used).

 Non-static operator members are declared inside the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union). Global operators are declared outside. All operator definitions (procedure bodies) must appear outside.

 `Let`, `Cast`, and other assignment operators must be declared inside the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union). As all non-static member procedures, they have passed a hidden [`This`](This) parameter.

 Unary operators must be declared outside the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union) and have a return data type explicitly declared. Unary operators can be overloaded to return any valid data type, except for [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access) which must return a [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union) data type.

 Binary operators must be declared outside the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union) and have a return data type explicitly declared. Binary operators can be overloaded with valid data types, including for relational operators, which can also return any valid data type.

 [`Let`](Let) refers to the assignment operator, as in `LET a=b`. The [`Let`](Let) keyword is omitted in common practice, and is not allowed in the *[-lang fb](Compiler-Option-Lang)* dialect. However, [`Let()`](Operator-Let-Assignment) can be used to assign the fields of a UDT to multiple variables.

 See [`For`](Operator-for-Iteration), [`Step`](Operator-Step-Iteration), and [`Next`](Operator-Next-Iteration) for more information on overloading the [`For..Next`](For-Next) statement for use with user defined types.

 Although declared inside the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union), the member operators `New`, `New[]`, `Delete`, and `Delete[]` are always static, even if not explicitly declared ([`Static`](Static-Member) keyword is unnecessary but allowed).

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Class`](Class)
- [`Union`](Union)
- [`Type`](Type-Udt)
- [Coercion and Conversion](Coercion-and-Conversion)

## Examples

```freebasic
'' operator1.bas

Type Vector2D

  As Single x, y

  '' Return a string containing the vector data.

  Declare Operator Cast() As String

  '' Multiply the vector by a scalar.

  Declare Operator *= ( ByVal rhs As Single )

End Type

'' Allow two vectors to be able to be added together.

Declare Operator + ( ByRef lhs As Vector2D, ByRef rhs As Vector2D ) As Vector2D

'' Return the modulus (single) of the vector using the overloaded operator abs().

Declare Operator Abs (  ByRef rhs As Vector2D ) As Single

Operator Vector2D.cast () As String

  Return "(" + Str(x) + ", " + Str(y) + ")"

End Operator

Operator Vector2D.*= ( ByVal rhs As Single )

  This.x *= rhs

  This.y *= rhs

End Operator

Operator + ( ByRef lhs As Vector2D, ByRef rhs As Vector2D ) As Vector2D

  Return Type<Vector2D>( lhs.x + rhs.x, lhs.y + rhs.y )

End Operator

Operator Abs ( ByRef rhs As Vector2D ) As Single

  Return Sqr( rhs.x * rhs.x + rhs.y * rhs.y )

End Operator

Dim a As Vector2D = Type<Vector2D>( 1.2, 3.4 )

Dim b As Vector2D = Type<Vector2D>( 8.9, 6.7 )

Dim c As Vector2D = Type<Vector2D>( 4.3, 5.6 )

Print "a = "; a, "abs(a) ="; Abs( a )

Print "b = "; b, "abs(b) ="; Abs( b )

Print "a + b = "; a + b, "abs(a+b) ="; Abs( a + b )

Print "c = "; c, "abs(c) ="; Abs( c )

Print "'c *= 3'"

c *= 3

Print "c = "; c, "abs(c) ="; Abs( c )
```

 Small use case of the operator "\[\]": simplest smart pointers for byte buffers.

```freebasic
'' operator3.bas

'' A smart pointer is an object which behaves like a pointer but does more than a pointer:

'' - This object is flexible as a pointer and has the advantage of being an object,

''   like constructor and destructor called automatically.

'' - Therefore, the destructor of the smart pointer will be automatically called

''   when this object goes out of scope, and it will delete the user pointer.

'' Example of simplest smart pointers for byte buffers:

'' - Constructor and destructor allow to allocate, deallocate, and resize the byte buffer.

'' - Pointer index operator allows to access buffer elements.

'' - Copy-constructor and let-operator are just declared in private section,

''   in order to disallow copy construction and any assignment.

Type smartByteBuffer

  Public:

    Declare Constructor (ByVal size As UInteger = 0)

    Declare Operator [] (ByVal index As UInteger) ByRef As Byte

    Declare Destructor ()

  Private:

    Declare Constructor (ByRef rhs As smartByteBuffer)

    Declare Operator Let (ByRef rhs As smartByteBuffer)

    Dim As Byte Ptr psbb

End Type

Constructor smartByteBuffer (ByVal size As UInteger = 0)

  This.destructor()

  If size > 0 Then

    This.psbb = New Byte[size]

    Print "Byte buffer allocated"

  End If

End Constructor

Operator smartByteBuffer.[] (ByVal index As UInteger) ByRef As Byte

  Return This.psbb[index]

End Operator

Destructor smartByteBuffer ()

  If This.psbb > 0 Then

    Delete[] This.psbb

    This.psbb = 0

    Print "Byte buffer deallocated"

  End If

End Destructor

Scope

  Dim As smartByteBuffer sbb = smartByteBuffer(256)

  For I As Integer = 0 To 255

    sbb[I] = I - 128

  Next I

  Print

  For I As Integer = 0 To 255

    Print Using "#####"; sbb[I];

  Next I

  Print

End Scope
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
