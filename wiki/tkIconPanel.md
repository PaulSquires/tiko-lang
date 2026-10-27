[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkIconPanel**

# tkIconPanel

Draws a row or column of icon-only buttons, toggles and separators.

tkIconPanel is a compact strip of icon buttons with no captions: the small tool row above a panel, or the activity bar down the side of an editor window. Each item is an `IP_KIND_COMMAND` (a button), an `IP_KIND_TOGGLE` (latches on and off) or an `IP_KIND_SEPARATOR`. An icon is a glyph from the font you set, or an image file; captions belong in the tooltips.

Each cell is its declared icon size plus padding, whatever the glyph, and `tkIconPanel_SetJustify` places the run left, centred or right. The item set is static once built. Selection is a set of latched toggles; a radio-style group is one call, `tkIconPanel_SelectExclusive`, from the SelChange callback.

`tkIconPanel_SetVertical` turns the row into a column, and `tkIconPanel_SetMarker` draws a selection marker: a slab down a column's left edge, or a rule under a row's cell. Both are off by default. A click never takes the keyboard focus. Setters are silent; Click and SelChange fire only for what the user does.

## Importing

```freebasic
#import "vendor/tkControls/tkIconPanel"
using tkIconPanel
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme), [tkTooltip](tkTooltip) and [tkImage](tkImage). Add `using tkPaint` to write a paint callback.

## Example

An activity bar. `gHost` is the window ([tkHost](tkHost)); `gGlyph12` is the bundled icon font, opened with `tkHost_OpenFont( gHost, tkHost_FontDir() & TK_FONT_ICONS, 12 )`.

```freebasic
sub OnSelChange( byval p as TK_WIDGET ptr, byval idx as long, byval isSelected as boolean )
    tkIconPanel_SelectExclusive( p, idx )        ' one view at a time
end sub

sub OnClick( byval p as TK_WIDGET ptr, byval idx as long, byval id as long )
    print "command "; id
end sub

dim as TK_WIDGET ptr bar = tkIconPanel_Create( tkHost_Root( gHost ), 1100 )
tkIconPanel_SetVertical( bar, true )
tkIconPanel_SetFont( bar, gGlyph12 )
tkIconPanel_SetIconSize( bar, tkHost_Scale( gHost, 24 ), tkHost_Scale( gHost, 24 ) )
tkIconPanel_SetPadding( bar, tkHost_Scale( gHost, 6 ), tkHost_Scale( gHost, 6 ) )
tkIconPanel_SetMarker( bar, tkHost_Scale( gHost, 3 ), true )
tkIconPanel_SetSelChangeCallback( bar, @OnSelChange )
tkIconPanel_SetClickCallback( bar, @OnClick )

dim as long idx
idx = tkIconPanel_AddItem( bar, IP_KIND_TOGGLE, wchr( TK_ICON_DOCUMENT ), 1 ) : tkIconPanel_SetTooltipText( bar, idx, "Explorer" )
idx = tkIconPanel_AddItem( bar, IP_KIND_TOGGLE, wchr( TK_ICON_SEARCH ), 2 )   : tkIconPanel_SetTooltipText( bar, idx, "Search" )
tkIconPanel_AddSeparator( bar )
idx = tkIconPanel_AddItem( bar, IP_KIND_COMMAND, wchr( TK_ICON_SETTINGS ), 4 ) : tkIconPanel_SetTooltipText( bar, idx, "Settings" )
tkIconPanel_SetSelected( bar, 0, true )

tkWidget_SetPos( bar, 0, 0, tkIconPanel_GetIdealWidth( bar ), tkIconPanel_GetIdealHeight( bar ) )
```

The toolchain's `examples/tkControls/tkIconPanel/` shows three rows (left, centred and right, one with a custom painter) and this column.

## Coming from PsIconPanel

The [PsIconPanel](PsIconPanel) page remains the behaviour reference for everything not listed here: the cell layout, the three kinds, selection, the press / slide-off / release gesture, the colours and the tooltips are the same.

- `PsIconPanel_*` → `tkIconPanel_*`; `PSICONPANEL_*` → `TKICONPANEL_*` (`_COLORS`, `_ITEM`, `_PAINTINFO`, `_MESSAGEINFO`, `_DEFAULT_*`). `IP_JUSTIFY_*`, `IP_KIND_*` and the `IP_*` callback types keep their names.
- `tkIconPanel_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the panel as a `TK_WIDGET ptr`. The font is a `TTF_Font ptr` the panel borrows; with none set, the host's default font draws.
- `tkIconPanel_SetImage` loads any image file [tkImage](tkImage) can read. In `TKICONPANEL_PAINTINFO`, `b` is a `TK_PAINT ptr` and `pImage` a `tkImageFile ptr` (draw it with `tkImage_Paint`); `isVertical` is new.
- `TKICONPANEL_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x` and `y` instead of `uMsg` / `wParam` / `lParam`. A double click is two ordinary presses.
- `tkIconPanel_SetHoverTime` is the tooltip delay only; `tkIconPanel_GetTooltipHandle` returns the `TK_TIP ptr`.
- Added: `tkIconPanel_SetVertical` / `tkIconPanel_GetVertical`. In a column, `IP_JUSTIFY_LEFT` / `CENTER` / `RIGHT` mean top / centre / bottom, `tkIconPanel_GetIdealWidth` is the widest icon and `tkIconPanel_GetIdealHeight` the whole run.
- Added: `tkIconPanel_SetMarker( h, nSize, bFillSelected )`, `tkIconPanel_GetMarker`, `tkIconPanel_GetMarkerRect`, coloured by `TKICONPANEL_COLORS.MarkerColor` (theme role `Accent`). `bFillSelected = false` leaves a latched toggle on the idle fill, for a tab-row look.
- Added: `tkIconPanel_SelectExclusive` (silent), `tkIconPanel_GetHotItem`, `tkIconPanel_GetPressedItem`.
- No equivalent: `WM_MOUSEHOVER` reporting, `SetTooltipMode` / `GetTooltipMode`, PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKICONPANEL_DEFAULT_ICONWIDTH = 20
const TKICONPANEL_DEFAULT_ICONHEIGHT = 20
const TKICONPANEL_DEFAULT_PADBEFORE = 4
const TKICONPANEL_DEFAULT_PADAFTER = 4
const TKICONPANEL_DEFAULT_SEPWIDTH = 1

enum
    IP_JUSTIFY_LEFT = 0           ' TOP in vertical mode
    IP_JUSTIFY_CENTER
    IP_JUSTIFY_RIGHT              ' BOTTOM in vertical mode
end enum

enum
    IP_KIND_TOGGLE = 0
    IP_KIND_COMMAND
    IP_KIND_SEPARATOR
end enum
```

### Types

```freebasic
type TKICONPANEL_COLORS
    BackColor         as ulong = &hFF21252Bul    ' ( 33, 37, 43) panel + idle cell
    ForeColor         as ulong = &hFFD7DAE0ul    ' (215,218,224) idle glyph
    BackColorHot      as ulong = &hFF2C313Aul    ' ( 44, 49, 58)
    ForeColorHot      as ulong = &hFFFFFFFFul
    BackColorSelect   as ulong = &hFF264F78ul    ' ( 38, 79,120) latched toggle + press flash
    ForeColorSelect   as ulong = &hFFFFFFFFul
    ForeColorDisabled as ulong = &hFF6E737Dul    ' (110,115,125)
    SeparatorColor    as ulong = &hFF464C58ul    ' ( 70, 76, 88)
    MarkerColor       as ulong = &hFF569CD6ul    ' the selection marker (tk addition)
end type

type TKICONPANEL_ITEM
    itemKind      as long = IP_KIND_TOGGLE
    wszGlyph      as ustring
    pImage        as tkImageFile ptr     ' OWNED; a cell is a glyph or an image, never both
    wszTooltip    as ustring
    id            as long
    itemData      as integer
    isSelected    as boolean
    isEnabled     as boolean = true
    nPadBefore    as long = -1           ' -1 = inherit
    nPadAfter     as long = -1
    nIconWidth    as long = 0            '  0 = inherit
    nIconHeight   as long = 0
    ForeColorItem as ulong
    bHasForeColor as boolean
    nCellWidth    as long                ' the cell's extent ALONG the run (a height when vertical)
    rc            as TKRECT
    rcIcon        as TKRECT
end type

type TKICONPANEL_PAINTINFO
    hIconPanel as TK_WIDGET ptr
    itemID     as long
    b          as TK_PAINT ptr
    itemKind   as long
    rc         as TKRECT
    rcIcon     as TKRECT
    isHot      as boolean
    isSelected as boolean
    isPressed  as boolean
    isEnabled  as boolean
    wszGlyph   as ustring
    pImage     as tkImageFile ptr        ' draw with tkImage_Paint INSTEAD OF the glyph
    isVertical as boolean
end type

type TKICONPANEL_MESSAGEINFO
    hIconPanel as TK_WIDGET ptr
    msg        as long                   ' TKM_*
    x          as single
    y          as single
    idx        as long                   ' item under the mouse, -1 for none
end type

type TKICONPANEL_STATE   ' per-instance state; reach it through the procedures

type IP_PaintItemCallbackSub as sub( byval p as TKICONPANEL_PAINTINFO ptr )
type IP_MessageCallbackFunc as function( byval m as TKICONPANEL_MESSAGEINFO ptr ) as boolean
type IP_TooltipCallbackFunc as function( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as ustring
type IP_ClickCallbackSub as sub( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval id as long )
type IP_SelChangeCallbackSub as sub( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval isSelected as boolean )
```

### Procedures

```freebasic
function tkIconPanel_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkIconPanel_AddItem( byval hIconPanel as TK_WIDGET ptr, byval itemKind as long, byval Glyph as ustring, byval id as long = 0, byval itemData as integer = 0 ) as long
function tkIconPanel_AddSeparator( byval hIconPanel as TK_WIDGET ptr ) as long
sub tkIconPanel_Refresh( byval hIconPanel as TK_WIDGET ptr )
function tkIconPanel_GetCount( byval hIconPanel as TK_WIDGET ptr ) as long
function tkIconPanel_IsValidItem( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as boolean
function tkIconPanel_FindItemByID( byval hIconPanel as TK_WIDGET ptr, byval id as long ) as long
function tkIconPanel_HitTest( byval hIconPanel as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkIconPanel_GetItemKind( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as long
function tkIconPanel_GetGlyph( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as ustring
function tkIconPanel_SetGlyph( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval Glyph as ustring ) as boolean
function tkIconPanel_SetImage( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval Path as ustring ) as boolean
function tkIconPanel_GetItemID( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as long
function tkIconPanel_SetItemID( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval id as long ) as boolean
function tkIconPanel_GetItemData( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as integer
function tkIconPanel_SetItemData( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkIconPanel_GetSelected( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as boolean
function tkIconPanel_SetSelected( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval isSelected as boolean ) as boolean
sub tkIconPanel_SelectExclusive( byval hIconPanel as TK_WIDGET ptr, byval idx as long )
function tkIconPanel_GetEnabled( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as boolean
function tkIconPanel_SetEnabled( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval isEnabled as boolean ) as boolean
function tkIconPanel_GetJustify( byval hIconPanel as TK_WIDGET ptr ) as long
sub tkIconPanel_SetJustify( byval hIconPanel as TK_WIDGET ptr, byval nJustify as long )
sub tkIconPanel_SetVertical( byval hIconPanel as TK_WIDGET ptr, byval bVertical as boolean )
function tkIconPanel_GetVertical( byval hIconPanel as TK_WIDGET ptr ) as boolean
sub tkIconPanel_SetMarker( byval hIconPanel as TK_WIDGET ptr, byval nSize as long, byval bFillSelected as boolean = true )
sub tkIconPanel_GetMarker( byval hIconPanel as TK_WIDGET ptr, byref nSize as long, byref bFillSelected as boolean )
function tkIconPanel_GetMarkerRect( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
sub tkIconPanel_GetIconSize( byval hIconPanel as TK_WIDGET ptr, byref nIconWidth as long, byref nIconHeight as long )
sub tkIconPanel_SetIconSize( byval hIconPanel as TK_WIDGET ptr, byval nIconWidth as long, byval nIconHeight as long )
sub tkIconPanel_GetPadding( byval hIconPanel as TK_WIDGET ptr, byref nPadBefore as long, byref nPadAfter as long )
sub tkIconPanel_SetPadding( byval hIconPanel as TK_WIDGET ptr, byval nPadBefore as long, byval nPadAfter as long )
function tkIconPanel_GetSeparatorWidth( byval hIconPanel as TK_WIDGET ptr ) as long
sub tkIconPanel_SetSeparatorWidth( byval hIconPanel as TK_WIDGET ptr, byval nSepWidth as long )
function tkIconPanel_SetItemPadding( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval nPadBefore as long, byval nPadAfter as long ) as boolean
function tkIconPanel_SetItemIconSize( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval nIconWidth as long, byval nIconHeight as long ) as boolean
function tkIconPanel_GetItemRect( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkIconPanel_GetItemIconRect( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkIconPanel_GetIdealWidth( byval hIconPanel as TK_WIDGET ptr ) as long
function tkIconPanel_GetIdealHeight( byval hIconPanel as TK_WIDGET ptr ) as long
sub tkIconPanel_GetColors( byval hIconPanel as TK_WIDGET ptr, byval pColors as TKICONPANEL_COLORS ptr )
sub tkIconPanel_SetColors( byval hIconPanel as TK_WIDGET ptr, byval pColors as TKICONPANEL_COLORS ptr )
function tkIconPanel_ThemeColors( byref t as TKTHEME_COLORS ) as TKICONPANEL_COLORS
sub tkIconPanel_ApplyTheme( byval hIconPanel as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkIconPanel_UnpinColors( byval hIconPanel as TK_WIDGET ptr )
sub tkIconPanel_ApplyFonts( byval hIconPanel as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkIconPanel_SetItemForeColor( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval clr as ulong ) as boolean
function tkIconPanel_ClearItemForeColor( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as boolean
function tkIconPanel_GetFont( byval hIconPanel as TK_WIDGET ptr ) as TTF_Font ptr
function tkIconPanel_SetFont( byval hIconPanel as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
function tkIconPanel_GetTooltipHandle( byval hIconPanel as TK_WIDGET ptr ) as TK_TIP ptr
sub tkIconPanel_SetHoverTime( byval hIconPanel as TK_WIDGET ptr, byval milliseconds as long )
sub tkIconPanel_SetAutoPopTime( byval hIconPanel as TK_WIDGET ptr, byval milliseconds as long )
sub tkIconPanel_SetReshowTime( byval hIconPanel as TK_WIDGET ptr, byval milliseconds as long )
function tkIconPanel_GetTooltipText( byval hIconPanel as TK_WIDGET ptr, byval idx as long ) as ustring
function tkIconPanel_SetTooltipText( byval hIconPanel as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkIconPanel_GetHotItem( byval hIconPanel as TK_WIDGET ptr ) as long
function tkIconPanel_GetPressedItem( byval hIconPanel as TK_WIDGET ptr ) as long
sub tkIconPanel_SetPaintItemCallback( byval hIconPanel as TK_WIDGET ptr, byval usersub as IP_PaintItemCallbackSub )
sub tkIconPanel_SetMessageCallback( byval hIconPanel as TK_WIDGET ptr, byval userfunc as IP_MessageCallbackFunc )
sub tkIconPanel_SetTooltipCallback( byval hIconPanel as TK_WIDGET ptr, byval userfunc as IP_TooltipCallbackFunc )
sub tkIconPanel_SetClickCallback( byval hIconPanel as TK_WIDGET ptr, byval usersub as IP_ClickCallbackSub )
sub tkIconPanel_SetSelChangeCallback( byval hIconPanel as TK_WIDGET ptr, byval usersub as IP_SelChangeCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsIconPanel](PsIconPanel), the PsControls control
