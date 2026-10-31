[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Dark mode**

# Dark mode

Gives windows a dark title bar and rounded corners, and reads the light or dark setting.

Windows keeps two light-or-dark settings, both under Settings › Personalization › Colors: one
for apps and one for the Windows shell (the taskbar and Start). A program reads the first with
[AppsUseDarkMode](#appsusedarkmode) and follows it.

What Windows draws for you is the frame: the caption bar, its buttons and the border. The client
area, and the controls in it, stay the colours your program paints them;
[EnableDarkModeForWindow](#enabledarkmodeforwindow) changes the frame only. The frame functions
work on top-level windows on Windows 11 (build 22000 and later); on older versions they return an
error `HRESULT` and change nothing.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A window that takes a dark caption bar when the user has chosen dark apps, with small rounded
corners and a client area painted to match:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared as HBRUSH hBackground

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "DarkDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Dark mode", @WndProc )
    if AppsUseDarkMode() then
        EnableDarkModeForWindow( hWin )
        hBackground = CreateSolidBrush( BGR( 32, 32, 32 ) )
    else
        hBackground = CreateSolidBrush( GetSysColor( COLOR_WINDOW ) )
    end if
    SetWindowCornerPreference( hWin, DWMWCP_ROUNDSMALL )
    SetWindowClientSizeForDpi( hWin, 360, 160 )
    CenterWindow( hWin )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_ERASEBKGND
            dim rc as RECT
            GetClientRect( hwnd, @rc )
            FillRect( cast( HDC, wParam ), @rc, hBackground )
            return 1
        case WM_DESTROY
            DeleteObject( hBackground )
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
| [EnableDarkModeForWindow](#enabledarkmodeforwindow) | Draws a window's caption bar and frame in dark colours. |
| [SetWindowCornerPreference](#setwindowcornerpreference) | Chooses square, rounded or small rounded corners for a window. |
| [AppsUseDarkMode](#appsusedarkmode) | Returns `true` when the user has chosen dark mode for apps. |
| [SystemUsesDarkMode](#systemusesdarkmode) | Returns `true` when the user has chosen dark mode for the Windows shell. |

## Reference

### EnableDarkModeForWindow

```freebasic
function EnableDarkModeForWindow( byval hWin as HWND ) as HRESULT
```

Has Windows draw a window's caption bar, caption buttons and border in dark colours. It only
turns dark mode on; to go back to a light frame, call `DwmSetWindowAttribute` with
`DWMWA_USE_IMMERSIVE_DARK_MODE` and a `BOOL` of `FALSE` yourself.

Call it before the window is first shown, so that it never appears light first.

| Parameter | Meaning |
| --- | --- |
| `hWin` | A top-level window. |

**Returns** `S_OK` on success, otherwise an error `HRESULT` (on Windows versions without the
attribute).

**Example**

```freebasic
if AppsUseDarkMode() then EnableDarkModeForWindow( hwnd )
```

Microsoft Learn: [DwmSetWindowAttribute](https://learn.microsoft.com/en-us/windows/win32/api/dwmapi/nf-dwmapi-dwmsetwindowattribute), [DWMWINDOWATTRIBUTE](https://learn.microsoft.com/en-us/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute)

### SetWindowCornerPreference

```freebasic
function SetWindowCornerPreference( byval hWin as HWND, byval preference as long ) as HRESULT
```

Chooses how the corners of a window are drawn on Windows 11.

| Parameter | Meaning |
| --- | --- |
| `hWin` | A top-level window. |
| `preference` | `DWMWCP_DEFAULT`: as Windows decides for that kind of window. `DWMWCP_DONOTROUND`: square. `DWMWCP_ROUND`: rounded. `DWMWCP_ROUNDSMALL`: rounded with a smaller radius. |

**Returns** `S_OK` on success, otherwise an error `HRESULT`.

**Example**

```freebasic
SetWindowCornerPreference( hwnd, DWMWCP_DONOTROUND )
```

Microsoft Learn: [DWM_WINDOW_CORNER_PREFERENCE](https://learn.microsoft.com/en-us/windows/win32/api/dwmapi/ne-dwmapi-dwm_window_corner_preference)

### AppsUseDarkMode

```freebasic
function AppsUseDarkMode() as boolean
```

Reports the user's choice for apps under Settings › Personalization › Colors, read from the
`AppsUseLightTheme` value under
`HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize`. The value is
read on every call, so a program that answers `WM_SETTINGCHANGE` can follow a change while it
runs.

**Returns** `true` for dark, `false` for light or when the value is not there (older Windows).

**Example**

```freebasic
if AppsUseDarkMode() then print "apps are dark" else print "apps are light"
```

### SystemUsesDarkMode

```freebasic
function SystemUsesDarkMode() as boolean
```

Reports the user's choice for the Windows shell (the taskbar, Start and the notification area),
read from the `SystemUsesLightTheme` value under the same key as
[AppsUseDarkMode](#appsusedarkmode). The two can differ.

**Returns** `true` for dark, `false` for light or when the value is not there.

**Example**

```freebasic
if SystemUsesDarkMode() then print "use a light icon for the notification area"
```

## See also

- [Category: sys/win](Category-Sys-Win)
- [Window text and styles](SysWin-Window-Text-and-Styles)
- [Colours](SysWin-Colors)
