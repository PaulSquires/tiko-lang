[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Input #**

# Input #

Reads comma- or line-separated values from a text file into variables.

## Syntax

```freebasic
Input # filenum, variable_list
```

## Parameters

- `filenum`
- `variable_list`

## Description

Reads from a text file through a bound file number a delimiter-separated set of values and writes them in reading order into the variables in `variable_list`. If a variable is numeric the read value is converted from its string representation into the corresponding type.

 Numeric values are converted in a similar way to the procedures [`Val`](Val) and [`ValLng`](Vallng), using the most appropriate function for the number format.

 Delimiters may be commas or line breaks. Whitespace is also treated as a separator after numbers. A string including a comma or a whitespace must be surrounded by double quotes.

 To read an entire line into a string, use [`Line Input`](Line-Input) instead.

 [Write #](procedures-Write) can be used to create a file readable with `Input #`.

 **Note:**

**-** Using **`Input #`** is naturally dedicated to Input Access file mode.
 **-** It is also allowed in Binary/Random Access file mode, but this was never well tested and results may vary.

## Remarks

### Differences from QB

- QB has a bug in INPUT # that causes it to read past the end of the line if it does not find a matching end-quote when reading a string. If you are porting QB code that relies upon this bug, you may need to edit your data files to remove newlines from inside quoted strings, or to use a custom function to piece back together the multiline string.

### See also

- [`Input`](procedures-Input)
- [`Input()`](Input-2)
- [`Line Input #`](Line-Input)
- [`Write #`](procedures-Write)
- [`Open`](Open)
- [`Input (File Mode)`](Input-File-Mode)

## Examples

```freebasic
Dim a As Integer

Dim b As String

Dim c As Single

Open "myfile.txt" For Output As #1

Write #1, 1, "Hello, World", 34.5

Close #1

Open "myfile.txt" For Input As #1

Input #1, a, b, c

Close #1

Print a, b, c
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
