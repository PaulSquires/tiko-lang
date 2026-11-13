[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkStatusBar**

# tkStatusBar

Draws a status bar of text panels, one of which stretches to fill the leftover width.

tkStatusBar is the strip along the bottom of a window: "Ready", the caret position, the line ending, the encoding. Each panel holds text and item data, and is as wide as its text plus padding, or its minimum width if that is larger. A panel set to stretch with `tkStatusBar_SetPanelStretch` is a **spring**: the springs share the leftover width evenly (the first ones take a pixel each of any remainder), and a hidden spring takes none. `tkStatusBar_SetExpandPanel( sb, i )` makes panel `i` the only spring (`-1`: none), and `tkStatusBar_GetExpandPanel` answers the first one. When the bar is too narrow nothing shrinks; panels run past the right edge.

Without a paint callback the bar draws its panels itself: the text inset by the padding and a divider between panels. Set a click callback and a panel under the mouse gets a hover fill, since it can now be clicked. A paint callback replaces the built-in painter and draws every panel pixel itself.

The bar takes no focus and no keyboard, and has no size grip; your program places it, usually from the window's size handler. Each panel can show a tooltip, from the tooltip callback or else its own text. Setters are silent.

## Importing

```freebasic
#import "vendor/tkControls/tkStatusBar"
using tkStatusBar
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` to write a paint callback.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` is a font opened with `tkHost_OpenFont`.

```freebasic
sub OnClick( byval hBar as TK_WIDGET ptr, byval idx as long, byval clicks as long )
    print "clicked "; tkStatusBar_GetText( hBar, idx ); " (clicks="; clicks; ")"
end sub

dim as TK_WIDGET ptr sb = tkStatusBar_Create( tkHost_Root( gHost ), 1 )
tkStatusBar_SetFont( sb, gFont10 )
tkStatusBar_SetClickCallback( sb, @OnClick )
tkStatusBar_AddPanel( sb, "Ready", 1001 )
tkStatusBar_AddPanel( sb, "", 1002 )                     ' the spring
tkStatusBar_AddPanel( sb, "Ln 1, Col 1", 1003 )
tkStatusBar_AddPanel( sb, "UTF-8", 1004 )
tkStatusBar_SetExpandPanel( sb, 1 )
tkStatusBar_SetPanelMinWidth( sb, 2, tkHost_Scale( gHost, 110 ) )

' in the window's size handler, with pw x ph the window's pixel size:
tkWidget_SetPos( sb, 0, ph - tkHost_Scale( gHost, 24 ), pw, tkHost_Scale( gHost, 24 ) )

' later, silently:
tkStatusBar_SetText( sb, 2, "Ln 12, Col 5" )
```

`tkStatusBar_SetPanelVisible( sb, idx, false )` hides a panel without renumbering the others: it keeps its index and takes no width. The toolchain's `examples/tkControls/tkStatusBar/` shows two bars with custom painters and one with the built-in painter and a click callback.

## Coming from PsStatusBar

The [PsStatusBar](PsStatusBar) page remains the behaviour reference for everything not listed here: the panel model, the width law, the index fix-ups, hover and the tooltips are the same. Added here: several springs (`tkStatusBar_SetPanelStretch`); PsStatusBar has one.

- `PsStatusBar_*` → `tkStatusBar_*`; `PSSTATUSBAR_*` → `TKSTATUSBAR_*` (`_PANELINFO`, `_PAINTINFO`, `_MESSAGEINFO`, `_DEFAULT_PADDING`). The `SB_*` callback types keep their names. Indices are `long`.
- `tkStatusBar_Create( parent, id )` takes a `TK_WIDGET ptr` parent; for a window's top level pass `tkHost_Root( h )`. It is created zero-sized, so it shows nothing until you size it. The font is a `TTF_Font ptr` the bar borrows; with none set, the host's default font is used.
- `TKSTATUSBAR_MESSAGEINFO` carries `msg`, `x`, `y`, `clicks` and `idx` instead of `uMsg` / `wParam` / `lParam`. A double click is `TKM_LBUTTONDOWN` with `clicks = 2`; the hover message is `TKSB_MOUSEHOVER`, sent once per rest while the mouse stays on the bar.
- `tkStatusBar_GetTooltipHandle` returns the `TK_TIP ptr`. `tkStatusBar_SetHoverTime` still sets both the tooltip delay and the hover message's.
- The background colour lives in `TKSTATUSBAR_COLORS` with the built-in painter's colours; `tkStatusBar_SetBackColor` still works. The bar follows theme changes on its own.
- Added: the built-in painter; `tkStatusBar_SetClickCallback`, fired on the left-button release over a panel with `clicks = 2` on the second click of a double click (a message callback that returns true for that release suppresses it).
- Added: `tkStatusBar_GetColors` / `tkStatusBar_SetColors` / `tkStatusBar_ThemeColors`, `tkStatusBar_HitTest`, `tkStatusBar_GetHot`, `tkStatusBar_SetPanelVisible` / `tkStatusBar_GetPanelVisible`.
- A scale change rescales the padding and every panel's minimum width on its own; there is no `Rescale`.
- No equivalent: `SetTooltipMode` / `GetTooltipMode`, PsRegistry. There are still no per-panel icons, per-panel alignment or fixed-width panels.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKSTATUSBAR_DEFAULT_PADDING = 8
const as long TKSTATUSBAR_DEFAULT_HOVERTIME = 250
const as long TKSTATUSBAR_DEFAULT_DIVIDERINSET = 4
const as long TKSB_MOUSEHOVER = 1001
```

### Types

```freebasic
type TKSTATUSBAR_PANELINFO
    Text      as ustring
    itemData  as integer
    nMinWidth as long            ' floor for this panel's width; 0 = auto-size to the text
    bHidden   as boolean         ' laid out at width 0: not painted, no divider, never hit (tk addition)
    rc        as TKRECT          ' derived by LayoutPanels, read-only to the host
end type

type TKSTATUSBAR_COLORS
    BackColor    as ulong = &hFF21252Bul    ' ( 33, 37, 43) theme Window
    BackColorHot as ulong = &hFF373D48ul    ' ( 55, 61, 72) theme SurfaceHot
    ForeColor    as ulong = &hFF969CA6ul    ' (150,156,166) theme TextDim
    ForeColorHot as ulong = &hFFE2E6EEul    ' (226,230,238) theme TextHot
    DividerColor as ulong = &hFF373C45ul    ' ( 55, 60, 69) theme Divider
end type

type TKSTATUSBAR_PAINTINFO
    hStatusBar as TK_WIDGET ptr      ' the control, so the callback can ask for GetPadding
    itemID     as long               ' the panel's model index
    b          as TK_PAINT ptr       ' this repaint's painter (borrowed)
    rc         as TKRECT             ' this panel's rect, widget-local -- the only rect to fill
    isHot      as boolean            ' the mouse is over this panel
    wszCaption as ustring            ' the panel's Text
end type

type TKSTATUSBAR_MESSAGEINFO
    hStatusBar as TK_WIDGET ptr
    msg        as long               ' TKM_MOUSEMOVE / TKM_MOUSELEAVE / TKM_LBUTTONDOWN (clicks = 2:
    x          as single             ' widget-local pixels
    y          as single
    clicks     as long
    idx        as long               ' panel under the mouse, -1 for none
end type

type TKSTATUSBAR_STATE   ' per-instance state; reach it through the procedures

type SB_PaintCallbackSub as sub( byval p as TKSTATUSBAR_PAINTINFO ptr )
type SB_MessageCallbackFunc as function( byval m as TKSTATUSBAR_MESSAGEINFO ptr ) as boolean
type SB_TooltipCallbackFunc as function( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as ustring
type SB_ClickCallbackSub as sub( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval clicks as long )
```

### Procedures

```freebasic
function tkStatusBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkStatusBar_AddPanel( byval hStatusBar as TK_WIDGET ptr, byval Text as ustring, byval itemData as integer = 0 ) as long
function tkStatusBar_InsertPanel( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring, byval itemData as integer = 0 ) as long
function tkStatusBar_DeletePanel( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkStatusBar_Clear( byval hStatusBar as TK_WIDGET ptr )
function tkStatusBar_GetCount( byval hStatusBar as TK_WIDGET ptr ) as long
sub tkStatusBar_Refresh( byval hStatusBar as TK_WIDGET ptr )
function tkStatusBar_GetText( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkStatusBar_SetText( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkStatusBar_GetItemData( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as integer
function tkStatusBar_SetItemData( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkStatusBar_GetPanelMinWidth( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as long
function tkStatusBar_SetPanelVisible( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval bVisible as boolean ) as boolean
function tkStatusBar_GetPanelVisible( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkStatusBar_SetPanelMinWidth( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval nMinWidth as long ) as boolean
function tkStatusBar_GetExpandPanel( byval hStatusBar as TK_WIDGET ptr ) as long
function tkStatusBar_SetExpandPanel( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkStatusBar_SetPanelStretch( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byval bStretch as boolean ) as boolean
function tkStatusBar_GetPanelStretch( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkStatusBar_GetPadding( byval hStatusBar as TK_WIDGET ptr ) as long
sub tkStatusBar_SetPadding( byval hStatusBar as TK_WIDGET ptr, byval nPadding as long )
function tkStatusBar_GetPanelRect( byval hStatusBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkStatusBar_GetItemRect( byval hStatusBar as TK_WIDGET ptr, byval idx as long ) as TKRECT
function tkStatusBar_HitTest( byval hStatusBar as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkStatusBar_GetHot( byval hStatusBar as TK_WIDGET ptr ) as long
function tkStatusBar_GetBackColor( byval hStatusBar as TK_WIDGET ptr ) as ulong
function tkStatusBar_SetBackColor( byval hStatusBar as TK_WIDGET ptr, byval clr as ulong ) as ulong
sub tkStatusBar_GetColors( byval hStatusBar as TK_WIDGET ptr, byval pColors as TKSTATUSBAR_COLORS ptr )
sub tkStatusBar_SetColors( byval hStatusBar as TK_WIDGET ptr, byval pColors as TKSTATUSBAR_COLORS ptr )
function tkStatusBar_ThemeColors( byref t as TKTHEME_COLORS ) as TKSTATUSBAR_COLORS
sub tkStatusBar_ApplyTheme( byval hStatusBar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkStatusBar_UnpinColors( byval hStatusBar as TK_WIDGET ptr )
function tkStatusBar_GetFont( byval hStatusBar as TK_WIDGET ptr ) as TTF_Font ptr
function tkStatusBar_SetFont( byval hStatusBar as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkStatusBar_ApplyFonts( byval hStatusBar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkStatusBar_GetTooltipHandle( byval hStatusBar as TK_WIDGET ptr ) as TK_TIP ptr
sub tkStatusBar_SetHoverTime( byval hStatusBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkStatusBar_SetAutoPopTime( byval hStatusBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkStatusBar_SetReshowTime( byval hStatusBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkStatusBar_SetPaintCallback( byval hStatusBar as TK_WIDGET ptr, byval usersub as SB_PaintCallbackSub )
sub tkStatusBar_SetMessageCallback( byval hStatusBar as TK_WIDGET ptr, byval userfunc as SB_MessageCallbackFunc )
sub tkStatusBar_SetTooltipCallback( byval hStatusBar as TK_WIDGET ptr, byval userfunc as SB_TooltipCallbackFunc )
sub tkStatusBar_SetClickCallback( byval hStatusBar as TK_WIDGET ptr, byval usersub as SB_ClickCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsStatusBar](PsStatusBar), the PsControls control
