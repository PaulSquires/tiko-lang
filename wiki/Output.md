[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Output**

# Output

Opens a text file for writing with Open, creating it or emptying it first.

## Syntax

```freebasic
Open filename for Output [Encoding encoding_type] [Lock lock_type] as [#]filenum
```

## Parameters

- `filename`
- `encoding_type`
- `lock_type`
- `filenum`

## Description

A file mode used with [`Open`](Open) to open a text file for writing.

 This mode is used to write text with [`Print #`](procedures-Print), or comma separated values with [`Write #`](Write).

 Text files can't be simultaneously read and written in FreeBASIC, so if both functions are required on the same file, it must be opened twice.

 `filename` must be a string expression resulting in a legal file name in the target OS, without wildcards. The file will be sought for in the present directory, unless the `filename` contains a path . If the file does not exist, it is created. The pointer is set at the first character of the file.

 `Encoding_type` indicates the Unicode [`Encoding`](Encoding) of the file, so characters are correctly read. If omitted, "ascii" encoding is defaulted. Only little endian character encodings are supported at the moment.

`Lock_type` indicates the way the file is locked for other processes, it is one of:

`filenum` Is a valid FreeBASIC file number (in the range `1..255`) not being used for any other file presently open. The file number identifies the file for the rest of file operations. A free file number can be found using the [`FreeFile`](Freefile) function.

## Remarks

### Differences from QB

### See also

- [`Append`](Append)
- [`Input (File Mode)`](Input-File-Mode)
- [`Open`](Open)

## Examples

```freebasic
Dim ff As UByte

Dim randomvar As Integer

Dim name_str As String

Dim age_ubyte As UByte

ff = FreeFile

Input "What is your name? ",name_str

Input "What is your age? ",age_ubyte

Open "testfile" For Output As #ff

Write #ff, Int(Rnd(0)*42),name_str,age_ubyte

Close #ff

randomvar=0

name_str=""

age_ubyte=0

Open "testfile" For Input As #ff

Input #ff, randomvar,name_str,age_ubyte

Close #ff

Print "Random Number was: ", randomvar

Print "Your name is: " + name_str

Print "Your age is: " + Str(age_ubyte)

'File outputted by this sample will look like this,

'minus the comment of course:

'23,"Your Name",19
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
