[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option ByVal**

# Option ByVal

Specifies parameters are to be passed by value by default in procedure declarations

## Syntax

```freebasic
Option ByVal
```

## Description

`Option ByVal` is a statement that sets the default passing convention for procedure parameters to *by value*, as if declared with [`ByVal`](Byval). This default remains in effect for the rest of the module in which `Option ByVal` is used, and can be overridden by specifying [`ByRef`](Byref-Parameters) in parameter lists.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_BYVAL__`](Fb-Option-Byval)

## Examples

```freebasic
'' compile with the "-lang fblite" compiler switch

#lang "fblite"

Sub TestDefaultByref( a As Integer )

  '' change the value

  a = a * 2

End Sub

Option ByVal

Sub TestDefaultByval( a As Integer )

  a = a * 2

End Sub

Dim a As Integer = 1

Print "a = "; a

TestDefaultByref( a )

Print "After TestDefaultByref : a = "; a

Print

Print "a = "; a

TestDefaultByval( a )

Print "After TestDefaultByval : a = "; a

Print
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
