[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **SysLink**

# SysLink

Measures a SysLink control, reads and sets its links, and finds the link at a point.

A SysLink control shows text with hyperlinks in it, written with `<a>` tags:
`Read the <a href="https://example.com">manual</a>`. Each `<a>` is one link, numbered from 0 in
the order of the text; it may carry an `href` (the URL) and an `id` (a name for the program).
Create the control with `CWindow.AddControl( "SysLink", ... )`, the tagged text as its title.
Every function here takes the control's handle first and is written with the namespace:
`SysLink.GetIdealHeight( hLink )`.

The control exists only in version 6 of the common controls: call `EnableVisualStyles()` at
start-up or give the program a manifest, or creation fails and `AddControl` returns `NULL`.

Clicking a link (or pressing Enter on it) does not open anything by itself. The parent receives
`WM_NOTIFY` with `NM_CLICK` or `NM_RETURN` and an `NMLINK`, whose `item` is the link's `LITEM`
with its index, `szID` and `szUrl`; the program opens the URL, for instance with
`ShellExecuteW`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A line with two links, sized to what its text needs within 320 pixels. One opens a web page;
the other, which has no URL, is recognised by its `id`.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_LINK = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "SysLinkDemo"
    dim hWin as HWND = pWindow.Create( NULL, "SysLink", @WndProc )
    pWindow.SetClientSize( 360, 80 )
    pWindow.Center()
    dim hLink as HWND = pWindow.AddControl( "SysLink", hWin, IDC_LINK, _
        "See the <a href=""https://learn.microsoft.com"">documentation</a> or <a id=""about"">about this program</a>.", _
        20, 30, 320, 20 )
    dim sz as SIZE = SysLink.GetIdealSize( hLink, 320 )
    SetWindowPos( hLink, NULL, 0, 0, sz.cx, sz.cy, SWP_NOMOVE or SWP_NOZORDER )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = cast( NMHDR ptr, lParam )
            if pnmh->idFrom = IDC_LINK andalso ( pnmh->code = NM_CLICK orelse pnmh->code = NM_RETURN ) then
                dim pnml as NMLINK ptr = cast( NMLINK ptr, lParam )
                if pnml->item.szID = "about" then
                    SetWindowText( hwnd, "A SysLink demonstration" )
                else
                    ShellExecuteW( hwnd, "open", pnml->item.szUrl, NULL, NULL, SW_SHOWNORMAL )
                end if
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
| [GetIdealHeight](#getidealheight) | Returns the height the text needs on one line. |
| [GetIdealSize](#getidealsize) | Returns the size the text needs within a width. |
| [GetItem](#getitem) | Reads a link's URL, id or state. |
| [SetItem](#setitem) | Changes a link's URL, id or state. |
| [HitTest](#hittest) | Finds the link at a point. |

## Reference

### GetIdealHeight

```freebasic
function GetIdealHeight( byval hLM as HWND ) as long
```

Returns the height in pixels of the control's text. The function passes the control no width
to wrap at, so the text is measured as one line whatever the control's width: a control 60
pixels wide whose text needs 144 pixels of height at that width still gets 16. For wrapped text
use [GetIdealSize](#getidealsize) with the width.

**Returns** the height of one line of the text.

**Example**

```freebasic
SetWindowPos( hCtrl, NULL, 0, 0, 400, SysLink.GetIdealHeight( hCtrl ), SWP_NOMOVE or SWP_NOZORDER )   ' one line
```

Microsoft Learn: [LM_GETIDEALHEIGHT](https://learn.microsoft.com/en-us/windows/win32/controls/lm-getidealheight)

### GetIdealSize

```freebasic
function GetIdealSize overload( byval hLM as HWND, byval cxMaxWidth as long, byval psize as SIZE ptr ) as long
function GetIdealSize overload( byval hLM as HWND, byval cxMaxWidth as long, byref sz as SIZE ) as long
function GetIdealSize overload( byval hLM as HWND, byval cxMaxWidth as long ) as SIZE
```

Works out the size the text needs when it may be at most `cxMaxWidth` pixels wide, wrapping it
as needed: `cx` receives the width actually used, `cy` the height. A text that needs 402 × 16
on one line needs 52 × 144 within 60 pixels. It is the same request as
[GetIdealHeight](#getidealheight) with a width and a `SIZE` passed.

**Returns** the height (first two forms), or the size.

**Example**

```freebasic
dim sz as SIZE = SysLink.GetIdealSize( hCtrl, 200 )
SetWindowPos( hCtrl, NULL, 0, 0, sz.cx, sz.cy, SWP_NOMOVE or SWP_NOZORDER )
```

Microsoft Learn: [LM_GETIDEALSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/lm-getidealsize)

### GetItem

```freebasic
function GetItem overload( byval hLM as HWND, byval pItem as LITEM ptr ) as boolean
function GetItem overload( byval hLM as HWND, byref item as LITEM ) as boolean
```

Reads the attributes of one link. Set `mask` to `LIF_ITEMINDEX` and `iLink` to the link's index,
plus the members wanted: `LIF_URL` (`szUrl`), `LIF_ITEMID` (`szID`), `LIF_STATE` (`state`, with
`stateMask`: `LIS_FOCUSED`, `LIS_ENABLED`, `LIS_VISITED` …).

**Returns** `true` on success.

**Example**

```freebasic
dim li as LITEM
li.mask = LIF_ITEMINDEX or LIF_URL : li.iLink = 0
if SysLink.GetItem( hCtrl, li ) then print "first link goes to "; li.szUrl
```

Microsoft Learn: [LM_GETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/lm-getitem)

### SetItem

```freebasic
function SetItem overload( byval hLM as HWND, byval pItem as LITEM ptr ) as boolean
function SetItem overload( byval hLM as HWND, byref item as LITEM ) as boolean
```

Changes the attributes of one link, chosen and named by `mask` and `iLink` as for
[GetItem](#getitem). Marking a link `LIS_VISITED` draws it in the visited colour.

**Returns** `true` on success.

**Example**

```freebasic
dim li as LITEM
li.mask = LIF_ITEMINDEX or LIF_URL : li.iLink = 0
li.szUrl = "https://example.org"
SysLink.SetItem( hCtrl, li )
```

Microsoft Learn: [LM_SETITEM](https://learn.microsoft.com/en-us/windows/win32/controls/lm-setitem)

### HitTest

```freebasic
function HitTest overload( byval hLM as HWND, byval phti as LHITTESTINFO ptr ) as boolean
function HitTest overload( byval hLM as HWND, byref hti as LHITTESTINFO ) as boolean
```

Finds the link at `pt`, in client coordinates of the control. When there is one, `item`
receives its index, `szID` and `szUrl`.

**Returns** `true` when the point is on a link.

**Example**

```freebasic
dim lh as LHITTESTINFO
GetCursorPos( @lh.pt ) : ScreenToClient( hCtrl, @lh.pt )
if SysLink.HitTest( hCtrl, lh ) then print "over link"; lh.item.iLink
```

Microsoft Learn: [LM_HITTEST](https://learn.microsoft.com/en-us/windows/win32/controls/lm-hittest)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "SysLink", ... )`
- [Label](SysWin-Gui-Label) for plain text
- [Internet](SysWin-Internet) for opening a URL in the browser
- [Window text and styles](SysWin-Window-Text-and-Styles) for `EnableVisualStyles`
