[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **FileSetEof**

# FileSetEof

Sets the length of a open file bound to a file number

## Syntax

```freebasic
Declare Function FileSetEof ( ByVal filenum As Long ) As Long
```

## Parameters

- `filenum`

## Description

`FileSetEof` Sets the end of file based on the current file position. File position as in [`Seek`](Seek-Statement) is one based.

 When the current file position is before the end of the file, the file is truncated. File contents before the the current file position are kept, and file contents on or after the current file position are deleted. When the current position is beyond the end of file, the file is extended with zero value bytes. After `FileSetEof` completes, the current file position is at the end of the file.

 To set a file having a length of *N-bytes* where the file is opened for `binary`, `output`, or `append`, it is necessary to [`Seek`](Seek-Statement) to position *N-bytes + 1*. To set a file having a length of *N-records* where the file is opened for `random`, it is necessary to [`Seek`](Seek-Statement) to position *N-records + 1*.

## Return Value

Returns zero (0) for success or an error code if the end of file (file size) could not be set.

## Remarks

### Usage

```freebasic
#include "file.bi"

result = FileSetEof(fnum)
```

### Differences from QB

- New to FreeBASIC.

### See also

- [`EOF`](Eof)
- [`LOF`](Lof)
- [`Seek`](Seek-Statement)

## Examples

```freebasic
#include "file.bi"

'' create a zero length file

Open "file.dat" For Binary As #1

FileSetEof 1

Close #1

'' open same file and extend to 10000 bytes size

Open "file.dat" For Binary As #1

Seek #1, (10000 + 1)

FileSetEof 1

Close #1

'' open same file and truncate to 5000 bytes size

Open "file.dat" For Binary As #1

Seek #1, (5000 + 1)

FileSetEof 1

Close #1

'' clean-up

Kill "file.dat"
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
