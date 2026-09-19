[Home](Home) › [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library) › **Strig**

# Strig

Reads button state from attached gaming devices

## Syntax

```freebasic
Declare Function Strig ( ByVal button As Long ) As Long
```

## Parameters

- `button`

## Description

`Strig` will retrieve the button state for the first and second buttons on the first and second gaming devices. `button` must be a number between 0 and 7 and has the following meaning:

| Button | State to return |
| --- | --- |
| 0 | First button on gaming device A pressed since STICK(0) was called |
| 1 | First button on gaming device A is pressed |
| 2 | First button on gaming device B pressed since STICK(0) was called |
| 3 | First button on gaming device B is pressed |
| 4 | Second button on gaming device A pressed since STICK(0) was called |
| 5 | Second button on gaming device A is pressed |
| 6 | Second button on gaming device B pressed since STICK(0) was called |
| 7 | Second button on gaming device B is pressed |

 Calling `Stick(0)` will reset the state returned where `button` is equal to 0, 2, 4, or 6.

## Return Value

Returns -1 (pressed) or 0 (not-pressed) to indicate the state of the `button` requested.

## Remarks

### Usage

`result = Strig( button )`

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- None

### See also

- [`GetJoystick`](Getjoystick)
- [`Stick`](Stick)

## Examples

```freebasic
'' Compile with -lang qb

'$lang: "qb"

Screen 12

Do

    Locate 1, 1

    Print "Joystick A-X position : "; Stick(0); "   "

    Print "Joystick A-Y position : "; Stick(1); "   "

    Print "Joystick B-X position : "; Stick(2); "   "

    Print "Joystick B-Y position : "; Stick(3); "   "

    Print

    Print "Button A1 was pressed : "; Strig(0); "  "

    Print "Button A1 is pressed  : "; Strig(1); "  "

    Print "Button B1 was pressed : "; Strig(2); "  "

    Print "Button B1 is pressed  : "; Strig(3); "  "

    Print "Button A2 was pressed : "; Strig(4); "  "

    Print "Button A2 is pressed  : "; Strig(5); "  "

    Print "Button B2 was pressed : "; Strig(6); "  "

    Print "Button B2 is pressed  : "; Strig(7); "  "

    Print

    Print "Press ESC to Quit"

    If Inkey$ = Chr$(27) Then

        Exit Do

    End If

    Sleep 1

Loop
```

---

**Category:** [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
