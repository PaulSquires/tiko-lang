[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkTextBox**

# tkTextBox

Draws an editable text box, single-line or word-wrapped multiline, with its own editor.

`tkTextBox` is the [tkControls](Category-tkControls) text entry: a rounded frame around a
self-drawn editor with selection, clipboard, undo and redo, word navigation, a cue banner and a
right-click menu. Single-line or multiline is fixed at creation. A multiline box word-wraps and
scrolls vertically only; Enter starts a new line and Tab inserts a tab. A single-line box always
claims Enter (and reports it through the Enter-pressed callback), lets Tab move focus, and centres
its text vertically.

Programmatic changes (`SetText`, `ReplaceSel`, `Clear`, `SetValue`) are silent; typing, Cut,
Paste, Undo, Delete and Backspace run the change callback. A single-line box also has a numeric
mode, which vets every keystroke and paste and reformats the value when focus leaves.

## Importing

```freebasic
#import "vendor/tkControls/tkTextBox"

using tkTextBox
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme), [tkPopupMenu](tkPopupMenu) (the context menu) and
[tkVScrollBar](tkVScrollBar) (the optional scrollbar). Add `using tkPopupMenu` to style the menu
returned by `tkTextBox_GetContextMenu`.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Search_Changed( byval hTextBox as TK_WIDGET ptr )
    print "typed: " & tkTextBox_GetText( hTextBox )
end sub

sub Search_Enter( byval hTextBox as TK_WIDGET ptr )
    print "search for [" & tkTextBox_GetText( hTextBox ) & "]"
end sub

dim as TK_WIDGET ptr search = tkTextBox_Create( tkHost_Root( host ), 4000 )
tkTextBox_SetCueBannerText( search, "Search anything..." )
tkTextBox_SetMargins( search, tkHost_Scale( host, 8 ), tkHost_Scale( host, 8 ) )
tkTextBox_SetChangeCallback( search, @Search_Changed )
tkTextBox_SetEnterPressedCallback( search, @Search_Enter )
tkWidget_SetPos( search, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), _
                 tkHost_Scale( host, 300 ), tkHost_Scale( host, 30 ) )

dim as TK_WIDGET ptr notes = tkTextBox_Create( tkHost_Root( host ), 4001, true )   ' multiline
tkTextBox_SetScrollBarVisible( notes, true )
```

## Offsets are bytes

The buffer is UTF-8. `GetSel`, `SetSel`, `GetCaret`, `GetTextLength`, `PosFromChar` and
`CharFromPos` work in **byte offsets**, snapped to character boundaries; for ASCII text they
equal character indices. `SetLimitText` counts characters, and its default 0 means no limit.

## Coming from PsTextBox

[PsTextBox](PsTextBox) is the Win32 twin; its page remains the behaviour reference for everything
not listed here. PsTextBox frames a RichEdit control; tkTextBox draws its own editor behind the
same API.

- Names: `PsTextBox_*` → `tkTextBox_*`, `PSTEXTBOX_MESSAGEINFO` → `TKTEXTBOX_MESSAGEINFO`.
  `TXT_ALIGN_*` and the `TXT_*Callback*` types keep their names. The handle is `TK_WIDGET ptr`.
- `tkTextBox_Create( hParent, CtrlID, bMultiline = false )` takes a `TK_WIDGET ptr` parent; for
  a top-level control pass `tkHost_Root( host )`.
- Offsets are UTF-8 byte offsets (see above).
- Colours: a `TKTEXTBOX_COLORS` struct adds `SelBackColor`, `SelForeColor` and
  `ForeColorDisabled`, with `tkTextBox_GetColors` / `SetColors` / `ThemeColors` beside the
  per-colour setters. Defaults are the dark theme.
- Fonts are `TTF_Font ptr` (`tkTextBox_SetFont`, `SetCueBannerFont`).
- `TKTEXTBOX_MESSAGEINFO` carries `msg` (a `TKM_*` code or `TKTEXTBOX_MSG_CONTEXTMENU`), `x`,
  `y`, `key`, `mods`, `wheelY` and `text`.
- The context menu is a [tkPopupMenu](tkPopupMenu) (`TK_MENU ptr`). It opens on the right
  button's release, the Menu key and Shift+F10.
- Escape is not claimed; the message callback still sees it.
- A multi-line string pasted or set into a single-line box keeps only its first line.
- The selection is kept but not painted while the box is unfocused.
- The password character applies to single-line boxes only, and a password box will not copy or
  cut.
- Tabs are drawn and measured as one space.
- `SetTextAlign` keeps the undo history.
- No equivalent: `GetRichEditHandle`, forwarding of `EM_*` / `WM_SETTEXT` messages,
  `FilterMessage`, `Rescale` (scale changes arrive as `TKM_SCALECHANGED`), PsRegistry.
- Added: Redo (`Ctrl+Y`, `Ctrl+Shift+Z`, `tkTextBox_Redo` / `CanRedo`); inline IME composition
  (`GetComposition`); an optional built-in scrollbar (`SetScrollBarVisible` / `GetScrollBar`);
  `GetTextRect`, `PosFromChar`, `CharFromPos`, `GetCaretRect`, `GetCaret`, `GetCaretVisible`,
  `SetCaretBlink` / `GetCaretBlink`, `ShowsCue`, `GetPasswordChar`, `GetID`; the clipboard keys
  Ctrl+Insert, Shift+Insert and Shift+Delete.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKTEXTBOX_MSG_CONTEXTMENU = 1000
const TKTEXTBOX_CARET_BLINK_MS = 530 ' GetCaretBlinkTime's default
const TKTEXTBOX_MAX_UNDO = 100
const TKTEXTBOX_WHEEL_LINES = 3 ' SPI_GETWHEELSCROLLLINES' default

enum
    TXT_ALIGN_LEFT = 0
    TXT_ALIGN_CENTER
    TXT_ALIGN_RIGHT
end enum

enum
    TKTEXTBOX_IDM_CUT = 1
    TKTEXTBOX_IDM_COPY
    TKTEXTBOX_IDM_PASTE
    TKTEXTBOX_IDM_SELECTALL
end enum
```

### Types

```freebasic
type TKTEXTBOX_COLORS
    ForeColor         as ulong = &hFFC8CDD6ul
    BackColor         as ulong = &hFF2C313Aul
    CueColor          as ulong = &hFF969CA6ul
    BorderColor       as ulong = &hFF444A56ul
    FocusBorderColor  as ulong = &hFF61AFEFul
    OuterBackColor    as ulong = &hFF21252Bul
    SelBackColor      as ulong = &hFF264F78ul
    SelForeColor      as ulong = &hFFFFFFFFul
    ForeColorDisabled as ulong = &hFF606670ul
end type

type TKTEXTBOX_MESSAGEINFO
    hTextBox as TK_WIDGET ptr
    msg      as long                    ' TKM_* or TKTEXTBOX_MSG_CONTEXTMENU
    x        as single
    y        as single
    key      as long
    mods     as long
    wheelY   as single                  ' TKM_MOUSEWHEEL: notches, positive = away
    text     as string                  ' TKM_CHAR / TKM_IMECOMPOSE: UTF-8
end type

type TKTB_UNDO
    sText   as string
    nCaret  as long
    nAnchor as long
end type

type TKTEXTBOX_STATE   ' per-instance state; reach it through the procedures

type TXT_ChangeCallbackSub as sub( byval hTextBox as TK_WIDGET ptr )
type TXT_FocusCallbackSub as sub( byval hTextBox as TK_WIDGET ptr, byval bGotFocus as boolean )
type TXT_EnterPressedCallbackSub as sub( byval hTextBox as TK_WIDGET ptr )
type TXT_ScrollChangedCallbackSub as sub( byval hTextBox as TK_WIDGET ptr )
type TXT_MessageCallbackFunc as function( byval m as TKTEXTBOX_MESSAGEINFO ptr ) as boolean
```

### Procedures

```freebasic
function tkTextBox_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long, byval bMultiline as boolean = false ) as TK_WIDGET ptr
function tkTextBox_GetMultiline( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_HasFocus( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_GetID( byval hTextBox as TK_WIDGET ptr ) as long
function tkTextBox_GetText( byval hTextBox as TK_WIDGET ptr ) as ustring
function tkTextBox_SetText( byval hTextBox as TK_WIDGET ptr, byval Text as ustring ) as boolean
function tkTextBox_GetTextLength( byval hTextBox as TK_WIDGET ptr ) as integer
function tkTextBox_GetSelText( byval hTextBox as TK_WIDGET ptr ) as ustring
function tkTextBox_ReplaceSel( byval hTextBox as TK_WIDGET ptr, byval Text as ustring ) as boolean
function tkTextBox_Clear( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_GetSel( byval hTextBox as TK_WIDGET ptr, byref nStart as integer, byref nEnd as integer )
sub tkTextBox_SetSel( byval hTextBox as TK_WIDGET ptr, byval nStart as integer, byval nEnd as integer )
sub tkTextBox_SelectAll( byval hTextBox as TK_WIDGET ptr )
function tkTextBox_GetCaret( byval hTextBox as TK_WIDGET ptr ) as integer
function tkTextBox_GetLimitText( byval hTextBox as TK_WIDGET ptr ) as integer
sub tkTextBox_SetLimitText( byval hTextBox as TK_WIDGET ptr, byval nLimit as integer )
function tkTextBox_GetReadOnly( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_SetReadOnly( byval hTextBox as TK_WIDGET ptr, byval bReadOnly as boolean ) as boolean
function tkTextBox_GetModify( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_SetModify( byval hTextBox as TK_WIDGET ptr, byval bModified as boolean )
sub tkTextBox_SetPasswordChar( byval hTextBox as TK_WIDGET ptr, byval wchChar as integer )
function tkTextBox_GetPasswordChar( byval hTextBox as TK_WIDGET ptr ) as integer
function tkTextBox_GetSelectOnFocus( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_SetSelectOnFocus( byval hTextBox as TK_WIDGET ptr, byval bSelect as boolean )
sub tkTextBox_GetMargins( byval hTextBox as TK_WIDGET ptr, byref nLeft as integer, byref nRight as integer )
sub tkTextBox_SetMargins( byval hTextBox as TK_WIDGET ptr, byval nLeft as integer, byval nRight as integer )
sub tkTextBox_Cut( byval hTextBox as TK_WIDGET ptr )
sub tkTextBox_Copy( byval hTextBox as TK_WIDGET ptr )
sub tkTextBox_Paste( byval hTextBox as TK_WIDGET ptr )
function tkTextBox_CanPaste( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_Undo( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_CanUndo( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_Redo( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_CanRedo( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_GetNumericMode( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_SetNumericMode( byval hTextBox as TK_WIDGET ptr, byval bEnable as boolean )
function tkTextBox_GetDecimalPlaces( byval hTextBox as TK_WIDGET ptr ) as integer
sub tkTextBox_SetDecimalPlaces( byval hTextBox as TK_WIDGET ptr, byval nPlaces as integer )
function tkTextBox_GetValue( byval hTextBox as TK_WIDGET ptr ) as double
function tkTextBox_SetValue( byval hTextBox as TK_WIDGET ptr, byval nValue as double ) as boolean
function tkTextBox_GetZeroWhenEmpty( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_SetZeroWhenEmpty( byval hTextBox as TK_WIDGET ptr, byval bEnable as boolean )
sub tkTextBox_GetVScrollInfo( byval hTextBox as TK_WIDGET ptr, byref nTotalLines as integer, byref nLinesPerPage as integer, byref nFirstVisibleLine as integer )
sub tkTextBox_ScrollToLine( byval hTextBox as TK_WIDGET ptr, byval nLine as integer )
sub tkTextBox_SetScrollBarVisible( byval hTextBox as TK_WIDGET ptr, byval bShow as boolean )
function tkTextBox_GetScrollBar( byval hTextBox as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkTextBox_GetTextRect( byval hTextBox as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkTextBox_PosFromChar( byval hTextBox as TK_WIDGET ptr, byval nOffset as integer, byref x as long, byref y as long )
function tkTextBox_CharFromPos( byval hTextBox as TK_WIDGET ptr, byval x as long, byval y as long ) as integer
function tkTextBox_GetCaretRect( byval hTextBox as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkTextBox_GetCaretVisible( byval hTextBox as TK_WIDGET ptr ) as boolean
sub tkTextBox_SetCaretBlink( byval hTextBox as TK_WIDGET ptr, byval nMs as long )
function tkTextBox_GetCaretBlink( byval hTextBox as TK_WIDGET ptr ) as long
function tkTextBox_GetComposition( byval hTextBox as TK_WIDGET ptr ) as ustring
function tkTextBox_GetFont( byval hTextBox as TK_WIDGET ptr ) as TTF_Font ptr
function tkTextBox_SetFont( byval hTextBox as TK_WIDGET ptr, byval f as TTF_Font ptr ) as boolean
sub tkTextBox_GetColors( byval hTextBox as TK_WIDGET ptr, byval pColors as TKTEXTBOX_COLORS ptr )
sub tkTextBox_SetColors( byval hTextBox as TK_WIDGET ptr, byval pColors as TKTEXTBOX_COLORS ptr )
function tkTextBox_GetForeColor( byval hTextBox as TK_WIDGET ptr ) as ulong
function tkTextBox_SetForeColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong ) as ulong
function tkTextBox_GetBackColor( byval hTextBox as TK_WIDGET ptr ) as ulong
function tkTextBox_SetBackColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong ) as ulong
function tkTextBox_GetCueBannerColor( byval hTextBox as TK_WIDGET ptr ) as ulong
sub tkTextBox_SetCueBannerColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong )
function tkTextBox_GetBorderColor( byval hTextBox as TK_WIDGET ptr ) as ulong
sub tkTextBox_SetBorderColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong )
function tkTextBox_GetFocusBorderColor( byval hTextBox as TK_WIDGET ptr ) as ulong
sub tkTextBox_SetFocusBorderColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong )
function tkTextBox_GetOuterBackColor( byval hTextBox as TK_WIDGET ptr ) as ulong
sub tkTextBox_SetOuterBackColor( byval hTextBox as TK_WIDGET ptr, byval clr as ulong )
function tkTextBox_GetCueBannerText( byval hTextBox as TK_WIDGET ptr ) as ustring
sub tkTextBox_SetCueBannerText( byval hTextBox as TK_WIDGET ptr, byval Text as ustring )
function tkTextBox_GetCueBannerFont( byval hTextBox as TK_WIDGET ptr ) as TTF_Font ptr
sub tkTextBox_SetCueBannerFont( byval hTextBox as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkTextBox_ShowsCue( byval hTextBox as TK_WIDGET ptr ) as boolean
function tkTextBox_GetTextAlign( byval hTextBox as TK_WIDGET ptr ) as long
sub tkTextBox_SetTextAlign( byval hTextBox as TK_WIDGET ptr, byval nAlign as long )
function tkTextBox_GetBorderWidth( byval hTextBox as TK_WIDGET ptr ) as integer
sub tkTextBox_SetBorderWidth( byval hTextBox as TK_WIDGET ptr, byval nWidth as integer )
function tkTextBox_GetCornerRadius( byval hTextBox as TK_WIDGET ptr ) as integer
sub tkTextBox_SetCornerRadius( byval hTextBox as TK_WIDGET ptr, byval nRadius as integer )
function tkTextBox_ThemeColors( byref t as TKTHEME_COLORS ) as TKTEXTBOX_COLORS
sub tkTextBox_ApplyTheme( byval hTextBox as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkTextBox_UnpinColors( byval hTextBox as TK_WIDGET ptr )
sub tkTextBox_ApplyFonts( byval hTextBox as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkTextBox_SetMenuText( byval hTextBox as TK_WIDGET ptr, byval CutText as ustring, byval CopyText as ustring, byval PasteText as ustring, byval SelectAllText as ustring = "" )
function tkTextBox_GetContextMenu( byval hTextBox as TK_WIDGET ptr ) as TK_MENU ptr
sub tkTextBox_CloseContextMenu()
sub tkTextBox_SetChangeCallback( byval hTextBox as TK_WIDGET ptr, byval usersub as TXT_ChangeCallbackSub )
sub tkTextBox_SetFocusCallback( byval hTextBox as TK_WIDGET ptr, byval usersub as TXT_FocusCallbackSub )
sub tkTextBox_SetEnterPressedCallback( byval hTextBox as TK_WIDGET ptr, byval usersub as TXT_EnterPressedCallbackSub )
sub tkTextBox_SetMessageCallback( byval hTextBox as TK_WIDGET ptr, byval userfunc as TXT_MessageCallbackFunc )
sub tkTextBox_SetScrollChangedCallback( byval hTextBox as TK_WIDGET ptr, byval usersub as TXT_ScrollChangedCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsTextBox](PsTextBox), the PsControls control
