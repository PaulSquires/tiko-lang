[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **GetKey**

# GetKey

Waits for a key and returns its code; the key is not shown on screen.

## Syntax

```freebasic
Declare Function GetKey ( ) As Long
```

## Description

It returns the ascii code of the first key in the keyboard buffer. The key is removed from the buffer. If no key is present, `GetKey` waits for it.

 For extended keys (returning two characters), the extended code is returned in the first byte (255), and the scancode for keyboard is returned in the second byte (the third and fourth bytes always being null at least in console mode).

 For FB's built-in functionality of getting keyboard input, see `Keyboard Input (Basics)`.

 WARNING: In graphics mode and depending on the key pressed, `Getkey` may not always return the exact same value as in console mode (for a non-extended key, the most significant bit of the ascii code byte may be propagated to the higher 3 bytes of the return value, such as a sign bit).  
 For a compatible code of the 2 screen modes, see the example below.

 The key read is not echoed to the screen.

 For a keyword not stopping the program if no key is at the buffer see [`Inkey`](Inkey) or [`MultiKey`](Multikey).

## Return Value

The value of the ascii code returned.

## Remarks

### Usage

`result = GetKey`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Getkey`.

### Differences from QB

- New to FreeBASIC

### See also

- [`GetMouse`](Getmouse)
- [`Inkey`](Inkey)
- [`Input()`](Input-2)
- [`MultiKey`](Multikey)
- [Keyboard scancodes](Dos-Keyboard-Scancodes)

## Examples

```freebasic
Dim As Long foo

Do

    foo = GetKey

    Print "total return: " & foo

    If( foo > 255 ) Then

        Print "extended code: " & (foo And &hff)

        Print "regular code: " & (foo Shr 8)

    Else

        Print "regular code: " & (foo And &hff)

    End If

    Print

Loop Until foo = 27
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
