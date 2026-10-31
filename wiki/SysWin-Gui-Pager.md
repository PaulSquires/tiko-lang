[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **Pager**

# Pager

Sets what a pager control scrolls, and reads and sets its position, buttons and colours.

A pager control is a strip that holds one window too wide (or too tall) for the space it is
given, typically a toolbar, and shows arrow buttons at its ends that scroll the window through
it. Create one with `CWindow.AddControl( "Pager", ... )`, which makes a horizontal pager
(`PGS_HORZ`); then create the contained window as a **child of the pager** and hand it over with
[SetChild](#setchild). Every function here takes the pager's handle first and is written with
the namespace: `Pager.SetChild( hPager, hToolbar )`.

The pager does not measure the contained window. It asks its parent with a `WM_NOTIFY`
carrying `PGN_CALCSIZE`: the parent fills in `iWidth` (or `iHeight`) of the `NMPGCALCSIZE` with
the window's full size. [RecalcSize](#recalcsize) asks again after the contents change.
Positions and sizes are in pixels.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A 300-pixel pager holding a label 900 pixels wide; the arrows scroll the label, and each scroll
puts the position it starts from in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_PAGER = 101
const CONTENT_WIDTH = 900

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "PagerDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Pager", @WndProc )
    pWindow.SetClientSize( 340, 80 )
    pWindow.Center()
    dim hPager as HWND = pWindow.AddControl( "Pager", hWin, IDC_PAGER, "", 20, 25, 300, 30 )
    dim hLabel as HWND = pWindow.AddControl( "Label", hPager, -1, _
        "A long line of text that is far wider than the pager, so the pager shows its arrows.", _
        0, 0, CONTENT_WIDTH, 30 )
    Pager.SetButtonSize( hPager, 16 )
    Pager.SetChild( hPager, hLabel )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = cast( NMHDR ptr, lParam )
            if pnmh->idFrom = IDC_PAGER then
                select case pnmh->code
                    case PGN_CALCSIZE
                        dim pcs as NMPGCALCSIZE ptr = cast( NMPGCALCSIZE ptr, lParam )
                        if pcs->dwFlag = PGF_CALCWIDTH then pcs->iWidth = CONTENT_WIDTH
                    case PGN_SCROLL
                        SetWindowText( hwnd, "Scrolling from " & Pager.GetPos( pnmh->hwndFrom ) )
                end select
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
| [SetChild](#setchild) | Sets the window the pager scrolls. |
| [RecalcSize](#recalcsize) | Makes the pager ask for the contained window's size again. |
| [GetPos](#getpos) | Returns the scroll position. |
| [SetPos](#setpos) | Scrolls to a position. |
| [GetButtonSize](#getbuttonsize) | Returns the size of the arrow buttons. |
| [SetButtonSize](#setbuttonsize) | Sets the size of the arrow buttons. |
| [GetButtonState](#getbuttonstate) | Returns whether an arrow button is shown, greyed or pressed. |
| [GetBorder](#getborder) | Returns the border around the contained window. |
| [SetBorder](#setborder) | Sets the border around the contained window. |
| [GetBkColor](#getbkcolor) | Returns the background colour. |
| [SetBkColor](#setbkcolor) | Sets the background colour. |
| [ForwardMouse](#forwardmouse) | Passes mouse moves on to the contained window. |
| [GetDropTarget](#getdroptarget) | Returns the pager's `IDropTarget`. |

## Reference

### SetChild

```freebasic
sub SetChild( byval hPager as HWND, byval hwndChild as HWND )
```

Makes `hwndChild` the window the pager scrolls. It does not change the window's parent: create
the window as a child of the pager. The pager then sends `PGN_CALCSIZE` to find its size.

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
Pager.SetChild( hCtrl, pWindow->AddControl( "Toolbar", hCtrl, 300 ) )
```

Microsoft Learn: [PGM_SETCHILD](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-setchild)

### RecalcSize

```freebasic
sub RecalcSize( byval hPager as HWND )
```

Makes the pager send `PGN_CALCSIZE` again and lay itself out for the size it is given. Call it
after the contained window grows or shrinks, for instance after buttons are added to a toolbar.

**Example**

```freebasic
Pager.RecalcSize( hCtrl )
```

Microsoft Learn: [PGM_RECALCSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-recalcsize)

### GetPos

```freebasic
function GetPos( byval hPager as HWND ) as long
```

**Returns** the scroll position, in pixels from the start of the contained window: 0 when it is
not scrolled.

**Example**

```freebasic
print "scrolled by"; Pager.GetPos( hCtrl ); " pixels"
```

Microsoft Learn: [PGM_GETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getpos)

### SetPos

```freebasic
function SetPos( byval hPager as HWND, byval iPos as long ) as long
```

Scrolls the contained window to position `iPos`, in pixels.

**Returns** the control's reply, which carries no information.

**Example**

```freebasic
Pager.SetPos( hCtrl, 0 )   ' back to the start
```

Microsoft Learn: [PGM_SETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-setpos)

### GetButtonSize

```freebasic
function GetButtonSize( byval hPager as HWND ) as long
```

**Returns** the size of the arrow buttons in pixels: their width for a horizontal pager, their
height for a vertical one. It is 12 unless changed.

**Example**

```freebasic
print "arrow buttons:"; Pager.GetButtonSize( hCtrl ); " pixels"
```

Microsoft Learn: [PGM_GETBUTTONSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getbuttonsize)

### SetButtonSize

```freebasic
function SetButtonSize( byval hPager as HWND, byval iSize as long ) as long
```

Sets the size of the arrow buttons in pixels.

**Returns** the previous size.

**Example**

```freebasic
Pager.SetButtonSize( hCtrl, 16 )
```

Microsoft Learn: [PGM_SETBUTTONSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-setbuttonsize)

### GetButtonState

```freebasic
function GetButtonState( byval hPager as HWND, byval iButton as long ) as DWORD
```

Returns the state of one arrow button: `iButton` is `PGB_TOPORLEFT` or `PGB_BOTTOMORRIGHT`.

**Returns** `PGF_INVISIBLE`, `PGF_NORMAL`, `PGF_GRAYED`, `PGF_DEPRESSED` or `PGF_HOT`.

**Example**

```freebasic
if Pager.GetButtonState( hCtrl, PGB_BOTTOMORRIGHT ) = PGF_INVISIBLE then print "scrolled to the end"
```

Microsoft Learn: [PGM_GETBUTTONSTATE](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getbuttonstate)

### GetBorder

```freebasic
function GetBorder( byval hPager as HWND ) as long
```

**Returns** the width of the border drawn around the contained window, in pixels; 0 unless
changed.

**Example**

```freebasic
print "border:"; Pager.GetBorder( hCtrl )
```

Microsoft Learn: [PGM_GETBORDER](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getborder)

### SetBorder

```freebasic
function SetBorder( byval hPager as HWND, byval iBorder as long ) as long
```

Sets the width of the border around the contained window, in pixels.

**Returns** the previous border.

**Example**

```freebasic
Pager.SetBorder( hCtrl, 2 )
```

Microsoft Learn: [PGM_SETBORDER](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-setborder)

### GetBkColor

```freebasic
function GetBkColor( byval hPager as HWND ) as COLORREF
```

**Returns** the background colour; the button-face colour unless changed.

**Example**

```freebasic
print "background: &h"; hex( Pager.GetBkColor( hCtrl ) )
```

Microsoft Learn: [PGM_GETBKCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getbkcolor)

### SetBkColor

```freebasic
function SetBkColor( byval hPager as HWND, byval clr as COLORREF ) as COLORREF
```

Sets the background colour, seen around and behind the contained window.

**Returns** the previous colour.

**Example**

```freebasic
Pager.SetBkColor( hCtrl, BGR( 255, 255, 255 ) )
```

Microsoft Learn: [PGM_SETBKCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-setbkcolor)

### ForwardMouse

```freebasic
sub ForwardMouse( byval hPager as HWND, byval bForward as boolean )
```

With `bForward` `true` the pager passes `WM_MOUSEMOVE` on to the contained window, which a
toolbar needs to show hot buttons; `false` stops it.

**Example**

```freebasic
Pager.ForwardMouse( hCtrl, true )
```

Microsoft Learn: [PGM_FORWARDMOUSE](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-forwardmouse)

### GetDropTarget

```freebasic
sub GetDropTarget overload( byval hPager as HWND, byval ppdt as IDropTarget ptr ptr )
function GetDropTarget overload( byval hPager as HWND ) as IDropTarget ptr
```

Gets the pager's `IDropTarget` interface, for a program that handles drag and drop over the
pager. The pointer holds a reference: call `Release` on it when done.

**Returns** the interface pointer, or `NULL` (second form).

**Example**

```freebasic
dim pdt as IDropTarget ptr = Pager.GetDropTarget( hCtrl )
if pdt then pdt->lpVtbl->Release( pdt )
```

Microsoft Learn: [PGM_GETDROPTARGET](https://learn.microsoft.com/en-us/windows/win32/controls/pgm-getdroptarget)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "Pager", ... )`
- [ToolBar](SysWin-Gui-ToolBar), the usual contents of a pager
- [Rebar](SysWin-Gui-Rebar)
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_NOTIFY`
