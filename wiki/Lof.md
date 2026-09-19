[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **LOF**

# LOF

Returns the length of an open disk file

## Syntax

```freebasic
Declare Function LOF ( ByVal filenum As Long ) As LongInt
```

## Parameters

- `filenum`

## Description

Returns the length, in bytes, of a file opened previously with [`Open`](Open) using the given `filenum`.

 With [`Open Com`](Open-Com) it returns the length of the data pending to be read in the receive buffer.

## Return Value

The length in bytes of an open disk file.

## Remarks

### Usage

`result = LOF( filenum )`

### Differences from QB

- None

### See also

- [`LOC`](Loc)
- [`EOF`](Eof)
- [`Open`](Open)

## Examples

```freebasic
Dim f As Long

f = FreeFile

Open "file.ext" For Binary As #f

Print LOF(f)

Close #f
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
