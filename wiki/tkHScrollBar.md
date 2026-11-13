[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkHScrollBar**

# tkHScrollBar

Draws a horizontal scrollbar that you size, feed a range, and listen to.

tkHScrollBar is a flat horizontal track with a flat thumb and no arrow buttons. You tell it the
total, the page and the position; it tells you when the user drags, pages or wheels it. It does
not scroll anything itself, so use it under content you already draw that is wider than its
view: a timeline, a wide table, a long line of text.

It is a thin module over [tkScrollBar](tkScrollBar), which describes the behaviour both bars
share: paging and auto-repeat, the minimum thumb, the wheel, theme colours and the porting notes.
It takes only the horizontal wheel, and a positive wheel delta moves it right.

## Importing

```freebasic
#import "vendor/tkControls/tkHScrollBar"

using tkHScrollBar
using tkHost
```

The module imports `tkScrollBar`, `tkHost` and `tkTheme` publicly.

## Example

```freebasic
dim shared as TK_WIDGET ptr gHS

sub HS_Scroll( byval hSB as TK_WIDGET ptr, byval newPos as integer )
    gLeftColumn = newPos           ' the user moved the bar: redraw the content from here
    tkHost_Invalidate( gHost )
end sub

gHS = tkHScrollBar_Create( tkHost_Root( gHost ), 1003 )
tkWidget_SetPos( gHS, 0, ph - tkHost_Scale( gHost, TKHSCROLL_DEFAULT_HEIGHT ), _
                 pw, tkHost_Scale( gHost, TKHSCROLL_DEFAULT_HEIGHT ) )
tkHScrollBar_SetRange( gHS, nColumns, nVisibleColumns, 0 )
tkHScrollBar_SetScrollCallback( gHS, @HS_Scroll )
```

`tkHScrollBar_SetRange` and `tkHScrollBar_SetPos` are silent; only the user's actions call the
scroll callback. Forward a horizontal wheel from your content with
`tkHScrollBar_HandleWheelDelta( gHS, cint( m->wheelX * 120 ) )`.

## Coming from PsHScrollBar

`PsHScrollBar_*` → `tkHScrollBar_*` and `CHSCROLL_*` → `TKHSCROLL_*`; the callback type names are
unchanged and the handle is `TK_WIDGET ptr`. `tkHScrollBar_GetThumbRect` is new on this bar. The
rest of the differences are listed on [tkScrollBar](tkScrollBar).
[PsHScrollBar](PsHScrollBar) remains the behaviour reference.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKHSCROLL_REPEAT_DELAY = TKSCROLL_REPEAT_DELAY
const TKHSCROLL_REPEAT_MS = TKSCROLL_REPEAT_MS
const TKHSCROLL_MIN_THUMB = TKSCROLL_MIN_THUMB
const TKHSCROLL_DEFAULT_HEIGHT = TKSCROLL_DEFAULT_THICKNESS
```

### Types

```freebasic
type TKHSCROLLBAR_PAINTINFO as TKSCROLLBAR_PAINTINFO
type HScrollPaintCallbackSub as tkScrollPaintSub
type HScrollCallbackSub as tkScrollNotifySub
```

### Procedures

```freebasic
function tkHScrollBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as integer ) as TK_WIDGET ptr
sub tkHScrollBar_SetRange( byval hSB as TK_WIDGET ptr, byval nTotal as integer, byval nPage as integer, byval nPosition as integer )
function tkHScrollBar_GetPos( byval hSB as TK_WIDGET ptr ) as integer
sub tkHScrollBar_SetPos( byval hSB as TK_WIDGET ptr, byval nPosition as integer )
function tkHScrollBar_HandleWheelDelta( byval hSB as TK_WIDGET ptr, byval nDelta as integer ) as boolean
sub tkHScrollBar_SetWheelStep( byval hSB as TK_WIDGET ptr, byval nUnitsPerNotch as integer )
function tkHScrollBar_GetWheelStep( byval hSB as TK_WIDGET ptr ) as integer
function tkHScrollBar_NeedsThumb( byval hSB as TK_WIDGET ptr ) as boolean
function tkHScrollBar_IsDragging( byval hSB as TK_WIDGET ptr ) as boolean
function tkHScrollBar_GetThumbRect( byval hSB as TK_WIDGET ptr ) as TKRECT
sub tkHScrollBar_SetColors( byval hSB as TK_WIDGET ptr, byval backclr as ulong, byval foreclr as ulong, byval foreclrhot as ulong )
sub tkHScrollBar_ApplyTheme( byval hSB as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkHScrollBar_UnpinColors( byval hSB as TK_WIDGET ptr )
sub tkHScrollBar_PaintDefault( byval p as TKHSCROLLBAR_PAINTINFO ptr )
sub tkHScrollBar_SetPaintCallback( byval hSB as TK_WIDGET ptr, byval usersub as HScrollPaintCallbackSub )
sub tkHScrollBar_SetScrollCallback( byval hSB as TK_WIDGET ptr, byval usersub as HScrollCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsHScrollBar](PsHScrollBar), the PsControls control
