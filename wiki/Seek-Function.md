[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Seek (Function)**

# Seek (Function)

Returns the 1-based position of the next read or write: bytes, or records for Random.

## Syntax

```freebasic
Declare Function Seek ( ByVal filenum As Long ) As LongInt
```

## Parameters

- `filenum`

## Description

The position is given in records if the file was opened in [`Random`](Random) access mode, in bytes in any other case. The file position returned is 1-based, so the first record of a file is 1.

 The [`Seek`](Seek-Statement) statement is used to set the position of the next read or write operation.

## Return Value

The file position where the next read or write operation will take place.

## Remarks

### Differences from QB

- None

### See also

- [`Seek (Statement)`](Seek-Statement)
- [`LOC`](Loc)
- [`Open`](Open)

## Examples

```freebasic
Dim f As Long, position As LongInt

f = FreeFile

Open "file.ext" For Binary As #f

position = Seek(f)

Close #f
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
