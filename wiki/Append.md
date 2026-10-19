[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Append**

# Append

Opens a text file with Open to add to its end, creating the file if needed.

## Syntax

```freebasic
Open filename for Append [Encoding encoding_type] [Lock lock_type] as [#]filenum
```

## Parameters

- `filename`
- `encoding_type`
- `lock_type`
- `filenum`

## Description

A file mode used with [`Open`](Open) to open a text file for writing.

 This mode is used to add text to an existing file with [`Print #`](procedures-Print), or comma separated values with [`Write#`](Write).

 Text files can't be simultaneously read and written in FreeBASIC, so if both functions are required on the same file, it must be opened twice.

 `filename` must be a string expression resulting in a legal file name in the target OS, without wildcards. The file will be sought for in the present directory, unless the `filename` contains a path . If the file does not exist, it is created. The pointer is set after the last character of the file.

 `Encoding_type` indicates the Unicode [`Encoding`](Encoding) of the file, so characters are correctly read. If omitted, "ascii" encoding is defaulted. Only little endian character encodings are supported at the moment.

`Lock_type` indicates the way the file is locked for other processes, it is one of:

`filenum` Is a valid FreeBASIC file number (in the range `1..255`) not being used for any other file presently open. The file number identifies the file for the rest of file operations. A free file number can be found using the [`FreeFile`](Freefile) function.

## Remarks

### Differences from QB

- None

### See also

- [`Input (File Mode)`](Input-File-Mode)
- [`Open`](Open)
- [`Output`](Output)
- [`Print #`](procedures-Print)
- [`? #`](procedures-Print)
- [`Write #`](Write)

## Examples

```freebasic
Dim i As Integer

For i = 1 To 10

    Open "test.txt" For Append As #1

    Print #1, "extending test.txt"

    Close #1

Next
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
