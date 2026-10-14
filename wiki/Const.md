[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Const**

# Const

Non-modifiable variable declaration.

## Syntax

```freebasic
Const symbolname1 [AS DataType] = value1 [, symbolname2 [AS DataType] = value2, ...]
Const [AS DataType] symbolname1 = value1 [, symbolname2 = value2, ...]
```

## Description

Declares non-modifiable constant data that can be integer or decimal (floating-point) numbers or strings. The constant type will be inferred if `DataType` isn't explicitly given.

 Specifying [`String * Size`](String), [`Zstring * Size`](Zstring) or [`Wstring * Size`](Wstring) as `DataType` is not allowed.  
 Specifying [`String`](String) as `DataType` is tolerated but without effect because the resulting type is always a [`Zstring * Size`](Zstring).

 Constants follow visibility rules similar to those of variables for Namespace blocks, Type blocks, and compound block statements.

## Remarks

### Differences from QB

- QB does not support the [`As`](As) `datatype` syntax.

### See also

- [`#define`](Define)
- [`Const (Qualifier)`](Const-Qualifier)
- [`Const (Member)`](Const-Member)
- [`Enum`](Enum)
- [`Var`](Var)

## Examples

```freebasic
Const Red = RGB(252, 2, 4)

Const Black As UInteger = RGB(0, 0, 0)

Const Text = "This is red text on a black bkgnd."

Locate 1, 1

Color Red, Black

Print Text

Sleep

End
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
