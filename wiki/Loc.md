[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **LOC**

# LOC

Returns the file position where the last file read/write was performed

## Syntax

```freebasic
Declare Function LOC ( ByVal filenum As Long ) As LongInt
```

## Parameters

- `filenum`

## Description

Returns the position where the last file read/write was performed.

 The position is indicated in records:

In files opened FOR RANDOM the record length specified when file was opened is used  
 In text files (FOR INPUT|OUTPUT|APPEND, a record length of 128 bytes is supposed.  
 In files opened for BINARY a 1 byte record length is used.

In FreeBASIC the file position is 1 based, the first record of a file is record 1 (`LOC`=1 after reading or writing the first record, `LOC`=0 for the start position in the file).

 When used with a serial device, `LOC` returns the number of bytes waiting to be read from the serial device's input buffer.

## Return Value

The file position where the last read/write was performed.

## Remarks

### Usage

`result = LOC( filenum )`

### Differences from QB

- None

### See also

- [`LOF`](Lof)
- [`EOF`](Eof)
- [`Seek (Function)`](Seek-Function)
- [`Open`](Open)

## Examples

```freebasic
Dim b As String

If Open Com ("com1:9600,n,8,1,cs,rs,ds,bin" For Binary As #1) <> 0 Then

  Print "unable to open serial port"

  End

End If

Print "Sending command: AT"

Print #1, "AT" + Chr(13, 10);

Sleep 500,1

Print "Response:"

While( LOC(1) > 0 )

  b = Input(LOC(1), 1)

  Print b;

Wend

Close #1
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
