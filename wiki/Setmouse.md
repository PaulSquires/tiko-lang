[Home](Home) › [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library) › **SetMouse**

# SetMouse

Sets the position and visibility of the mouse cursor

## Syntax

```freebasic
Declare Function SetMouse ( ByVal x As Long = -1, ByVal y As Long = -1, ByVal visibility As Long = -1, ByVal clip As Long = -1 ) As Long
```

## Parameters

- `x`
- `y`
- `visibility`
- `clip`

## Description

`SetMouse` will set the (`x`, `y`) coordinates of the mouse pointer, as well as setting its visibility. The mouse position is set using the `x` and `y` parameters. The mouse will be visible if visibility is set to `1`, and invisible if `visibility` is set to `0`. `SetMouse` is intended for graphics modes initiated using the [`Screen (Graphics)`](Screen-Graphics) statement only.

 The error code returned by `SetMouse` can be checked using [`Err`](Err) in the next line. The function version of `SetMouse` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Zero (`0`) on success, non-zero to indicate failure.

## Remarks

### Usage

`result = SetMouse([ x ] [, [ y ] [, [ visibility ] [, [ clip ]]]])`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Setmouse`.

### Differences from QB

- New to FreeBASIC

### See also

- [`GetMouse`](Getmouse)
- [`Screen (Graphics)`](Screen-Graphics)
- [`MultiKey`](Multikey)
- [`GetKey`](Getkey)

## Examples

```freebasic
Dim As Long x, y, buttons

' create a screen 640*480

ScreenRes 640, 480

Print "Click the mouse button to center the mouse"

Do

    ' get mouse x, y and button state (wait until mouse is onscreen)

    Do: Sleep 1: Loop While GetMouse( x, y , , buttons) <> 0

    If buttons And 1 Then

        ' on left mouse click, center mouse

        SetMouse 320, 240

    End If

    ' run loop until a key is pressed or the window is closed

Loop While Inkey = ""
```

---

**Category:** [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
