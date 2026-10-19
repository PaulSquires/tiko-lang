[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Random**

# Random

Opens a file with Open for reading and writing fixed-size records, 128 bytes by default.

## Syntax

```freebasic
Open filename for Random [Access access_type] [Lock lock_type] as [#]filenum [Len = record_length]
```

## Parameters

- `filename`
- `access_type`
- `lock_type`
- `filenum`
- `record_length`

## Description

Opens a file or device for reading and/or writing binary data in the given file `filenum`, with records of size `record_length`.  
 If the file does not exist, a new file will be created, otherwise any data existing in the file is preserved by [`Open`](Open). The file pointer is initialized by [`Open`](Open) at the start of the file, at record number `1`. File operations move the file position in steps of `record_length` bytes.  
 This file mode uses an user-defined [`Type`](Type-Udt) buffer variable to read/write full records in a file. The buffer variable uses to include several fields.  
 The data is saved in binary mode, in the same internal format FreeBASIC uses, by means of [`Get #`](Get-File-I-O) and [`Put #`](Put-File-I-O).

 `filename` must be string expression resulting in a legal file name in the target OS, without wildcards. The file will be sought for in the present directory, unless a path is given.  
 `Access_type` - By default `Random` mode allows to both read and write the file, unless an [`Access`](Access) type is specified, it must be one of:

`Lock_type` indicates the way the file is locked for other processes (users or threads), it is one of:

If no lock type is stated, the file will be `Shared` for other threads of the program and `Lock Read Write` for other programs.  
 [`Lock`](Lock) and [`Unlock`](Unlock) can be used to restrict temporally access to parts of a file.

`filenum` is a valid FreeBASIC file number (in the range `1..255`) not being used for any other file presently open. This number identifies the file for the rest of file operations. A free file number can be found using the [`FreeFile`](Freefile) function.

 `record_length` is the amount of bytes the file pointer will move for each individual [`Get`](Get-File-I-O) and [`Put`](Put-File-I-O), it must match the size of the buffer variable used when [`Get`](Get-File-I-O)ting and [`Put`](Put-File-I-O)ting data. If omitted, it defaults to `128`.

## Remarks

### Differences from QB

- Care must be taken with dynamic or fixed length strings inside user defined types (UDT), see the warning at [Type](Type-Udt).
  The keyword [`Field`](Field) can only be used with [`Type`](Type-Udt) to specify the packing of the UDT.

### See also

- [`Open`](Open)
- [`Binary`](Binary)
- [`Get #`](Get-File-I-O)
- [`Put #`](Put-File-I-O)

## Examples

```freebasic
'' This example generates a test file and then lets you view random records

'' that are read live from the file.

Type Entry

    slen As Byte

    sdata As String * 10

End Type

Dim u As Entry

Dim s As String

Open "testfile" For Random As #1 Len = SizeOf(Entry)

'' Write out 9 records with predefined data

For i As Integer = 1 To 9

    Read s

    u = Type( Len(s), s )

    Put #1, i, u

Next

Data ".,-?!'@:", "abc",      "def"

Data "ghi",      "jkl",      "mno"

Data "pqrs",     "tuv",      "wxyz"

'' Let the user view records by specifying their index number

Do

    Dim i As Integer

    Input "Record number: ", i

    If i < 1 Or i > 9 Then Exit Do

    Get #1, i, u

    Print i & ": " & Left( u.sdata, u.slen )

    Print

Loop

Close #1
```

```freebasic
Type ScoreEntry Field = 1

    As String * 20 Name

    As Single score

End Type

Dim As ScoreEntry entry

'' Generate a fake boring highscore file

Open "scores.dat" For Random Access Write As #1 Len = SizeOf(entry)

For i As Integer = 1 To 10

    entry.name = "Player " & i

    entry.score = i

    Put #1, i, entry

Next

Close #1

'' Read out and display the entries

Open "scores.dat" For Random Access Read As #1 Len = SizeOf(entry)

For i As Integer = 1 To 10

    Get #1, i, entry

    Print i & ":", entry.name, Str(entry.score), entry.score

Next

Close #1
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
