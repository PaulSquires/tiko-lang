[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkColumnHeader**

# tkColumnHeader

Draws a band of column headings with draggable dividers and one column taking the rest.

tkColumnHeader is the heading strip above a report or grid: one cell per column, a divider between cells that the user drags to resize, and one **fill column** that absorbs the width left over (the last column by default, or none). Widths are in pixels with a per-column minimum. The control reports clicks, width changes and divider double-clicks; it never sorts, and never lays out anything but itself.

Use it above any list whose columns you draw yourself. [tkListTree](tkListTree) builds one in for its report mode, so you only create a tkColumnHeader directly for your own grid.

Without a paint callback the header draws itself: hover and press fills, the caption with an ellipsis, a sort triangle and a divider tick. Your program sets the sort indicator with `tkColumnHeader_SetSortColumn`, usually from the Click callback. A paint callback can call `tkColumnHeader_PaintColumnDefault` and draw on top. Setters are silent; the header never takes the keyboard focus.

## Importing

```freebasic
#import "vendor/tkControls/tkColumnHeader"
using tkColumnHeader
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` to write a paint callback.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont9b` is a font opened with `tkHost_OpenFont`.

```freebasic
sub OnClick( byval hHdr as TK_WIDGET ptr, byval idx as integer )
    dim as boolean bDesc = (tkColumnHeader_GetSortColumn( hHdr ) = idx) andalso _
                           (tkColumnHeader_GetSortDirection( hHdr ) = HDR_SORT_ASC)
    tkColumnHeader_SetSortColumn( hHdr, idx, iif( bDesc, HDR_SORT_DESC, HDR_SORT_ASC ) )
    ' ... sort your rows by column idx and repaint them
end sub

sub OnWidth( byval hHdr as TK_WIDGET ptr, byval idx as integer, byval nWidth as integer, byval bLive as boolean )
    ' bLive is true while the divider is dragged, false once at the end
end sub

function OnAutoSize( byval hHdr as TK_WIDGET ptr, byval idx as integer ) as integer
    return tkText_Width( gFont9b, tkColumnHeader_GetColumnText( hHdr, idx ) ) + _
           2 * tkColumnHeader_GetPadding( hHdr )
end function

dim as TK_WIDGET ptr hdr = tkColumnHeader_Create( tkHost_Root( gHost ), 1 )
tkColumnHeader_SetFont( hdr, gFont9b )
tkColumnHeader_AddColumn( hdr, "Name", tkHost_Scale( gHost, 200 ) )
tkColumnHeader_AddColumn( hdr, "Size", tkHost_Scale( gHost, 90 ), tkHost_Scale( gHost, 50 ) )
tkColumnHeader_AddColumn( hdr, "Type" )                ' the fill column
tkColumnHeader_SetClickCallback( hdr, @OnClick )
tkColumnHeader_SetWidthChangedCallback( hdr, @OnWidth )
tkColumnHeader_SetAutoSizeCallback( hdr, @OnAutoSize )
```

The toolchain's `examples/tkControls/tkColumnHeader/` sorts a table from the header and shows a paint callback over the built-in painter.

## Coming from PsColumnHeader

The [PsColumnHeader](PsColumnHeader) page remains the behaviour reference for everything not listed here: the column model, the layout, the fill column, the divider drag and its notifications, and the matched click are the same.

- `PsColumnHeader_*` → `tkColumnHeader_*`; `PSCOLUMNHEADER_*` → `TKCOLUMNHEADER_*`. The `CCOLHDR_*` constants and the `HDR_*` callback types keep their names.
- `tkColumnHeader_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the header as a `TK_WIDGET ptr`. Fonts are `TTF_Font ptr`.
- `TKCOLUMNHEADER_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x`, `y` and `idx`. The divider double-click still asks the AutoSize callback.
- Escape during a divider drag restores the width, as before; it reaches the header as a key while it holds the mouse.
- `tkColumnHeader_GetTooltipHandle` returns the `TK_TIP ptr`.
- Added: the built-in painter, `tkColumnHeader_PaintColumnDefault` and `TKCOLUMNHEADER_COLORS` (`tkColumnHeader_GetColors`, `tkColumnHeader_SetColors`, `tkColumnHeader_ThemeColors`; `BackColor` is its first field).
- Added: the sort indicator, `tkColumnHeader_SetSortColumn( h, idx, HDR_SORT_ASC / HDR_SORT_DESC / HDR_SORT_NONE )`, `tkColumnHeader_GetSortColumn`, `tkColumnHeader_GetSortDirection`. It follows its column across inserts and deletes.
- Added: `tkColumnHeader_HitTestColumn`, `tkColumnHeader_GetHotColumn`, `tkColumnHeader_GetHotDivider`, `tkColumnHeader_GetPressedColumn`, `tkColumnHeader_GetDragColumn`, `tkColumnHeader_GetXOffset`, `tkColumnHeader_GetID`.
- No equivalent: `WM_MOUSEHOVER` reporting, `SetTooltipMode` / `GetTooltipMode` / `GetPsTooltipHandle`, PsRegistry, `Rescale` (a scale change rescales widths, minimums, padding and offset on its own).

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const CCOLHDR_DEFAULT_PADDING = 8 ' scaled once at create
const CCOLHDR_DIVIDER_GUTTER = 3 ' scaled at use: half-width of the grab zone
const CCOLHDR_DEFAULT_MINWIDTH = 16 ' scaled at use: the floor for nMinWidth = 0
const CCOLHDR_DEFAULT_WIDTH = 100
const CCOLHDR_FILL_LAST = -2
const CCOLHDR_FILL_NONE = -1

enum
    HDR_SORT_NONE = 0
    HDR_SORT_ASC
    HDR_SORT_DESC
end enum
```

### Types

```freebasic
type TKCOLUMNHEADER_COLORS
    BackColor        as ulong = &hFF2C313Aul
    BackColorHot     as ulong = &hFF373D48ul
    BackColorPressed as ulong = &hFF264F78ul
    ForeColor        as ulong = &hFF969CA6ul
    ForeColorHot     as ulong = &hFFE2E6EEul
    ForeColorPressed as ulong = &hFFFFFFFFul
    DividerColor     as ulong = &hFF444A56ul
    DividerColorHot  as ulong = &hFF61AFEFul
    SortMarkColor    as ulong = &hFF569CD6ul
end type

type TKCOLUMNHEADER_PAINTINFO
    hHeader     as TK_WIDGET ptr
    itemID      as integer
    b           as TK_PAINT ptr
    rc          as TKRECT
    isHot       as boolean
    isPressed   as boolean
    isResizeHot as boolean
    isResizing  as boolean
    isFill      as boolean
    wszCaption  as ustring
    nSortDir    as long            ' HDR_SORT_* (the host's indicator)
