[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkSelectBar**

# tkSelectBar

Draws a strip of text panels where exactly one is current, marked by a line beneath it.

tkSelectBar is a flat, tab-like row of text labels: one panel is always the current one and carries an indicator line under its label. It suits switching the view of a panel underneath, such as an output pane's Results / Log / Notes, without the weight of a tab control. The panel set is static: add panels with `tkSelectBar_AddPanel` and remove them all with `tkSelectBar_Clear`; there is no insert or delete.

Exactly one panel is current. The first panel added becomes current silently, `tkSelectBar_SetCurSel` refuses -1 and disabled panels, and the current panel cannot be disabled. Panels can carry their own padding and tooltip text, and a paint callback can draw each panel yourself; `tkSelectBar_PaintPanelDefault( p )` in it draws the stock panel first.

Setters are silent; the SelChange callback fires only for a user's click or key. A click never takes the keyboard focus, so the bar does not pull the caret out of an editor, but the bar is a Tab stop.

## Importing

```freebasic
#import "vendor/tkControls/tkSelectBar"
using tkSelectBar
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` to write a panel paint callback.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` is a font opened with `tkHost_OpenFont`.

```freebasic
sub OnSelChange( byval hBar as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
    print "now showing panel id "; tkSelectBar_GetPanelID( hBar, idxNew )
end sub

dim as TK_WIDGET ptr bar = tkSelectBar_Create( tkHost_Root( gHost ), 1000 )
tkSelectBar_SetFont( bar, gFont10 )
tkSelectBar_SetSelChangeCallback( bar, @OnSelChange )

dim as long idx = tkSelectBar_AddPanel( bar, "COMPILER RESULTS", 1 )
tkSelectBar_SetTooltipText( bar, idx, "Errors and warnings from the last build" )
tkSelectBar_AddPanel( bar, "COMPILER LOG FILE", 2 )
idx = tkSelectBar_AddPanel( bar, "SEARCH RESULTS", 3 )
tkSelectBar_SetEnabled( bar, idx, false )
tkSelectBar_AddPanel( bar, "NOTES", 4 )
tkSelectBar_SetCurSel( bar, 1 )
tkSelectBar_SetIndicator( bar, tkHost_Scale( gHost, 3 ), tkHost_Scale( gHost, 6 ) )

tkWidget_SetPos( bar, 0, 0, tkSelectBar_GetIdealWidth( bar ), tkHost_Scale( gHost, 32 ) )
```

The toolchain's `examples/tkControls/tkSelectBar/` shows three bars: the default look, custom colours and padding, and a custom panel painter.

## Coming from PsSelectBar

The [PsSelectBar](PsSelectBar) page remains the behaviour reference for everything not listed here: the panel layout, the colours and their precedence, the press / slide-off / release gesture and the tooltips are the same.

- `PsSelectBar_*` → `tkSelectBar_*`; `PSSELECTBAR_*` → `TKSELECTBAR_*` (`_COLORS`, `_PANEL`, `_PAINTINFO`, `_MESSAGEINFO`, `_DEFAULT_*`). The `SEL_*` callback types keep their names.
- `tkSelectBar_Create( parent, id )` takes a `TK_WIDGET ptr` parent; for a window's top level pass `tkHost_Root( h )`. The font is a `TTF_Font ptr` the bar borrows; with none set, the host's default font is used.
- `TKSELECTBAR_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x`, `y`, `clicks` and `idx` instead of `uMsg` / `wParam` / `lParam`. A double click is `TKM_LBUTTONDOWN` with `clicks = 2` and is handled as a press.
- Tooltips use [tkTooltip](tkTooltip); `tkSelectBar_GetTooltipHandle` returns its `TK_TIP ptr`. `tkSelectBar_SetHoverTime`, `tkSelectBar_SetAutoPopTime` and `tkSelectBar_SetReshowTime` set its delays.
- A scale change rescales the bar on its own; there is no `Rescale`.
- Added, keyboard focus: the bar is a Tab stop. Left / Right move the selection, skipping disabled panels and never wrapping; Home / End go to the first / last enabled panel. These notify, as a user action. Up / Down, Space and Enter are left to the parent.
- Added: a focus ring round the current panel, coloured by `TKSELECTBAR_COLORS.FocusRingColor` (theme role `FocusRing`), and `isFocused` in `TKSELECTBAR_PAINTINFO`.
- Added: disabling the whole widget with `tkWidget_Enable` greys every label; the indicator stays.
- Added: `tkSelectBar_GetHot`, `tkSelectBar_GetPressed`, `tkSelectBar_GetFocused`, `tkSelectBar_GetTextHeight`.
- No equivalent: `WM_MOUSEHOVER` reporting, `SetTooltipMode` / `GetTooltipMode`, PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKSELECTBAR_DEFAULT_PADLEFT = 12
const as long TKSELECTBAR_DEFAULT_PADRIGHT = 12
const as long TKSELECTBAR_DEFAULT_INDICATORH = 2
const as long TKSELECTBAR_DEFAULT_INDICATORGAP = 4
const as long TKSELECTBAR_DEFAULT_FOCUSGAP = 2
const as long TKSELECTBAR_FOCUSTHICK = 1
```

### Types

```freebasic
type TKSELECTBAR_COLORS
    BackColor         as ulong = &hFF21252Bul    ' ( 33, 37, 43) bar background + idle cell
    ForeColor         as ulong = &hFF969CA6ul    ' (150,156,166) idle label
    BackColorHot      as ulong = &hFF21252Bul
    ForeColorHot      as ulong = &hFFD7DAE0ul    ' (215,218,224)
    BackColorSelect   as ulong = &hFF21252Bul
    ForeColorSelect   as ulong = &hFFFFFFFFul
    ForeColorDisabled as ulong = &hFF5A606Aul    ' ( 90, 96,106)
    IndicatorColor    as ulong = &hFFFFFFFFul    ' the line under the current panel
    FocusRingColor    as ulong = &hFF61AFEFul    ' ADDED: the keyboard focus ring ( 97,175,239)
end type

type TKSELECTBAR_PANEL
    wszText     as ustring
    wszTooltip  as ustring            ' "" = ask the tooltip callback, then nothing
    id          as long = 0
    itemData    as integer = 0
    isEnabled   as boolean = true
    nPadLeft    as long = -1          ' -1 = inherit the bar's
    nPadRight   as long = -1
    nTextW      as long = 0
    nCellWidth  as long = 0
    rc          as TKRECT             ' the full cell: the FILL and HIT rect
    rcText      as TKRECT             ' exactly the measured text box
    rcIndicator as TKRECT             ' spans rcText, gap below it
end type

type TKSELECTBAR_PAINTINFO
    hSelectBar  as TK_WIDGET ptr
    itemID      as long
    b           as TK_PAINT ptr       ' this repaint's painter (borrowed)
    rc          as TKRECT             ' fill THIS
    rcText      as TKRECT
    rcIndicator as TKRECT
    isHot       as boolean
    isSelected  as boolean
    isPressed   as boolean            ' live left press on this panel AND the cursor still on it
    isEnabled   as boolean
    isFocused   as boolean            ' ADDED: the bar has keyboard focus and this is current
    wszCaption  as ustring
end type

type TKSELECTBAR_MESSAGEINFO
    hSelectBar  as TK_WIDGET ptr
    msg         as long               ' TKM_*
    x           as single             ' widget-local pixels
    y           as single
    clicks      as long
    idx         as long               ' the INTERACTION index: -1 for none, disabled, outside
end type

type TKSELECTBAR_STATE   ' per-instance state; reach it through the procedures

type SEL_PaintPanelCallbackSub as sub( byval p as TKSELECTBAR_PAINTINFO ptr )
type SEL_MessageCallbackFunc as function( byval m as TKSELECTBAR_MESSAGEINFO ptr ) as boolean
type SEL_TooltipCallbackFunc as function( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as ustring
type SEL_SelChangeCallbackSub as sub( byval hSelectBar as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
```

### Procedures

```freebasic
function tkSelectBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkSelectBar_AddPanel( byval hSelectBar as TK_WIDGET ptr, byval Text as ustring, byval id as long = 0, byval itemData as integer = 0 ) as long
sub tkSelectBar_Clear( byval hSelectBar as TK_WIDGET ptr )
sub tkSelectBar_Refresh( byval hSelectBar as TK_WIDGET ptr )
function tkSelectBar_GetCount( byval hSelectBar as TK_WIDGET ptr ) as long
function tkSelectBar_IsValidPanel( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkSelectBar_FindPanelByID( byval hSelectBar as TK_WIDGET ptr, byval id as long ) as long
function tkSelectBar_HitTest( byval hSelectBar as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkSelectBar_GetText( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkSelectBar_SetText( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkSelectBar_GetPanelID( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as long
function tkSelectBar_SetPanelID( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval id as long ) as boolean
function tkSelectBar_GetItemData( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as integer
function tkSelectBar_SetItemData( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkSelectBar_GetEnabled( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkSelectBar_SetEnabled( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval isEnabled as boolean ) as boolean
function tkSelectBar_GetCurSel( byval hSelectBar as TK_WIDGET ptr ) as long
function tkSelectBar_SetCurSel( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkSelectBar_GetPadding( byval hSelectBar as TK_WIDGET ptr, byref nPadLeft as long, byref nPadRight as long )
sub tkSelectBar_SetPadding( byval hSelectBar as TK_WIDGET ptr, byval nPadLeft as long, byval nPadRight as long )
function tkSelectBar_SetPanelPadding( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval nPadLeft as long, byval nPadRight as long ) as boolean
sub tkSelectBar_GetIndicator( byval hSelectBar as TK_WIDGET ptr, byref nThickness as long, byref nGap as long )
sub tkSelectBar_SetIndicator( byval hSelectBar as TK_WIDGET ptr, byval nThickness as long, byval nGap as long )
function tkSelectBar_GetPanelRect( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkSelectBar_GetPanelTextRect( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkSelectBar_GetPanelIndicatorRect( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkSelectBar_GetIdealWidth( byval hSelectBar as TK_WIDGET ptr ) as long
sub tkSelectBar_GetColors( byval hSelectBar as TK_WIDGET ptr, byval pColors as TKSELECTBAR_COLORS ptr )
sub tkSelectBar_SetColors( byval hSelectBar as TK_WIDGET ptr, byval pColors as TKSELECTBAR_COLORS ptr )
function tkSelectBar_ThemeColors( byref t as TKTHEME_COLORS ) as TKSELECTBAR_COLORS
sub tkSelectBar_ApplyTheme( byval hSelectBar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkSelectBar_UnpinColors( byval hSelectBar as TK_WIDGET ptr )
function tkSelectBar_GetFont( byval hSelectBar as TK_WIDGET ptr ) as TTF_Font ptr
function tkSelectBar_SetFont( byval hSelectBar as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkSelectBar_ApplyFonts( byval hSelectBar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkSelectBar_GetTooltipHandle( byval hSelectBar as TK_WIDGET ptr ) as TK_TIP ptr
sub tkSelectBar_SetHoverTime( byval hSelectBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkSelectBar_SetAutoPopTime( byval hSelectBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkSelectBar_SetReshowTime( byval hSelectBar as TK_WIDGET ptr, byval milliseconds as long )
function tkSelectBar_GetTooltipText( byval hSelectBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkSelectBar_SetTooltipText( byval hSelectBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
sub tkSelectBar_PaintPanelDefault( byval p as TKSELECTBAR_PAINTINFO ptr )
sub tkSelectBar_SetPaintPanelCallback( byval hSelectBar as TK_WIDGET ptr, byval usersub as SEL_PaintPanelCallbackSub )
sub tkSelectBar_SetMessageCallback( byval hSelectBar as TK_WIDGET ptr, byval userfunc as SEL_MessageCallbackFunc )
sub tkSelectBar_SetTooltipCallback( byval hSelectBar as TK_WIDGET ptr, byval userfunc as SEL_TooltipCallbackFunc )
sub tkSelectBar_SetSelChangeCallback( byval hSelectBar as TK_WIDGET ptr, byval usersub as SEL_SelChangeCallbackSub )
function tkSelectBar_GetHot( byval hSelectBar as TK_WIDGET ptr ) as long
function tkSelectBar_GetPressed( byval hSelectBar as TK_WIDGET ptr ) as long
function tkSelectBar_GetFocused( byval hSelectBar as TK_WIDGET ptr ) as boolean
function tkSelectBar_GetTextHeight( byval hSelectBar as TK_WIDGET ptr ) as long
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsSelectBar](PsSelectBar), the PsControls control
