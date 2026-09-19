[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Access**

# Access

Clause of the Open statement to specify requested privileges

## Syntax

```freebasic
Open filename for Binary Access {Read | Write | Read Write} as [#]filenum
```

## Description

`Access` is used with the [`Open`](Open) statement to request read, write, or read and write privileges. If the `Access` clause is not specified, `Read Write` is assumed.

## Remarks

### Usage

```freebasic
open filename for binary Access Read as #filenum

open filename for binary Access Write as #filenum

open filename for binary Access Read Write as #filenum
```

### Differences from QB

- None known.

### See also

- [`Open`](Open)
- [`Read`](Read-File-Access)
- [`Write`](Write-File-Access)

## Examples

This example shows how to open the file "data.raw" with [`Read`](Read-File-Access) and then "data.out" with [`Write`](Write-File-Access) access, in [`Binary`](Binary) mode, in an open file number returned by [`FreeFile`](Freefile).

```freebasic
Dim As Long o

  '' get an open file number.

  o = FreeFile

  '' open file for read-only access.

  Open "data.raw" For Binary Access Read As #o

    '' make a buffer in memory thats the entire size of the file

    Dim As UByte file_char( LOF( o ) - 1 )

      '' get the file into the buffer.

      Get #o, , file_char()

  Close

  '' get another open file number.

  o = FreeFile

  '' open file for write-only access.

  Open "data.out" For Binary Access Write As #o

    '' put the buffer into the new file.

    Put #o, , file_char()

  Close

  Print "Copied file ""data.raw"" to file ""data.out"""

  Sleep
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
