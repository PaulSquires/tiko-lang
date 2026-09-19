[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Encoding**

# Encoding

Specifies character format of a text file

## Syntax

```freebasic
Open filename for {Input|Output|Append} Encoding "utf-8"|"utf-16"|"utf-32"|"ascii" as [#]filenum
```

## Parameters

- `filename`
- `filenum`

## Description

`Encoding` specifies the format for an Unicode text file, so [`Winput #`](Winput) and [`Print #`](procedures-Print) use the correct encoding. If omitted from an [`Open`](Open) statement, "ascii" encoding is the default.

 Only little endian character encodings are supported at the moment.

## Remarks

### Platform Differences

- Unicode (w)strings are not supported in the DOS port of FreeBASIC

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Encoding`.

### Differences from QB

- QB had no support for Unicode

### See also

- [`Open`](Open)

## Examples

```freebasic
'' This example will:

'' 1) Write a string to a text file with utf-16 encoding

'' 2) Display the byte contents of the file

'' 3) Read the text back from the file

''

'' WSTRING's will work as well but STRING has been

'' used in this example since not all consoles support

'' printing WSTRING's.

'' The name of the file to use in this example

Dim f As String

f = "sample.txt"

''

Scope

  Dim s As String

  s = "FreeBASIC"

  Print "Text to write to " + f + ":"

  Print s

  Print

  '' open a file for output using utf-16 encoding

  '' and print a short message

  Open f For Output Encoding "utf-16" As #1

  '' The ascii string is converted to utf-16

  Print #1, s

  Close #1

End Scope

''

Scope

  Dim s As String, n As LongInt

  '' open the same file for binary and read all the bytes

  Open f For Binary As #1

  n = LOF(1)

  s = Space( n )

  Get #1,,s

  Close #1

  Print "Binary contents of " + f + ":"

  For i As Integer = 1 To n

    Print Hex( Asc( Mid( s, i, 1 )), 2); " ";

  Next

  Print

  Print

End Scope

''

Scope

  Dim s As String

  '' open a file for input using utf-16 encoding

  '' and read back the message

  Open f For Input Encoding "utf-16" As #1

  '' The ascii string is converted from utf-16

  Line Input #1, s

  Close #1

  '' Display the text

  Print "Text read from " + f + ":"

  Print s

  Print

End Scope
```

 Output:

```freebasic
Text to write to sample.txt:
FreeBASIC

Binary contents of sample.txt:
FF FE 46 00 72 00 65 00 65 00 42 00 41 00 53 00 49 00 43 00 0D 00 0A 00

Text read from sample.txt:
FreeBASIC
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
