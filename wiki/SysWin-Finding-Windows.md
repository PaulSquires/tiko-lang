[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Finding windows**

# Finding windows

Finds a control's form, top-level windows, controls by id, and the windows of a process.

Windows are linked in two ways. A *child* window (a control, with `WS_CHILD`) has a **parent**:
it lives inside the parent's client area. A top-level window can have an **owner**: it stays
above its owner and is hidden with it, as a dialog stays above the main window. The functions
here walk those links up, or search down for a control by its id, so a handler that only has one
control's handle can reach the rest of its window.

Every process has an id; the last functions go from a window or a process id to the program that
runs it.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A window with an edit control and a button. The button's handler starts from the button alone:
it finds the form, finds the edit control by its id, and fills it with the path of the program
that owns the form:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "FindDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Finding windows", @WndProc )
    SetWindowClientSizeForDpi( hWin, 420, 110 )
    CenterWindow( hWin )
    pWindow.AddControl( "Edit", hWin, 101, "", 20, 20, 380, 24 )
    pWindow.AddControl( "Button", hWin, 100, "&Who owns this window?", 20, 60, 200, 30 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = 100 andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                dim hButton as HWND = cast( HWND, lParam )
                dim hForm as HWND = GetFormHandle( hButton )
                dim hEdit as HWND = GetControlHandle( hButton, 101 )
                SetWindowText( hEdit, GetPathFromWindowHandle( hForm ) )
            end if
            return 0
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
| [ForceSetForegroundWindow](#forcesetforegroundwindow) | Brings a window to the front and gives it the keyboard, even from the background. |
| [GetTopLevelWindow](#gettoplevelwindow) | Follows parents and owners up to the window at the top. |
| [GetTopLevelParent](#gettoplevelparent) | Follows parents up to the top-level window. |
| [GetFormHandle](#getformhandle) | Returns the form or MDI child window a control is on. |
| [GetControlHandle](#getcontrolhandle) | Finds a control on a form by its id. |
| [GetTopEnabledWindow](#gettopenabledwindow) | Returns the program's frontmost enabled, visible window. |
| [GethWndFromPID](#gethwndfrompid) | Returns a top-level window of a process. |
| [GetPathFromProcessId](#getpathfromprocessid) | Returns the path of the program a process runs. |
| [GetPathFromWindowHandle](#getpathfromwindowhandle) | Returns the path of the program that created a window. |

## Reference

### ForceSetForegroundWindow

```freebasic
sub ForceSetForegroundWindow( byval hWin as HWND )
```

Brings a window to the front, activates it and gives it the keyboard focus. Windows refuses
`SetForegroundWindow` to a program that is not in the foreground; this joins the calling
thread's input to the thread of the current foreground window for the length of the call, which
lets the request through.

Joining input queues can hang both threads if the other one is not responding, so keep it for
the cases that need it, such as a second copy of a program handing over to the first.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The top-level window to bring forward. |

**Example**

```freebasic
if IsIconic( hwnd ) then ShowWindow( hwnd, SW_RESTORE )
ForceSetForegroundWindow( hwnd )
```

Microsoft Learn: [AttachThreadInput](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-attachthreadinput), [SetForegroundWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setforegroundwindow)

### GetTopLevelWindow

```freebasic
function GetTopLevelWindow( byval hWin as HWND ) as HWND
```

Walks up from a window to the one at the very top: from a child to its parent, and from a
top-level window to its owner, until there is neither. From a control on a dialog owned by the
main window, it returns the main window.

**Returns** the window at the top, which is `hWin` itself for an unowned top-level window, or
`NULL` when `hWin` is not a window.

**Example**

```freebasic
dim hMain as HWND = GetTopLevelWindow( hCtrl )
```

Microsoft Learn: [GetWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindow)

### GetTopLevelParent

```freebasic
function GetTopLevelParent( byval hWin as HWND ) as HWND
```

Walks up from a window through `GetParent` until there is no parent. For a child window that is
its top-level window. `GetParent` also returns the owner of a `WS_POPUP` window, so a popup's
owner is followed; the owner of a top-level window without `WS_POPUP` is not, and the window
itself is returned.

**Returns** the last window reached, or `NULL` when `hWin` is not a window.

**Example**

```freebasic
dim hTop as HWND = GetTopLevelParent( hCtrl )
```

Microsoft Learn: [GetParent](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getparent)

### GetFormHandle

```freebasic
function GetFormHandle( byval hWin as HWND ) as HWND
```

Returns the form a control is on: it walks up through the parents while the window has
`WS_CHILD`, and stops at the first window that is not a child or that is an MDI child window
(`WS_EX_MDICHILD`). A control nested in a group box or a tab page gives the form, not the
container.

**Returns** the form or MDI child window, `hWin` itself for a top-level window, or `NULL` for
`NULL`.

**Example**

```freebasic
dim hForm as HWND = GetFormHandle( hCtrl )
SetWindowText( hForm, "changed by a control" )
```

### GetControlHandle

```freebasic
function GetControlHandle( byval hWin as HWND, byval wCtrlID as WORD ) as HWND
```

Finds the control with the id `wCtrlID` on a form. `hWin` can be the form or any control on
it: the search starts from its [form](#getformhandle) and looks at every window inside, nested
ones included, returning the first whose id matches.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The form, or any control on it. |
| `wCtrlID` | The control id. |

**Returns** the control, or `NULL` when there is none with that id.

**Example**

```freebasic
dim hEdit as HWND = GetControlHandle( hwnd, 101 )
if hEdit then SetFocus( hEdit )
```

Microsoft Learn: [EnumChildWindows](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enumchildwindows)

### GetTopEnabledWindow

```freebasic
function GetTopEnabledWindow() as HWND
```

Returns the frontmost top-level window of the calling program that is both enabled and visible,
going down the Z order. Tooltip windows are skipped. A window disabled while a modal dialog is up
is passed over, so the dialog is returned instead.

**Returns** the window, or `NULL` when the program has no such window (a console program without
windows gets `NULL`).

**Example**

```freebasic
MsgBox( GetTopEnabledWindow(), "The download has finished." )
```

Microsoft Learn: [EnumWindows](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enumwindows)

### GethWndFromPID

```freebasic
function GethWndFromPID( byval PID as DWORD ) as HWND
```

Returns the first top-level window, going down the Z order, that belongs to the process with the
id `PID`. The window can be hidden: a program keeps windows of its own that are never shown, so
the window found is not always the main window.

**Returns** the window, or `NULL` when the process has no top-level window.

**Example**

```freebasic
dim hOther as HWND = GethWndFromPID( GetCurrentProcessId() )
if hOther then print "class "; GetWindowClassName( hOther )
```

Microsoft Learn: [GetWindowThreadProcessId](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowthreadprocessid)

### GetPathFromProcessId

```freebasic
function GetPathFromProcessId( byval dwProcessId as DWORD ) as ustring
```

Returns the full path of the executable a process runs. The process is opened with query and
read access, which fails for system processes and for processes of other users or with higher
rights than the caller.

**Returns** the path, or an empty string when the process cannot be opened.

**Example**

```freebasic
print "this program: "; GetPathFromProcessId( GetCurrentProcessId() )
```

Microsoft Learn: [GetModuleFileNameExW](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getmodulefilenameexw)

### GetPathFromWindowHandle

```freebasic
function GetPathFromWindowHandle( byval hWin as HWND ) as ustring
```

Returns the full path of the executable of the process that created a window: the window's
process id passed to [GetPathFromProcessId](#getpathfromprocessid), with the same limits.

**Returns** the path, or an empty string for an invalid handle or a process that cannot be
opened.

**Example**

```freebasic
print "the foreground window belongs to "; GetPathFromWindowHandle( GetForegroundWindow() )
```

## See also

- [Category: sys/win](Category-Sys-Win)
- [Window text and styles](SysWin-Window-Text-and-Styles)
- [Window size and position](SysWin-Window-Size-and-Position)
- [CWindow](CWindow)
