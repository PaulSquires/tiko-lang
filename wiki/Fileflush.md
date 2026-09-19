[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **FileFlush**

# FileFlush

Flush application stream buffers to system, or system buffers to file

## Syntax

```freebasic
Declare Function FileFlush ( ByVal filenum As Long = -1, ByVal systembuffers As Long = 0 ) As Long
```

## Parameters

- `filenum`
- `systembuffers`

## Description

`FileFlush` writes application buffered output to the underlying stream, and if `systembuffers` is non-zero, to the underlying physical device as well.

 In the form `FileFlush(filenum)`, the application output buffer for a specific file are written. And in the form `FileFlush`, all application buffers are written to the system. Typically, when a file is opened, the stream will be block buffered for `binary` and `random` files, and line buffered for `append` and `output` files. The `FileFlush` function overrides the normal buffering of the application and immediately writes buffered output to the system. The system may have it's own buffers as well.

 In the form `FileFlush(filenum,1)`, both the application buffer is flushed and the underlying system buffer is flushed to physical device. In the form `FileFlush(,1)`, all application buffers are flushed and all underlying system buffers are flushed to physical device.

## Return Value

Returns zero (0) for success or an error code if file buffers could not be flushed.

## Remarks

### Usage

```freebasic
#include "file.bi"

result = FileFlush()

result = FileFlush( filenum )

result = FileFlush( filenum, systembuffers )
```

### Version

- Since fbc 1.08.0

### Differences from QB

- New to FreeBASIC.

### See also

- [`Close`](Close)

## Examples

```freebasic
#include "file.bi"

Dim As Long f1, f2

Dim As String s

Print "File length", "File string"

f1 = FreeFile

Open "fileflushtest.txt" For Output As #f1

Print #f1, "successful file flush"

f2 = FreeFile

Open "fileflushtest.txt" For Input As #f2

Line Input #f2, s

Print FileLen("fileflushtest.txt"), "'" & s & "'"  '' the string is not yet physically written to the file

FileFlush(f1)

Line Input #f2, s

Print FileLen("fileflushtest.txt"), "'" & s & "'"  '' the string is now physically written to the file

Close #f2

Close #f1

Sleep
```

 Output (Windows):

```freebasic
File length   File string
 0            ''
 23           'successful file flush'

```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
