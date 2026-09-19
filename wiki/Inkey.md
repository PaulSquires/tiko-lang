[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **Inkey**

# Inkey

Returns a string representing the first key waiting in the keyboard buffer

## Syntax

```freebasic
Declare Function Inkey ( ) As String
```

## Description

Peeks into the keyboard buffer and returns a [`String`](String) representation of the first character, if any, found. The key is then removed from the buffer, and is not echoed to the screen. If the keyboard buffer is empty, an empty string (`"``"`) is immediately returned without waiting for keys.

 If the key is in the ASCII character set, a one-character [`String`](String) consisting of that character is returned.  
 If the key is an "extended" one (numeric pad, cursors, functions) a two-character [`String`](String) is returned, the first of which is the extended character (*See dialect differences below*), and the second is the raw scancode for the keyboard.

 For FB's built-in functionality of getting keyboard input, see `Keyboard Input (Basics)`.

 The Shift, Ctrl, Alt, and AltGr keys can't be read independently by this function as they never enter the keyboard buffer (although, perhaps obviously, Shift-A will be reported by `Inkey` differently than Control-A et cetera; Alt-A is an extended key a la the above).

 See also [`Input()`](Input-2) or [`GetKey`](Getkey), or [`Sleep`](Sleep) to wait for a key press if the keyboard buffer is empty.

## Return Value

The first character found in the keyboard buffer, or an empty string (`"``"`) if none found.

## Remarks

### Usage

`result = Inkey[$]`

### Dialect Differences

- The extended character is `Chr(255)` in the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

  - In the *[-lang qb](Compiler-Option-Lang)* dialect, the extended character depends on how the keyword is written. If the QB form `Inkey$` is used, the extended character is `Chr(0)`. If it is referenced as `__Inkey`, the extended char is `Chr(255)`.
  In all other dialects, the extended char is always `Chr(255)`.

  The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None in the *[-lang qb](Compiler-Option-Lang)* dialect.
  QBasic returned a `Chr(0)` as the first character for an extended key, but FreeBASIC returns `Chr(255)` as the first character in the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### See also

- [`Sleep`](Sleep)
- [`GetKey`](Getkey)
- [`Input()`](Input-2)
- [`MultiKey`](Multikey)
- [Keyboard scancodes](Dos-Keyboard-Scancodes)
- [Keyboard Input](Keyboard-Input)

## Examples

```freebasic
Print "press q to quit"

Do

    Sleep 1, 1

Loop Until Inkey = "q"
```

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

#if __FB_LANG__ = "qb"

#define EXTCHAR Chr$(0)

#else

#define EXTCHAR Chr(255)

#endif

Dim k As String

Print "Press a key, or Escape to end"

Do

    k = Inkey$

    Select Case k

        Case "A" To "Z", "a" To "z": Print "Letter: " & k

        Case "1" To "9":             Print "Number: " & k

        Case Chr$(32): Print "Space"

        Case Chr$(27): Print "Escape"

        Case Chr$(9): Print "Tab"

        Case Chr$(8): Print "Backspace"

        Case Chr$(32) To Chr$(127)

            Print "Printable character: " & k

        Case EXTCHAR & "G": Print "Up Left / Home"

        Case EXTCHAR & "H": Print "Up"

        Case EXTCHAR & "I": Print "Up Right / PgUp"

        Case EXTCHAR & "K": Print "Left"

        Case EXTCHAR & "L": Print "Center"

        Case EXTCHAR & "M": Print "Right"

        Case EXTCHAR & "O": Print "Down Left / End"

        Case EXTCHAR & "P": Print "Down"

        Case EXTCHAR & "Q": Print "Down Right / PgDn"

        Case EXTCHAR & "R": Print "Insert"

        Case EXTCHAR & "S": Print "Delete"

        Case EXTCHAR & "k": Print "Close window / Alt-F4"

        Case EXTCHAR & Chr$(59) To EXTCHAR & Chr$(68)

            Print "Function key: F" & Asc(k, 2) - 58

        Case EXTCHAR & Chr$(133) To EXTCHAR & Chr$(134)

            Print "Function key: F" & Asc(k, 2) - 122

        Case Else

            If Len(k) = 2 Then

                Print Using "Extended character: chr$(###, ###)"; Asc(k, 1); Asc(k, 2)

            ElseIf Len(k) = 1 Then

                Print Using "Character chr$(###)"; Asc(k)

            End If

    End Select

    If k = Chr$(27) Then Exit Do

    Sleep 1, 1

Loop
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
