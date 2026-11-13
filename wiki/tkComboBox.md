[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkComboBox**

# tkComboBox

Shows the current choice on a button that drops a scrolling list of the alternatives.

tkComboBox is a drop-down picker: a button with the current item's text and an up/down chevron, which opens a list where the current item carries a checkmark. Items have text, an id, item data and an enabled flag. The list scrolls once it has more than `tkComboBox_SetListMaxRows` rows (12 by default), with a scrollbar, the wheel and PageUp / PageDown.

Use it where a choice from a short-to-medium list must take little room. Three text modes decide whether the button shows a caption (`CBO_TEXT_ALWAYS`, `CBO_TEXT_NEVER`, `CBO_TEXT_WHENSELECTED`), and `tkComboBox_SetAutoSize` sizes the button to its widest item. With `tkComboBox_SetEditable` it becomes an editable combo: a text field over the button that the list fills.

Setters are silent. The SelChange callback fires only for a user's pick; the DropDown callback fires for every open and close, programmatic ones included.

`tkComboBox_SetTooltipText` gives the combo a tooltip (the edit box of an editable one included), with `SetHoverTime` / `SetAutoPopTime` / `SetReshowTime` and `GetTooltipHandle`; opening the list hides it. The border follows the theme's `BorderWidth` until `SetBorderThickness`. A paint callback replaces the button's drawing; `tkComboBox_PaintDefault( p )` draws the stock one first.

## Importing

```freebasic
#import "vendor/tkControls/tkComboBox"
using tkComboBox
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme), [tkPopupMenu](tkPopupMenu) (for `TKPOPUPMENU_COLORS`, the list's colours) and [tkVScrollBar](tkVScrollBar). Add `using tkPaint` to write a paint callback.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` is a font opened with `tkHost_OpenFont`.

```freebasic
sub OnSel( byval hCombo as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
    print "picked: "; tkComboBox_GetItemText( hCombo, idxNew )
end sub

sub OnDrop( byval hCombo as TK_WIDGET ptr, byval isOpen as boolean )
    print iif( isOpen, "list opened", "list closed" )
end sub

dim as TK_WIDGET ptr c = tkComboBox_Create( tkHost_Root( gHost ), 100 )
tkComboBox_SetFont( c, gFont10 )
tkComboBox_SetSelChangeCallback( c, @OnSel )
tkComboBox_SetDropDownCallback( c, @OnDrop )
tkComboBox_SetPlaceholderText( c, "Choose an action..." )
tkComboBox_AddItem( c, "Add to Existing Window", 1 )
tkComboBox_AddItem( c, "Open a New Window", 2 )
tkComboBox_AddItem( c, "Not Available Right Now", 3 )
tkComboBox_SetItemEnabled( c, 2, false )

dim as long iw, ih
tkComboBox_GetIdealSize( c, iw, ih )
tkWidget_SetPos( c, 16, 16, iw, ih )
```

The toolchain's `examples/tkControls/tkComboBox/` shows every text mode, a disabled combo, a custom-painted one and a long scrolling list.

## Editable mode

`tkComboBox_SetEditable( c, true )` lays a single-line [tkTextBox](tkTextBox) over the text area. The chevron, F4 and Alt+Down still open the list.

- A pick from the list, or Down / Up in the edit, fills the edit silently; SelChange reports the pick.
- Typing changes no selection. It notifies `tkComboBox_SetEditChangeCallback`; Enter notifies `tkComboBox_SetEditEnterCallback`.
- `tkComboBox_GetText` returns the edit's text; `tkComboBox_SetEditText` sets it silently. `tkComboBox_GetEditHandle` returns the edit widget.
- The edit takes the keyboard focus; the combo draws its focus ring while the edit has it.
- There is no autocomplete while typing.

## Coming from PsComboBox

The [PsComboBox](PsComboBox) page remains the behaviour reference for everything not listed here: the button layout, the text modes, the keyboard, the colours and auto-size are the same.

- `PsComboBox_*` → `tkComboBox_*`; `PSCOMBOBOX_*` types → `TKCOMBOBOX_*`. `CBO_TEXT_*` and the `CBO_*` callback types keep their names.
- `tkComboBox_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the control as a `TK_WIDGET ptr`. Fonts are `TTF_Font ptr`.
- The list is no longer a popup menu: it scrolls past the max-rows limit, so long lists are fine.
- The highlight in the open list is provisional: hover and the arrows move it, a click or Enter / Space commits, Escape, Tab, F4 or Alt+arrow close it with no change. The arrows wrap in the open list.
- The click that closes the list is consumed: clicking the button while the list is open just closes it, and a click elsewhere does not also act on what it lands on.
- Opening another popup closes the list at once, and the DropDown callback reports the close then.
- `tkComboBox_GetListHandle` returns the open list's `TK_HOST ptr`, or 0 while it is closed; the list is created on each open. `tkComboBox_SetListColors` / `tkComboBox_GetListColors` take a `TKPOPUPMENU_COLORS ptr`.
- The wheel over a focused, closed combo steps its selection; otherwise the parent scrolls.
- `TKCOMBOBOX_MESSAGEINFO` carries `msg` (a `TKM_*` value), `x`, `y`, `key` and `mods`.
- Added: editable mode (above), `tkComboBox_SetListMaxRows` / `tkComboBox_GetListMaxRows`, `tkComboBox_GetListItemHeight`, `tkComboBox_GetListItemRect`, `tkComboBox_GetListHot`, `tkComboBox_GetListTopIndex`, `tkComboBox_GetListScrollBar`, `tkComboBox_GetHot`, `tkComboBox_GetID`.
- No equivalent: `FilterMessage`, `EnsureList` (no list exists between opens), the `WM_CHAR` swallowing, PsRegistry and `Rescale` (a scale change rescales every metric and closes an open list).

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKCOMBOBOX_DEFAULT_PADLEFT = 12
const TKCOMBOBOX_DEFAULT_PADRIGHT = 10
const TKCOMBOBOX_DEFAULT_PADTOP = 6
const TKCOMBOBOX_DEFAULT_PADBOTTOM = 6
const TKCOMBOBOX_DEFAULT_TEXTGAP = 8
const TKCOMBOBOX_DEFAULT_CHEVRONW = 9 ' odd, so the glyph comes to a point
const TKCOMBOBOX_DEFAULT_CHEVRONH = 12
const TKCOMBOBOX_DEFAULT_CHEVRONGAP = 3
const TKCOMBOBOX_DEFAULT_CURVATURE = 12 ' a DIAMETER
const TKCOMBOBOX_DEFAULT_BORDERTHICK = 1 ' not scaled
const TKCOMBOBOX_DEFAULT_FOCUSGAP = 2
const TKCOMBOBOX_DEFAULT_FOCUSTHICK = 1 ' not scaled
const TKCOMBOBOX_DEFAULT_LISTITEMHEIGHT = 24
const TKCOMBOBOX_DEFAULT_LISTCHECKCOL = 30 ' the left checkmark gutter
const TKCOMBOBOX_DEFAULT_LISTRIGHTCOL = 20
const TKCOMBOBOX_DEFAULT_LISTMAXROWS = 12 ' the list scrolls past this many

enum
    CBO_TEXT_ALWAYS = 0
    CBO_TEXT_NEVER
    CBO_TEXT_WHENSELECTED
end enum
```

### Types

```freebasic
type TKCOMBOBOX_COLORS
    BackColor            as ulong = &hFF2C313Aul
    ForeColor            as ulong = &hFFC8CDD6ul
    BorderColor          as ulong = &hFF2C313Aul    ' = BackColor: borderless by default
    ChevronColor         as ulong = &hFFC8CDD6ul    ' = ForeColor
    BackColorHot         as ulong = &hFF373D48ul
    ForeColorHot         as ulong = &hFFE2E6EEul
    BorderColorHot       as ulong = &hFF373D48ul
    ChevronColorHot      as ulong = &hFFE2E6EEul
    BackColorOpen        as ulong = &hFF2C313Aul    ' = BackColor, NOT BackColorHot
    ForeColorOpen        as ulong = &hFF61AFEFul
    BorderColorOpen      as ulong = &hFF2C313Aul
    ChevronColorOpen     as ulong = &hFF61AFEFul
    BackColorDisabled    as ulong = &hFF282C33ul
    ForeColorDisabled    as ulong = &hFF606670ul
    BorderColorDisabled  as ulong = &hFF282C33ul
    ChevronColorDisabled as ulong = &hFF606670ul
    ForeColorPlaceholder as ulong = &hFF787E88ul
    FocusRingColor       as ulong = &hFF61AFEFul
end type

type TKCOMBOBOX_ITEM
    wszText   as ustring
    id        as long
    itemData  as integer
    isEnabled as boolean = true
end type

type TKCOMBOBOX_PAINTINFO
    hCombo        as TK_WIDGET ptr
    b             as TK_PAINT ptr
    rcClient      as TKRECT
    rcButton      as TKRECT
    rcText        as TKRECT
    rcChevron     as TKRECT
    rcVisual      as TKRECT
    isHot         as boolean
    isOpen        as boolean
    isEnabled     as boolean
    isFocused     as boolean
    nCurSel       as long
    wszText       as ustring
    isPlaceholder as boolean
    isTextVisible as boolean
end type

type TKCOMBOBOX_MESSAGEINFO
    hCombo as TK_WIDGET ptr
    msg    as long                    ' TKM_*
    x      as single
    y      as single
    key    as long
    mods   as long
end type

type TKCOMBOBOX_STATE   ' per-instance state; reach it through the procedures

type CBO_PaintCallbackSub as sub( byval p as TKCOMBOBOX_PAINTINFO ptr )
type CBO_MessageCallbackFunc as function( byval m as TKCOMBOBOX_MESSAGEINFO ptr ) as boolean
type CBO_SelChangeCallbackSub as sub( byval hCombo as TK_WIDGET ptr, byval idxOld as long, byval idxNew as long )
type CBO_DropDownCallbackSub as sub( byval hCombo as TK_WIDGET ptr, byval isOpen as boolean )
type CBO_EditCallbackSub as sub( byval hCombo as TK_WIDGET ptr )
```

### Procedures

```freebasic
function tkComboBox_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkComboBox_GetID( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_AddItem( byval hCombo as TK_WIDGET ptr, byval Text as ustring, byval id as long = 0, byval itemData as integer = 0 ) as long
function tkComboBox_InsertItem( byval hCombo as TK_WIDGET ptr, byval idx as long, byval Text as ustring, byval id as long = 0, byval itemData as integer = 0 ) as long
function tkComboBox_DeleteItem( byval hCombo as TK_WIDGET ptr, byval idx as long ) as boolean
sub tkComboBox_Clear( byval hCombo as TK_WIDGET ptr )
function tkComboBox_GetCount( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_IsValidItem( byval hCombo as TK_WIDGET ptr, byval idx as long ) as boolean
function tkComboBox_GetItemText( byval hCombo as TK_WIDGET ptr, byval idx as long ) as ustring
function tkComboBox_SetItemText( byval hCombo as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkComboBox_GetItemID( byval hCombo as TK_WIDGET ptr, byval idx as long ) as long
function tkComboBox_SetItemID( byval hCombo as TK_WIDGET ptr, byval idx as long, byval id as long ) as boolean
function tkComboBox_GetItemData( byval hCombo as TK_WIDGET ptr, byval idx as long ) as integer
function tkComboBox_SetItemData( byval hCombo as TK_WIDGET ptr, byval idx as long, byval itemData as integer ) as boolean
function tkComboBox_GetItemEnabled( byval hCombo as TK_WIDGET ptr, byval idx as long ) as boolean
function tkComboBox_SetItemEnabled( byval hCombo as TK_WIDGET ptr, byval idx as long, byval bEnabled as boolean ) as boolean
function tkComboBox_FindItemByID( byval hCombo as TK_WIDGET ptr, byval id as long ) as long
function tkComboBox_FindItemByText( byval hCombo as TK_WIDGET ptr, byval Text as ustring ) as long
function tkComboBox_GetCurSel( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_SetCurSel( byval hCombo as TK_WIDGET ptr, byval idx as long ) as boolean
function tkComboBox_GetText( byval hCombo as TK_WIDGET ptr ) as ustring
function tkComboBox_GetEnabled( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_SetEnabled( byval hCombo as TK_WIDGET ptr, byval isEnabled as boolean )
function tkComboBox_GetFocused( byval hCombo as TK_WIDGET ptr ) as boolean
function tkComboBox_GetHot( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_Refresh( byval hCombo as TK_WIDGET ptr )
function tkComboBox_IsDroppedDown( byval hCombo as TK_WIDGET ptr ) as boolean
function tkComboBox_DropDown( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_CloseUp( byval hCombo as TK_WIDGET ptr )
function tkComboBox_GetListHandle( byval hCombo as TK_WIDGET ptr ) as TK_HOST ptr
function tkComboBox_GetListItemRect( byval hCombo as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkComboBox_GetListHot( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_GetListTopIndex( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_GetListScrollBar( byval hCombo as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkComboBox_SetListColors( byval hCombo as TK_WIDGET ptr, byval pColors as TKPOPUPMENU_COLORS ptr )
sub tkComboBox_GetListColors( byval hCombo as TK_WIDGET ptr, byval pColors as TKPOPUPMENU_COLORS ptr )
sub tkComboBox_SetListItemHeight( byval hCombo as TK_WIDGET ptr, byval nItemHeight as long )
function tkComboBox_GetListItemHeight( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetListMaxRows( byval hCombo as TK_WIDGET ptr, byval nRows as long )
function tkComboBox_GetListMaxRows( byval hCombo as TK_WIDGET ptr ) as long
function tkComboBox_GetTextMode( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetTextMode( byval hCombo as TK_WIDGET ptr, byval nTextMode as long )
function tkComboBox_GetShowText( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_SetShowText( byval hCombo as TK_WIDGET ptr, byval bShowText as boolean )
function tkComboBox_GetAutoSize( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_SetAutoSize( byval hCombo as TK_WIDGET ptr, byval bAutoSize as boolean )
sub tkComboBox_GetPadding( byval hCombo as TK_WIDGET ptr, byref nLeft as long, byref nTop as long, byref nRight as long, byref nBottom as long )
sub tkComboBox_SetPadding( byval hCombo as TK_WIDGET ptr, byval nLeft as long, byval nTop as long, byval nRight as long, byval nBottom as long )
function tkComboBox_GetTextGap( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetTextGap( byval hCombo as TK_WIDGET ptr, byval nTextGap as long )
sub tkComboBox_GetChevronSize( byval hCombo as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
sub tkComboBox_SetChevronSize( byval hCombo as TK_WIDGET ptr, byval nWidth as long, byval nHeight as long )
function tkComboBox_GetChevronGap( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetChevronGap( byval hCombo as TK_WIDGET ptr, byval nGap as long )
function tkComboBox_GetChevronThickness( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetChevronThickness( byval hCombo as TK_WIDGET ptr, byval nThickness as long )
function tkComboBox_GetCornerCurvature( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetCornerCurvature( byval hCombo as TK_WIDGET ptr, byval nCurvature as long )
function tkComboBox_GetBorderThickness( byval hCombo as TK_WIDGET ptr ) as long
sub tkComboBox_SetBorderThickness( byval hCombo as TK_WIDGET ptr, byval nThickness as long )
sub tkComboBox_GetFocusRing( byval hCombo as TK_WIDGET ptr, byref nGap as long, byref nThickness as long )
sub tkComboBox_SetFocusRing( byval hCombo as TK_WIDGET ptr, byval nGap as long, byval nThickness as long )
sub tkComboBox_GetIdealSize( byval hCombo as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkComboBox_GetButtonRect( byval hCombo as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkComboBox_GetTextRect( byval hCombo as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkComboBox_GetChevronRect( byval hCombo as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkComboBox_GetVisualRect( byval hCombo as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkComboBox_GetColors( byval hCombo as TK_WIDGET ptr, byval pColors as TKCOMBOBOX_COLORS ptr )
sub tkComboBox_SetColors( byval hCombo as TK_WIDGET ptr, byval pColors as TKCOMBOBOX_COLORS ptr )
function tkComboBox_ThemeColors( byref t as TKTHEME_COLORS ) as TKCOMBOBOX_COLORS
sub tkComboBox_ApplyTheme( byval hCombo as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkComboBox_UnpinColors( byval hCombo as TK_WIDGET ptr )
function tkComboBox_GetFont( byval hCombo as TK_WIDGET ptr ) as TTF_Font ptr
sub tkComboBox_SetFont( byval hCombo as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkComboBox_ApplyFonts( byval hCombo as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
function tkComboBox_GetPlaceholderText( byval hCombo as TK_WIDGET ptr ) as ustring
sub tkComboBox_SetPlaceholderText( byval hCombo as TK_WIDGET ptr, byval Text as ustring )
sub tkComboBox_SetPaintCallback( byval hCombo as TK_WIDGET ptr, byval usersub as CBO_PaintCallbackSub )
sub tkComboBox_PaintDefault( byval pi as TKCOMBOBOX_PAINTINFO ptr )
sub tkComboBox_SetTooltipText( byval hCombo as TK_WIDGET ptr, byval Text as ustring )
function tkComboBox_GetTooltipText( byval hCombo as TK_WIDGET ptr ) as ustring
function tkComboBox_GetTooltipHandle( byval hCombo as TK_WIDGET ptr ) as TK_TIP ptr
sub tkComboBox_SetHoverTime( byval hCombo as TK_WIDGET ptr, byval ms as long )
sub tkComboBox_SetAutoPopTime( byval hCombo as TK_WIDGET ptr, byval ms as long )
sub tkComboBox_SetReshowTime( byval hCombo as TK_WIDGET ptr, byval ms as long )
sub tkComboBox_SetMessageCallback( byval hCombo as TK_WIDGET ptr, byval userfunc as CBO_MessageCallbackFunc )
sub tkComboBox_SetSelChangeCallback( byval hCombo as TK_WIDGET ptr, byval usersub as CBO_SelChangeCallbackSub )
sub tkComboBox_SetDropDownCallback( byval hCombo as TK_WIDGET ptr, byval usersub as CBO_DropDownCallbackSub )
sub tkComboBox_SetEditable( byval hCombo as TK_WIDGET ptr, byval bEditable as boolean )
function tkComboBox_GetEditable( byval hCombo as TK_WIDGET ptr ) as boolean
sub tkComboBox_SetEditText( byval hCombo as TK_WIDGET ptr, byval Text as ustring )
function tkComboBox_GetEditHandle( byval hCombo as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkComboBox_SetEditChangeCallback( byval hCombo as TK_WIDGET ptr, byval usersub as CBO_EditCallbackSub )
sub tkComboBox_SetEditEnterCallback( byval hCombo as TK_WIDGET ptr, byval usersub as CBO_EditCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsComboBox](PsComboBox), the PsControls control
