[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Write #**

# Write #

Outputs a comma-separated list of values to a text file or device

## Syntax

```freebasic
Write # filenum , [ expressionlist ]
```

## Parameters

- `filenum`
- `expressionlist`

## Description

Outputs the values in `expressionlist` to the text file or device bound to `filenum`. The values are separated with commas, and strings are enclosed in double quotes. Numeric values greater than zero (`0`) and less than one (`1`) are prefixed with a zero (`0`) if none is given (e.g., a value of `-.123` will be output as `-0.123`). Extra zeroes are truncated.

 If no expression list is given, `Write #` outputs a carriage return (note that the comma after `filenum` is still necessary, even if no expression list is given).  
 The purpose of `Write #` is to create a file that can be read back by using [Input #](Input).

 **Note:**

**-** Using **`Write #`** is naturally dedicated to Output/Append Access file mode.
 **-** It is also allowed in Binary/Random Access file mode, but this was never well tested and results may vary.

## Remarks

### Differences from QB

- None

### See also

- [`Write`](Write)
- [`Print #`](procedures-Print)
- [`? #`](procedures-Print)
- [`Input #`](Input)

## Examples

```freebasic
Const filename As String = "file.txt"

Dim filenum As Integer = FreeFile()

If 0 <> Open(filename, For Output, As filenum) Then

    Print "error opening " & filename & " for output."

    End -1

End If

Dim i As Integer = 10

Dim d As Double = 123.456

Dim s As String = "text"

Write #filenum, 123, "text", -.45600

Write #filenum,

Write #filenum, i, d, s
```

 will produce the file:

```freebasic
123,"text",-0.456

10,123.456,"text"
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
