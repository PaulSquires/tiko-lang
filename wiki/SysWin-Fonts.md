[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Fonts**

# Fonts

Creates fonts, reads the fonts Windows uses and changes the font of a window or control.

A font is a GDI object, an `HFONT`. Every function on this page that returns one has created a
**new** font, and that font is yours: delete it with `DeleteObject` once no window uses it any
more. Giving a font to a window with `WM_SETFONT` does not hand it over; the window only borrows
it, so delete it after the window has been destroyed.

Sizes come in two forms. A **point size** is what a user picks in a font dialog (10 pt). A
**logical height** is what a `LOGFONTW` holds: a negative number of pixels for the character
height, worked out from the vertical DPI of the display. A program that is not DPI aware always
sees 96 DPI, so 10 pt is -13 there; at 175 % (168 DPI) a DPI-aware program gets -23.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A window whose label shows which font Windows uses in message boxes, written in a bold font of
its own, which is deleted once the window has closed:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "FontDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Fonts", @WndProc )
    SetWindowClientSizeForDpi( hWin, 420, 120 )
    CenterWindow( hWin )
    dim lf as LOGFONTW
    dim face as ustring = "(unknown)"
    if GetWindowsFontInfo( FONT_MESSAGE, @lf ) then face = lf.lfFaceName
    dim hLabel as HWND = pWindow.AddControl( "Label", hWin, 100, _
        "Message boxes use " & face & ", " & GetWindowsFontPointSize( FONT_MESSAGE ) & " pt", 20, 20, 380, 60 )
    dim hBold as HFONT = CreateFont( "Georgia", 14, -1, FW_BOLD )
    SendMessageW( hLabel, WM_SETFONT, cast( WPARAM, hBold ), true )
    dim result as long = pWindow.DoEvents( SW_NORMAL )
    DeleteObject( hBold )
    return result
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Functions

