[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Name**

# Name

Renames or moves a file or folder; returns 0 on success.

## Syntax

```freebasic
Declare Function Name( ByRef oldname As Const String, ByRef newname As Const String ) As Long
```

## Parameters

- `oldname`
- `newname`

## Description

Renames a file or folder originally called `oldname` to `newname`.

 The function is not guaranteed to succeed if a file/folder exists with the same name. It may succeed, overwriting the original, or it may fail. For greater control, [`FileExists`](Fileexists) could be used to test for an existing file, and [`Kill`](Kill) could be used to delete an existing file beforehand.

## Return Value

Returns zero (`0`) on success and non-zero on failure.

## Remarks

### Usage

`result = Name( oldname, newname )`

### Differences from QB

- In QB, NAME required AS rather than a comma between the old and new names. This is because NAME was a language keyword rather than a function.

### See also

- [`Kill`](Kill)
- [`FileExists`](Fileexists)

## Examples

```freebasic
Dim OldName As String

Dim NewName As String

Dim result As Long

OldName = "dsc001.jpg"

NewName = "landscape.jpg"

result = Name( OldName, NewName )

If 0 <> result Then

    Print "error renaming " & oldname & " to " & newname & "."

End If
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
