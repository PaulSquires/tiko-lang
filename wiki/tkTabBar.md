[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkTabBar**

# tkTabBar

Draws a row of document tabs that scroll, close and reorder by drag.

tkTabBar is a tab **bar**, not a tab container: it shows the tabs and reports what the user does, and your program swaps whatever sits beneath it. It is the strip above an editor's documents: tabs as wide as their text (never squeezed), scrolling when they overflow, a close "X" on each, a middle click to close anywhere on a tab, and live drag-to-reorder.

A tab is selected on the mouse press, unless the press is on its X. A close gesture does not delete the tab; it calls the Close callback, and your program decides whether to call `tkTabBar_DeleteTab`. `tkTabBar_CanNavigate` and `tkTabBar_Navigate` scroll the strip one tab left or right, for arrow buttons beside it.

Without a paint callback the bar draws its tabs itself, with an optional icon per tab (`tkTabBar_SetGlyph`, drawn with the font from `tkTabBar_SetGlyphFont`) and an accent on the active tab. Set a paint callback to draw the tabs yourself; the bottom rule and the active tab's border are drawn after it. Setters are silent; SelChange, Close and Reorder fire only for what the user does.

## Importing

```freebasic
#import "vendor/tkControls/tkTabBar"
using tkTabBar
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` to write a paint callback.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` and `gGlyph9` are fonts opened with `tkHost_OpenFont`, the second from `tkHost_FontDir() & TK_FONT_ICONS`.

```freebasic
sub OnSel( byval b as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
    print "show document "; tkTabBar_GetItemData( b, idxNew )
end sub

sub OnClose( byval b as TK_WIDGET ptr, byval idx as long )
    tkTabBar_DeleteTab( b, idx )   ' the program decides; the bar only asks
end sub

dim as TK_WIDGET ptr bar = tkTabBar_Create( tkHost_Root( gHost ), 1003 )
tkTabBar_SetFont( bar, gFont10 )
tkTabBar_SetGlyphFont( bar, gGlyph9 )
tkTabBar_SetSelChangeCallback( bar, @OnSel )
tkTabBar_SetCloseCallback( bar, @OnClose )
tkTabBar_SetKeyboard( bar, true )

tkTabBar_AddTab( bar, "Explorer", 3001 ) : tkTabBar_SetGlyph( bar, 0, wchr( TK_ICON_FOLDER ) )
tkTabBar_AddTab( bar, "Search", 3002 )   : tkTabBar_SetGlyph( bar, 1, wchr( TK_ICON_SEARCH ) )
tkTabBar_AddTab( bar, "Output", 3003 )   : tkTabBar_SetGlyph( bar, 2, wchr( TK_ICON_CONSOLE ) )
tkTabBar_SetClosable( bar, 2, false )
tkTabBar_SetCurSel( bar, 0 )
tkWidget_SetPos( bar, 0, 0, 600, tkHost_Scale( gHost, 32 ) )
```

The toolchain's `examples/tkControls/tkTabBar/` shows two bars with custom painters and navigation buttons, and one with the built-in painter.

## Coming from PsTabBar

The [PsTabBar](PsTabBar) page remains the behaviour reference for everything not listed here: the width formula, scrolling, the close gestures, drag reorder and the index fix-ups are the same.

- `PsTabBar_*` → `tkTabBar_*`; `PSTABBAR_*` → `TKTABBAR_*` (`_TABINFO`, `_PAINTINFO`, `_MESSAGEINFO`, `_DEFAULT_*`). The `TB_*` callback types keep their names. Indices are `long`.
- `tkTabBar_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the bar as a `TK_WIDGET ptr`. Fonts are `TTF_Font ptr`; with none set, the host's default font is used.
- `TKTABBAR_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x`, `y`, `clicks` and `wheelY`. A double click is `TKM_LBUTTONDOWN` with `clicks = 2`. A message callback that returns true for a mouse move stops that move driving a drag.
- `TKTABBAR_COLORS` holds the background and border colours along with the built-in painter's; `tkTabBar_GetColors` / `tkTabBar_SetColors` read and pin them. `tkTabBar_SetBackColor` and `tkTabBar_SetBorderColor` still work.
- `tkTabBar_SetHoverTime` is the tooltip delay only. `tkTabBar_GetTooltipHandle` returns the `TK_TIP ptr`.
- Added: the built-in painter; `tkTabBar_SetGlyph` / `tkTabBar_GetGlyph`; `tkTabBar_SetClosable` / `tkTabBar_GetClosable` (a tab that refuses both close gestures, keeping its X space so nothing shifts).
- Added: `tkTabBar_SetKeyboard` makes the bar a Tab stop where Left / Right / Home / End select, notifying SelChange. Clicks still never take focus.
- Added: `tkTabBar_HitTest`, `tkTabBar_GetHotTab`, `tkTabBar_GetHotClose`, `tkTabBar_IsDragging`.
- No equivalent: the `TCM_NAVIGATE` / `TCM_CANNAVIGATE` messages (call the functions), `WM_MOUSEHOVER` reporting, `SetTooltipMode` / `GetTooltipMode`, PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKTABBAR_DEFAULT_PADDING = 8
const TKTABBAR_DEFAULT_ICONWIDTH = 20
const TKTABBAR_DRAG_THRESHOLD = 4
```

### Types

```freebasic
type TKTABBAR_COLORS
    BackColor            as ulong = &hFF21252Bul    ' the whole client, filled first
    BorderColor          as ulong = &hFF444A56ul    ' bottom rule + the active tab's border
    TabBackColor         as ulong = &hFF2C313Aul    ' --- built-in painter only ---
    TabBackColorHot      as ulong = &hFF373D48ul
    TabBackColorSelected as ulong = &hFF21252Bul
    TabBackColorDrag     as ulong = &hFF264F78ul
    TextColor            as ulong = &hFF969CA6ul
    TextColorHot         as ulong = &hFFE2E6EEul
    TextColorSelected    as ulong = &hFFFFFFFFul
    CloseColor           as ulong = &hFF969CA6ul
    CloseColorHot        as ulong = &hFFE2E6EEul
    AccentColor          as ulong = &hFF569CD6ul
    FocusRingColor       as ulong = &hFF61AFEFul
end type

type TKTABBAR_TABINFO
    Text      as ustring
    itemData  as integer
    nMinWidth as long
    wszGlyph  as ustring
    bClosable as boolean = true
    nWidth    as long
    rc        as TKRECT
    rcPaint   as TKRECT
    rcText    as TKRECT
    rcIcon    as TKRECT
    rcClose   as TKRECT
end type

type TKTABBAR_PAINTINFO
    hTabBar    as TK_WIDGET ptr
    itemID     as long
    b          as TK_PAINT ptr
    rc         as TKRECT            ' the border-DEFLATED paint area: fill THIS
    rcText     as TKRECT
    rcIcon     as TKRECT
    rcClose    as TKRECT
    isSelected as boolean
    isHot      as boolean
    isHotClose as boolean
    isPressed  as boolean
    isDragging as boolean
    isFocused  as boolean           ' the bar has keyboard focus (opt-in keyboard)
    wszCaption as ustring
end type

type TKTABBAR_MESSAGEINFO
    hTabBar as TK_WIDGET ptr
    msg     as long                 ' TKM_*
    x       as single
    y       as single
    clicks  as long
    wheelY  as single               ' TKM_MOUSEWHEEL
    idx     as long
end type

type TKTABBAR_STATE   ' per-instance state; reach it through the procedures

type TB_PaintCallbackSub as sub( byval p as TKTABBAR_PAINTINFO ptr )
type TB_MessageCallbackFunc as function( byval m as TKTABBAR_MESSAGEINFO ptr ) as boolean
type TB_TooltipCallbackFunc as function( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as ustring
type TB_SelChangeCallbackSub as sub( byval hTabBar as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
type TB_CloseCallbackSub as sub( byval hTabBar as TK_WIDGET ptr, byval idx as long )
type TB_ReorderCallbackSub as sub( byval hTabBar as TK_WIDGET ptr, byval idxFrom as long, byval idxTo as long )
```

### Procedures

```freebasic
function tkTabBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkTabBar_AddTab( byval hTabBar as TK_WIDGET ptr, byval Text as ustring, byval itemData as integer = 0 ) as long
function tkTabBar_InsertTab( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring, byval itemData as integer = 0 ) as long
function tkTabBar_DeleteTab( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkTabBar_MoveTab( byval hTabBar as TK_WIDGET ptr, byval idxFrom as long, byval idxTo as long ) as boolean
sub tkTabBar_Clear( byval hTabBar as TK_WIDGET ptr )
function tkTabBar_GetCount( byval hTabBar as TK_WIDGET ptr ) as long
function tkTabBar_IsValidTab( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkTabBar_GetText( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkTabBar_SetText( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkTabBar_GetItemData( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as integer
function tkTabBar_SetItemData( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkTabBar_SetGlyph( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval Glyph as ustring ) as boolean
function tkTabBar_GetGlyph( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkTabBar_SetClosable( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval bClosable as boolean ) as boolean
function tkTabBar_GetClosable( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkTabBar_Refresh( byval hTabBar as TK_WIDGET ptr )
function tkTabBar_GetCurSel( byval hTabBar as TK_WIDGET ptr ) as long
function tkTabBar_SetCurSel( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkTabBar_GetFirstVisible( byval hTabBar as TK_WIDGET ptr ) as long
function tkTabBar_SetFirstVisible( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkTabBar_CanNavigate( byval hTabBar as TK_WIDGET ptr, byval nDirection as long ) as boolean
function tkTabBar_Navigate( byval hTabBar as TK_WIDGET ptr, byval nDirection as long ) as long
function tkTabBar_GetTabMinWidth( byval hTabBar as TK_WIDGET ptr, byval idx as long ) as long
function tkTabBar_SetTabMinWidth( byval hTabBar as TK_WIDGET ptr, byval idx as long, byval nMinWidth as long ) as boolean
function tkTabBar_GetPadding( byval hTabBar as TK_WIDGET ptr ) as long
sub tkTabBar_SetPadding( byval hTabBar as TK_WIDGET ptr, byval nPadding as long )
function tkTabBar_GetIconWidth( byval hTabBar as TK_WIDGET ptr ) as long
sub tkTabBar_SetIconWidth( byval hTabBar as TK_WIDGET ptr, byval nIconWidth as long )
function tkTabBar_GetBorderWidth( byval hTabBar as TK_WIDGET ptr ) as long
sub tkTabBar_SetBorderWidth( byval hTabBar as TK_WIDGET ptr, byval nBorderWidth as long )
function tkTabBar_GetTabRect( byval hTabBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkTabBar_GetTabParts( byval hTabBar as TK_WIDGET ptr, byval idx as long, byref rcPaint as TKRECT, byref rcText as TKRECT, byref rcIcon as TKRECT, byref rcClose as TKRECT ) as boolean
function tkTabBar_HitTest( byval hTabBar as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkTabBar_GetHotTab( byval hTabBar as TK_WIDGET ptr ) as long
function tkTabBar_GetHotClose( byval hTabBar as TK_WIDGET ptr ) as boolean
function tkTabBar_IsDragging( byval hTabBar as TK_WIDGET ptr ) as boolean
function tkTabBar_GetBackColor( byval hTabBar as TK_WIDGET ptr ) as ulong
function tkTabBar_SetBackColor( byval hTabBar as TK_WIDGET ptr, byval clr as ulong ) as ulong
function tkTabBar_GetBorderColor( byval hTabBar as TK_WIDGET ptr ) as ulong
function tkTabBar_SetBorderColor( byval hTabBar as TK_WIDGET ptr, byval clr as ulong ) as ulong
sub tkTabBar_GetColors( byval hTabBar as TK_WIDGET ptr, byval pColors as TKTABBAR_COLORS ptr )
sub tkTabBar_SetColors( byval hTabBar as TK_WIDGET ptr, byval pColors as TKTABBAR_COLORS ptr )
function tkTabBar_ThemeColors( byref t as TKTHEME_COLORS ) as TKTABBAR_COLORS
sub tkTabBar_ApplyTheme( byval hTabBar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkTabBar_UnpinColors( byval hTabBar as TK_WIDGET ptr )
function tkTabBar_GetFont( byval hTabBar as TK_WIDGET ptr ) as TTF_Font ptr
function tkTabBar_SetFont( byval hTabBar as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkTabBar_SetGlyphFont( byval hTabBar as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkTabBar_ApplyFonts( byval hTabBar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkTabBar_SetKeyboard( byval hTabBar as TK_WIDGET ptr, byval bOn as boolean )
function tkTabBar_GetKeyboard( byval hTabBar as TK_WIDGET ptr ) as boolean
function tkTabBar_GetTooltipHandle( byval hTabBar as TK_WIDGET ptr ) as TK_TIP ptr
sub tkTabBar_SetHoverTime( byval hTabBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkTabBar_SetAutoPopTime( byval hTabBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkTabBar_SetReshowTime( byval hTabBar as TK_WIDGET ptr, byval milliseconds as long )
sub tkTabBar_SetPaintCallback( byval hTabBar as TK_WIDGET ptr, byval usersub as TB_PaintCallbackSub )
sub tkTabBar_SetMessageCallback( byval hTabBar as TK_WIDGET ptr, byval userfunc as TB_MessageCallbackFunc )
sub tkTabBar_SetTooltipCallback( byval hTabBar as TK_WIDGET ptr, byval userfunc as TB_TooltipCallbackFunc )
sub tkTabBar_SetSelChangeCallback( byval hTabBar as TK_WIDGET ptr, byval usersub as TB_SelChangeCallbackSub )
sub tkTabBar_SetCloseCallback( byval hTabBar as TK_WIDGET ptr, byval usersub as TB_CloseCallbackSub )
sub tkTabBar_SetReorderCallback( byval hTabBar as TK_WIDGET ptr, byval usersub as TB_ReorderCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsTabBar](PsTabBar), the PsControls control
