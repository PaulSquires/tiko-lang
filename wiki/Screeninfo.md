[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenInfo**

# ScreenInfo

Fills in the screen's width, height, depth and driver, or the desktop's if none is open.

## Syntax

```freebasic
Declare Sub ScreenInfo ( ByRef w As Long = 0, ByRef h As Long = 0, ByRef depth As Long = 0, ByRef bpp As Long = 0, ByRef pitch As Long = 0, ByRef rate As Long = 0, ByRef driver As String = "" )
Declare Sub ScreenInfo ( ByRef w As LongInt, ByRef h As LongInt, ByRef depth As LongInt = 0, ByRef bpp As LongInt = 0, ByRef pitch As LongInt = 0, ByRef rate As LongInt = 0, ByRef driver As String = "" )
```

## Parameters

- `w`
- `h`
- `depth`
- `bpp`
- `pitch`
- `rate`
- `driver`

## Description

This function can be useful to get current mode informations like graphics driver name, color depth, screen size and more.

 If `ScreenInfo` is called when no graphics mode is set, it returns the information about the desktop.

 Here's a description of available fields:

| w | Width of the screen in pixels |
| --- | --- |
| h | Height of the screen in pixels |
| depth | Current pixel format bits per pixel: this can be 1, 2, 4, 8, 16, or 32 |
| bpp | Bytes per pixel |
| pitch | Size of a framebuffer row in bytes |
| rate | Current refresh rate, or 0 if unknown |
| driver | Name of current graphics driver in use, like DirectX (Direct2D added on new systems) or X11 |

## Remarks

### Usage

```freebasic
in the LONG (or INTEGER<32>) version of the sub:

ScreenInfo [ w ] [, [ h ] [, [ depth ] [, [ bpp ] [, [ pitch ] [, [ rate ] [, driver ]]]]]]

in the LONGINT (or INTEGER<64>) version of the sub:

ScreenInfo w , h [, [ depth ] [, [ bpp ] [, [ pitch ] [, [ rate ] [, driver ]]]]]
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screeninfo`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)

## Examples

```freebasic
Dim w As Long, h As Long

Dim depth As Long

Dim driver_name As String

Screen 15, 32

' Obtain info about current mode

ScreenInfo w, h, depth,,,,driver_name

Print Str(w) + "x" + Str(h) + "x" + Str(depth);

Print " using " + driver_name + " driver"

Sleep

' Quit graphics mode and obtain info about desktop

Screen 0

ScreenInfo w, h, depth

Print "Desktop running at " + Str(w) + "x" + Str(h) + "x" + Str(depth);
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
