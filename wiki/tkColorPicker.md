[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkColorPicker**

# tkColorPicker

Shows a modal colour picker popup and returns the colour and alpha the user chose.

tkColorPicker is a chromeless popup with three tabs: **Web** (the named web colours),
**System** (a table of system colour names) and **Custom** (a colour matrix with red, green, blue
and optional alpha fields). Below the tabs, an Initial and a Current preview and an OK button.
It blocks until the user answers: OK, Enter or a double-click on a colour accepts; Esc or a click
outside cancels.

For the common case, `tkColorPicker_DoModal` (centred) or `tkColorPicker_DoModalForRect`
(dropped under a rectangle, flipping above it when there is no room) does everything in one
call. It returns true with your two variables written, or false with neither touched. For more
control (hiding the alpha field, opening on a tab, live preview while the user drags), create
the picker yourself and call `tkColorPicker_RunModal`.

## Importing

```freebasic
#import "vendor/tkControls/tkColorPicker"

using tkColorPicker
using tkHost
```

The module imports `tkHost`, `tkTheme` and `tkVScrollBar` publicly.

## Example

The one-call form, dropped under the button that asked for it:

```freebasic
dim as TKRECT rcAnchor
tkWidget_AbsRect( hButton, rcAnchor )
if tkColorPicker_DoModalForRect( tkHost_Root( gHost ), rcAnchor, gColor, gAlpha ) then
    tkHost_Invalidate( gHost )            ' gColor and gAlpha hold the new choice
end if
```

The long form, with a live callback and no alpha field:

```freebasic
sub Pick_ColorChanged( byval hCtrl as TK_WIDGET ptr, byval clr as ulong, byval nAlpha as ubyte, byval nPhase as long )
    ' CLR_PHASE_BEGIN, then CLR_PHASE_MOVE while dragging, then CLR_PHASE_END
end sub

dim as TK_WIDGET ptr hPick = tkColorPicker_Create( tkHost_Root( gHost ) )
tkColorPicker_SetFont( hPick, gFont10 )
tkColorPicker_ShowAlpha( hPick, false )
tkColorPicker_SetColor( hPick, gColor, gAlpha )
tkColorPicker_SetTab( hPick, CLR_TAB_CUSTOM )
tkColorPicker_SetColorChangedCallback( hPick, @Pick_ColorChanged )
tkColorPicker_PositionCentered( hPick )
if tkColorPicker_RunModal( hPick ) then
    gColor = tkColorPicker_GetColor( hPick )
    gAlpha = tkColorPicker_GetAlpha( hPick )
end if
tkColorPicker_Destroy( hPick )
```

The handle stays valid after `RunModal`, so the getters answer after the run; call
`tkColorPicker_Destroy` when done. `DoModal` and `DoModalForRect` set no font, so they draw in the
host's default font.

## Coming from PsColorPicker

[PsColorPicker](PsColorPicker) remains the behaviour reference for everything not listed here.

- Names: `PsColorPicker_*` → `tkColorPicker_*`; `PSCOLORPICKER_COLORS`, `_PAINTINFO`,
  `_MESSAGEINFO` and `PSCOLORPICKER_DEFAULT_*` → `TKCOLORPICKER_*`. `CLR_TAB_*`, `CLR_PHASE_*`,
  `CLR_PART_*`, `CLR_FIELD_*` and the `CLR_*` callback types keep their names.
- Colours are `ulong` in `&hAARRGGBB` form, always opaque; alpha still travels separately as a
  `ubyte`. Rectangles are `TKRECT`, fonts `TTF_Font ptr`.
- The handle is no longer the popup window. `tkColorPicker_Create( hParent [, id] )` returns a
  hidden widget in the owner's tree that holds the state; each `RunModal` opens a fresh popup
  window and closes it at the end. `tkColorPicker_Destroy` replaces `DestroyWindow`.
- Positions are the owner window's pixels, not screen pixels: `tkColorPicker_PositionForRect`
  takes a rectangle from `tkWidget_AbsRect`. `tkColorPicker_PositionCentered( h, hRef )` centres
  on a widget, or on the whole owner window when `hRef` is 0.
- The System tab is a fixed table of the Windows default system colours on every platform.
  `tkColorPicker_SetSystemColor` replaces one entry.
- The application losing focus does not cancel the picker.
- `TKCOLORPICKER_MESSAGEINFO` carries `msg` (a `TKM_*`), `x`, `y`, `key`, `mods` and `clicks`.
- Esc-cancelled typing in a field is never committed.
- Added: `tkColorPicker_SetOpenCallback` (the popup is on screen; receives its surface),
  `tkColorPicker_EndModal` (end a run as if the user had answered), `IsOpen`, `GetSurface`,
  `GetContent`, `GetPosition`, `GetFocusField`, `GetEditText`, `GetBodySel`, `GetScrollTop`,
  `GetFieldText`, `SetSystemColor`.
- Gone: `WM_GETDLGCODE` and `WM_CHAR` handling (digits come from key presses), `CS_DBLCLKS`,
  `IsDialogMessage`, `Rescale` (DPI changes are handled by the picker), `RunSelfTest`, and
  PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKCOLORPICKER_DEFAULT_PAD = 8
const TKCOLORPICKER_DEFAULT_GAP = 6
const TKCOLORPICKER_DEFAULT_TABHEIGHT = 24
const TKCOLORPICKER_DEFAULT_MATRIXCOLS = 16
const TKCOLORPICKER_DEFAULT_MATRIXROWS = 14
const TKCOLORPICKER_DEFAULT_CELLW = 18
const TKCOLORPICKER_DEFAULT_CELLH = 22
const TKCOLORPICKER_DEFAULT_SWATCHW = 34
const TKCOLORPICKER_DEFAULT_LISTROWS = 14
const TKCOLORPICKER_DEFAULT_SCROLLW = 14
const TKCOLORPICKER_DEFAULT_PREVIEWW = 92
const TKCOLORPICKER_DEFAULT_PREVIEWH = 46
const TKCOLORPICKER_DEFAULT_FIELDW = 58
const TKCOLORPICKER_DEFAULT_FIELDH = 24
const TKCOLORPICKER_DEFAULT_OKW = 92
const TKCOLORPICKER_DEFAULT_OKH = 30
const TKCOLORPICKER_DEFAULT_LABELW = 52
const TKCOLORPICKER_DEFAULT_ROWH = 22
const TKCOLORPICKER_DEFAULT_TABPAD = 14
const TKCOLORPICKER_DEFAULT_CURVATURE = 4
const TKCOLORPICKER_DEFAULT_BORDERTHICK = 1 ' never scaled
const TKCOLORPICKER_DEFAULT_FOCUSTHICK = 1 ' never scaled
const TKCOLORPICKER_RINGINSET = 1
const TKCOLORPICKER_CARET_MS = 530

enum
    CLR_TAB_WEB = 0
    CLR_TAB_SYSTEM
    CLR_TAB_CUSTOM
    CLR_TAB_COUNT
end enum

enum
    CLR_PHASE_BEGIN = 0
    CLR_PHASE_MOVE
    CLR_PHASE_END
end enum

enum
    CLR_PART_TABS = 0
    CLR_PART_MATRIX
    CLR_PART_SWATCHES
    CLR_PART_INITIAL
    CLR_PART_CURRENT
    CLR_PART_FIELDS
    CLR_PART_ALPHA
    CLR_PART_OK
end enum

enum
    CLR_FIELD_R = 0
    CLR_FIELD_G
    CLR_FIELD_B
    CLR_FIELD_A
    CLR_FIELD_COUNT
end enum
```

### Types

```freebasic
type TKCOLORPICKER_COLORS
    BackColor           as ulong = &hFF2C313Aul
    ForeColor           as ulong = &hFFC8CDD6ul
    BorderColor         as ulong = &hFF444A56ul
    TabBackColor        as ulong = &hFF2C313Aul
    TabBackColorSel     as ulong = &hFF373D48ul
    TabForeColor        as ulong = &hFF969CA7ul
    TabForeColorSel     as ulong = &hFFE2E6EEul
    FieldBackColor      as ulong = &hFF21252Bul
    FieldForeColor      as ulong = &hFFC8CDD6ul
    FieldBorderColor    as ulong = &hFF444A56ul
    FieldBorderColorSel as ulong = &hFF61AFEFul
    HotRingColor        as ulong = &hFFFFFFFFul
    SelRingColor        as ulong = &hFF61AFEFul
    FocusRingColor      as ulong = &hFF61AFEFul
    OKBackColor         as ulong = &hFF373D48ul
    OKBackColorHot      as ulong = &hFF444A56ul
    OKBackColorPressed  as ulong = &hFF282D35ul
    OKForeColor         as ulong = &hFFE2E6EEul
    OKBorderColor       as ulong = &hFF444A56ul
end type

type TKCOLORPICKER_PAINTINFO
    hColorPicker   as TK_WIDGET ptr      ' the handle, so the callback can query it
    b              as TK_PAINT ptr
    rcClient       as TKRECT
    rcContent      as TKRECT
    rcTabs         as TKRECT
    rcBody         as TKRECT
    rcMatrix       as TKRECT             ' EMPTY off Custom
    rcSwatches     as TKRECT             ' EMPTY on Custom
    rcOK           as TKRECT
    rcPreview      as TKRECT
    rcInitial      as TKRECT
    rcCurrent      as TKRECT
    rcInitialLabel as TKRECT
    rcCurrentLabel as TKRECT
    rcFields       as TKRECT
    rcAlpha        as TKRECT
    clrCurrent     as ulong
    nAlphaCurrent  as ubyte
    clrInitial     as ulong
    nAlphaInitial  as ubyte
    nTab           as long
    isEnabled      as boolean
    isFocused      as boolean
    isDragging     as boolean
    isOKHot        as boolean
    isOKPressed    as boolean
    nFocusField    as long
end type

type TKCOLORPICKER_MESSAGEINFO
    hColorPicker  as TK_WIDGET ptr
    msg           as long               ' TKM_*
    x             as single
    y             as single
    key           as long
    mods          as long
    clicks        as long
end type

type TKCOLORPICKER_STATE   ' per-instance state; reach it through the procedures

type CLR_ColorChangedCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval clr as ulong, byval nAlpha as ubyte, byval nPhase as long )
type CLR_TabChangedCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval nTab as long )
type CLR_MessageCallbackFunc as function( byval m as TKCOLORPICKER_MESSAGEINFO ptr ) as boolean
type CLR_PaintCallbackSub as sub( byval p as any ptr )
type CLR_OpenCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval pSurface as TK_HOST ptr )
```

### Procedures

```freebasic
function tkColorPicker_HSLtoRGB( byval h as double, byval s as double, byval lum as double ) as ulong
function tkColorPicker_MatrixColorAt( byval nCol as long, byval nRow as long, byval nCols as long, byval nRows as long ) as ulong
function tkColorPicker_MatrixIndexOf( byval clr as ulong, byval nCols as long, byval nRows as long ) as long
function tkColorPicker_PtIn( byref rc as TKRECT, byval x as long, byval y as long ) as boolean
function tkColorPicker_CellFromPoint( byref rc as TKRECT, byval nCellW as long, byval nCellH as long, byval nCols as long, byval nRows as long, byval x as long, byval y as long, byref nCol as long, byref nRow as long ) as boolean
function tkColorPicker_FormatHex( byval clr as ulong ) as ustring
function tkColorPicker_ParseHex( byval wszText as ustring, byref clr as ulong ) as boolean
function tkColorPicker_ContrastColor( byval clr as ulong ) as ulong
function tkColorPicker_FieldAccepts( byval nField as long, byval ch as long, byval nPos as long ) as boolean
function tkColorPicker_FieldMaxLen( byval nField as long ) as long
function tkColorPicker_TabName( byval idx as long ) as ustring
function tkColorPicker_WebColorCount() as long
function tkColorPicker_WebColorAt( byval idx as long ) as ulong
function tkColorPicker_WebColorName( byval idx as long ) as ustring
function tkColorPicker_SystemColorCount() as long
function tkColorPicker_SystemColorAt( byval idx as long ) as ulong
function tkColorPicker_SystemColorName( byval idx as long ) as ustring
sub tkColorPicker_SetSystemColor( byval idx as long, byval clr as ulong )
function tkColorPicker_Create( byval hParent as TK_WIDGET ptr, byval id as long = 0 ) as TK_WIDGET ptr
sub tkColorPicker_Destroy( byval hCtrl as TK_WIDGET ptr )
sub tkColorPicker_PositionForRect( byval hCtrl as TK_WIDGET ptr, byref rcAnchor as TKRECT )
sub tkColorPicker_PositionCentered( byval hCtrl as TK_WIDGET ptr, byval hRef as TK_WIDGET ptr = 0 )
sub tkColorPicker_GetPosition( byval hCtrl as TK_WIDGET ptr, byref x as long, byref y as long )
function tkColorPicker_RunModal( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkColorPicker_DoModal( byval hParent as TK_WIDGET ptr, byref clr as ulong, byref nAlpha as ubyte ) as boolean
function tkColorPicker_DoModalForRect( byval hParent as TK_WIDGET ptr, byref rcAnchor as TKRECT, byref clr as ulong, byref nAlpha as ubyte ) as boolean
sub tkColorPicker_EndModal( byval hCtrl as TK_WIDGET ptr, byval bAccept as boolean )
function tkColorPicker_IsOpen( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkColorPicker_GetSurface( byval hCtrl as TK_WIDGET ptr ) as TK_HOST ptr
function tkColorPicker_GetContent( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
sub tkColorPicker_SetColor( byval hCtrl as TK_WIDGET ptr, byval clr as ulong, byval nAlpha as ubyte = 255, byval bKeepInitial as boolean = false )
function tkColorPicker_GetColor( byval hCtrl as TK_WIDGET ptr ) as ulong
function tkColorPicker_GetAlpha( byval hCtrl as TK_WIDGET ptr ) as ubyte
sub tkColorPicker_SetInitial( byval hCtrl as TK_WIDGET ptr, byval clr as ulong, byval nAlpha as ubyte = 255 )
function tkColorPicker_GetInitial( byval hCtrl as TK_WIDGET ptr ) as ulong
sub tkColorPicker_RevertToInitial( byval hCtrl as TK_WIDGET ptr )
sub tkColorPicker_ShowAlpha( byval hCtrl as TK_WIDGET ptr, byval bShow as boolean )
function tkColorPicker_IsAlphaShown( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkColorPicker_SetTab( byval hCtrl as TK_WIDGET ptr, byval nTab as long )
function tkColorPicker_GetTab( byval hCtrl as TK_WIDGET ptr ) as long
sub tkColorPicker_SetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKCOLORPICKER_COLORS ptr )
sub tkColorPicker_GetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKCOLORPICKER_COLORS ptr )
function tkColorPicker_ThemeColors( byref t as TKTHEME_COLORS ) as TKCOLORPICKER_COLORS
sub tkColorPicker_ApplyTheme( byval hCtrl as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkColorPicker_UnpinColors( byval hCtrl as TK_WIDGET ptr )
sub tkColorPicker_SetFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkColorPicker_GetFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkColorPicker_ApplyFonts( byval hCtrl as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkColorPicker_SetOKText( byval hCtrl as TK_WIDGET ptr, byval Text as ustring )
sub tkColorPicker_SetPreviewText( byval hCtrl as TK_WIDGET ptr, byval TextInitial as ustring, byval TextCurrent as ustring )
sub tkColorPicker_SetFieldText( byval hCtrl as TK_WIDGET ptr, byval nField as long, byval Text as ustring )
function tkColorPicker_GetFieldText( byval hCtrl as TK_WIDGET ptr, byval nField as long ) as ustring
sub tkColorPicker_Refresh( byval hCtrl as TK_WIDGET ptr )
function tkColorPicker_GetEnabled( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkColorPicker_SetEnabled( byval hCtrl as TK_WIDGET ptr, byval bEnabled as boolean )
function tkColorPicker_GetFocused( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkColorPicker_GetFocusField( byval hCtrl as TK_WIDGET ptr ) as long
function tkColorPicker_GetEditText( byval hCtrl as TK_WIDGET ptr ) as ustring
function tkColorPicker_GetBodySel( byval hCtrl as TK_WIDGET ptr ) as long
function tkColorPicker_GetScrollTop( byval hCtrl as TK_WIDGET ptr ) as long
sub tkColorPicker_GetIdealSize( byval hCtrl as TK_WIDGET ptr, byref cx as long, byref cy as long )
sub tkColorPicker_GetMatrixSize( byval hCtrl as TK_WIDGET ptr, byref nCols as long, byref nRows as long )
sub tkColorPicker_SetMatrixSize( byval hCtrl as TK_WIDGET ptr, byval nCols as long, byval nRows as long )
sub tkColorPicker_GetCellSize( byval hCtrl as TK_WIDGET ptr, byref cx as long, byref cy as long )
sub tkColorPicker_SetCellSize( byval hCtrl as TK_WIDGET ptr, byval cx as long, byval cy as long )
function tkColorPicker_GetPartRect( byval hCtrl as TK_WIDGET ptr, byval nPart as long, byref rc as TKRECT ) as boolean
function tkColorPicker_GetFieldRect( byval hCtrl as TK_WIDGET ptr, byval nField as long, byref rc as TKRECT ) as boolean
function tkColorPicker_GetTabRect( byval hCtrl as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkColorPicker_HitTestTab( byval hCtrl as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkColorPicker_HitTestField( byval hCtrl as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkColorPicker_HitTestBody( byval hCtrl as TK_WIDGET ptr, byval x as long, byval y as long ) as long
sub tkColorPicker_SetColorChangedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CLR_ColorChangedCallbackSub )
sub tkColorPicker_SetTabChangedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CLR_TabChangedCallbackSub )
sub tkColorPicker_SetMessageCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as CLR_MessageCallbackFunc )
sub tkColorPicker_SetPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CLR_PaintCallbackSub )
sub tkColorPicker_SetOpenCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as CLR_OpenCallbackSub )
sub tkColorPicker_RenderInfo( byval p as any ptr )
function tkColorPicker_CountRenderedTones( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as long
function tkColorPicker_HashRenderedPart( byval hCtrl as TK_WIDGET ptr, byval nPart as long ) as ulong
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsColorPicker](PsColorPicker), the PsControls control
