[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **(Print | ?) #**

# (Print | ?) #

Writes a list of values to a file or device

## Syntax

```freebasic
(Print | ?) # filenum, [ expressionlist ] [ , | ; ]
```

## Parameters

- `filenum`
- `expressionlist`

## Description

`Print #` outputs a list of values to a text file or device. Numeric values are converted to their string representation, with left padding for the sign. Objects of user-defined types must overload `Operator Cast () As String`.

 Consecutive values in the expression list are separated either by a comma (`,`) or semicolon (`;`). A comma indicates printing should take place at the next 14 column boundary, while a semicolon indicates values are printed with no space between them.

 A new-line character is printed after the values in the expression list unless the expression list is followed by a comma or semicolon.

 Note that the comma (`,`) immediately following the file number is still necessary, even the expression list is empty. In this case a new-line is printed, just as with a normal expression list that doesn't have a comma or semicolon at the end.

 **Note:**

**-** Using **`Print #`** is naturally dedicated to Output/Append Access file mode.
 **-** It is also allowed in Binary/Random Access file mode, but this was never well tested and results may vary.

## Remarks

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, an extra space is printed after numbers.

### Differences from QB

- None, when using QBASIC's variable types in *[-lang qb](Compiler-Option-Lang)*.
- Unsigned numbers are printed without a space before them.
- QB did not support casting for UDTs, so didn't allow them to be `Print`ed.

### See also

- [`Print Using`](Print-Using)
- [`? Using`](Print-Using)
- [`Print`](Print)
- [`?`](Print)
- [`Write #`](procedures-Write)
- [`Open`](Open)

## Examples

```freebasic
Open "bleh.dat"  For Output As #1

    Print #1, "abc def"

    Print #1, 1234, 5678.901, "xyz zzz"

    Close #1
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
