[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Close**

# Close

Closes one or more file numbers, or every open file when given none.

## Syntax

```freebasic
Close [[#]filenum ] [, [#]filenum ...]
result = Close( [#filenum] )
```

## Parameters

- `filenum`

## Description

Closes the files whose file numbers are passed as arguments. If an unused file number is passed, `Close` returns an error.

 `Close` without arguments closes all the files presently opened.

 Terminating the program using an [`End`](End-Statement) statement will automatically close all files.

 The error code returned by `Close` can be checked using [`Err`](Err) in the next line. The function version of `Close` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

`Close` returns a 32 bit [`Long`](Long): a zero (`0`) on success and a non-zero error code otherwise.

## Remarks

### Differences from QB

- `Close` can be called as a function that returns an error code.
  FB throws an error on trying to close an unused file number, if compiled with error checking and if not used with the function-style syntax

### See also

- [`Open`](Open)
- [`Put (File I/O)`](Put-File-I-O)
- [`Get (File I/O)`](Get-File-I-O)
- [`FreeFile`](Freefile)

## Examples

```freebasic
' Create a string and fill it.

Dim buffer As String, f As Integer

buffer = "Hello World within a file."

' Find the first free file number.

f = FreeFile

' Open the file "file.ext" for binary usage, using the number "f".

Open "file.ext" For Binary As #f

  ' Place our string inside the file, using number "f".

  Put #f, , buffer

' Close the file.  We could also do 'Close #f', but it's only necessary if more than one number is open.

Close

' End of program. (Check the file "file.ext" upon running to see the output.)
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
