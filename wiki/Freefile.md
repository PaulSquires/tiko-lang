[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **FreeFile**

# FreeFile

Returns an unused file number for Open, or 0 if all 255 are taken.

## Syntax

```freebasic
Declare Function FreeFile ( ) As Long
```

## Description

Returns the number of the next free file number with valid values `1` to `255`, or `0` if there are already 255 files opened. This value is a required argument to [`Open`](Open) a file. `FreeFile` is useful when opening files in complex programs where the programmer can't keep track of the used file numbers.

 Make sure to always close files when no longer needed, otherwise you will get a file number leak, and won't be able to open any files anymore after 255 filenumbers are exhausted while your program is running.

 `FreeFile` will always return the smallest free file number. The file number returned by `FreeFile` will not change until that file number is [`Open`](Open)ed, or until a smaller file number is [`Close`](Close)d:

**-** For this reason, it is wise to use `FreeFile` immediately before its corresponding [`Open`](Open), to ensure that the same file number is not returned and opened elsewhere first.
 **-** In case of potential conflict with other threads, this non-breaking '`FreeFile...Open`' sequence must additionally be considered as a critical section of code and therefore must be protected, for example by mutual exclusion (using a mutex locking).

## Return Value

The next available file number, if any, otherwise zero (`0`).

## Remarks

### Usage

`result = FreeFile`

### Platform Differences

- On Windows, a file number used in a dynamic link library is not the same as an identical file number used in the main program. File numbers can not be passed or returned and then used between a DLL and an executable.
  Besides FreeBASIC's limit of 255 files per program opened at same time, there is an OS limit of total amount of opened files, but usually you won't touch it except in DOS, where the limit may be as low as 15 files total.

### Differences from QB

- None

### See also

- [`Open`](Open)
- [`Put (File I/O)`](Put-File-I-O)
- [`Get (File I/O)`](Get-File-I-O)
- [`FileAttr`](Fileattr)

## Examples

```freebasic
' Create a string and fill it.

Dim buffer As String, f As Long

buffer = "Hello World within a file."

' Find the first free file number.

f = FreeFile

' Open the file "file.ext" for binary usage, using the file number "f".

Open "file.ext" For Binary As #f

' Place our string inside the file, using file number "f".

Put #f, , buffer

' Close the file.

Close #f

' End the program. (Check the file "file.ext" upon running to see the output.)

End
```

 When using multiple `FreeFile` statements, `FreeFile` should be used immediately before the [`Open`](Open) statement:

```freebasic
Dim As Long fr, fs

' The CORRECT way:

fr = FreeFile

Open "File1" For Input As #fr

fs = FreeFile

Open "File2" For Input As #fs
```

 As opposed to:

```freebasic
Dim As Long fr, fs

' The WRONG way:

fr = FreeFile

fs = FreeFile '' fs has taken the same file number as fr

Open "file1" For Input As #fr

Open "file2" For Input As #fs '' error: file number already opened
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
