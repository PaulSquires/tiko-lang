[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkListTree**

# tkListTree

Shows a scrolling list of rows you paint that is also a tree, with columns and editing.

tkListTree is a list box and a tree view in one control. Rows have a fixed height and are drawn by your paint callback; the control decides which rows are visible, where they sit and what state each is in. A flat list, a grouped list (collapsible header rows), a report with resizable columns and a tree of any depth with twisties are all the same control. It also does single, multiple and extended selection, per-row tooltips, in-place label editing and drag reordering.

Reach for it for a file pane, a results list, a symbol browser or a settings tree. Rows are addressed by **model index**, the order you added them: collapsing a group or a node hides rows but never renumbers anything, and selection stays on the rows across a collapse.

The control builds its own parts: the row surface, a [tkVScrollBar](tkVScrollBar) that shows only while the rows overflow, and a [tkColumnHeader](tkColumnHeader) band that starts hidden. The in-place editor is a [tkTextBox](tkTextBox). Setters are silent; the callbacks fire only for what the user does.

## Importing

```freebasic
#import "vendor/tkControls/tkListTree"
using tkListTree
using tkHost
using tkPaint
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme), [tkTooltip](tkTooltip), [tkTextBox](tkTextBox), [tkColumnHeader](tkColumnHeader), [tkVScrollBar](tkVScrollBar) and [tkScrollBar](tkScrollBar). Add `using tkColumnHeader` to name the `HDR_*` callback types for the column band.

## Example

A tree with twisties and rename-in-place, using the built-in row painter. `gHost` is the window ([tkHost](tkHost)); `gFont10` is a font opened with `tkHost_OpenFont`.

```freebasic
sub OnSel( byval hList as TK_WIDGET ptr, byval row as integer )
    print "selected: "; tkListTree_GetText( hList, row )
end sub

sub PaintRow( byval p as TKLISTTREE_PAINTINFO ptr )
    tkListTree_PaintRowDefault( p )
end sub

dim as TK_WIDGET ptr gTree = tkListTree_Create( tkHost_Root( gHost ), 1020 )
tkListTree_SetFont( gTree, gFont10 )
tkListTree_SetPaintCallback( gTree, @PaintRow )
tkListTree_SetSelChangeCallback( gTree, @OnSel )
tkListTree_SetTreeIndent( gTree, true )
tkListTree_ShowTwisty( gTree, true )
tkListTree_EnableLabelEdit( gTree, true )
tkListTree_SetBorderWidth( gTree, 1 )

dim as integer proj = tkListTree_AddNode( gTree, -1, "MyProject" )
dim as integer src = tkListTree_AddNode( gTree, proj, "src" )
tkListTree_AddNode( gTree, src, "main.tiko" )
dim as integer docs = tkListTree_AddNode( gTree, proj, "docs" )
tkListTree_AddNode( gTree, docs, "README.md" )
tkListTree_SetCurSel( gTree, proj )
tkWidget_SetPos( gTree, 16, 16, 300, 240 )
```

For a report, add columns with `tkListTree_AddColumn`, call `tkListTree_ShowHeader( h, true )` and fill cells with `tkListTree_SetCellText`. Column 0 is the row's text. The toolchain's `examples/tkControls/tkListTree/` shows a grouped list, a report and a tree side by side.

## Coming from PsListTree

The [PsListTree](PsListTree) page remains the behaviour reference for everything not listed here: the row model, groups and trees, selection, the keyboard, batch updates, drag reorder and label editing all work the same way.

- `PsListTree_*` → `tkListTree_*`; `PSLISTTREE_*` types → `TKLISTTREE_*`.
- The unprefixed callback types take an `LT_` prefix: `PaintCallbackSub` → `LT_PaintCallbackSub`, `SelChangeCallbackSub` → `LT_SelChangeCallbackSub`, and so on for every callback.
- `tkListTree_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the control as a `TK_WIDGET ptr`.
- Fonts are `TTF_Font ptr` (`SetFont`, `SetHeaderFont`, `SetTwistyFont`).
- `TKLISTTREE_MESSAGEINFO.hList` is the control, not the row surface. It carries surface-local `x`, `y`, `clicks` and `wheelY` instead of wParam and lParam; a double click is `TKM_LBUTTONDOWN` with `clicks = 2`.
- The twisty is a drawn chevron until you give it a glyph font with `tkListTree_SetTwistyFont`.
- The mouse wheel scrolls 3 rows a notch, at most a page. A wheel against the end is left unclaimed, so a parent can scroll.
- Tooltips use the tkControls tooltip; `tkListTree_GetTooltipHandle` returns a `TK_TIP ptr`. The tooltip callback supplies the text, else the row text is shown.
- The editor is created on the first edit and hidden, not destroyed, when an edit ends.
- Added: `tkListTree_PaintRowDefault`, a ready-made row painter you can call from your paint callback (without a paint callback the rows stay blank, as before); `hList` and `hasFocus` in `TKLISTTREE_PAINTINFO`; `tkListTree_GetSurface`, `tkListTree_GetEditor`, `tkListTree_GetItemHeightPx`, `tkListTree_IsDragging`.
- No equivalent: `FilterMessage` (Enter and Escape reach the editor on their own), the `WM_CHAR` swallowing helpers, `SetTooltipMode` / `GetTooltipMode` / `GetPsTooltipHandle`, `ProbeRenderedPixel` (use the [tkTest](tkTest) pixel probes), `PositionWindows`, PsRegistry and `Rescale` (a scale change re-derives the metrics itself).

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const CLISTTREE_DEFAULT_ROWHEIGHT = 22 ' unscaled
const CLISTTREE_DEFAULT_HEADERHEIGHT = 24 ' unscaled
const CLISTTREE_DEFAULT_SCROLLWIDTH = 12 ' unscaled
const CLISTTREE_DEFAULT_INDENT = 16 ' unscaled
const CLISTTREE_DEFAULT_TWISTY = 16 ' unscaled
const CLISTTREE_DRAG_THRESHOLD = 4 ' scaled: SDL has no SM_CXDRAG
const CLISTTREE_DRAGSCROLL_ZONE = 16 ' scaled
const CLISTTREE_DRAGSCROLL_MS = 60
```

### Types

```freebasic
type TKLISTTREE_CELLINFO
    iCol    as integer
    rc      as TKRECT
    wszText as ustring
end type

type TKLISTTREE_PAINTINFO
    hList        as TK_WIDGET ptr      ' the control
    itemID       as integer            ' MODEL index
    b            as TK_PAINT ptr
    rc           as TKRECT             ' surface-local
    isHot        as boolean
    isSelected   as boolean
    isFocused    as boolean            ' the caret row
    hasFocus     as boolean            ' the surface has the keyboard focus (tk addition)
    isHeader     as boolean
    isCollapsed  as boolean
    isSpanned    as boolean
    isSelectable as boolean
    wszCaption   as ustring
    level        as integer
    hasChildren  as boolean
    isExpanded   as boolean
    indent       as integer
    rcTwisty     as TKRECT
    columnCount  as integer
    cells        as TKLISTTREE_CELLINFO ptr
end type

type TKLISTTREE_MESSAGEINFO
    hList   as TK_WIDGET ptr
    msg     as long                    ' TKM_*
    x       as single                  ' surface-local
    y       as single
    clicks  as long
    wheelY  as single
    idx     as integer                 ' MODEL row under the mouse, or -1
    isCtrl  as boolean
    isShift as boolean
end type

type TKLISTTREE_ROWINFO
    IsHeader      as boolean = false
    bCollapsed    as boolean = false
    bSpanColumns  as boolean = false
    bSelectable   as boolean = true
    level         as integer = 0
    selected      as boolean = false
    Text          as ustring
    cells(any)    as ustring           ' columns 1..N, sparse
    itemData      as integer
    itemDataExtra as integer
    declare sub EnsureCells( byval n as integer )
    declare sub TrimCells( byval n as integer )
end type

type TKLISTTREE_DROPINFO
    hList        as TK_WIDGET ptr
    srcRows      as integer ptr
    srcCount     as integer
    insertBefore as integer
    onHeader     as boolean
    targetRow    as integer
    targetInfo   as TKLISTTREE_ROWINFO ptr
end type

type TKLISTTREE_STATE   ' per-instance state; reach it through the procedures

type LT_PaintCallbackSub as sub( byval p as TKLISTTREE_PAINTINFO ptr )
type LT_MessageCallbackFunc as function( byval m as TKLISTTREE_MESSAGEINFO ptr ) as boolean
type LT_TooltipCallbackFunc as function( byval hList as TK_WIDGET ptr, byval row as integer, byval col as integer ) as ustring
type LT_SelChangeCallbackSub as sub( byval hList as TK_WIDGET ptr, byval row as integer )
type LT_ActivateCallbackSub as sub( byval hList as TK_WIDGET ptr, byval row as integer )
type LT_CanDropCallbackFunc as function( byval p as TKLISTTREE_DROPINFO ptr ) as boolean
type LT_DragDropCallbackSub as sub( byval hList as TK_WIDGET ptr, byval newFirstRow as integer, byval count as integer )
type LT_BeginLabelEditCallbackFunc as function( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
type LT_EndLabelEditCallbackFunc as function( byval hList as TK_WIDGET ptr, byval row as integer, byval newText as ustring ) as boolean
type LT_ExpandCollapseCallbackSub as sub( byval hList as TK_WIDGET ptr, byval row as integer, byval bExpanded as boolean )
```

### Procedures

```freebasic
function tkListTree_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkListTree_AddString( byval hList as TK_WIDGET ptr, byval Text as ustring, byval itemData as integer = 0, byval itemDataExtra as integer = 0 ) as integer
function tkListTree_AddHeader( byval hList as TK_WIDGET ptr, byval Text as ustring, byval itemData as integer = 0, byval itemDataExtra as integer = 0 ) as integer
function tkListTree_InsertString( byval hList as TK_WIDGET ptr, byval row as integer, byval Text as ustring, byval itemData as integer = 0, byval itemDataExtra as integer = 0 ) as integer
function tkListTree_AddNode( byval hList as TK_WIDGET ptr, byval parentRow as integer, byval Text as ustring, byval itemData as integer = 0, byval itemDataExtra as integer = 0 ) as integer
function tkListTree_InsertNode( byval hList as TK_WIDGET ptr, byval parentRow as integer, byval childIndex as integer, byval Text as ustring, byval itemData as integer = 0, byval itemDataExtra as integer = 0 ) as integer
function tkListTree_DeleteString( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
sub tkListTree_Clear( byval hList as TK_WIDGET ptr )
function tkListTree_GetCount( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetVisibleCount( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetText( byval hList as TK_WIDGET ptr, byval row as integer ) as ustring
function tkListTree_SetText( byval hList as TK_WIDGET ptr, byval row as integer, byval Text as ustring ) as boolean
function tkListTree_GetCellText( byval hList as TK_WIDGET ptr, byval row as integer, byval col as integer ) as ustring
function tkListTree_SetCellText( byval hList as TK_WIDGET ptr, byval row as integer, byval col as integer, byval Text as ustring ) as boolean
function tkListTree_GetItemData( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_SetItemData( byval hList as TK_WIDGET ptr, byval row as integer, byval itemData as integer ) as boolean
function tkListTree_GetItemDataExtra( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_SetItemDataExtra( byval hList as TK_WIDGET ptr, byval row as integer, byval itemDataExtra as integer ) as boolean
sub tkListTree_BeginUpdate( byval hList as TK_WIDGET ptr )
sub tkListTree_EndUpdate( byval hList as TK_WIDGET ptr )
sub tkListTree_Refresh( byval hList as TK_WIDGET ptr )
sub tkListTree_InvalidateRow( byval hList as TK_WIDGET ptr, byval row as integer )
sub tkListTree_InvalidateRows( byval hList as TK_WIDGET ptr, byval first_ as integer, byval last_ as integer )
sub tkListTree_UpdateNow( byval hList as TK_WIDGET ptr )
function tkListTree_IsHeader( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_IsCollapsed( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_CollapseRow( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_ExpandRow( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_ToggleRow( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_SetNodeCollapsed( byval hList as TK_WIDGET ptr, byval row as integer, byval bCollapsed as boolean ) as boolean
function tkListTree_CollapseAll( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_ExpandAll( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_GetLevel( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_GetParent( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_GetChildCount( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_HasChildren( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_GetCurSel( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetCurSel( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_GetTopIndex( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetTopIndex( byval hList as TK_WIDGET ptr, byval row as integer ) as integer
function tkListTree_GetSel( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_SetSel( byval hList as TK_WIDGET ptr, byval row as integer, byval state as boolean ) as boolean
function tkListTree_GetSelCount( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetSelItems( byval hList as TK_WIDGET ptr, selItems() as integer ) as integer
sub tkListTree_SelectAll( byval hList as TK_WIDGET ptr, byval state as boolean )
function tkListTree_SetMultiSelect( byval hList as TK_WIDGET ptr, byval enable as boolean ) as boolean
function tkListTree_SetExtendedSelect( byval hList as TK_WIDGET ptr, byval enable as boolean ) as boolean
function tkListTree_PreventDoubleClick( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_SetRowSpanColumns( byval hList as TK_WIDGET ptr, byval row as integer, byval bSpan as boolean = true ) as boolean
function tkListTree_GetRowSpanColumns( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_SetRowSelectable( byval hList as TK_WIDGET ptr, byval row as integer, byval bSelectable as boolean = true ) as boolean
function tkListTree_GetRowSelectable( byval hList as TK_WIDGET ptr, byval row as integer ) as boolean
function tkListTree_SetDragReorder( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_GetDragReorder( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_MoveRows( byval hList as TK_WIDGET ptr, srcRows() as integer, byval insertBefore as integer ) as integer
function tkListTree_SetDragIndicatorColor( byval hList as TK_WIDGET ptr, byval clr as ulong ) as ulong
function tkListTree_GetDragIndicatorColor( byval hList as TK_WIDGET ptr ) as ulong
function tkListTree_IsDragging( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_GetBackColor( byval hList as TK_WIDGET ptr ) as ulong
function tkListTree_SetBackColor( byval hList as TK_WIDGET ptr, byval clr as ulong ) as ulong
function tkListTree_GetRowHeight( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetRowHeight( byval hList as TK_WIDGET ptr, byval nHeight as integer ) as integer
function tkListTree_GetItemHeightPx( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetFont( byval hList as TK_WIDGET ptr ) as TTF_Font ptr
function tkListTree_SetFont( byval hList as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
function tkListTree_GetBorderWidth( byval hList as TK_WIDGET ptr ) as integer
sub tkListTree_SetBorderWidth( byval hList as TK_WIDGET ptr, byval nWidth as integer )
function tkListTree_GetBorderColor( byval hList as TK_WIDGET ptr ) as ulong
sub tkListTree_SetBorderColor( byval hList as TK_WIDGET ptr, byval clr as ulong )
function tkListTree_SetTreeIndent( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_GetTreeIndent( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_SetIndentWidth( byval hList as TK_WIDGET ptr, byval nWidth as integer ) as integer
function tkListTree_GetIndentWidth( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_ShowTwisty( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_IsTwistyShown( byval hList as TK_WIDGET ptr ) as boolean
sub tkListTree_SetTwistyWidth( byval hList as TK_WIDGET ptr, byval nWidth as integer )
sub tkListTree_SetTwistyColor( byval hList as TK_WIDGET ptr, byval clr as ulong )
sub tkListTree_SetTwistyFont( byval hList as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkListTree_SetTwistyGlyphs( byval hList as TK_WIDGET ptr, byval wszExpanded as ustring, byval wszCollapsed as ustring )
function tkListTree_EnableLabelEdit( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_IsLabelEditEnabled( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_SetClickToEdit( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
function tkListTree_SetEditColumn( byval hList as TK_WIDGET ptr, byval col as integer ) as boolean
function tkListTree_GetEditColumn( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetEnterEdits( byval hList as TK_WIDGET ptr, byval enable as boolean = true ) as boolean
sub tkListTree_SetEditColors( byval hList as TK_WIDGET ptr, byval clrBack as ulong, byval clrFore as ulong, byval clrBorder as ulong, byval clrFocusBorder as ulong )
sub tkListTree_SetEditSelectAll( byval hList as TK_WIDGET ptr, byval enable as boolean )
sub tkListTree_SetEditTextInset( byval hList as TK_WIDGET ptr, byval nPx as integer )
function tkListTree_BeginEdit( byval hList as TK_WIDGET ptr, byval row as integer, byval col as integer = 0 ) as boolean
function tkListTree_EndEdit( byval hList as TK_WIDGET ptr, byval bCommit as boolean = true ) as boolean
function tkListTree_IsEditing( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_GetEditRow( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetEditCol( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetEditor( byval hList as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkListTree_GetTooltipHandle( byval hList as TK_WIDGET ptr ) as TK_TIP ptr
sub tkListTree_SetHoverTime( byval hList as TK_WIDGET ptr, byval ms as long )
sub tkListTree_SetAutoPopTime( byval hList as TK_WIDGET ptr, byval ms as long )
sub tkListTree_SetReshowTime( byval hList as TK_WIDGET ptr, byval ms as long )
function tkListTree_GetScrollBar( byval hList as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkListTree_SetScrollBarWidth( byval hList as TK_WIDGET ptr, byval nWidth as integer )
sub tkListTree_SetScrollBarColors( byval hList as TK_WIDGET ptr, byval backclr as ulong, byval foreclr as ulong, byval foreclrhot as ulong )
sub tkListTree_SetScrollBarDividerColor( byval hList as TK_WIDGET ptr, byval clr as ulong, byval bShow as boolean = true )
sub tkListTree_SetScrollBarPaintCallback( byval hList as TK_WIDGET ptr, byval usersub as VScrollPaintCallbackSub )
function tkListTree_AddColumn( byval hList as TK_WIDGET ptr, byval Text as ustring, byval nWidth as integer = 100, byval nMinWidth as integer = 0, byval itemData as integer = 0 ) as integer
function tkListTree_InsertColumn( byval hList as TK_WIDGET ptr, byval idx as integer, byval Text as ustring, byval nWidth as integer = 100, byval nMinWidth as integer = 0, byval itemData as integer = 0 ) as integer
function tkListTree_DeleteColumn( byval hList as TK_WIDGET ptr, byval idx as integer ) as boolean
sub tkListTree_ClearColumns( byval hList as TK_WIDGET ptr )
function tkListTree_GetColumnCount( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_GetColumnText( byval hList as TK_WIDGET ptr, byval idx as integer ) as ustring
function tkListTree_SetColumnText( byval hList as TK_WIDGET ptr, byval idx as integer, byval Text as ustring ) as boolean
function tkListTree_GetColumnWidth( byval hList as TK_WIDGET ptr, byval idx as integer ) as integer
function tkListTree_SetColumnWidth( byval hList as TK_WIDGET ptr, byval idx as integer, byval nWidth as integer ) as boolean
function tkListTree_GetColumnRect( byval hList as TK_WIDGET ptr, byval idx as integer, byref rc as TKRECT ) as boolean
function tkListTree_GetColumnMinWidth( byval hList as TK_WIDGET ptr, byval idx as integer ) as integer
function tkListTree_SetColumnMinWidth( byval hList as TK_WIDGET ptr, byval idx as integer, byval nMinWidth as integer ) as boolean
function tkListTree_GetFillColumn( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetFillColumn( byval hList as TK_WIDGET ptr, byval idx as integer ) as boolean
function tkListTree_ShowHeader( byval hList as TK_WIDGET ptr, byval bShow as boolean = true ) as boolean
function tkListTree_IsHeaderVisible( byval hList as TK_WIDGET ptr ) as boolean
function tkListTree_GetHeaderHeight( byval hList as TK_WIDGET ptr ) as integer
function tkListTree_SetHeaderHeight( byval hList as TK_WIDGET ptr, byval nHeight as integer ) as integer
function tkListTree_GetHeader( byval hList as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkListTree_GetSurface( byval hList as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkListTree_SetPaintCallback( byval hList as TK_WIDGET ptr, byval usersub as LT_PaintCallbackSub )
sub tkListTree_SetMessageCallback( byval hList as TK_WIDGET ptr, byval userfunc as LT_MessageCallbackFunc )
sub tkListTree_SetTooltipCallback( byval hList as TK_WIDGET ptr, byval userfunc as LT_TooltipCallbackFunc )
sub tkListTree_SetSelChangeCallback( byval hList as TK_WIDGET ptr, byval usersub as LT_SelChangeCallbackSub )
sub tkListTree_SetActivateCallback( byval hList as TK_WIDGET ptr, byval usersub as LT_ActivateCallbackSub )
sub tkListTree_SetBeginLabelEditCallback( byval hList as TK_WIDGET ptr, byval userfunc as LT_BeginLabelEditCallbackFunc )
sub tkListTree_SetEndLabelEditCallback( byval hList as TK_WIDGET ptr, byval userfunc as LT_EndLabelEditCallbackFunc )
sub tkListTree_SetExpandCollapseCallback( byval hList as TK_WIDGET ptr, byval usersub as LT_ExpandCollapseCallbackSub )
sub tkListTree_SetCanDropCallback( byval hList as TK_WIDGET ptr, byval userfunc as LT_CanDropCallbackFunc )
sub tkListTree_SetDragDropCallback( byval hList as TK_WIDGET ptr, byval usersub as LT_DragDropCallbackSub )
sub tkListTree_SetColumnResizeCallback( byval hList as TK_WIDGET ptr, byval usersub as HDR_WidthChangedCallbackSub )
sub tkListTree_SetColumnClickCallback( byval hList as TK_WIDGET ptr, byval usersub as HDR_ClickCallbackSub )
sub tkListTree_SetColumnAutoSizeCallback( byval hList as TK_WIDGET ptr, byval userfunc as HDR_AutoSizeCallbackFunc )
sub tkListTree_SetHeaderPaintCallback( byval hList as TK_WIDGET ptr, byval usersub as HDR_PaintCallbackSub )
sub tkListTree_SetHeaderTooltipCallback( byval hList as TK_WIDGET ptr, byval userfunc as HDR_TooltipCallbackFunc )
sub tkListTree_SetHeaderBackColor( byval hList as TK_WIDGET ptr, byval clr as ulong )
sub tkListTree_SetHeaderFont( byval hList as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkListTree_ApplyTheme( byval hList as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkListTree_UnpinColors( byval hList as TK_WIDGET ptr )
sub tkListTree_ApplyFonts( byval hList as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkListTree_PaintRowDefault( byval pi as TKLISTTREE_PAINTINFO ptr )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsListTree](PsListTree), the PsControls control
