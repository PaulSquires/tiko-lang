[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Reset**

# Reset

Closes all open files, or resets standard I/O handles.

## Syntax

```freebasic
Declare Sub Reset ( )
Declare Sub Reset ( ByVal streamno As Long )
```

## Parameters

- `streamno`

## Description

`Reset`, when called with no arguments, closes all disk files.

 `Reset`, when called with the `streamno` argument, will reset the redirected or piped streams associated with stdin (`0`), or stdout (`1`).

 **Runtime errors:**
 `Reset(streamno)` can set one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

*(`3`) File I/O error*

## Remarks

### Usage

```freebasic
Reset

or

Reset( streamno )
```

### Differences from QB

- None for `Reset()`.
- The `Reset(streamno)` usage is new to FreeBASIC.

### See also

- [`Close`](Close)
- [`Open`](Open)
- [`Open Cons`](Open-Cons)
- [`IsRedirected`](Isredirected)

## Examples

```freebasic
Open "test.txt" For Output As #1

Print #1, "testing 123"

Reset
```

```freebasic
Dim x As String

'' Read from STDIN from piped input

Open Cons For Input As #1

While EOF(1) = 0

  Input #1, x

  Print """"; x; """"

Wend

Close #1

'' Reset to read from the keyboard

Reset(0)

Print "Enter some text:"

Input x

'' Read from STDIN (now from keyboard)

Open Cons For Input As #1

While EOF(1) = 0

  Input #1, x

  Print """"; x; """"

Wend

Close #1
```

Note: Under Windows, to specify to the program that data entry is completed (transfer EOF), you can press CTRL+Z then press ENTER.

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
