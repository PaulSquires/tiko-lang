[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **PropSheet**

# PropSheet

Creates an animation control, and names the wizard-button requests of a property sheet.

The `PropSheet` namespace holds two different things, and only the first can be called:

- [Create](#create), which despite the namespace's name creates an **animation control**
  (window class `SysAnimate32`), the control the [Animate](SysWin-Gui-Animate) functions work
  on. It is the counterpart of the Windows `Animate_Create` macro.
- Four helpers for the buttons of a property-sheet wizard: [SetNextText](#setnexttext),
  [ShowWizButtons](#showwizbuttons), [EnableWizButtons](#enablewizbuttons) and
  [SetButtonText](#setbuttontext). They sit in the source behind a Windows-version condition
  that the module's build does not meet, so they are **not part of the module**: a program that
  calls one stops with *the namespace 'propsheet' has no member named …*. Each entry below shows
  the message to send to the property sheet instead; the message numbers are not among the
  Windows constants, so the snippets write them out as `WM_USER + n`.

A property sheet itself, a dialog with a page per tab, or a wizard with **Back**, **Next** and
**Finish**, is created with the Windows function `PropertySheetW`. Inside a page's dialog
procedure, `GetParent( hDlg )` is the sheet that the messages go to.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

An animation control made with `PropSheet.Create`, playing `clock.avi` from the program's folder
in a loop. Without `ACS_CENTER` the control takes the size of the clip.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_ANIM = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "PropSheetCreateDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Animation control", @WndProc )
    pWindow.SetClientSize( 240, 140 )
    pWindow.Center()
    dim hAnim as HWND = PropSheet.Create( hWin, IDC_ANIM, WS_CHILD or WS_VISIBLE or ACS_TRANSPARENT, GetModuleHandleW( NULL ) )
    SetWindowPos( hAnim, NULL, 20, 20, 0, 0, SWP_NOSIZE or SWP_NOZORDER )
    if Animate.OpenClip( hAnim, "clock.avi" ) then
        Animate.Play( hAnim, 0, -1, -1 )
    else
        SetWindowText( hWin, "clock.avi could not be opened" )
    end if
    return pWindow.DoEvents( SW_NORMAL )
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
| [Create](#create) | Creates an animation control. |
| [SetNextText](#setnexttext) | Not in the module: would set the text of a wizard's **Next** button. |
| [ShowWizButtons](#showwizbuttons) | Not in the module: would show or hide wizard buttons. |
| [EnableWizButtons](#enablewizbuttons) | Not in the module: would enable or disable wizard buttons. |
| [SetButtonText](#setbuttontext) | Not in the module: would set the text of a wizard button. |

## Reference

### Create

```freebasic
function Create( byval hParent as HWND, byval id as LONG_PTR, byval dwStyle as DWORD, byval hInstance as HINSTANCE ) as HWND
```

Creates an animation control as a child of `hParent`, at (0, 0) and with no size. Move it into
place afterwards; without `ACS_CENTER` it takes the size of the first clip opened into it, with
`ACS_CENTER` give it a size and the clip is centred in it.

| Parameter | Meaning |
| --- | --- |
| `hParent` | The parent window. |
| `id` | The control's identifier. |
| `dwStyle` | The whole style: include `WS_CHILD` and `WS_VISIBLE`, and `ACS_CENTER`, `ACS_TRANSPARENT`, `ACS_AUTOPLAY` as wanted. |
| `hInstance` | The module creating the control; clips opened by resource name come from it. |

**Returns** the control's handle, or `NULL` on failure.

**Example**

```freebasic
dim hAnim as HWND = PropSheet.Create( hwnd, 200, WS_CHILD or WS_VISIBLE or ACS_TRANSPARENT, GetModuleHandleW( NULL ) )
SetWindowPos( hAnim, NULL, 10, 10, 0, 0, SWP_NOSIZE or SWP_NOZORDER )
```

Microsoft Learn: [Animate_Create](https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-animate_create)

### SetNextText

```freebasic
sub SetNextText( byval hDlg as HWND, byval pwszText as wstring ptr )
```

Not part of the module (see the introduction). It would set the text of a wizard's **Next**
button, for instance to **Install** on the last page before the work starts. Send
`WM_USER + 137` (`PSM_SETNEXTTEXTW`) with the text in `lParam`.

**Example**

```freebasic
dim wszText as wstring * 16 = "&Install"
SendMessageW( hDlg, WM_USER + 137, 0, cast( LPARAM, @wszText ) )   ' PSM_SETNEXTTEXTW
```

Microsoft Learn: [PSM_SETNEXTTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/psm-setnexttext)

### ShowWizButtons

```freebasic
sub ShowWizButtons( byval hDlg as HWND, byval dwFlag as DWORD, byval dwButton as DWORD )
```

Not part of the module (see the introduction). It would show or hide wizard buttons: `dwButton`
names the buttons, `PSWIZB_BACK` (1), `PSWIZB_NEXT`, `PSWIZB_FINISH` and `PSWIZB_CANCEL` (16),
and `dwFlag` lists those of them to show; the rest of `dwButton` are hidden. Send
`WM_USER + 138` (`PSM_SHOWWIZBUTTONS`) with `dwFlag` in `wParam` and `dwButton` in `lParam`.

**Example**

```freebasic
SendMessageW( hDlg, WM_USER + 138, 0, 1 )   ' PSM_SHOWWIZBUTTONS: hide Back
```

Microsoft Learn: [PSM_SHOWWIZBUTTONS](https://learn.microsoft.com/en-us/windows/win32/controls/psm-showwizbuttons)

### EnableWizButtons

```freebasic
sub EnableWizButtons( byval hDlg as HWND, byval dwState as DWORD, byval dwMask as DWORD )
```

Not part of the module (see the introduction). It would enable or disable wizard buttons:
`dwMask` names the buttons (`PSWIZB_NEXT`, `PSWIZB_FINISH` …) and `dwState` lists those of them
to enable; the rest of `dwMask` are disabled. Send `WM_USER + 139` (`PSM_ENABLEWIZBUTTONS`) with
`dwState` in `wParam` and `dwMask` in `lParam`.

**Example**

```freebasic
SendMessageW( hDlg, WM_USER + 139, 0, PSWIZB_NEXT )   ' PSM_ENABLEWIZBUTTONS: grey out Next
```

Microsoft Learn: [PSM_ENABLEWIZBUTTONS](https://learn.microsoft.com/en-us/windows/win32/controls/psm-enablewizbuttons)

### SetButtonText

```freebasic
sub SetButtonText( byval hDlg as HWND, byval dwButton as DWORD, byval pwszText as wstring ptr )
```

Not part of the module (see the introduction). It would set the text of one wizard button,
named by a `PSWIZB_*` value. Send `WM_USER + 140` (`PSM_SETBUTTONTEXTW`) with the button in
`wParam` and the text in `lParam`.

**Example**

```freebasic
dim wszText as wstring * 16 = "&Done"
SendMessageW( hDlg, WM_USER + 140, PSWIZB_FINISH, cast( LPARAM, @wszText ) )   ' PSM_SETBUTTONTEXTW
```

Microsoft Learn: [PSM_SETBUTTONTEXT](https://learn.microsoft.com/en-us/windows/win32/controls/psm-setbuttontext)

## See also

- [sys/win/gui](SysWin-Gui)
- [Animate](SysWin-Gui-Animate) for the control `Create` makes
- [TabCtl](SysWin-Gui-TabCtl) for pages on tabs inside an ordinary window
- [CDialog](CDialog)