| Function | Does |
| --- | --- |
| [Font constants](#font-constants) | The `FONT_*` values that pick a system font or a font setting. |
| [GetWindowFontInfo](#getwindowfontinfo) | Returns the `LOGFONTW` of the font a window or control uses. |
| [GetWindowsFontInfo](#getwindowsfontinfo) | Reads the `LOGFONTW` of a font Windows uses: caption, menu, status bar, message box. |
| [GetWindowsFontPointSize](#getwindowsfontpointsize) | Returns the point size of a font Windows uses. |
| [GetFontPointSize](#getfontpointsize) | Converts a logical font height to a point size. |
| [GetFontHeight](#getfontheight) | Converts a point size to a logical font height. |
| [ModifyFontFaceName](#modifyfontfacename) | Gives a window a copy of its font with another typeface. |
| [ModifyFontSettings](#modifyfontsettings) | Gives a window a copy of its font with one setting changed. |
| [ModifyFontHeight](#modifyfontheight) | Gives a window a copy of its font, scaled by a percentage. |
| [CreateFont](#createfont) | Creates a font from a typeface name and a point size. |

## Reference

### Font constants

```freebasic
enum
   FONT_CAPTION = 1
   FONT_SMALLCAPTION
   FONT_MENU
   FONT_STATUS
   FONT_MESSAGE
   FONT_HEIGHT
   FONT_WEIGHT
   FONT_ITALIC
   FONT_UNDERLINE
   FONT_STRIKEOUT
   FONT_CHARSET
end enum
```

The first five name the fonts Windows draws its own parts with, for
[GetWindowsFontInfo](#getwindowsfontinfo) and [GetWindowsFontPointSize](#getwindowsfontpointsize);
the other six name the setting [ModifyFontSettings](#modifyfontsettings) changes.

| Constant | Value | Means |
| --- | --- | --- |
| `FONT_CAPTION` | 1 | the title bar font |
| `FONT_SMALLCAPTION` | 2 | the font of small (tool window) title bars |
| `FONT_MENU` | 3 | the menu bar font |
| `FONT_STATUS` | 4 | the font of status bars and tooltips |
| `FONT_MESSAGE` | 5 | the message box font |
| `FONT_HEIGHT` | 6 | the size, as a percentage |
| `FONT_WEIGHT` | 7 | the weight, 0 to 1000 |
| `FONT_ITALIC` | 8 | italic on or off |
| `FONT_UNDERLINE` | 9 | underline on or off |
| `FONT_STRIKEOUT` | 10 | strikeout on or off |
| `FONT_CHARSET` | 11 | the character set |

**Example**

```freebasic
print "status bar font:"; GetWindowsFontPointSize( FONT_STATUS ); " pt"
```

### GetWindowFontInfo

```freebasic
function GetWindowFontInfo( byval hWin as HWND ) as LOGFONTW
```

Asks a window or control for its font (`WM_GETFONT`) and returns that font's description. A
window that has never been given a font draws with the system font and answers `NULL`; the
`LOGFONTW` that comes back is then all zeros.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |

**Returns** the `LOGFONTW`; `lfHeight` is 0 when the window has no font of its own.

**Example**

```freebasic
dim lf as LOGFONTW = GetWindowFontInfo( hCtrl )
dim face as ustring = lf.lfFaceName
print face; ","; GetFontPointSize( lf.lfHeight ); " pt"
```

Microsoft Learn: [WM_GETFONT](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-getfont)

### GetWindowsFontInfo

```freebasic
function GetWindowsFontInfo( byval nType as long, byval plfw as LOGFONTW ptr ) as boolean
```

Reads the description of one of the fonts Windows uses for its non-client parts from the
user's current settings. Use it to give your own controls the font the user sees in message
boxes, or to match a status bar.

| Parameter | Meaning |
| --- | --- |
| `nType` | `FONT_CAPTION`, `FONT_SMALLCAPTION`, `FONT_MENU`, `FONT_STATUS` or `FONT_MESSAGE`. |
| `plfw` | The `LOGFONTW` to fill. |

**Returns** `true` on success. `false` when `plfw` is `NULL`, when `nType` is not one of the five
values above, or when Windows could not be asked; in the last case `GetLastError()` says why.

**Example**

```freebasic
dim lf as LOGFONTW
if GetWindowsFontInfo( FONT_MESSAGE, @lf ) then
    dim hMsgFont as HFONT = CreateFontIndirectW( @lf )   ' delete it with DeleteObject
end if
```

Microsoft Learn: [NONCLIENTMETRICSW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-nonclientmetricsw)

### GetWindowsFontPointSize

```freebasic
function GetWindowsFontPointSize( byval nType as long ) as long
```

Returns the point size of one of the fonts Windows uses, worked out from its logical height and
the DPI of the display. On a Windows 11 machine with default settings, `FONT_MESSAGE` and
`FONT_CAPTION` both answer 9.

| Parameter | Meaning |
| --- | --- |
| `nType` | `FONT_CAPTION`, `FONT_SMALLCAPTION`, `FONT_MENU`, `FONT_STATUS` or `FONT_MESSAGE`. |

**Returns** the point size, rounded to a whole point; 0 for any other `nType` or on failure.

**Example**

```freebasic
print "menu font:"; GetWindowsFontPointSize( FONT_MENU ); " pt"
```

### GetFontPointSize

```freebasic
function GetFontPointSize( byval nHeight as long ) as long
```

Converts a logical font height, such as `lfHeight` of a `LOGFONTW`, to a point size, using the
vertical DPI of the display. The sign of `nHeight` does not matter. At 96 DPI, -13 gives 10 and
-20 gives 15.

**Returns** the point size, rounded to a whole point, or 0 when the display cannot be queried.

**Example**

```freebasic
print GetFontPointSize( -13 )   ' 10 at 96 DPI
```

Microsoft Learn: [MulDiv](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-muldiv)

### GetFontHeight

```freebasic
function GetFontHeight( byval nPointSize as long ) as long
```

Converts a point size to the logical height a `LOGFONTW` wants: minus the number of pixels the
characters are high on the display. At 96 DPI 10 pt gives -13 and 9 pt gives -12; a DPI-aware
program at 175 % gets -23 and -21.

**Returns** the logical height (negative), or 0 when the display cannot be queried.

**Example**

```freebasic
dim lf as LOGFONTW
lf.lfHeight = GetFontHeight( 11 )
lf.lfFaceName = "Segoe UI"
dim hFont as HFONT = CreateFontIndirectW( @lf )
```

Microsoft Learn: [LOGFONTW](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw)

### ModifyFontFaceName

```freebasic
function ModifyFontFaceName( byval hWin as HWND, byref wszNewFaceName as wstring ) as HFONT
```

Makes a copy of the font a window uses with the typeface replaced, keeping its size, weight and
style, and gives it to the window (`WM_SETFONT`, redrawn at once).

The window's previous font is **not** deleted: if you created it, delete it yourself, and delete
the returned font once the window no longer uses it. A window without a font of its own has
nothing to copy, and nothing happens.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |
| `wszNewFaceName` | The typeface, such as `"Consolas"`. |

**Returns** the new font, or `NULL` when the window has no font or the font could not be made.

**Example**

```freebasic
dim hOld as HFONT = cast( HFONT, SendMessageW( hCtrl, WM_GETFONT, 0, 0 ) )
dim hNew as HFONT = ModifyFontFaceName( hCtrl, "Consolas" )
if hNew then DeleteObject( hOld )   ' only if hOld was a font you created
```

Microsoft Learn: [WM_SETFONT](https://learn.microsoft.com/en-us/windows/win32/winmsg/wm-setfont)

### ModifyFontSettings

```freebasic
function ModifyFontSettings( byval hWin as HWND, byval nSetting as long, byval nValue as long ) as HFONT
```

Makes a copy of the font a window uses with one setting changed and gives it to the window
(`WM_SETFONT`, redrawn at once). As with [ModifyFontFaceName](#modifyfontfacename), the previous
font is not deleted and the returned font is yours to delete.

| `nSetting` | `nValue` |
| --- | --- |
| `FONT_HEIGHT` | A percentage of the current size: 120 makes it 20 % larger, 80 20 % smaller. The current size is first rounded to a whole point. |
| `FONT_WEIGHT` | 0 to 1000: `FW_NORMAL` (400), `FW_BOLD` (700) … 0 lets the font mapper choose. |
| `FONT_ITALIC`, `FONT_UNDERLINE`, `FONT_STRIKEOUT` | 1 to turn it on, 0 to turn it off. |
| `FONT_CHARSET` | A character set such as `DEFAULT_CHARSET`, `SYMBOL_CHARSET` or `GREEK_CHARSET`. |

The copy reads the current font's description through the ANSI form of `GetObject`, so the
typeface name it carries over is the ANSI bytes of the name packed into wide characters: the
new font asks for a typeface that does not exist and the font mapper substitutes one. Follow the
call with [ModifyFontFaceName](#modifyfontfacename) to put the right typeface back, as the example
does.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |
| `nSetting` | One of the six settings above. |
| `nValue` | The new value. |

**Returns** the new font, or `NULL` when `hWin` is not a window, the window has no font, or
`nSetting` is not one of the six settings.

**Example**

```freebasic
dim face as ustring = GetWindowFontInfo( hCtrl ).lfFaceName
dim hBold as HFONT = ModifyFontSettings( hCtrl, FONT_WEIGHT, FW_BOLD )
dim hFixed as HFONT = ModifyFontFaceName( hCtrl, face )
if hBold then DeleteObject( hBold )
```

Microsoft Learn: [CreateFontIndirectW](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createfontindirectw)

### ModifyFontHeight

```freebasic
function ModifyFontHeight( byval hWin as HWND, byval nValue as long ) as HFONT
```

The same as `ModifyFontSettings( hWin, FONT_HEIGHT, nValue )`: 150 makes a 10 pt font 15 pt. The
typeface name is carried over the same way as there, so restore it with
[ModifyFontFaceName](#modifyfontfacename).

**Returns** the new font, which is yours to delete, or `NULL` on failure.

**Example**

```freebasic
dim face as ustring = GetWindowFontInfo( hCtrl ).lfFaceName
dim hBig as HFONT = ModifyFontHeight( hCtrl, 150 )
dim hFixed as HFONT = ModifyFontFaceName( hCtrl, face )
if hBig then DeleteObject( hBig )
```

### CreateFont

```freebasic
function CreateFont overload( byref wszFaceName as wstring, byval lPointSize as long, byval DPI as long = 96, byval lWeight as long = 0, byval bItalic as ubyte = false, byval bUnderline as ubyte = false, byval bStrikeOut as ubyte = false, byval bCharSet as ubyte = DEFAULT_CHARSET ) as HFONT
```

Creates a TrueType-preferring font from a typeface name and a point size. The Windows function of
the same name, with fourteen arguments, is still there.

`DPI` says which display the size is meant for:

- `-1` sizes the font for the display the program sees: 10 pt is -13 pixels at 96 DPI and -23
  at 175 % in a DPI-aware program. Use this in a DPI-aware program.
- `96`, the default, keeps the font the pixel size it would have at 96 DPI. The point size is
  first scaled down in whole points (10 pt becomes 5 pt at 168 DPI, which gives -12 rather than
  -13), so on a scaled display the font can come out a pixel or so smaller.
- Any other positive value works the same way for that DPI.

A program that is not DPI aware sees 96 DPI, and every choice gives the same font.

| Parameter | Meaning |
| --- | --- |
| `wszFaceName` | The typeface, such as `"Segoe UI"`. |
| `lPointSize` | The size in points. |
| `DPI` | `-1`, or the DPI the size is meant for; see above. |
| `lWeight` | 0 to 1000; `FW_NORMAL` (400), `FW_BOLD` (700). 0 lets the font mapper choose. |
| `bItalic`, `bUnderline`, `bStrikeOut` | Nonzero turns the style on. |
| `bCharSet` | The character set; `SYMBOL_CHARSET` for a symbol font such as Marlett. |

**Returns** the font, which you delete with `DeleteObject`, or `NULL` on failure.

**Example**

```freebasic
dim hFont as HFONT = CreateFont( "Segoe UI", 10, -1, FW_BOLD )
SendMessageW( hCtrl, WM_SETFONT, cast( WPARAM, hFont ), true )
```

Microsoft Learn: [CreateFontIndirectW](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createfontindirectw)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Display, screen and DPI](SysWin-Display-and-DPI) for the DPI these conversions use
- [Units](SysWin-Units) for points, pixels and the other units
- [CWindow](CWindow), whose `CreateFont` and `SetFont` members size fonts for the window's DPI
