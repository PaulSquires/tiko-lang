[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **Winput()**

# Winput()

Reads a number of wide characters from a file or device and returns them.

## Syntax

```freebasic
Declare Function WInput( ByVal num As Integer ) As WString
Declare Function WInput( ByVal num As Integer, ByVal filenum As Long = 0 ) As WString
```

## Parameters

- `num`
- `filenum`

## Description

Reads a number of wide-characters from the console, or a bound file/device specified by `filenum`.

 The first version waits for and reads `n` wide characters from the keyboard buffer. Extended keys are not read. The characters are not echoed to the screen.

 The second version waits for and reads `n` wide characters from a file or device. The file position is updated.

 *Note: FreeBASIC does not currently support reading wide-characters from the console.*

 **Note:** Using **`Winput()`** is dedicated to Input Access file mode, but it is also allowed in Binary/Random Access file mode with some restrictions on the values of `num` (for random mode, `num` must be equal to the record length set by the LEN clause (or implicit value) in the OPEN statement).

## Return Value

Returns a [WString](Wstring) of the characters read.

## Remarks

### Usage

`result = WInput( num [, [#]filenum } )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- QB does not support Unicode

### See also

- [`Input()`](Input-2)
- [`Open`](Open)

## Examples

```freebasic
Dim char As WString * 2

Dim filename As String, enc As String

Dim f As Long

Line Input "Please enter a file name: ", filename

Line Input "Please enter an encoding type (optional): ", enc

If enc = "" Then enc = "ascii"

f = FreeFile

If Open(filename For Input Encoding enc As #f) = 0 Then

    Print "Press space to read a character from the file, or escape to exit."

    Do

        Select Case Input(1)

        Case " " 'Space

            If EOF(f) Then

                Print "You have reached the end of the file."

                Exit Do

            End If

            char = WInput(1, f)

            Print char & " (char no " & Asc(char) & ")"

        Case Chr(27) 'Escape

            Exit Do

        End Select

    Loop

    Close #f

Else

    Print "There was an error opening the file."

End If
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
