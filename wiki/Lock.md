[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Lock**

# Lock

Restricts other programs' access to a record or byte range of an open file.

## Syntax

```freebasic
Lock #filenum, record
Lock #filenum, start To end
```

## Parameters

- `filenum`
- `record`
- `start`
- `end`

## Description

`Lock` temporarily restricts access by other threads or programs to a file, or portion of a file, usually to allow safe writing to it.

 After modifying the data, an [`Unlock`](Unlock) with the same parameters as the `Lock` should be issued.

 **Note: This command does not always work, neither as documented nor as expected. It appears to be broken at the moment.**

## Remarks

### Differences from QB

- Currently, FB cannot implicitly lock the entire file
- In [`Random`](Random) mode, FB cannot lock a range of records

### See also

- [`Open`](Open)
- [`Unlock`](Unlock)
- [`ScreenLock`](Screenlock)

## Examples

```freebasic
'' e.g. locking a file, reading 100 bytes, and unlocking it.

'' To run, make sure there exists a file called 'file.ext'

'' in the current directory that is at least 100 bytes.

Dim array(1 To 100) As Integer

Dim f As Integer, i As Integer

f = FreeFile

Open "file.ext" For Binary As #f

Lock #f, 1 To 100

For i = 1 To 100

    Get #f, i, array(i)

Next

Unlock #f, 1 To 100

Close #f
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
