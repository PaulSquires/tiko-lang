[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Put (File I/O)**

# Put (File I/O)

Writes data from a buffer to a file

## Syntax

```freebasic
Put #filenum As Long, [position As LongInt], data As Any [, amount As UInteger]
Put #filenum As Long, [position As LongInt], data As String
Put #filenum As Long, [position As LongInt], data() As Any
```

## Parameters

- `filenum`
- `position`
- `position`
- `data`
- `amount`
- `data`
- `amount`
- `amount`
- `amount`
- `amount`
- `data`
- `amount`

## Description

Writes binary data from a buffer variable to a file opened in [`Binary`](Binary) or [`Random`](Random) mode.

 `Put` can be used as a function, and will return `0` on success or an error code on failure.

 For files opened in [`Random`](Random) mode, the size in bytes of the data to write must match the specified record size.

 *Note:

- If a real \[w/z\]string variable is passed to `Put`, the `amount` parameter should be forbidden as it is when passing a string. Do not use. Otherwise, it is dangerously used to multiply the string length to be written to the file, but possibly by overflowing outside the provided \[w/z\]string buffer.
 - If a dereferenced \[w/z\]string pointer is passed to `Put`, the `amount` parameter is not taken into account as it is when passing a dereferenced numeric pointer. Do not use. But instead of respecting the `amount` parameter, the pointed buffer is written to the file up to the zero element (terminal element which is excluded).
 - For finer granularity, any \[w/z\]string variable can be safely passed to `Put` as numeric buffer by providing the first numeric element (an indexed \[w/z\]string variable, or a dereferenced \[w/z\]string pointer then indexed) and the number of numeric elements to be processed.*

 **Note:**

**-** Using **`Put #`** is naturally dedicated to Binary/Random Access file mode.
 **-** It is also allowed in Ouput/Append Access file mode, but this was never well tested and results may vary.

## Return Value

`Put()` returns a 32 bit [`Long`](Long): `0` on success; nonzero on error. "disk full" is considered as an error, and results in return code `3`. An "exact" amount of data written before is not available, and wouldn't be really useful anyway.

## Remarks

### Usage

```freebasic
Put #filenum, position, data [, amount]

varres = Put (#filenum, position, data [, amount])
```

### Differences from QB

- `Put` can write full arrays as in VB or, alternatively, write a multiple of the data size from `buffer`'s memory location.
  `Put` can be used as a function in FB, to find the success/error code returned without having to use error handling procedures.

### See also

- [`Put (Graphics)`](Put-Graphics) different usage of same keyword
- [`Get (File I/O)`](Get-File-I-O)
- [`Open`](Open)
- [`Close`](Close)
- [`Random`](Random)
- [`Binary`](Binary)
- [`FreeFile`](Freefile)

## Examples

```freebasic
' Create variables for the file number, and the number to put

Dim As Long f

Dim As Long value

' Find the first free file number

f = FreeFile()

' Open the file "file.ext" for binary usage, using the file number "f"

Open "file.ext" For Binary As #f

  value= 10

  ' Write the bytes of the integer 'value' into the file, using file number "f"

  ' starting at the beginning of the file (position 1)

  Put #f, 1, value

' Close the file

Close #f
```

```freebasic
' Create an integer array

Dim buffer(1 To 10) As Integer

For i As Integer = 1 To 10

    buffer(i) = i

Next

' Find the first free file file number

Dim f As Long

f = FreeFile()

' Open the file "file.ext" for binary usage, using the file number "f"

Open "file.ext" For Binary As #f

' Write the array into the file, using file number "f"

' starting at the beginning of the file (position 1)

Put #f, 1, buffer()

' Close the file

Close #f
```

```freebasic
Dim As Byte Ptr lpBuffer

Dim As Long hFile

Dim As Integer Counter

Dim As UInteger Size

Size = 256

lpBuffer = Allocate(Size)

For Counter = 0 To Size-1

  lpBuffer[Counter] = (Counter And &HFF)

Next

' Get free file file number

hFile = FreeFile()

' Open the file "test.bin" in binary writing mode

Open "test.bin" For Binary Access Write As #hFile

  ' Write 256 bytes from the memory pointed to by lpBuffer

  Put #hFile, , lpBuffer[0], Size

' Close the file

Close #hFile

' Free the allocated memory

Deallocate lpBuffer
```

```freebasic
' 'THIS' can be used as argument for writing/filling all non-static data of an UDT instance to/from a file

Type UDT

    Dim As String * 32 s

    Dim As Double d

    Declare Sub Save(ByRef filename As String)

    Declare Sub Load(ByRef filename As String)

End Type

Sub UDT.Save(ByRef filename As String)

    Dim As Integer f

    f = FreeFile()

    Open filename For Binary As #f

    Put #f, , This  '' writes all non-static data of the UDT instance to the file

    Close #f

End Sub

Sub UDT.Load(ByRef filename As String)

    Dim As Integer f

    f = FreeFile()

    Open filename For Binary As #f

    Get #f, , This  '' fills all non-static data of the UDT instance from the file

    Close #f

End Sub

Dim As UDT u1

u1.s = "PI number"

u1.d = 3.14159

u1.Save("file.ext")

Dim As UDT u2

u2.Load("file.ext")

Print u2.s

Print u2.d
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
