[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Binary**

# Binary

Specifies file or device to be opened for binary mode

## Syntax

```freebasic
Open filename for Binary [Access access_type] [Lock lock_type] as [#]filenum
```

## Parameters

- `filename`
- `access_type`
- `lock_type`
- `filenum`

## Description

Opens a file or device for reading and/or writing binary data in the file `filenum`, with free format.  
 If the file does not exist, a new file will be created. The file pointer is initialized by [`Open`](Open) at byte no. 1.  
 [`Get #`](Get-File-I-O) and [`Put #`](Put-File-I-O) file operations move the file pointer according to the size of the data, the pointer can be set to any byte in the file.  
 The data existing in the file is preserved by [`Open`](Open).  
 This file mode can use any buffer variable to read/write data in the file.  
 The data is saved in binary mode, in the same internal format FreeBASIC uses, by means of [`Get #`](Get-File-I-O) and [`Put #`](Put-File-I-O).

 `filename` must be a string expression resulting in a legal file name in the target OS, without wildcards. The file will be sought for in the present directory, unless a path is given.

 `Access_type` By default `Binary` mode allows to both read and write the file, unless an [`Access`](Access) type is specified, it must be one of:

`Lock_type` indicates the way the file is locked for other processes (users or threads), it is one of:

If no lock type is stated, the file will be `Shared` for other threads of the program and `Lock Read Write` for other programs.  
 [`Lock`](Lock) and [`Unlock`](Unlock) can be used to restrict temporally access to parts of a file.

`filenum` is a valid file number (in the range `1..255`) not being used for any other file presently open. The file number identifies the file for the rest of file operations. A free file number can be found using the [`FreeFile`](Freefile) function.

## Remarks

### Differences from QB

- None

### See also

- [`Open`](Open)
- [`Put #`](Put-File-I-O)
- [`Get #`](Get-File-I-O)
- [`Random`](Random)
- [`Append`](Append)
- [`Output`](Output)
- [`Input`](Input-File-Mode)

## Examples

```freebasic
'' Create a binary data file with one number in it

Dim x As Single = 17.164

Open "MyFile.Dat" For Binary As #1

  '' put without a position setting will put from the last known file position

  '' in this case, the very beginning of the file.

  Put #1, , x

Close #1
```

```freebasic
'' Now read the number from the file

Dim x As Single = 0

Open "MyFile.Dat" For Binary As #1

  Get #1, , x

Close #1

Print x
```

```freebasic
'' Read entire contents of a file to a string

Dim txt As String

Open "myfile.txt" For Binary Access Read As #1

  If LOF(1) > 0 Then

    '' our string has as many characters as the file has in bytes

    txt = String(LOF(1), 0)

    '' size of txt is known.  entire string filled with file data

    Get #1, , txt

  End If

Close #1

Print txt
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
