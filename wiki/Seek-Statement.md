[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Seek (Statement)**

# Seek (Statement)

Sets the 1-based position of the next read or write: bytes, or records for Random.

## Syntax

```freebasic
Seek [#]filenum, position
```

## Parameters

- `filenum`
- `position`

## Description

Sets the position at which the next read or write operation on a file will occur.

 The position is given in records if the file was opened in [`Random`](Random) access mode, in bytes in any other case. The position is 1 based -- the first record of a file is at position 1.

 The [`Seek`](Seek-Function) function is used to get the position of the next read or write operation.

## Remarks

### Differences from QB

- None

### See also

- [`Seek (Function)`](Seek-Function)
- [`Open`](Open)

## Examples

```freebasic
' e.g. if you want to skip to the 100th byte in the file for reading/writing:

Dim f As Long

f = FreeFile

Open "file.ext" For Binary As #f

Seek f, 100

Close #f
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** statement

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
