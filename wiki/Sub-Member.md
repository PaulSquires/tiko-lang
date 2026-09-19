[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Sub (Member)**

# Sub (Member)

Declares or defines a member procedure

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare [ Static | Const ] Sub fieldname [calling convention specifier] [ Alias external_name ] ( [ parameters ] ) [ Static ]
End { Type | Class | Union }
Sub typename.fieldname ( [ parameters ] ) [ Export ]
statements
End Sub
```

## Parameters

- `typename`
- `fieldname`
- `external_name`
- `parameters`
- `calling convention specifier`

## Description

`Sub` members are accessed with [`Operator . (Member Access)`](Operator-Member-Access) or [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access) to call a member procedure and may optionally accept parameters either [`ByVal`](Byval) or [`ByRef`](Byref-Parameters). `typename` be overloaded without explicit use of the [`Overload`](Overload) keyword.

 `typename` is the name of the type for which the `Sub` method is declared and defined. Name resolution for `typename` follows the same rules as procedures when used in a [`Namespace`](Namespace).

 A hidden [`This`](This) parameter having the same type as `typename` is passed to non-static member procedures. [`This`](This) is used to access the fields of the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union).  
 To access duplicated symbols defined as global outside the Type, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

 A [`Static (Member)`](Static-Member) may be declared using the `Static` specifier. A [`Const (Member)`](Const-Member) may be declared using the `Const` specifier.

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Class`](Class)
- [`Function (Member)`](Function-Member)
- [`Sub`](Sub)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type Statistics

  count As Single

  sum As Single

  Declare Sub AddValue( ByVal x As Single )

  Declare Sub ShowResults( )

End Type

Sub Statistics.AddValue( ByVal x As Single )

  count += 1

  sum += x

End Sub

Sub Statistics.ShowResults( )

  Print "Number of Values = "; count

  Print "Average          = ";

  If( count > 0 ) Then

    Print sum / count

  Else

    Print "N/A"

  End If

End Sub

Dim stats As Statistics

stats.AddValue 17.5

stats.AddValue 20.1

stats.AddValue 22.3

stats.AddValue 16.9

stats.ShowResults
```

 **Output:**

```freebasic
Number of Values =  4
Average          =  19.2
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** member

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
