[Home](Home) › [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library) › **GetMouse**

# GetMouse

Fills in the mouse position, wheel and buttons, or -1 in each if there is no mouse.

## Syntax

```freebasic
Declare Function GetMouse ( ByRef x As Long, ByRef y As Long, ByRef wheel As Long = 0, ByRef buttons As Long = 0, ByRef clip As Long = 0 ) As Long
Declare Function GetMouse ( ByRef x As LongInt, ByRef y As LongInt, ByRef wheel As LongInt = 0, ByRef buttons As LongInt = 0, ByRef clip As LongInt = 0 ) As Long
```

## Parameters

- `x`
- `y`
- `wheel`
- `buttons`
- `clip`

## Description

`GetMouse` retrieves the mouse position and buttons status; information is returned in the variables passed to this function by reference. If a mouse is not available, all variables will contain the `-1` value.

 If in console mode, the `x` and `y` coordinates are the character cell coordinates the mouse is currently on; the upper left corner of the screen is at coordinates `0, 0`. If the mouse moves out of the console window, `GetMouse` returns the last coordinate on the window that the mouse was on. If in console mode and fullscreen, the scroll wheel value is not returned.

 If in graphics mode, `x` and `y` will always be returned in pixel coordinates still relative to the upper left corner of the screen, which is at 0,0 in this case; custom coordinates system set via [`View`](View-Graphics) or [`Window`](Window) do not affect the coordinates returned by `GetMouse`.  
 If the mouse runs off the graphic window, all values are set to `-1` and the return value of the function is set to `1`. This may result in misinterpretation for the buttons and wheel if the return value of the function is not also tested.

 `Wheel` is the mouse wheel counter; rotating the wheel away from you makes the count to increase, rotating the wheel toward you makes it to decrease. At program startup or when a new graphics mode is set via [`Screen (Graphics)`](Screen-Graphics), wheel position is reset to 0. FreeBASIC may not always support mouse wheels for a given platform, in which case 0 is always returned.

 `Buttons` stores the buttons status as a bitmask: bit 0 is set if left mouse button is down; bit 1 is set if right mouse button is down; bit 2 is set if middle mouse button / wheel is down.

 `Clip` stores the mouse clipping status; if `1`, the mouse is currently clipped to the graphics window; if `0`, the mouse is not clipped.

 The error code returned by `GetMouse` can be checked using [`Err`](Err) in the next line. The function version of `GetMouse` returns directly the error code as a 32 bit [`Long`](Long).

 **Warning:** When the flag GFX_SHAPED_WINDOW is set (see [`ScreenRes`](Screenres)), `GetMouse` is only active in any colored area, ie there where color <> RGBA(255, 0, 255, alpha).

## Return Value

`0` on success, or `1` on error (for example because the mouse is outside the graphic window) or on failure. *[(sets a runtime error)](Error-Handling)*

## Remarks

### Usage

`result = GetMouse (x, y [, [ wheel ] [, [ buttons ] [, [ clip ]]]])`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Getmouse`. The variables passed must also be of type [`Long`](Long) instead of [`Integer`](Integer).

### Platform Differences

- On Win32, scroll wheel changes are not guaranteed to be detected in full-screen console mode. Confirmed on WinXP: In windowed mode, mouse wheel changes are seen, but in full-screen console mode they are not.
  In DOS, the "clip" value has no relevance. Additionally the wheel and middle button will not work unless supported and enabled by the mouse driver. See also FaqDOS.

### Differences from QB

- New to FreeBASIC

### See also

- [`ScreenRes`](Screenres) setting graph mode by resolution
- [`Screen (Graphics)`](Screen-Graphics) setting mode the QB-like way
- [`SetMouse`](Setmouse)
- [`MultiKey`](Multikey)
- [`GetJoystick`](Getjoystick)
- [`Event`](Event-Message-Data-From-Screenevent)
- [`ScreenEvent`](Screenevent)

## Examples

```freebasic
Dim As Long x, y, buttons, res

' Set video mode and enter loop

ScreenRes 640, 480, 8

Do

    ' Get mouse x, y and buttons. Discard wheel position.

    res = GetMouse (x, y, , buttons)

    Locate 1, 1

    If res <> 0 Then '' Failure

#ifdef __FB_DOS__

        Print "Mouse or mouse driver not available"

#else

        Print "Mouse not available or not on window"

#endif

    Else

        Print Using "Mouse position: ###:###  Buttons: "; x; y;

        If buttons And 1 Then Print "L";

        If buttons And 2 Then Print "R";

        If buttons And 4 Then Print "M";

        Print "   "

    End If

Loop While Inkey = ""

End
```

```freebasic
'Example 2: type-union-type structure

Type mouse

    As Long res

    As Long x, y, wheel, clip

    Union

        buttons As Long

        Type

            Left:1 As Long

            Right:1 As Long

            middle:1 As Long

        End Type

    End Union

End Type

Screen 11

Dim As mouse m

Do

    m.res = GetMouse( m.x, m.y, m.wheel, m.buttons, m.clip )

    ScreenLock

    Cls

    Print Using "res = #"; m.res

    Print Using "x = ###; y = ###; wheel = +###; clip = ##"; m.x; m.y; m.wheel; m.clip

    Print Using "buttons = ##; left = #; middle = #; right = #"; m.buttons; m.left; m.middle; m.right

    ScreenUnlock

    Sleep 10, 1

Loop While Inkey = ""
```

---

**Category:** [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
