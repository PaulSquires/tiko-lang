[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **gui macros and helpers**

# gui macros and helpers

Extracts control ids, notification codes and pointers from window-message parameters.

A window procedure receives two numbers with every message, `wParam` and `lParam`, and what they
hold depends on the message. For the two messages controls talk to their parent with, the layout
is fixed:

| Message | `wParam` | `lParam` |
| --- | --- | --- |
| `WM_COMMAND` | low word: the control, menu item or accelerator identifier; high word: the notification code (`BN_CLICKED`, `EN_CHANGE` …), 0 for a menu, 1 for an accelerator | the control's handle, or `NULL` for a menu or an accelerator |
| `WM_NOTIFY` | the control's identifier | the address of an `NMHDR` (or of a larger structure that starts with one) holding the code, identifier and handle |

The macros on this page, which come with `sys/win/gui`, name those pieces. Each takes `wParam` and
`lParam` (often called `wp` and `lp` below) even when it uses only one of them, so that every call
looks the same: `CBCTL( wParam, lParam )`. They are plain text replacements, usable anywhere a
program imports `sys/win/gui`.

For `WM_COMMAND` use [CBCTL](#cbctl), [CBCTLMSG](#cbctlmsg) and [CBHNDL](#cbhndl). For `WM_NOTIFY`
use [CBNMHDR](#cbnmhdr), [CBNMSGPTR](#cbnmsgptr) or [CBNMTYPESET](#cbnmtypeset) and read the code,
identifier and handle from the structure: [CBNMCODE](#cbnmcode), [CBNMID](#cbnmid) and
[CBNMHWND](#cbnmhwnd) read `wParam` and `lParam` themselves and do not give those values.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A list view, an edit box and a button. Typing enables the button, clicking it disables it again,
and selecting a row puts its number in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_LIST = 101
const IDC_TEXT = 102
const IDC_ADD  = 103

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "MacroDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Message helpers", @WndProc )
    pWindow.SetClientSize( 320, 250 )
    pWindow.Center()
    dim hList as HWND = pWindow.AddControl( "ListView", hWin, IDC_LIST, "", 10, 10, 300, 190 )
    ListView.AddColumn( hList, 0, "Item", 200 )
    for i as long = 0 to 9
        ListView.AddItem( hList, i, -1, "Row " & i )
    next
    pWindow.AddControl( "Edit", hWin, IDC_TEXT, "", 10, 212, 200, 26 )
    dim hAdd as HWND = pWindow.AddControl( "Button", hWin, IDC_ADD, "&Done", 220, 211, 90, 28 )
    EnableWindow( hAdd, false )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            select case CBCTL( wParam, lParam )
                case IDC_TEXT
                    if CBCTLMSG( wParam, lParam ) = EN_CHANGE then EnableWindow( GetDlgItem( hwnd, IDC_ADD ), true )
                case IDC_ADD
                    if CBCTLMSG( wParam, lParam ) = BN_CLICKED then EnableWindow( CBHNDL( wParam, lParam ), false )
                case IDCANCEL
                    SendMessageW( hwnd, WM_CLOSE, 0, 0 )
            end select
            return 0
        case WM_NOTIFY
            if CBNMHDR( wParam, lParam )->idFrom = IDC_LIST andalso CBNMHDR( wParam, lParam )->code = LVN_ITEMCHANGED then
                dim pnmlv as NMLISTVIEW ptr = CBNMSGPTR( NMLISTVIEW, wParam, lParam )
                if pnmlv->uNewState and LVIS_SELECTED then SetWindowText( hwnd, "Row " & pnmlv->iItem & " selected" )
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

| Macro | Gives |
| --- | --- |
| [CBCTL](#cbctl) | `WM_COMMAND`: the control, menu or accelerator identifier. |
| [CBCTLMSG](#cbctlmsg) | `WM_COMMAND`: the notification code. |
| [CBHNDL](#cbhndl) | `WM_COMMAND`: the control's handle. |
| [CBNMHDR](#cbnmhdr) | `WM_NOTIFY`: an `NMHDR ptr` to the notification. |
| [CBNMSGPTR](#cbnmsgptr) | `WM_NOTIFY`: a pointer of the structure type you name. |
| [CBNMTYPESET](#cbnmtypeset) | `WM_NOTIFY`: a copy of the notification structure. |
| [CBNMCODE](#cbnmcode) | The low word of `wParam`. |
| [CBNMID](#cbnmid) | The high word of `wParam`. |
| [CBNMHWND](#cbnmhwnd) | `lParam` as an `HWND`. |
| [DDT_CBMACROS](#ddt_cbmacros) | Defined when the macros above are. |

## Reference

### CBCTL

```freebasic
#define CBCTL(wp, lp) LOWORD(wp)
```

The low word of `wParam`. In `WM_COMMAND` that is the identifier of the control that sent the
notification, of the menu item chosen, or of the accelerator pressed; `IDOK` and `IDCANCEL` also
come from Enter and Esc in a window that handles dialog keys.

**Example**

```freebasic
dim wParam as WPARAM = MAKEWPARAM( 1001, BN_CLICKED ), lParam as LPARAM = 0
if CBCTL( wParam, lParam ) = 1001 then print "control 1001"
```

Microsoft Learn: [WM_COMMAND](https://learn.microsoft.com/en-us/windows/win32/menurc/wm-command)

### CBCTLMSG

```freebasic
#define CBCTLMSG(wp, lp) HIWORD(wp)
```

The high word of `wParam`. In `WM_COMMAND` that is the notification code: `BN_CLICKED` (0) from a
button, `EN_CHANGE` (768) from an edit box, `CBN_SELCHANGE` from a combo box and so on; 0 for a
menu item and 1 for an accelerator.

**Example**

```freebasic
dim wParam as WPARAM = MAKEWPARAM( 102, EN_CHANGE ), lParam as LPARAM = 0
print CBCTLMSG( wParam, lParam )   ' prints 768
```

### CBHNDL

```freebasic
#define CBHNDL(wp, lp) cast(HWND, lp)
```

`lParam` as an `HWND`. In `WM_COMMAND` that is the handle of the control that sent the
notification, `NULL` for a menu item or an accelerator.

**Example**

```freebasic
dim wParam as WPARAM = MAKEWPARAM( 103, BN_CLICKED ), lParam as LPARAM = cast(LPARAM, hCtrl)
if CBHNDL( wParam, lParam ) then EnableWindow( CBHNDL( wParam, lParam ), false )
```

### CBNMHDR

```freebasic
#define CBNMHDR(wp, lp) cast(NMHDR PTR, lp)
```

`lParam` as an `NMHDR ptr`. In `WM_NOTIFY` it points to the notification's header: `->code` is the
notification code, `->idFrom` the control's identifier and `->hwndFrom` its handle. The structure
belongs to the control and is valid only while the message is being handled.

**Example**

```freebasic
dim hdr as NMHDR
hdr.idFrom = 101 : hdr.code = LVN_ITEMCHANGED
dim wParam as WPARAM = 101, lParam as LPARAM = cast(LPARAM, @hdr)
if CBNMHDR( wParam, lParam )->code = LVN_ITEMCHANGED then print "from control"; CBNMHDR( wParam, lParam )->idFrom
```

Microsoft Learn: [NMHDR](https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-nmhdr)

### CBNMSGPTR

```freebasic
#define CBNMSGPTR(msg, wp, lp) cast(msg PTR, CBNMHDR(wp, lp))
```

`lParam` as a pointer to the structure type `msg`, for the many notifications whose structure
starts with an `NMHDR` and carries more: `NMLISTVIEW` for list view changes, `NMTREEVIEWW` for tree
view selections, `NMLVDISPINFOW`, `NMTTDISPINFOW` and so on. Check `->hdr.code` (or
[CBNMHDR](#cbnmhdr)'s `->code`) first to know which structure it is.

**Example**

```freebasic
dim lv as NMLISTVIEW
lv.iItem = 4
dim wParam as WPARAM = 101, lParam as LPARAM = cast(LPARAM, @lv)
print "row"; CBNMSGPTR( NMLISTVIEW, wParam, lParam )->iItem
```

Microsoft Learn: [WM_NOTIFY](https://learn.microsoft.com/en-us/windows/win32/controls/wm-notify)

### CBNMTYPESET

```freebasic
#define CBNMTYPESET(tp, wp, lp) memcpy @tp, CAST(ANY PTR, lp), SIZEOF(tp)
```

Copies the structure `lParam` points to into the variable `tp`, `sizeof( tp )` bytes, so that the
values can be kept after the message has been handled. It is a statement, not an expression. The
variable's type must match the notification: copying a larger type than the control sent reads
past the end of its structure.

**Example**

```freebasic
dim src as NMHDR
src.idFrom = 101
dim wParam as WPARAM = 101, lParam as LPARAM = cast(LPARAM, @src)
dim hdr as NMHDR
CBNMTYPESET( hdr, wParam, lParam )
print hdr.idFrom   ' prints 101
```

### CBNMCODE

```freebasic
#define CBNMCODE(wp, lp) LOWORD(wp)
```

The low word of `wParam`, the same as [CBCTL](#cbctl). In `WM_NOTIFY` that is the low word of the
control's identifier, **not** the notification code: for a notification with the code
`TCN_SELCHANGE` from control 77 it gives 77. Read the code with `CBNMHDR( wParam, lParam )->code`.

**Example**

```freebasic
dim wParam as WPARAM = 77, lParam as LPARAM = 0
print CBNMCODE( wParam, lParam )   ' prints 77
```

### CBNMID

```freebasic
#define CBNMID(wp, lp) HIWORD(wp)
```

The high word of `wParam`, the same as [CBCTLMSG](#cbctlmsg). In `WM_NOTIFY` that is the high word
of the control's identifier, normally 0, **not** the identifier. Read the identifier with
`CBNMHDR( wParam, lParam )->idFrom`.

**Example**

```freebasic
dim wParam as WPARAM = 77, lParam as LPARAM = 0
print CBNMID( wParam, lParam )   ' prints 0
```

### CBNMHWND

```freebasic
#define CBNMHWND(wp, lp) cast(HWND, lp)
```

`lParam` as an `HWND`, the same as [CBHNDL](#cbhndl). In `WM_NOTIFY` `lParam` is the address of
the `NMHDR`, so the result is that address, **not** the control's handle. Read the handle with
`CBNMHDR( wParam, lParam )->hwndFrom`.

**Example**

```freebasic
dim hdr as NMHDR
hdr.hwndFrom = hCtrl
dim wParam as WPARAM = 101, lParam as LPARAM = cast(LPARAM, @hdr)
dim hFrom as HWND = CBNMHDR( wParam, lParam )->hwndFrom   ' not CBNMHWND( wParam, lParam )
```

### DDT_CBMACROS

```freebasic
#define DDT_CBMACROS
```

Defined, with no value, when the macros on this page are. They are defined only if `DDT_CBMACROS`
is not defined yet, so a program can test it or provide macros of its own under the same names.

**Example**

```freebasic
#ifdef DDT_CBMACROS
print "the CB macros are available"
#endif
```

## See also

- [CWindow](CWindow), whose window procedures these macros are used in
- [CDialog](CDialog)
- [sys/win/gui](SysWin-Gui)
- [ListView](SysWin-Gui-ListView), [TreeView](SysWin-Gui-TreeView) and the other control pages for each control's notifications
