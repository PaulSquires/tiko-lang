[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkMenuBar**

# tkMenuBar

Draws a window's menu bar, whose items drop down tkPopupMenu menus.

tkMenuBar is the strip of top-level menu names (File, Edit, View, Help) along the top of a window. Each item can own a dropdown, a [tkPopupMenu](tkPopupMenu) menu attached with `tkMenuBar_SetDropDown`; the bar owns it from then on and destroys it with itself. Items are appended in order, each as wide as its text in the bar's font; `tkMenuBar_GetIdealWidth` is the width they need.

It behaves like a desktop menu bar. A click opens an item's dropdown, moving the mouse along the bar switches dropdowns while one is open, and clicking the bar again closes it. Left and Right step between dropdowns. `tkMenuBar_SetActiveIndex` starts the keyboard highlight mode (bind it to a key such as F10): Left / Right move the highlight, Down or Enter open, Escape clears.

A chosen command arrives at the bar's Command callback with its id, after the whole menu has closed. The InitPopup callback runs before every dropdown opens, the moment to update check marks and enabled states. Setters are silent.

## Importing

```freebasic
#import "vendor/tkControls/tkMenuBar"
using tkMenuBar
using tkPopupMenu
using tkHost
```

The module brings in [tkHost](tkHost), [tkTheme](tkTheme) and [tkPopupMenu](tkPopupMenu); `using tkPopupMenu` names the `tkPopupMenu_*` calls that build the dropdowns.

## Example

`gHost` is the window ([tkHost](tkHost)); `gFont10` and `gGlyph9` are fonts opened with `tkHost_OpenFont`, the second from `tkHost_FontDir() & TK_FONT_ICONS`.

```freebasic
const as long IDM_FILE_NEW = 101, IDM_FILE_WRAP = 102, IDM_FILE_EXIT = 103
dim shared as boolean gWrap

sub OnCommand( byval hMenuBar as TK_WIDGET ptr, byval id as long )
    if id = IDM_FILE_WRAP then gWrap = not gWrap
end sub

sub OnInitPopup( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byval hPopup as TK_MENU ptr )
    if idx = 0 then tkPopupMenu_SetItemChecked( hPopup, IDM_FILE_WRAP, gWrap )
end sub

dim as TK_WIDGET ptr bar = tkMenuBar_Create( tkHost_Root( gHost ), 100 )
tkMenuBar_SetFont( bar, gFont10 )
tkMenuBar_SetCommandCallback( bar, @OnCommand )
tkMenuBar_SetInitPopupCallback( bar, @OnInitPopup )
tkMenuBar_AddItem( bar, "File", 1 )
tkMenuBar_AddItem( bar, "Help", 2 )

dim as TK_MENU ptr hFile = tkPopupMenu_Create( gHost )
tkPopupMenu_SetFonts( hFile, gFont10, gGlyph9 )
tkPopupMenu_SetGlyphs( hFile, wchr( TK_ICON_CHECKMARK ), wchr( TK_ICON_CHEVRON_RIGHT ) )
tkPopupMenu_AddItem( hFile, IDM_FILE_NEW, "New File", "Ctrl+N" )
tkPopupMenu_AddItem( hFile, IDM_FILE_WRAP, "Word Wrap" )
tkPopupMenu_AddSeparator( hFile )
tkPopupMenu_AddItem( hFile, IDM_FILE_EXIT, "Exit", "Alt+F4" )
tkMenuBar_SetDropDown( bar, 0, hFile )

tkWidget_SetPos( bar, 0, 0, 600, tkHost_Scale( gHost, 30 ) )   ' a height first,
tkWidget_SetPos( bar, 0, 0, tkMenuBar_GetIdealWidth( bar ), tkHost_Scale( gHost, 30 ) )
```

The item rects, and so `tkMenuBar_GetIdealWidth`, are only known once the bar has a height, hence the two calls. The accelerator text in a menu is only a label: bind the keys themselves with [tkKeys](tkKeys). The toolchain's `examples/tkControls/tkMenuBar/` has four dropdowns, a submenu rebuilt on every open and a right-click menu.

## Coming from PsMenuBar

The [PsMenuBar](PsMenuBar) page remains the behaviour reference for everything not listed here: the layout, the open / switch / close gestures, the keyboard and the order of the callbacks are the same.

- `PsMenuBar_*` → `tkMenuBar_*`; `PSMENUBAR_*` → `TKMENUBAR_*` (`_ITEM`, `_COLORS`, `_PAINTINFO`, `_DEFAULT_PADDING`). The `MB_*` callback types keep their names.
- `tkMenuBar_Create( parent, id )` takes a `TK_WIDGET ptr` parent and returns the bar as a `TK_WIDGET ptr`. The dropdowns are `TK_MENU ptr` ([tkPopupMenu](tkPopupMenu)), not windows. Fonts are `TTF_Font ptr`.
- There is no `FilterMessage` to call from the message loop: keys reach an open dropdown on their own. While the keyboard highlight mode is on, the bar holds the keyboard focus and the mouse, and gives the focus back when it ends; a click elsewhere still lands, and Tab moves the focus on.
- A dropdown's own select and closed callbacks still run; the bar chains its own behind them.
- If another popup opens elsewhere and closes the bar's dropdown, the bar notices on its next paint, mouse event or `tkMenuBar_IsMenuOpen`.
- Added: `tkMenuBar_GetColors`, `tkMenuBar_GetHotIndex`.
- No equivalent: `FilterMessage`, PsRegistry, `Rescale` (a scale change rescales the padding on its own). The application's own focus loss closes the menus.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKMENUBAR_DEFAULT_PADDING = 6
```

### Types

```freebasic
type TKMENUBAR_ITEM
    id          as long
    wszText     as ustring
    hDropDown   as TK_MENU ptr            ' OWNED once attached
    prevSelect  as PM_SelectCallbackSub
    prevClosed  as PM_ClosedCallbackSub
    prevKeyHook as PM_KeyHookFunc
    nWidth      as long
    rc          as TKRECT
end type

type TKMENUBAR_COLORS
    BackColor    as ulong = &hFF21252Bul    ' bar + idle item
    ForeColor    as ulong = &hFFC8CDD6ul
    BackColorHot as ulong = &hFF373D48ul    ' hovered / active item
    ForeColorHot as ulong = &hFFE2E6EEul
end type

type TKMENUBAR_PAINTINFO
    hMenuBar   as TK_WIDGET ptr
    itemID     as long
    b          as TK_PAINT ptr
    rc         as TKRECT
    isHot      as boolean
    isActive   as boolean
    wszCaption as ustring
end type

type TKMENUBAR_STATE   ' per-instance state; reach it through the procedures

type MB_CommandCallbackSub as sub( byval hMenuBar as TK_WIDGET ptr, byval id as long )
type MB_InitPopupCallbackSub as sub( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byval hPopup as TK_MENU ptr )
type MB_PaintItemCallbackSub as sub( byval p as TKMENUBAR_PAINTINFO ptr )
```

### Procedures

```freebasic
function tkMenuBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkMenuBar_AddItem( byval hMenuBar as TK_WIDGET ptr, byval Text as ustring, byval id as long ) as long
function tkMenuBar_GetItemCount( byval hMenuBar as TK_WIDGET ptr ) as long
function tkMenuBar_GetItemText( byval hMenuBar as TK_WIDGET ptr, byval idx as long ) as ustring
function tkMenuBar_SetItemText( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byval Text as ustring ) as boolean
function tkMenuBar_SetDropDown( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byval hPopup as TK_MENU ptr ) as boolean
function tkMenuBar_GetDropDown( byval hMenuBar as TK_WIDGET ptr, byval idx as long ) as TK_MENU ptr
function tkMenuBar_GetItemRect( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkMenuBar_GetIdealWidth( byval hMenuBar as TK_WIDGET ptr ) as long
function tkMenuBar_GetPadding( byval hMenuBar as TK_WIDGET ptr ) as long
sub tkMenuBar_SetPadding( byval hMenuBar as TK_WIDGET ptr, byval nPadding as long )
function tkMenuBar_OpenMenu( byval hMenuBar as TK_WIDGET ptr, byval idx as long, byval bSelectFirst as boolean = false ) as boolean
sub tkMenuBar_CloseMenu( byval hMenuBar as TK_WIDGET ptr )
function tkMenuBar_IsMenuOpen( byval hMenuBar as TK_WIDGET ptr ) as boolean
function tkMenuBar_GetActiveIndex( byval hMenuBar as TK_WIDGET ptr ) as long
function tkMenuBar_SetActiveIndex( byval hMenuBar as TK_WIDGET ptr, byval idx as long ) as boolean
function tkMenuBar_GetHotIndex( byval hMenuBar as TK_WIDGET ptr ) as long
sub tkMenuBar_SetColors( byval hMenuBar as TK_WIDGET ptr, byval pColors as TKMENUBAR_COLORS ptr )
sub tkMenuBar_GetColors( byval hMenuBar as TK_WIDGET ptr, byval pColors as TKMENUBAR_COLORS ptr )
function tkMenuBar_ThemeColors( byref t as TKTHEME_COLORS ) as TKMENUBAR_COLORS
sub tkMenuBar_ApplyTheme( byval hMenuBar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkMenuBar_UnpinColors( byval hMenuBar as TK_WIDGET ptr )
sub tkMenuBar_ApplyFonts( byval hMenuBar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkMenuBar_SetFont( byval hMenuBar as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkMenuBar_SetCommandCallback( byval hMenuBar as TK_WIDGET ptr, byval usersub as MB_CommandCallbackSub )
sub tkMenuBar_SetInitPopupCallback( byval hMenuBar as TK_WIDGET ptr, byval usersub as MB_InitPopupCallbackSub )
sub tkMenuBar_SetPaintItemCallback( byval hMenuBar as TK_WIDGET ptr, byval usersub as MB_PaintItemCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsMenuBar](PsMenuBar), the PsControls control
