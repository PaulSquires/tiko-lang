[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkToolbar**

# tkToolbar

Draws a toolbar of command, toggle, split and dropdown buttons that overflows to a menu.

tkToolbar is a strip of buttons along the top of a window or panel. Each item is one of six kinds: `TBR_KIND_COMMAND` (a button), `TBR_KIND_TOGGLE` (stays pressed; toggles sharing a group id act as radio buttons), `TBR_KIND_SPLIT` (a button with a chevron that opens a menu), `TBR_KIND_DROPDOWN` (the whole button opens a menu), `TBR_KIND_SEPARATOR`, and `TBR_KIND_CONTROL`, which hosts another widget such as a search box. An item shows a glyph from the icon font, an image file, a caption, or an icon with a caption.

Items run from the left, or with `TBR_GRAVITY_RIGHT` hug the right edge. When the bar is too narrow, items move into an overflow menu behind a chevron: the left run's tail goes first, then the front of the right run; CONTROL items never overflow and are hidden instead.

A click reports the item's index and id through the Click callback; a toggle's change goes to the SelChange callback. The menus of split and dropdown items are [tkPopupMenu](tkPopupMenu) menus, and the DropDown callback fires as one opens, so you can fill it just in time. A paint callback draws each item yourself; `tkToolbar_PaintItemDefault( p )` in it draws the stock item first. Setters are silent.

## Importing

```freebasic
#import "vendor/tkControls/tkToolbar"
using tkToolbar
using tkPopupMenu
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme), [tkTooltip](tkTooltip), [tkImage](tkImage) and [tkPopupMenu](tkPopupMenu). Import the module of any widget you place in a CONTROL item.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` and `gGlyph12` are fonts opened with `tkHost_OpenFont`, the second from `tkHost_FontDir() & TK_FONT_ICONS`.

```freebasic
const as long IDM_SAVE = 1, IDM_RUN = 2, IDM_RUN_DEBUG = 3, IDM_WRAP = 4

sub OnClick( byval h as TK_WIDGET ptr, byval idx as long, byval id as long )
    print "command "; id
end sub

sub OnDrop( byval h as TK_WIDGET ptr, byval idx as long, byval m as TK_MENU ptr, byval isOpen as boolean )
    if (isOpen = false) orelse (idx = -1) then exit sub        ' -1: the overflow menu
    if tkToolbar_GetItemID( h, idx ) = IDM_RUN then
        tkPopupMenu_Clear( m )
        tkPopupMenu_AddItem( m, IDM_RUN_DEBUG, "Run in Debugger", "F5" )
    end if
end sub

dim as TK_WIDGET ptr t = tkToolbar_Create( tkHost_Root( gHost ), 100 )
tkToolbar_SetTextFont( t, gFont10 )
tkToolbar_SetGlyphFont( t, gGlyph12 )
tkToolbar_SetClickCallback( t, @OnClick )
tkToolbar_SetDropDownCallback( t, @OnDrop )

tkToolbar_AddItem( t, TBR_KIND_COMMAND, wchr( TK_ICON_SAVE ), "Save", IDM_SAVE )
tkToolbar_AddSeparator( t )
dim as long idx = tkToolbar_AddItem( t, TBR_KIND_SPLIT, wchr( TK_ICON_PLAY ), "Run", IDM_RUN )
tkToolbar_SetTooltipText( t, idx, "Run (click the chevron for options)" )
idx = tkToolbar_AddItem( t, TBR_KIND_TOGGLE, wchr( TK_ICON_WRAP ), "Wrap", IDM_WRAP )
tkToolbar_SetItemGravity( t, idx, TBR_GRAVITY_RIGHT )

dim as long iw, ih
tkToolbar_GetIdealSize( t, iw, ih )
tkWidget_SetPos( t, 0, 0, 640, ih )
```

A command chosen from an item's menu goes to that menu's own Select callback: set it with `tkPopupMenu_SetSelectCallback( tkToolbar_GetItemMenu( t, idx ), ... )`. The toolchain's `examples/tkControls/tkToolbar/` has every kind, an image icon, a radio group, a CONTROL item and a custom painter.

## CONTROL items

Create the widget **as a child of the toolbar**, then hand it over with `tkToolbar_AddControl( t, child, width, height, id )`. The toolbar positions it, shows it and hides it when there is no room; `tkToolbar_DeleteItem` and `tkToolbar_Clear` hide and forget it but do not destroy it, and it is destroyed with the toolbar. The child reports through its own callbacks. Tab walks into CONTROL children like any other widget.

## Coming from PsToolbar

The [PsToolbar](PsToolbar) page remains the behaviour reference for everything not listed here: the six kinds, the cell widths, gravity and overflow, the press / release gesture, radio groups and the menus are the same.

- `PsToolbar_*` → `tkToolbar_*`; `PSTOOLBAR_*` → `TKTOOLBAR_*` (`_COLORS`, `_ITEM`, `_PAINTINFO`, `_MESSAGEINFO`, `_DEFAULT_*`). `TBR_KIND_*`, `TBR_GRAVITY_*`, `TBR_ZONE_*`, `TBR_PART_*`, `TBR_MOOD_*` and the `TBR_*` callback types keep their names.
- `tkToolbar_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the toolbar as a `TK_WIDGET ptr`. Item menus are `TK_MENU ptr` ([tkPopupMenu](tkPopupMenu)).
- Fonts are `TTF_Font ptr`, borrowed; with no text font the host's default is used.
- `tkToolbar_SetItemImage` loads any image file [tkImage](tkImage) can read; the paint info's `pImage` is a `tkImageFile ptr` (draw it with `tkImage_Paint`).
- `TKTOOLBAR_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x`, `y`, `idx` and `nZone`.
- There is no `FilterMessage` to call from the message loop: keys reach an open menu on their own. An item menu's own select and closed callbacks still run.
- `tkToolbar_GetTooltipHandle` returns the `TK_TIP ptr`. Added: `tkToolbar_GetHotItem`, `tkToolbar_GetPressedItem`.
- No equivalent: `SetControlNotifyCallback` and `PSTOOLBAR_CONTROLNOTIFY` (a child widget reports through its own callbacks), `WM_MOUSEHOVER` reporting, `SetTooltipMode` / `GetTooltipMode`, `RunSelfTest`, PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKTOOLBAR_DEFAULT_ICONWIDTH = 16
const TKTOOLBAR_DEFAULT_ICONHEIGHT = 16
const TKTOOLBAR_DEFAULT_PADBEFORE = 6
const TKTOOLBAR_DEFAULT_PADAFTER = 6
const TKTOOLBAR_DEFAULT_PADTOP = 4
const TKTOOLBAR_DEFAULT_PADBOTTOM = 4
const TKTOOLBAR_DEFAULT_TEXTGAP = 6
const TKTOOLBAR_DEFAULT_SEPWIDTH = 1
const TKTOOLBAR_DEFAULT_CHEVRONWIDTH = 14
const TKTOOLBAR_DEFAULT_CHEVRONGAP = 4
const TKTOOLBAR_DEFAULT_DIVIDERTHICK = 1 ' NOT scaled: a hairline stays a hairline
const TKTOOLBAR_DEFAULT_CURVATURE = 4

enum
    TBR_KIND_COMMAND = 0
    TBR_KIND_TOGGLE
    TBR_KIND_SEPARATOR
    TBR_KIND_SPLIT
    TBR_KIND_DROPDOWN
    TBR_KIND_CONTROL
end enum

enum
    TBR_GRAVITY_LEFT = 0
    TBR_GRAVITY_RIGHT
end enum

enum
    TBR_ZONE_NONE = 0
    TBR_ZONE_ACTION
    TBR_ZONE_CHEVRON
    TBR_ZONE_OVERFLOW
end enum

enum
    TBR_PART_TOOLBAR = 0
    TBR_PART_ITEM
    TBR_PART_ICON
    TBR_PART_TEXT
    TBR_PART_CHEVRON
end enum

enum
    TBR_MOOD_IDLE = 0
    TBR_MOOD_HOT
    TBR_MOOD_PRESSED
    TBR_MOOD_DISABLED
end enum
```

### Types

```freebasic
type TKTOOLBAR_COLORS
    BackColor         as ulong = &hFF21252Bul    ' ( 33, 37, 43)
    ForeColor         as ulong = &hFFD7DAE0ul    ' (215,218,224)
    BackColorHot      as ulong = &hFF2C313Aul    ' ( 44, 49, 58)
    ForeColorHot      as ulong = &hFFFFFFFFul
    BackColorSelect   as ulong = &hFF264F78ul    ' ( 38, 79,120)
    ForeColorSelect   as ulong = &hFFFFFFFFul
    ForeColorDisabled as ulong = &hFF6E737Dul    ' (110,115,125)
    SeparatorColor    as ulong = &hFF464C58ul    ' ( 70, 76, 88)
    SplitDividerColor as ulong = &hFF464C58ul
end type

type TKTOOLBAR_ITEM
    itemKind       as long = TBR_KIND_COMMAND
    wszGlyph       as ustring
    pImage         as tkImageFile ptr       ' OWNED; glyph OR image
    wszText        as ustring
    wszTooltip     as ustring
    id             as long
    itemData       as integer
    isSelected     as boolean
    isEnabled      as boolean = true
    isVisible      as boolean = true
    nGroupID       as long
    nGravity       as long = TBR_GRAVITY_LEFT
    hMenu          as TK_MENU ptr           ' OWNED, created on demand
    prevSelect     as PM_SelectCallbackSub  ' the menu's own callbacks, chained behind ours
    prevClosed     as PM_ClosedCallbackSub
    hChild         as TK_WIDGET ptr         ' CONTROL: the host's widget, a child of the toolbar
    nControlWidth  as long
    nControlHeight as long
    nPadBefore     as long = -1
    nPadAfter      as long = -1
    nIconWidth     as long = 0
    nIconHeight    as long = 0
    ForeColorItem  as ulong
    bHasForeColor  as boolean
    nTextWidth     as long
    nCellWidth     as long
    bOverflowed    as boolean
    bTrimmed       as boolean
    rc             as TKRECT
    rcIcon         as TKRECT
    rcText         as TKRECT               ' the caption SPAN, not the ink
    rcChevron      as TKRECT
end type

type TKTOOLBAR_PAINTINFO
    hToolbar     as TK_WIDGET ptr
    itemID       as long                   ' -1 = the overflow button
    b            as TK_PAINT ptr
    itemKind     as long
    rc           as TKRECT
    rcIcon       as TKRECT
    rcText       as TKRECT
    rcChevron    as TKRECT
    nMood        as long
    isHot        as boolean
    isSelected   as boolean
    isPressed    as boolean
    isEnabled    as boolean
    isChevronHot as boolean
    isDropped    as boolean
    wszGlyph     as ustring
    wszText      as ustring
    pImage       as tkImageFile ptr        ' draw with tkImage_Paint INSTEAD OF the glyph
end type

type TKTOOLBAR_MESSAGEINFO
    hToolbar as TK_WIDGET ptr
    msg      as long                       ' TKM_*
    x        as single
    y        as single
    idx      as long
    nZone    as long
end type

type TKTOOLBAR_STATE   ' per-instance state; reach it through the procedures

type TBR_PaintItemCallbackSub as sub( byval p as TKTOOLBAR_PAINTINFO ptr )
type TBR_MessageCallbackFunc as function( byval m as TKTOOLBAR_MESSAGEINFO ptr ) as boolean
type TBR_TooltipCallbackFunc as function( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as ustring
type TBR_ClickCallbackSub as sub( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval id as long )
type TBR_SelChangeCallbackSub as sub( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval isSelected as boolean )
type TBR_DropDownCallbackSub as sub( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval hMenu as TK_MENU ptr, byval isOpen as boolean )
```

### Procedures

```freebasic
function tkToolbar_ComputeCellWidth( byval nKind as long, byval nIconWidth as long, byval nTextWidth as long, byval nTextGap as long, byval nSepWidth as long, byval nControlWidth as long, byval nChevronWidth as long, byval nChevronGap as long, byval nDividerThick as long, byval nPadBefore as long, byval nPadAfter as long ) as long
sub tkToolbar_ComputeOverflowSplit( nCellW() as long, nGravity() as long, nKind() as long, byval nCount as long, byval nClientW as long, byval nOverflowCellW as long, bOverflow() as boolean, byref bNeedOverflow as boolean )
function tkToolbar_ResolveMood( byval isEnabled as boolean, byval isPressed as boolean, byval isHot as boolean ) as long
function tkToolbar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkToolbar_AddItem( byval hToolbar as TK_WIDGET ptr, byval itemKind as long, byval Glyph as ustring, byval Text as ustring = "", byval id as long = 0, byval itemData as integer = 0 ) as long
function tkToolbar_InsertItem( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval itemKind as long, byval Glyph as ustring, byval Text as ustring = "", byval id as long = 0, byval itemData as integer = 0 ) as long
function tkToolbar_AddSeparator( byval hToolbar as TK_WIDGET ptr ) as long
function tkToolbar_AddControl( byval hToolbar as TK_WIDGET ptr, byval hChild as TK_WIDGET ptr, byval nControlWidth as long, byval nControlHeight as long = 0, byval id as long = 0 ) as long
function tkToolbar_DeleteItem( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkToolbar_Clear( byval hToolbar as TK_WIDGET ptr )
sub tkToolbar_Refresh( byval hToolbar as TK_WIDGET ptr )
function tkToolbar_GetCount( byval hToolbar as TK_WIDGET ptr ) as long
function tkToolbar_IsValidItem( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_FindItemByID( byval hToolbar as TK_WIDGET ptr, byval id as long ) as long
function tkToolbar_HitTestEx( byval hToolbar as TK_WIDGET ptr, byval x as long, byval y as long, byref nZone as long ) as long
function tkToolbar_HitTest( byval hToolbar as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkToolbar_GetItemKind( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as long
function tkToolbar_GetGlyph( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkToolbar_SetGlyph( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval Glyph as ustring ) as boolean
function tkToolbar_SetItemImage( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval Path as ustring ) as boolean
function tkToolbar_GetText( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkToolbar_SetText( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkToolbar_GetItemID( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as long
function tkToolbar_SetItemID( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval id as long ) as boolean
function tkToolbar_GetItemData( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as integer
function tkToolbar_SetItemData( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkToolbar_GetSelected( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_SetSelected( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval isSelected as boolean ) as boolean
function tkToolbar_GetEnabled( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_SetEnabled( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval isEnabled as boolean ) as boolean
function tkToolbar_GetVisible( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_SetVisible( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval isVisible as boolean ) as boolean
function tkToolbar_GetItemGroupID( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as long
function tkToolbar_SetItemGroupID( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval nGroupID as long ) as boolean
function tkToolbar_FindCheckedInGroup( byval hToolbar as TK_WIDGET ptr, byval nGroupID as long ) as long
function tkToolbar_GetItemGravity( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as long
function tkToolbar_SetItemGravity( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval nGravity as long ) as boolean
function tkToolbar_GetItemChild( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as TK_WIDGET ptr
function tkToolbar_FindItemByChild( byval hToolbar as TK_WIDGET ptr, byval hChild as TK_WIDGET ptr ) as long
function tkToolbar_Click( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_Toggle( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkToolbar_GetIconSize( byval hToolbar as TK_WIDGET ptr, byref nIconWidth as long, byref nIconHeight as long )
sub tkToolbar_SetIconSize( byval hToolbar as TK_WIDGET ptr, byval nIconWidth as long, byval nIconHeight as long )
sub tkToolbar_GetPadding( byval hToolbar as TK_WIDGET ptr, byref nPadBefore as long, byref nPadAfter as long, byref nPadTop as long, byref nPadBottom as long )
sub tkToolbar_SetPadding( byval hToolbar as TK_WIDGET ptr, byval nPadBefore as long, byval nPadAfter as long, byval nPadTop as long, byval nPadBottom as long )
function tkToolbar_GetTextGap( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_SetTextGap( byval hToolbar as TK_WIDGET ptr, byval nTextGap as long )
function tkToolbar_GetSeparatorWidth( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_SetSeparatorWidth( byval hToolbar as TK_WIDGET ptr, byval nSepWidth as long )
function tkToolbar_GetSeparatorHeight( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_SetSeparatorHeight( byval hToolbar as TK_WIDGET ptr, byval nSepHeight as long )
sub tkToolbar_GetChevronSize( byval hToolbar as TK_WIDGET ptr, byref nChevronWidth as long, byref nChevronGap as long )
sub tkToolbar_SetChevronSize( byval hToolbar as TK_WIDGET ptr, byval nChevronWidth as long, byval nChevronGap as long )
function tkToolbar_GetDividerThickness( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_SetDividerThickness( byval hToolbar as TK_WIDGET ptr, byval nThickness as long )
function tkToolbar_GetCornerCurvature( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_SetCornerCurvature( byval hToolbar as TK_WIDGET ptr, byval nCurvature as long )
function tkToolbar_SetItemPadding( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval nPadBefore as long, byval nPadAfter as long ) as boolean
function tkToolbar_SetItemIconSize( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval nIconWidth as long, byval nIconHeight as long ) as boolean
function tkToolbar_SetItemControlSize( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval nControlWidth as long, byval nControlHeight as long ) as boolean
function tkToolbar_GetItemRect( byval hToolbar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkToolbar_GetItemIconRect( byval hToolbar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkToolbar_GetItemTextRect( byval hToolbar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkToolbar_GetItemChevronRect( byval hToolbar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkToolbar_GetOverflowRect( byval hToolbar as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkToolbar_GetIdealSize( byval hToolbar as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkToolbar_GetIdealWidth( byval hToolbar as TK_WIDGET ptr ) as long
function tkToolbar_IsItemOverflowed( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_GetOverflowCount( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_GetColors( byval hToolbar as TK_WIDGET ptr, byval pColors as TKTOOLBAR_COLORS ptr )
sub tkToolbar_SetColors( byval hToolbar as TK_WIDGET ptr, byval pColors as TKTOOLBAR_COLORS ptr )
function tkToolbar_ThemeColors( byref t as TKTHEME_COLORS ) as TKTOOLBAR_COLORS
sub tkToolbar_ApplyTheme( byval hToolbar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkToolbar_UnpinColors( byval hToolbar as TK_WIDGET ptr )
function tkToolbar_SetItemForeColor( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval clr as ulong ) as boolean
function tkToolbar_ClearItemForeColor( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkToolbar_GetTextFont( byval hToolbar as TK_WIDGET ptr ) as TTF_Font ptr
function tkToolbar_SetTextFont( byval hToolbar as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
function tkToolbar_GetGlyphFont( byval hToolbar as TK_WIDGET ptr ) as TTF_Font ptr
function tkToolbar_SetGlyphFont( byval hToolbar as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkToolbar_ApplyFonts( byval hToolbar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkToolbar_GetGlyphs( byval hToolbar as TK_WIDGET ptr, byref wszChevron as ustring, byref wszOverflow as ustring )
sub tkToolbar_SetGlyphs( byval hToolbar as TK_WIDGET ptr, byval wszChevron as ustring, byval wszOverflow as ustring )
function tkToolbar_GetItemMenu( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as TK_MENU ptr
function tkToolbar_GetOverflowMenu( byval hToolbar as TK_WIDGET ptr ) as TK_MENU ptr
sub tkToolbar_SetMenuColors( byval hToolbar as TK_WIDGET ptr, byval pColors as TKPOPUPMENU_COLORS ptr )
function tkToolbar_IsDroppedDown( byval hToolbar as TK_WIDGET ptr ) as boolean
function tkToolbar_GetDroppedItem( byval hToolbar as TK_WIDGET ptr ) as long
function tkToolbar_DropDown( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkToolbar_CloseUp( byval hToolbar as TK_WIDGET ptr )
function tkToolbar_GetTooltipText( byval hToolbar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkToolbar_SetTooltipText( byval hToolbar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkToolbar_GetTooltipHandle( byval hToolbar as TK_WIDGET ptr ) as TK_TIP ptr
sub tkToolbar_SetHoverTime( byval hToolbar as TK_WIDGET ptr, byval milliseconds as long )
sub tkToolbar_SetAutoPopTime( byval hToolbar as TK_WIDGET ptr, byval milliseconds as long )
sub tkToolbar_SetReshowTime( byval hToolbar as TK_WIDGET ptr, byval milliseconds as long )
function tkToolbar_GetHotItem( byval hToolbar as TK_WIDGET ptr, byref nZone as long ) as long
function tkToolbar_GetPressedItem( byval hToolbar as TK_WIDGET ptr ) as long
sub tkToolbar_PaintItemDefault( byval p as TKTOOLBAR_PAINTINFO ptr )
sub tkToolbar_SetPaintItemCallback( byval hToolbar as TK_WIDGET ptr, byval usersub as TBR_PaintItemCallbackSub )
sub tkToolbar_SetMessageCallback( byval hToolbar as TK_WIDGET ptr, byval userfunc as TBR_MessageCallbackFunc )
sub tkToolbar_SetTooltipCallback( byval hToolbar as TK_WIDGET ptr, byval userfunc as TBR_TooltipCallbackFunc )
sub tkToolbar_SetClickCallback( byval hToolbar as TK_WIDGET ptr, byval usersub as TBR_ClickCallbackSub )
sub tkToolbar_SetSelChangeCallback( byval hToolbar as TK_WIDGET ptr, byval usersub as TBR_SelChangeCallbackSub )
sub tkToolbar_SetDropDownCallback( byval hToolbar as TK_WIDGET ptr, byval usersub as TBR_DropDownCallbackSub )
function tkToolbar_CountRenderedTones( byval hToolbar as TK_WIDGET ptr, byval nPart as long, byval idx as long ) as long
function tkToolbar_HashRenderedPart( byval hToolbar as TK_WIDGET ptr, byval nPart as long, byval idx as long ) as ulong
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsToolbar](PsToolbar), the PsControls control
