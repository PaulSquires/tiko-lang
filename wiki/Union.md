[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Union**

# Union

Declares a union user defined type.

## Syntax

```freebasic
Union typename
fieldname as datatype
Declare member function declaration ...
...
End Union
```

## Parameters

- `typename`
- `fieldname`
- `member function declaration`

## Description

The data elements of a `Union` occupy a common space in memory (same memory address for all data elements of the `Union`). A data element of a `Union` can be a simple data field or an anonymous [`Type`](Type-Udt) block of data fields.  
 The size of the `Union` is the size of the largest data element.  
 Since they occupy a common memory space, only one data element can usually be used at a given time (when a given data element is written, the other data elements sharing the common union space may be overwritten or mutilated).

 Like [`Type`](Type-Udt), `Union` can use the optional `Field = number` specifier for field alignment, and supports also inheritance through the use of the [Extends](Extends) keyword.  
 Unlike [`Type`](Type-Udt), `Union` can not contain variable-length strings and arrays, and more generally can not have object fields (or bases) with constructors or destructors. Therefore, `Union` does not support to inherit from the [`Object`](Object) built-in type.

 A `Union` supports member procedures including [`Constructor`](Constructor), [`Destructor`](Destructor), [`Function`](Function-Member), [`Operator`](Operator), [`Property`](Property) and [`Sub`](Sub-Member). All members of a `Union` are public and access modifiers are not supported.

 Initializer elements for UNION's should pair with only the first member of the UNION and skip the rest.

 A `Union` can also contain nested Types or Unions, of different kinds:

**-** Nested Anonymous Type/Union allows data members to be grouped as desired.
 **-** Anonymous Type or Anonymous Union can be nested on condition of alternating their nesting.
 **-** Nested Anonymous Type/Union can not have procedure members or static data members (same restriction than for a local scope named Type/Union).

**-** Nested Named Type/Union allows declaration of an inner structure inside a (named) Type/Union namespace and according to the access right of the place
 **-** Mostly everything it can be done in a Named Type/Union can also be done in a Nested Named Type/Union.
 **-** When there are circular dependencies between Types/Unions, Nested Named Type/Union usage can avoid using type aliases and forward referencing.

**-** Nested Type-Def allows declaration of an inner Type (Alias) inside a Type/Union and according to the access right of the place.

The main structure (Type/Union) must be always named, the other (nested) structures can be anonymous or named.

 A `Union` can be passed in a similar way of a User Defined Type to overloaded operator procedures.

 **Note:** When `Union` extends a base, it can be confusing because no new fields are added to the base, but instead the base is added to the derived Union. This means that data elements in the derived Union can share the same memory space like the base (here it doesn't matter whether the base is a `Union` or not). Of course it can be dangerous, but that is always the problem with Unions.
 If only the base is a `Union`, then it won't be affected by data elements from the derived UDT.  
 Since `Union` is not allowed to have complex data elements (i.e. UDTs with constructor/destructor, or dynamic strings), a derived Union can not be allowed to have (contain) a complex base.

 **Note:** Since fbc version 1.20.0, unions containing STRING\*N fields will initialize to spaces if the first field is a STRING\*N type, otherwise will initialize to zero (as for a STRING\*N field before fbc version 1.20.0).

## Remarks

### Version

- Since fbc 1.10.0: Nested Named Type/Union capability added.

### Dialect Differences

- Object-related features as functions defined inside the `Union` block are supported only in the *[-lang fb](Compiler-Option-Lang)* dialect.
  Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Union`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)
- [Coercion and Conversion](Coercion-and-Conversion)

## Examples

```freebasic
' Example 0: Little-endianness

' For larger integer values (as the following Ulong data type),

'   bytes are arranged in memory in 'little-endian' byte order

'   (the least significant byte gets stored first).

Union UDU

   ul As ULong      ' 32-bit data type

   Type

      ub0 As UByte  ' 8-bit data type

      ub1 As UByte  ' 8-bit data type

      ub2 As UByte  ' 8-bit data type

      ub3 As UByte  ' 8-bit data type

   End Type

End Union

Dim As UDU u

u.ul = &h12345678

Print Hex(u.ul)                                       ' Result: 12345678

Print Hex(u.ub3), Hex(u.ub2), Hex(u.ub1), Hex(u.ub0)  ' Result: 12   34   56   78

Sleep
```

```freebasic
' Example 1: Only one union member can be relevantly accessed at a time

Union member

  username As String * 32

  posts As ULong

End Union

Dim As member userX

userX.username = "Samantha"

userX.posts = 1234

Print userX.username  ' value of username corrupted because final value assigned to posts occupies same memory location

'                     ' (and this is reason that value of posts is displayed well)

Print userX.posts

Print

Dim As member userY

userY.posts = 4321

userY.username = "Alexander"

Print userY.username

Print userY.posts  ' value of posts corrupted because final value assigned to username occupies same memory location

'                  ' (and this is reason that value of username is displayed well)

Print

Sleep
```

```freebasic
' Example 2: Alternative to RGBA keyword and allowing to retrieve elementary colors values

Union BGRA_UNION

   colour As ULong

   Type

      blue  As UByte

      green As UByte

      red   As UByte

      Alpha As UByte

   End Type

End Union

Dim ubgra As BGRA_UNION

' Setting the individual color values...

ubgra.red = &h33

ubgra.green = &hcc

ubgra.blue = &h66

' We can get a ULONG value

Print Hex(ubgra.colour)  ' Result: 33CC66

Print

' Setting a ULONG value...

ubgra.colour = &h228844

' We can get the individual color values

Print Hex(ubgra.red)    ' Result: 22

Print Hex(ubgra.green)  ' Result: 88

Print Hex(ubgra.blue)   ' Result: 44

Print

Sleep
```

```freebasic
' Example 3.

' Define a simple union.

Union AUnion

    a As UByte

    b As UInteger

End Union

' Define a composite type with an unnamed union.

Type CompType

    s As String * 20

    ui As UByte 'Flag to tell us what to use in union.

    Union

        au As UByte

        bu As UInteger

    End Union

End Type

' Flags to let us know what to use in union,

' because it's relevant to only use a single element of a union at a given time.

Const IsInteger = 1

Const IsUByte = 2

Dim MyUnion As AUnion

Dim MyComposite As CompType

' Only one field within the union is set, without choice criterion.

MyUnion.a = 128

MyComposite.s = "Type + Union"

MyComposite.ui = IsInteger ' Tells us this is an integer union.

MyComposite.bu = 1500      ' Field set according to the above flag.

Print "Simple Union: ";MyUnion.a

Print MyComposite.s & ": ";

If MyComposite.ui = IsInteger Then

    Print MyComposite.bu

ElseIf MyComposite.ui = IsUByte Then

    Print MyComposite.au

Else

    Print "Unknown Type."

End If

Print

Sleep
```

```freebasic
' Example 4: Using Nested Named Union

Type T

    Union U

        a As Short

        Type

            b1 As Byte

            b2 As Byte

        End Type

        Declare Sub proc(ByVal _b1 As Byte, ByVal _b2 As Byte)

    End Union

    m As U

    Declare Sub proc()

End Type

Sub T.U.proc(ByVal _b1 As Byte, ByVal _b2 As Byte)

    This.b1 = _b1

    This.b2 = _b2

End Sub

Sub T.proc()

    Print This.m.b1, This.m.b2, This.m.a

End Sub

Dim x As T

x.m.proc(1, 2)

x.proc()

Sleep
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
