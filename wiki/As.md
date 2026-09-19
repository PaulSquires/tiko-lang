[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **As**

# As

Part of a declaration which specifies a data type, or part of the Open statement which specifies a file handle.

## Syntax

```freebasic
symbolname As datatype
Open ... As #filenumber
Type ... As datatype
```

## Description

`As` is used to declare the type of variables, fields or arguments and is also used in the [`Open`](Open) statement to determine the file handle. `As` is also used with the [`Type (Alias)`](Type-Alias) syntax, similar to C's typedef statement.

## Remarks

### Differences from QB

- The [Type (Alias)](Type-Alias) syntax was not supported in QB.

### See also

- [`Declare`](Declare)
- [`Dim`](Dim)
- [`Type`](Type-Udt)
- [`Open`](Open)

## Examples

```freebasic
'' don't try to compile this code, the examples are unrelated

Declare Sub mySub (X As Integer, Y As Single, Z As String)

' ...

Dim X As Integer

' ...

Type myType

  X As Integer

  Y As Single

  Z As String

End Type

' ...

Type TheNewType As myType

' ...

Open "test" For Input As #1

' ...
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
