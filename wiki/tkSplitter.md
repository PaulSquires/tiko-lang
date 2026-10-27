[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkSplitter**

# tkSplitter

Draws a draggable divider bar between two panes and reports where the user drags it.

tkSplitter is a thin bar, vertical or horizontal, that shows a resize cursor, moves itself while
the user drags it, and calls you back with its new position. It keeps exactly one number: the
bar's leading edge in its parent's coordinates (its x for a vertical bar, its y for a horizontal
one).

It does not own, create or size the panes on either side. Your layout code reads
`tkSplitter_GetPos`, places the panes, and pushes the limits in with `tkSplitter_SetRange`
whenever the window resizes. Use it for any two-pane layout: a file list beside an editor, an
output panel under a document.

## Importing

```freebasic
#import "vendor/tkControls/tkSplitter"

using tkSplitter
using tkHost
using tkPaint
```

The module imports `tkHost` and `tkTheme` publicly, so `tkHost_*`, `tkWidget_*`, the `TK_PAINT`
drawing calls and `tkTheme_*` are available once their namespaces are opened with `using`.

## Example

A vertical bar between two panes. The callback fires with `TKSPLITTER_PHASE_BEGIN`, then
`TKSPLITTER_PHASE_MOVE` for each change of position, then `TKSPLITTER_PHASE_END`.

```freebasic
dim shared as TK_WIDGET ptr gSplit

sub Split_PosChanged( byval hSplitter as TK_WIDGET ptr, byval newPos as long, byval nPhase as long )
    ' The bar has already moved itself: lay out the panes either side of newPos.
    tkHost_Invalidate( gHost )
end sub

sub Form_Size( byval h as TK_HOST ptr )
    dim as long pw, ph
    tkHost_PixelSize( h, pw, ph )
    dim as long bar = tkHost_Scale( h, 6 ), minPane = tkHost_Scale( h, 80 )
    tkSplitter_SetRange( gSplit, minPane, pw - minPane - bar )
    tkWidget_SetPos( gSplit, tkSplitter_GetPos( gSplit ), 0, bar, ph )
end sub

gSplit = tkSplitter_Create( tkHost_Root( gHost ), 1001, TKSPLITTER_VERTICAL )
tkSplitter_SetPosChangedCallback( gSplit, @Split_PosChanged )
tkSplitter_SetPos( gSplit, tkHost_Scale( gHost, 240 ) )
gHost->OnSize = @Form_Size
```

`tkSplitter_SetPos` and `tkSplitter_SetRange` are silent: they move or clamp the bar without
calling the position callback, so repaint the panes yourself after calling them.

## Coming from PsSplitter

The behaviour reference is [PsSplitter](PsSplitter); everything not listed here works the same.

- Names: `PsSplitter_*` → `tkSplitter_*`, `PSSPLITTER_*` → `TKSPLITTER_*`. The callback types
  `SPL_PaintCallbackSub`, `SPL_MessageCallbackFunc` and `SPL_PosChangedCallbackSub` keep their
  names. The handle is `TK_WIDGET ptr`.
- `tkSplitter_Create( hParent, ctrlId [, nOrientation] )` takes a `TK_WIDGET ptr` parent; for a
  top-level window pass `tkHost_Root( h )`. The bar is created at 0,0 with no size: place it
  with `tkWidget_SetPos`.
- The cursor is the widget's own, `TK_CURSOR_SIZEWE` or `TK_CURSOR_SIZENS`, and holds for the
  whole drag. There is no `WM_SETCURSOR`; replace it with `tkWidget_SetCursor`.
- `TKSPLITTER_MESSAGEINFO` carries `msg` (`TKM_LBUTTONDOWN`, `TKM_MOUSEMOVE`, `TKM_LBUTTONUP`),
  widget-local `x` / `y` and `clicks` in place of `uMsg` / `wParam` / `lParam`. A double click
  is `TKM_LBUTTONDOWN` with `clicks = 2`; claim it from the message callback for the
  collapse-and-restore idiom.
- Colours start from the current theme and follow it. `tkSplitter_SetColors` pins them;
  `tkSplitter_UnpinColors` hands them back. `tkSplitter_ThemeColors` and
  `TKSPLITTER_COLORS` give the theme mapping as a value.
- Added: `tkSplitter_GetHotColor` and the constant `TKSPLITTER_MAX_UNBOUNDED`.
- A disabled widget (`tkWidget_Enable`) ends any drag and drops its hover.
- DPI changes rescale the position and range automatically; there is no `Rescale` call.
- Gone: the hover-poll timer and its constants, `CS_DBLCLKS`, and PsRegistry. The control still
  has no keyboard, no tooltip and no text.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKSPLITTER_MAX_UNBOUNDED = &h7FFFFFFF

enum TKSPLITTER_ORIENTATION
    TKSPLITTER_VERTICAL   = 0     ' vertical bar,   left/right panes -> TK_CURSOR_SIZEWE, nPos = x
    TKSPLITTER_HORIZONTAL = 1     ' horizontal bar, top/bottom panes -> TK_CURSOR_SIZENS, nPos = y
end enum

enum TKSPLITTER_PHASE
    TKSPLITTER_PHASE_BEGIN = 0    ' the user just grabbed the bar; newPos = current position
    TKSPLITTER_PHASE_MOVE  = 1    ' the position actually changed
    TKSPLITTER_PHASE_END   = 2    ' the drag ended (button up, or capture lost); final position
end enum
```

### Types

```freebasic
type TKSPLITTER_COLORS
    BackColor as ulong = &hFF353B45ul      ' the whole bar, idle
    HotColor  as ulong = &hFF5A6270ul      ' the whole bar, hot OR dragging
end type

type TKSPLITTER_PAINTINFO
    hSplitter    as TK_WIDGET ptr         ' the control, so the callback can query it
    b            as TK_PAINT ptr          ' the paint context for this repaint (borrowed)
    rcClient     as TKRECT                ' the whole bar, widget-local
    nOrientation as long                  ' TKSPLITTER_VERTICAL / TKSPLITTER_HORIZONTAL
    isHot        as boolean               ' the mouse is over the bar (pinned TRUE for a drag)
    isDragging   as boolean               ' a drag is in progress
end type

type TKSPLITTER_MESSAGEINFO
    hSplitter as TK_WIDGET ptr
    msg       as long
    x         as single
    y         as single
    clicks    as long
end type

type TKSPLITTER_STATE   ' per-instance state; reach it through the procedures

type SPL_PaintCallbackSub as sub( byval p as TKSPLITTER_PAINTINFO ptr )
type SPL_MessageCallbackFunc as function( byval m as TKSPLITTER_MESSAGEINFO ptr ) as boolean
type SPL_PosChangedCallbackSub as sub( byval hSplitter as TK_WIDGET ptr, byval newPos as long, byval nPhase as long )
```

### Procedures

```freebasic
function tkSplitter_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long, byval nOrientation as long = TKSPLITTER_VERTICAL ) as TK_WIDGET ptr
function tkSplitter_GetOrientation( byval hSplit as TK_WIDGET ptr ) as long
function tkSplitter_GetPos( byval hSplit as TK_WIDGET ptr ) as long
sub tkSplitter_SetPos( byval hSplit as TK_WIDGET ptr, byval nPosition as long )
sub tkSplitter_SetRange( byval hSplit as TK_WIDGET ptr, byval nMin as long, byval nMax as long )
function tkSplitter_GetMin( byval hSplit as TK_WIDGET ptr ) as long
function tkSplitter_GetMax( byval hSplit as TK_WIDGET ptr ) as long
function tkSplitter_IsHot( byval hSplit as TK_WIDGET ptr ) as boolean
function tkSplitter_IsDragging( byval hSplit as TK_WIDGET ptr ) as boolean
function tkSplitter_GetBackColor( byval hSplit as TK_WIDGET ptr ) as ulong
function tkSplitter_GetHotColor( byval hSplit as TK_WIDGET ptr ) as ulong
sub tkSplitter_SetColors( byval hSplit as TK_WIDGET ptr, byval backclr as ulong, byval hotclr as ulong )
function tkSplitter_ThemeColors( byref t as TKTHEME_COLORS ) as TKSPLITTER_COLORS
sub tkSplitter_ApplyTheme( byval hSplit as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkSplitter_UnpinColors( byval hSplit as TK_WIDGET ptr )
sub tkSplitter_SetPaintCallback( byval hSplit as TK_WIDGET ptr, byval usersub as SPL_PaintCallbackSub )
sub tkSplitter_SetMessageCallback( byval hSplit as TK_WIDGET ptr, byval userfunc as SPL_MessageCallbackFunc )
sub tkSplitter_SetPosChangedCallback( byval hSplit as TK_WIDGET ptr, byval usersub as SPL_PosChangedCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsSplitter](PsSplitter), the PsControls control
