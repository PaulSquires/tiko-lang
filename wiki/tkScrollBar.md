[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkScrollBar**

# tkScrollBar

Runs the one scrollbar engine behind tkVScrollBar and tkHScrollBar.

tkScrollBar is the shared implementation of the two scrollbar controls. A vertical and a
horizontal bar are the same control with the axes swapped, so both are built here and
[tkVScrollBar](tkVScrollBar) and [tkHScrollBar](tkHScrollBar) are thin modules over it. Import
one of those for a bar; this page describes the behaviour they share.

A bar is a flat track with a flat thumb, and no arrow buttons. It knows nothing about your
content: you give it a total, a page (how many units are visible) and a position, and it calls
you back when the user moves it. It never takes focus, handles no keys, and does not size, place
or hide itself.

## Importing

```freebasic
#import "vendor/tkControls/tkVScrollBar"   ' or tkHScrollBar, or both

using tkVScrollBar
using tkScrollBar
using tkHost
```

Each of the two bar modules imports `tkScrollBar`, `tkHost` and `tkTheme` publicly. Open
`tkScrollBar` with `using` only to call an engine name such as `tkScrollBar_GetThumbRect` on a
bar of either kind; every bar handle is accepted by the `tkScrollBar_*` procedures.

## How a bar behaves

- Positions are whole units, clamped to `0 .. total - page`. When everything fits
  (`page >= total`) there is no thumb: `tkScrollBar_NeedsThumb` is false and
  `tkScrollBar_GetThumbRect` is empty.
- Dragging the thumb moves the position. A click on the track pages by exactly `page` toward
  the click, then repeats while the button is held (`TKSCROLL_REPEAT_DELAY`, then every
  `TKSCROLL_REPEAT_MS` milliseconds) until the thumb reaches the cursor or the end.
- The thumb never gets shorter than `TKSCROLL_MIN_THUMB` (scaled), so it stays grabbable.
- The wheel steps by the wheel step (`tkScrollBar_SetWheelStep`), or by
  `TKSCROLL_SYSTEM_WHEEL_LINES` units per notch when the step is 0. Partial notches from a
  touchpad accumulate in 120ths until they add up to a unit.
- A vertical bar takes only the vertical wheel and a horizontal bar only the horizontal one; the
  other axis passes on to the parent.
- `HandleWheelDelta` takes 120ths of a notch. A positive delta moves a vertical bar up but a
  horizontal bar right. Call it from your content widget so the wheel works over the content,
  not only over the bar.
- `SetRange` and `SetPos` are silent. Only the user's drag, track click and wheel call the
  scroll callback, and `tkScrollBar_StepBy` (a step that behaves as the user's) does too.
- Colours follow the current theme until `SetColors` pins them; `UnpinColors` hands them back.
  A paint callback replaces the built-in painter, and receives the thumb rectangle and the
  hot and dragging states in `TKSCROLLBAR_PAINTINFO`.

## Coming from PsVScrollBar and PsHScrollBar

[PsVScrollBar](PsVScrollBar) and [PsHScrollBar](PsHScrollBar) remain the behaviour reference for
everything not listed here.

- Names: `PsVScrollBar_*` → `tkVScrollBar_*`, `PsHScrollBar_*` → `tkHScrollBar_*`;
  `CVSCROLL_*` → `TKVSCROLL_*`, `CHSCROLL_*` → `TKHSCROLL_*`. The callback type names
  (`VScrollCallbackSub`, `VScrollPaintCallbackSub`, `HScrollCallbackSub`,
  `HScrollPaintCallbackSub`) are unchanged. The handle is `TK_WIDGET ptr`.
- `Create( hParent, CtrlID )` takes a `TK_WIDGET ptr` parent (`tkHost_Root( h )` for a
  top-level window). Place and size the bar with `tkWidget_SetPos`; the usual thickness is
  `TKVSCROLL_DEFAULT_WIDTH` / `TKHSCROLL_DEFAULT_HEIGHT`, scaled with `tkHost_Scale`.
- `IsDragging` and `GetThumbRect` exist on both bars.
- The system lines-per-notch has no query here, so it is fixed at
  `TKSCROLL_SYSTEM_WHEEL_LINES` (3).
- DPI changes are handled by the bar itself.
- Gone: the hover-poll timer and its `*_HOTTRACK*` constants, and PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKSCROLL_REPEAT_DELAY = 400
const TKSCROLL_REPEAT_MS = 80
const TKSCROLL_MIN_THUMB = 20
const TKSCROLL_DEFAULT_THICKNESS = 12
const TKSCROLL_SYSTEM_WHEEL_LINES = 3
```

### Types

```freebasic
type TKSCROLLBAR_PAINTINFO
    b          as TK_PAINT ptr
    rcClient   as TKRECT
    rcThumb    as TKRECT              ' empty when no thumb is needed
    isHot      as boolean             ' the mouse is over the thumb
    isDragging as boolean
end type

type TKSCROLLBAR_STATE   ' per-instance state; reach it through the procedures

type tkScrollPaintSub as sub( byval p as TKSCROLLBAR_PAINTINFO ptr )
type tkScrollNotifySub as sub( byval hSB as TK_WIDGET ptr, byval newPos as integer )
```

### Procedures

```freebasic
function tkScrollBar_StepBy( byval pSB as TKSCROLLBAR_STATE ptr, byval nUnits as integer ) as boolean
function tkScrollBar_HandleWheelDelta( byval hSB as TK_WIDGET ptr, byval nDelta as integer ) as boolean
function tkScrollBar_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as integer, byval bVertical as boolean ) as TK_WIDGET ptr
function tkScrollBar_State( byval hSB as TK_WIDGET ptr ) as TKSCROLLBAR_STATE ptr
sub tkScrollBar_SetRange( byval hSB as TK_WIDGET ptr, byval nTotal as integer, byval nPage as integer, byval nPosition as integer )
function tkScrollBar_GetPos( byval hSB as TK_WIDGET ptr ) as integer
sub tkScrollBar_SetPos( byval hSB as TK_WIDGET ptr, byval nPosition as integer )
function tkScrollBar_NeedsThumb( byval hSB as TK_WIDGET ptr ) as boolean
function tkScrollBar_IsDragging( byval hSB as TK_WIDGET ptr ) as boolean
function tkScrollBar_GetThumbRect( byval hSB as TK_WIDGET ptr ) as TKRECT
sub tkScrollBar_SetColors( byval hSB as TK_WIDGET ptr, byval backclr as ulong, byval foreclr as ulong, byval foreclrhot as ulong )
sub tkScrollBar_SetDividerColor( byval hSB as TK_WIDGET ptr, byval clr as ulong, byval bShow as boolean = true )
sub tkScrollBar_ApplyTheme( byval hSB as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkScrollBar_UnpinColors( byval hSB as TK_WIDGET ptr )
sub tkScrollBar_SetPaintCallback( byval hSB as TK_WIDGET ptr, byval usersub as tkScrollPaintSub )
sub tkScrollBar_SetScrollCallback( byval hSB as TK_WIDGET ptr, byval usersub as tkScrollNotifySub )
sub tkScrollBar_SetWheelStep( byval hSB as TK_WIDGET ptr, byval nUnitsPerNotch as integer )
function tkScrollBar_GetWheelStep( byval hSB as TK_WIDGET ptr ) as integer
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
