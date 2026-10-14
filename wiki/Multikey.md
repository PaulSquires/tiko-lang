[Home](Home) › [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library) › **MultiKey**

# MultiKey

Detects the status of keys by keyboard scancode.

## Syntax

```freebasic
Declare Function MultiKey ( ByVal scancode As Long ) As Long
```

## Parameters

- `scancode`

## Description

`MultiKey` is a function which will detect the status of any key, determined by scancode, at any time. It will return `-1` if the key is pressed, otherwise it will return `0`.

 The keyboard input buffer is not disabled while you use `MultiKey`; that is, pressed keys will be stored and subsequently returned by your next call to [`Inkey`](Inkey) or [`GetKey`](Getkey) or [`Input`](procedures-Input). This means you have to empty the keyboard input buffer manually when you finish using `MultiKey`, using something like the following method:

`While Inkey <> "": Wend '' loop until the keyboard input buffer is empty`

For FB's built-in functionality of getting keyboard input, see `Keyboard Input (Basics)`.

 Keeping [`Inkey`](Inkey) to work while you use `MultiKey` allows more flexibility and can be useful to detect `Chr(255)+"k"` combo returned on window close button click, if a windowed graphics mode has been set via the [`Screen (Graphics)`](Screen-Graphics) statement. For a list of accepted scancodes, see [DOS keyboard scancodes](Dos-Keyboard-Scancodes); these are guaranteed to be valid for all FreeBASIC supported platforms.  
 `MultiKey` should always work in graphics mode, as long as the screen is [Unlocked](Screenunlock). Support in the console depends on the platform the program is run on though, and cannot be guaranteed.

## Return Value

Returns `-1` if the key for the specified [scan code](Dos-Keyboard-Scancodes) is pressed, otherwise returns `0`.

## Remarks

### Usage

`result = MultiKey(scancode)`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Multikey`.

### Differences from QB

- New to FreeBASIC

### See also

- [Keyboard scancodes](Dos-Keyboard-Scancodes)
- [`GetMouse`](Getmouse)
- [`GetJoystick`](Getjoystick)
- [`Screen (Graphics)`](Screen-Graphics)
- [`Inkey`](Inkey)
- [`Event`](Event-Message-Data-From-Screenevent)
- [`ScreenEvent`](Screenevent)

## Examples

```freebasic
#include "fbgfx.bi"

#if __FB_LANG__ = "fb"

Using FB '' Scan code constants are stored in the FB namespace in lang FB

#endif

Dim As Integer x, y

ScreenRes 640, 480

Color 2, 15

x = 320: y = 240

Do

    ' Check arrow keys and update the (x, y) position accordingly

    If MultiKey(SC_LEFT ) And x >   0 Then x = x - 1

    If MultiKey(SC_RIGHT) And x < 639 Then x = x + 1

    If MultiKey(SC_UP   ) And y >   0 Then y = y - 1

    If MultiKey(SC_DOWN ) And y < 479 Then y = y + 1

    ' Lock the page while we work on it

    ScreenLock

        ' Clear the screen and draw a circle at the position (x, y)

        Cls

        Circle(x, y), 30, , , , ,F

    ScreenUnlock

    Sleep 15, 1

    ' Run loop until user presses Escape

Loop Until MultiKey(SC_ESCAPE)

' Clear Inkey buffer

While Inkey <> "": Wend

Print "Press CTRL and H to exit..."

Do

    Sleep 25

    '' Stay in loop until user holds down CTRL and H at the same time

    If MultiKey(SC_CONTROL) And MultiKey(SC_H) Then Exit Do

Loop
```

---

**Category:** [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
