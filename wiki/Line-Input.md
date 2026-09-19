[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Line Input #**

# Line Input #

Reads one line of text from a file

## Syntax

```freebasic
Line Input #file number, string_variable_1
Line Input #file number, string_variable_2 , max_length
```

## Parameters

- `file number`
- `string_variable_1`
- `string_variable_2`
- `max_length`

## Description

Reads a line from an open text file (opened for [`Input`](Input-File-Mode) through a bound file number) and stores it in a string variable.

 A line of text ends at, but does not include the end of line characters. An end of line character may be the `LF` character (`Chr(10)`) or the `CRLF` character pair (`Chr(13,10)`).

 Two syntaxes are available:

**Note:**

**-** Using **`Line Input #`** is naturally dedicated to Input Access file mode.
 **-** It is also allowed in Binary/Random Access file mode, but this was never well tested and results may vary.

## Remarks

### Version

- Before fbc 1.10.0, the second syntax (with `max_length` parameter) was not supported.

### Differences from QB

- None

### See also

- [`Line Input`](procedures-Line-Input)
- [`Input #`](Input)
- [`Open`](Open)
- [`Input (File Mode)`](Input-File-Mode)

## Examples

```freebasic
Open "myfile.txt" For Output As #1

Print #1, "Hello, World"

Close #1

Dim s As String

Open "myfile.txt" For Input As #1

Line Input #1, s

Close #1

Print "'" & s & "'"

Const maxlength = 6  '' max 5 characters plus 1 null terminal character

Dim pz As ZString Ptr = CAllocate(maxlength, SizeOf(ZString))

Open "myfile.txt" For Input As #1

Line Input #1, *pz, maxlength

Close #1

Print "'" & *pz & "'"

Deallocate(pz)
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
