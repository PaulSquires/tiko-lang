[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Function (Member)**

# Function (Member)

Declares or defines a member procedure returning a value

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare [ Static | Const ] Function fieldname [calling convention specifier] [ Alias external_name ] ( [ parameters ] ) [ ByRef ] As datatype [ Static ]
End { Type | Class | Union }
Function typename.fieldname ( [ parameters ] ) [ ByRef ] As datatype [ Export ]
statements
End Function
```

## Parameters

- `typename`
- `fieldname`
- `external_name`
- `parameters`
- `calling convention specifier`

## Description

`Function` members are accessed with [`Operator . (Member Access)`](Operator-Member-Access) or [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access) to call a member procedure that returns a value (a reference can also be returned by specifying `Byref As return_type`). The procedure may optionally accept parameters either [`ByVal`](Byval) or [`ByRef`](Byref-Parameters). `typename` be overloaded without explicit use of the [`Overload`](Overload) keyword.

 `typename` is the name of the type for which the `Function` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 A hidden [`This`](This) parameter having the same type as `typename` is passed to non-static member procedures. [`This`](This) is used to access the fields of the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union).  
 To access duplicated symbols defined as global outside the Type, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

 A [`Static (Member)`](Static-Member) may be declared using the `Static` specifier. A [`Const (Member)`](Const-Member) may be declared using the `Const` specifier.

 As for a normal [`Function`](procedures-Function), the return value of a `Function` member can be ignored in the calling code.

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Class`](Class)
- [`Function`](procedures-Function)
- [`Sub (Member)`](Sub-Member)
- [`Type`](Type-Udt)

## Examples

```freebasic
#include "vbcompat.bi"

Type Date

  value As Double

  Declare Static Function Today() As Date

  Declare Function Year() As Integer

  Declare Function Month() As Integer

  Declare Function Day() As Integer

End Type

Function Date.Today() As Date

  Return Type(Now())

End Function

Function Date.Year() As Integer

  Return ..Year(value)

End Function

Function Date.Month() As Integer

  Return ..Month(value)

End Function

Function Date.Day() As Integer

  Return ..Day(value)

End Function

Dim d As Date = Date.Today

Print "Year  = "; d.Year

Print "Month = "; d.Month

Print "Day   = "; d.Day
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** member

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