end type

type TKCOLUMNHEADER_MESSAGEINFO
    hHeader as TK_WIDGET ptr
    msg     as long                ' TKM_*
    x       as single
    y       as single
    idx     as integer             ' the column under the mouse; -1 on a divider gutter
end type

type TKCOLUMNHEADER_COLINFO
    wszText   as ustring
    itemData  as integer
    nWidth    as integer = CCOLHDR_DEFAULT_WIDTH
    nMinWidth as integer
    rc        as TKRECT
end type

type TKCOLUMNHEADER_STATE   ' per-instance state; reach it through the procedures

type HDR_PaintCallbackSub as sub( byval p as TKCOLUMNHEADER_PAINTINFO ptr )
type HDR_MessageCallbackFunc as function( byval m as TKCOLUMNHEADER_MESSAGEINFO ptr ) as boolean
type HDR_TooltipCallbackFunc as function( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as ustring
type HDR_ClickCallbackSub as sub( byval hHeader as TK_WIDGET ptr, byval idx as integer )
type HDR_WidthChangedCallbackSub as sub( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval nWidth as integer, byval bLive as boolean )
type HDR_AutoSizeCallbackFunc as function( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as integer
```

### Procedures

```freebasic
function tkColumnHeader_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkColumnHeader_GetID( byval hHeader as TK_WIDGET ptr ) as long
function tkColumnHeader_InsertColumn( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval Text as ustring, byval nWidth as integer = CCOLHDR_DEFAULT_WIDTH, byval nMinWidth as integer = 0, byval itemData as integer = 0 ) as integer
function tkColumnHeader_AddColumn( byval hHeader as TK_WIDGET ptr, byval Text as ustring, byval nWidth as integer = CCOLHDR_DEFAULT_WIDTH, byval nMinWidth as integer = 0, byval itemData as integer = 0 ) as integer
function tkColumnHeader_DeleteColumn( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as boolean
sub tkColumnHeader_Clear( byval hHeader as TK_WIDGET ptr )
function tkColumnHeader_GetCount( byval hHeader as TK_WIDGET ptr ) as integer
sub tkColumnHeader_Refresh( byval hHeader as TK_WIDGET ptr )
function tkColumnHeader_GetColumnText( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as ustring
function tkColumnHeader_SetColumnText( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval Text as ustring ) as boolean
function tkColumnHeader_GetColumnItemData( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as integer
function tkColumnHeader_SetColumnItemData( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval itemData as integer ) as boolean
function tkColumnHeader_GetColumnWidth( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as integer
function tkColumnHeader_SetColumnWidth( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval nWidth as integer ) as boolean
function tkColumnHeader_GetColumnMinWidth( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as integer
function tkColumnHeader_SetColumnMinWidth( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval nMinWidth as integer ) as boolean
function tkColumnHeader_GetFillColumn( byval hHeader as TK_WIDGET ptr ) as integer
function tkColumnHeader_SetFillColumn( byval hHeader as TK_WIDGET ptr, byval idx as integer ) as boolean
function tkColumnHeader_GetColumnRect( byval hHeader as TK_WIDGET ptr, byval idx as integer, byref rc as TKRECT ) as boolean
function tkColumnHeader_HitTestDivider( byval hHeader as TK_WIDGET ptr, byval x as long, byval y as long ) as integer
function tkColumnHeader_HitTestColumn( byval hHeader as TK_WIDGET ptr, byval x as long, byval y as long ) as integer
function tkColumnHeader_GetPadding( byval hHeader as TK_WIDGET ptr ) as integer
sub tkColumnHeader_SetPadding( byval hHeader as TK_WIDGET ptr, byval nPadding as integer )
function tkColumnHeader_GetXOffset( byval hHeader as TK_WIDGET ptr ) as integer
sub tkColumnHeader_SetXOffset( byval hHeader as TK_WIDGET ptr, byval xOffset as integer )
function tkColumnHeader_GetHotColumn( byval hHeader as TK_WIDGET ptr ) as integer
function tkColumnHeader_GetHotDivider( byval hHeader as TK_WIDGET ptr ) as integer
function tkColumnHeader_GetPressedColumn( byval hHeader as TK_WIDGET ptr ) as integer
function tkColumnHeader_GetDragColumn( byval hHeader as TK_WIDGET ptr ) as integer
sub tkColumnHeader_SetSortColumn( byval hHeader as TK_WIDGET ptr, byval idx as integer, byval nDir as long )
function tkColumnHeader_GetSortColumn( byval hHeader as TK_WIDGET ptr ) as integer
function tkColumnHeader_GetSortDirection( byval hHeader as TK_WIDGET ptr ) as long
sub tkColumnHeader_PaintColumnDefault( byval pi as TKCOLUMNHEADER_PAINTINFO ptr )
function tkColumnHeader_GetBackColor( byval hHeader as TK_WIDGET ptr ) as ulong
function tkColumnHeader_SetBackColor( byval hHeader as TK_WIDGET ptr, byval clr as ulong ) as ulong
sub tkColumnHeader_GetColors( byval hHeader as TK_WIDGET ptr, byval pColors as TKCOLUMNHEADER_COLORS ptr )
sub tkColumnHeader_SetColors( byval hHeader as TK_WIDGET ptr, byval pColors as TKCOLUMNHEADER_COLORS ptr )
function tkColumnHeader_ThemeColors( byref t as TKTHEME_COLORS ) as TKCOLUMNHEADER_COLORS
sub tkColumnHeader_ApplyTheme( byval hHeader as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkColumnHeader_UnpinColors( byval hHeader as TK_WIDGET ptr )
function tkColumnHeader_GetFont( byval hHeader as TK_WIDGET ptr ) as TTF_Font ptr
function tkColumnHeader_SetFont( byval hHeader as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkColumnHeader_ApplyFonts( byval hHeader as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkColumnHeader_GetTooltipHandle( byval hHeader as TK_WIDGET ptr ) as TK_TIP ptr
sub tkColumnHeader_SetHoverTime( byval hHeader as TK_WIDGET ptr, byval ms as long )
sub tkColumnHeader_SetAutoPopTime( byval hHeader as TK_WIDGET ptr, byval ms as long )
sub tkColumnHeader_SetReshowTime( byval hHeader as TK_WIDGET ptr, byval ms as long )
sub tkColumnHeader_SetPaintCallback( byval hHeader as TK_WIDGET ptr, byval usersub as HDR_PaintCallbackSub )
sub tkColumnHeader_SetMessageCallback( byval hHeader as TK_WIDGET ptr, byval userfunc as HDR_MessageCallbackFunc )
sub tkColumnHeader_SetTooltipCallback( byval hHeader as TK_WIDGET ptr, byval userfunc as HDR_TooltipCallbackFunc )
sub tkColumnHeader_SetClickCallback( byval hHeader as TK_WIDGET ptr, byval usersub as HDR_ClickCallbackSub )
sub tkColumnHeader_SetWidthChangedCallback( byval hHeader as TK_WIDGET ptr, byval usersub as HDR_WidthChangedCallbackSub )
sub tkColumnHeader_SetAutoSizeCallback( byval hHeader as TK_WIDGET ptr, byval userfunc as HDR_AutoSizeCallbackFunc )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsColumnHeader](PsColumnHeader), the PsControls control
