[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Input (File Mode)**

# Input (File Mode)

Opens a text file for reading with Open; the file must already exist.

## Syntax

```freebasic
Open filename for Input [Encoding encoding_type] [Lock lock_type] as [#]filenum
```

## Parameters

- `filename`
- `encoding_type`
- `lock_type`
- `filenum`

## Description

A file mode used with [`Open`](Open) to open a text file for reading.

 This mode allows to read sequentially lines of text with [`Line Input #`](Line-Input), or to read comma separated values with [`Input #`](Input).

 Text files can't be simultaneously read and written in FreeBASIC, so if both functions are required on the same file, it must be opened twice.

 `filename` must be a string expression resulting in a legal file name in the target OS, without wildcards. The file will be sought for in the present directory, unless the `filename` contains a path . If the file does not exist, an error is issued. The pointer is set at the first character of the file.

 `Encoding_type` indicates the Unicode [`Encoding`](Encoding) of the file, so characters are correctly read. If omitted, "ascii" encoding is defaulted. Only little endian character encodings are supported at the moment.

`Lock_type` indicates the way the file is locked for other processes, it is one of:

`filenum` is a valid FreeBASIC file number (in the range `1..255`) not being used for any other file presently open. The file number identifies the file for the rest of file operations. A free file number can be found using the [`FreeFile`](Freefile) function.

## Remarks

### Differences from QB

### See also

- [`Input (Console I/O)`](procedures-Input)
- [`Input #`](Input)
- [`Input()`](Input-2)
- [`Append`](Append)
- [`Open`](Open)
- [`Output`](Output)

## Examples

```freebasic
Dim ff As UByte

Dim randomvar As Integer

Dim name_str As String

Dim age As Integer

'' collect the test data and output to file with Write #

Input "What is your name? ", name_str

Input "What is your age? ", age

Randomize

Print

ff = FreeFile

Open "testfile" For Output As #ff

Write #ff, Int(Rnd*42), name_str, age

Close #ff

'' clear variables

randomvar = 0

name_str = ""

age = 0

'' input the variables, using Input #

ff = FreeFile

Open "testfile" For Input As #ff

Input #ff, randomvar, name_str, age

Close #ff

Print "Random Number was: " & randomvar

Print "Your name is: " & name_str

Print "Your age is: " & age

'File outputted by this sample will look something like this

'(not including the leading comment marker):

'23,"Your Name",19
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
