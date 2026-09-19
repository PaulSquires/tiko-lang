[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **Input()**

# Input()

Reads a number of characters from console or file

## Syntax

```freebasic
Declare Function Input ( n As Integer ) As String
Declare Function Input ( n As Integer, filenum As Integer ) As String
```

## Parameters

- `n`
- `filenum`

## Description

Reads a number of characters from the console, or a bound file/device specified by `filenum`.

 The first version waits for and reads `n` characters from the keyboard buffer. Extended keys are not read. The characters are not echoed to the screen.

 The second version waits for and reads `n` characters from a file or device. The file position is updated.

 **Note:** Using **`Input()`** is dedicated to Input Access file mode, but it is also allowed in Binary/Random Access file mode with some restrictions on the values of `n` (for random mode, `n` must be equal to the record length set by the LEN clause (or implicit value) in the OPEN statement).

## Return Value

Returns a [`String`](String) of the characters read.

## Remarks

### Usage

`result = Input[$]( n [, [#]filenum ] )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None in the *[-lang qb](Compiler-Option-Lang)* dialect.

### See also

- [`Winput()`](Winput)
- [`GetKey`](Getkey)
- [`Inkey`](Inkey)

## Examples

```freebasic
Print "Select a color by number"

Print "1. blue"

Print "2. red"

Print "3. green"

Dim choice As String

Do

   choice = Input(1)

Loop Until choice >= "1" And choice <= "3"
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
