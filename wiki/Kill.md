[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Kill**

# Kill

Deletes a file; returns 0 on success or an error code.

## Syntax

```freebasic
Declare Function Kill ( ByRef filename As Const String ) As Long
```

## Parameters

- `filename`

## Description

`Kill` deletes a file from disk / storage media.

 The error code returned by `Kill` can be checked using [`Err`](Err) in the next line. The function version of `Kill` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Returns zero (`0`) on success, or non-zero on error.

## Remarks

### Usage

`result = Kill( filename )`

### Platform Differences

 On some platforms, `Kill` may be able to remove folders and read-only files. Whether it succeeds or fails here is not currently defined. It may be necessary to check the attributes of the file you are deleting, and decide accordingly whether you want to try `Kill`ing it.

### Differences from QB

- KILL can optionally be used as function in FreeBASIC.

### See also

- [`Shell`](Shell)
- [`RmDir`](Rmdir)

## Examples

```freebasic
Dim filename As String = "file.ext"

Dim result As Long = Kill( filename )

If result <> 0 Then Print "error trying to kill " ; filename ; " !"
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
