[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkScrollPanel**

# tkScrollPanel

Scrolls a page of ordinary child widgets that is taller than the space it is shown in.

tkScrollPanel is a viewport onto a page of controls, with a vertical scrollbar in a strip down
the right edge. Build the page from buttons, text boxes and the rest exactly as on a plain
window, lay them out once, and the panel scrolls by moving the whole page under the viewport.
Your widgets keep the coordinates you gave them. Use it for a settings page or any form that
runs past one screen.

The thumb appears only when the mouse is over the panel or the focus is inside it, but the strip
is always reserved, so nothing on the page shifts sideways. When the focus moves to a widget
below or above the viewport (by Tab or by `tkHost_SetFocus`), the panel scrolls it into view;
`tkScrollPanel_SetAutoScrollToFocus( h, false )` turns that off.

**Parent your widgets to `tkScrollPanel_GetPanel( h )`, never to the panel's own handle.** A
widget created on the panel itself sits over the viewport and never scrolls.

## Importing

```freebasic
#import "vendor/tkControls/tkScrollPanel"

using tkScrollPanel
using tkHost
using tkPaint
```

The module imports `tkHost`, `tkTheme`, `tkScrollBar` and `tkVScrollBar` publicly; the bar inside
the panel is a [tkVScrollBar](tkVScrollBar), returned by `tkScrollPanel_GetScrollBar`.

## Example

A layout callback places the page's widgets against the width it is handed and returns the
page height; the panel calls it whenever the viewport is resized. The rows here are
[tkButton](tkButton)s, so the program also imports `vendor/tkControls/tkButton`.

```freebasic
dim shared as TK_WIDGET ptr gScp, gRows(0 to 29)
dim shared as long gRowCount

function Page_Layout( byval hPanel as TK_WIDGET ptr, byval cxPanel as long ) as long
    dim as long y = tkHost_Scale( gHost, 16 )
    for i as long = 0 to gRowCount - 1
        tkWidget_SetPos( gRows(i), cxPanel - tkHost_Scale( gHost, 186 ), y, _
                         tkHost_Scale( gHost, 170 ), tkHost_Scale( gHost, 24 ) )
        y += tkHost_Scale( gHost, 34 )
    next
    return y + tkHost_Scale( gHost, 16 )       ' the page height
end function

gScp = tkScrollPanel_Create( tkHost_Root( gHost ), 100 )
tkScrollPanel_SetLayoutCallback( gScp, @Page_Layout )
tkScrollPanel_SetLineHeight( gScp, 34 )        ' one wheel line, unscaled
dim as TK_WIDGET ptr hPage = tkScrollPanel_GetPanel( gScp )
for i as long = 0 to 29
    gRows(i) = tkButton_Create( hPage, 2000 + i )
next
gRowCount = 30
tkWidget_SetPos( gScp, x, y, cx, cy )
```

Without a layout callback, place the widgets yourself and call `tkScrollPanel_SetContentHeight`,
or let `tkScrollPanel_AutoSizeContent` measure the visible children. `tkScrollPanel_SetPos`,
`tkScrollPanel_SetContentHeight` and the other setters are silent; the wheel, the thumb and the
focus scroll call the scroll callback.

## Coming from PsScrollPanel

[PsScrollPanel](PsScrollPanel) remains the behaviour reference for everything not listed here.

- Names: `PsScrollPanel_*` → `tkScrollPanel_*`, `PSSCROLLPANEL_*` → `TKSCROLLPANEL_*`.
  `SCP_PAINTINFO`, `SCP_MESSAGEINFO` and the `SCP_*` callback types keep their names. Handles
  are `TK_WIDGET ptr`.
- `tkScrollPanel_Create( hParent, CtrlID )` takes a `TK_WIDGET ptr` parent (`tkHost_Root( h )`
  for a top-level window). The page has id `CtrlID + 1` and the bar `CtrlID + 2`.
- Auto-scroll-to-focus works: a focus change landing inside the page scrolls it into view and
  calls the scroll callback.
- `SCP_MESSAGEINFO` carries `msg` (a `TKM_*`), `x`, `y` and `wheelY`, and `hFrom` (the page or
  the panel). It observes the wheel, left and right button down and up, and mouse moves. There
  is no `lResult`.
- `tkScrollPanel_HandleWheelDelta` takes 120ths of a notch, positive scrolling up. The
  lines-per-notch setting is fixed at `TKSCROLL_SYSTEM_WHEEL_LINES` (3), and there is no
  page-per-notch mode.
- Added: `tkScrollPanel_GetColors` and `tkScrollPanel_GetLineHeight`, so your own widgets can
  match the page's colours.
- Gone: `PsScrollPanel_SetFont` (give each widget its font through its own setter), the
  `WM_CTLCOLOR*` brush and the forwarding of `WM_COMMAND` / `WM_NOTIFY` to the parent (tk
  widgets report through their own callbacks), `IsDialogMessage` (the host owns Tab), and
  PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKSCROLLPANEL_REVEAL_MS = 100
const TKSCROLLPANEL_LINE_HEIGHT = 20 ' default wheel unit, unscaled (scaled at use)
const TKSCROLLPANEL_TIMER_REVEAL = TK_TIMER_APP
```

### Types

```freebasic
type SCP_PAINTINFO
    hScrollPanel as TK_WIDGET ptr
    hPanel       as TK_WIDGET ptr     ' the page, being painted
    b            as TK_PAINT ptr
    rcClient     as TKRECT            ' the WHOLE page, page coordinates
    nPos         as long
end type

type SCP_MESSAGEINFO
    hScrollPanel as TK_WIDGET ptr
    hPanel       as TK_WIDGET ptr
    hFrom        as TK_WIDGET ptr     ' which of the two it arrived on
    msg          as long              ' TKM_*
    x            as single
    y            as single
    wheelY       as single
end type

type TKSCROLLPANEL_STATE   ' per-instance state; reach it through the procedures

type SCP_PaintCallbackSub as sub( byval p as SCP_PAINTINFO ptr )
type SCP_MessageCallbackFunc as function( byval m as SCP_MESSAGEINFO ptr ) as boolean
type SCP_LayoutCallbackFunc as function( byval hPanel as TK_WIDGET ptr, byval cxPanel as long ) as long
type SCP_ScrollCallbackSub as sub( byval hScrollPanel as TK_WIDGET ptr, byval newPos as long )
```

### Procedures

```freebasic
function tkScrollPanel_ShouldShow( byval bNeeds as boolean, byval bMouse as boolean, byval bFocus as boolean ) as boolean
function tkScrollPanel_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkScrollPanel_GetPanel( byval hScp as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkScrollPanel_GetScrollBar( byval hScp as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkScrollPanel_SetContentHeight( byval hScp as TK_WIDGET ptr, byval nHeight as long )
function tkScrollPanel_GetContentHeight( byval hScp as TK_WIDGET ptr ) as long
function tkScrollPanel_AutoSizeContent( byval hScp as TK_WIDGET ptr, byval bottomPadding as long = 0 ) as long
function tkScrollPanel_GetPos( byval hScp as TK_WIDGET ptr ) as long
sub tkScrollPanel_SetPos( byval hScp as TK_WIDGET ptr, byval nPosition as long )
function tkScrollPanel_ScrollBy( byval hScp as TK_WIDGET ptr, byval nDelta as long ) as boolean
function tkScrollPanel_EnsureVisible( byval hScp as TK_WIDGET ptr, byval hChild as TK_WIDGET ptr, byval nMargin as long = 0 ) as boolean
function tkScrollPanel_HandleWheelDelta( byval hScp as TK_WIDGET ptr, byval nDelta as long ) as boolean
sub tkScrollPanel_SetLineHeight( byval hScp as TK_WIDGET ptr, byval nHeight as long )
function tkScrollPanel_GetLineHeight( byval hScp as TK_WIDGET ptr ) as long
sub tkScrollPanel_SetAutoScrollToFocus( byval hScp as TK_WIDGET ptr, byval bEnable as boolean )
function tkScrollPanel_GetAutoScrollToFocus( byval hScp as TK_WIDGET ptr ) as boolean
function tkScrollPanel_GetViewportHeight( byval hScp as TK_WIDGET ptr ) as long
function tkScrollPanel_GetPanelWidth( byval hScp as TK_WIDGET ptr ) as long
function tkScrollPanel_IsThumbVisible( byval hScp as TK_WIDGET ptr ) as boolean
sub tkScrollPanel_Recalc( byval hScp as TK_WIDGET ptr )
sub tkScrollPanel_SetColors( byval hScp as TK_WIDGET ptr, byval backclr as ulong, byval foreclr as ulong )
sub tkScrollPanel_GetColors( byval hScp as TK_WIDGET ptr, byref backclr as ulong, byref foreclr as ulong )
sub tkScrollPanel_SetScrollBarColors( byval hScp as TK_WIDGET ptr, byval backclr as ulong, byval foreclr as ulong, byval foreclrhot as ulong )
sub tkScrollPanel_ApplyTheme( byval hScp as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkScrollPanel_UnpinColors( byval hScp as TK_WIDGET ptr )
sub tkScrollPanel_SetScrollBarWidth( byval hScp as TK_WIDGET ptr, byval nWidth as long )
sub tkScrollPanel_SetPaintCallback( byval hScp as TK_WIDGET ptr, byval usersub as SCP_PaintCallbackSub )
sub tkScrollPanel_SetMessageCallback( byval hScp as TK_WIDGET ptr, byval userfunc as SCP_MessageCallbackFunc )
sub tkScrollPanel_SetLayoutCallback( byval hScp as TK_WIDGET ptr, byval userfunc as SCP_LayoutCallbackFunc )
sub tkScrollPanel_SetScrollCallback( byval hScp as TK_WIDGET ptr, byval usersub as SCP_ScrollCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsScrollPanel](PsScrollPanel), the PsControls control
