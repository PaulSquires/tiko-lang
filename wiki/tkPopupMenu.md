[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkPopupMenu**

# tkPopupMenu

Shows a popup menu of commands, separators, check marks and submenus.

tkPopupMenu is the menu itself: rows with a caption, an optional accelerator label on the right, a check mark, a disabled state, separators and nested submenus. It serves as a right-click context menu, as the dropdowns of a [tkMenuBar](tkMenuBar), and as a menu for any button. Create a menu once and show it as often as you like; while it is closed it has no window at all.

Hover is selection, and resting on a submenu row for a moment opens it. A command runs when the mouse button is released over an enabled row (or on Enter), and the Select callback receives its id after the whole chain of menus has closed. The keyboard works as in any desktop menu: Up / Down wrap, Home / End, Right and Left go in and out of submenus, Enter chooses, Escape closes one level. A click outside closes the menus and still reaches what it lands on. Only one chain of menus is open at a time.

Operations that take an id (`tkPopupMenu_SetItemChecked`, `tkPopupMenu_SetItemEnabled`, `tkPopupMenu_DeleteItem` and the rest) search the submenus too. A submenu attached with `tkPopupMenu_SetItemSubMenu` is owned by its parent and destroyed with it.

## Importing

```freebasic
#import "vendor/tkControls/tkPopupMenu"
using tkPopupMenu
using tkHost
```

The module brings in [tkHost](tkHost) and [tkTheme](tkTheme). The handle is a `TK_MENU ptr`, not a widget.

## Example

A right-click menu with a submenu. `gHost` is the window ([tkHost](tkHost)); `gFont10` and `gGlyph9` are fonts opened with `tkHost_OpenFont`, the second from `tkHost_FontDir() & TK_FONT_ICONS`.

```freebasic
const as long IDM_INSERT = 1, IDM_RENAME = 2, IDM_ADVANCED = 3, IDM_ADV_ONE = 4
dim shared as TK_MENU ptr gCtx

sub OnSelect( byval hPopup as TK_MENU ptr, byval id as long )
    print "command "; id
end sub

function NewMenu() as TK_MENU ptr
    dim as TK_MENU ptr m = tkPopupMenu_Create( gHost )
    tkPopupMenu_SetFonts( m, gFont10, gGlyph9 )
    tkPopupMenu_SetGlyphs( m, wchr( TK_ICON_CHECKMARK ), wchr( TK_ICON_CHEVRON_RIGHT ) )
    return m
end function

gCtx = NewMenu()
tkPopupMenu_SetSelectCallback( gCtx, @OnSelect )
tkPopupMenu_AddItem( gCtx, IDM_INSERT, "Insert Row" )
tkPopupMenu_AddItem( gCtx, IDM_RENAME, "Rename...", "F2" )
tkPopupMenu_AddSeparator( gCtx )
tkPopupMenu_AddItem( gCtx, IDM_ADVANCED, "Advanced" )
dim as TK_MENU ptr hAdv = NewMenu()
tkPopupMenu_AddItem( hAdv, IDM_ADV_ONE, "Advanced Option One" )
tkPopupMenu_SetItemSubMenu( gCtx, IDM_ADVANCED, hAdv )

' in a widget's procedure, on TKM_RBUTTONUP (m->x, m->y are widget-local):
'     dim as TKRECT a
'     tkWidget_AbsRect( w, a )
'     tkPopupMenu_Show( gCtx, a.left + cint( m->x ), a.top + cint( m->y ) )
```

The submenu needs no Select callback of its own: the root menu's callback receives a command chosen anywhere in its chain. The toolchain's `examples/tkControls/tkMenuBar/` uses this menu both as dropdowns and as a context menu.

## Where a menu appears

`tkPopupMenu_Show( m, x, y )` puts the menu's top-left at `x, y`, and `tkPopupMenu_ShowForRect( m, rc, PM_ALIGN_BELOW )` (or `PM_ALIGN_RIGHT`) places it against a rectangle, such as the button that opened it. Both take pixels of the **owner window**, the `TK_HOST ptr` given to `tkPopupMenu_Create`, not screen coordinates. Showing is not modal: the call returns at once and the command arrives through the Select callback.

## Coming from PsPopupMenu

The [PsPopupMenu](PsPopupMenu) page remains the behaviour reference for everything not listed here: the row layout, hover and the submenu delay, the keyboard, the colours and when commands run are the same.

- `PsPopupMenu_*` → `tkPopupMenu_*`; `PSPOPUPMENU_*` → `TKPOPUPMENU_*`. `PM_ALIGN_*` and the `PM_*` callback types keep their names.
- `tkPopupMenu_Create( owner, id )` takes the owner window as a `TK_HOST ptr` and returns a `TK_MENU ptr`, not a window. Free a menu you no longer need with `tkPopupMenu_Destroy`; it frees its submenus too. A menu given to `tkMenuBar_SetDropDown` belongs to the bar.
- `tkPopupMenu_Show` and `tkPopupMenu_ShowForRect` take the owner window's pixels, not screen coordinates.
- Fonts are `TTF_Font ptr`: `tkPopupMenu_SetFonts( m, text, glyph )`. Without a glyph font the check mark and the submenu chevron are drawn as text characters in the text font; give the bundled icon font and `tkPopupMenu_SetGlyphs` for the icon look.
- There is no `FilterMessage` to call from the message loop: keys reach the innermost open menu on their own.
- `SetNotifyWindow` and the `CPM_NOTIFY_*` messages are replaced by `tkPopupMenu_SetClosedCallback`, whose reason is `PM_CLOSED_ESCAPE` or `PM_CLOSED_OTHER`; the command itself is the Select callback.
- The theme and the scale are picked up each time a menu shows.
- Added: `tkPopupMenu_SetKeyHook` (sees each key before the menu's own keyboard handling), `tkPopupMenu_OpenSubMenu`, `tkPopupMenu_GetOpenRoot`, `tkPopupMenu_Surface` (the open level's `TK_HOST ptr`), `tkPopupMenu_GetColors`.
- No equivalent: `FilterMessage`, PsRegistry. The application losing the focus closes the menus.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKPOPUPMENU_HOVER_MS = 250
const TKPOPUPMENU_DEFAULT_ITEMHEIGHT = 24
const TKPOPUPMENU_DEFAULT_SEPHEIGHT = 9
const TKPOPUPMENU_DEFAULT_SEPTHICKNESS = 1
const TKPOPUPMENU_DEFAULT_CHECKCOL = 30
const TKPOPUPMENU_DEFAULT_CHEVRONCOL = 20
const TKPOPUPMENU_DEFAULT_ACCELGAP = 24
const TKPOPUPMENU_DEFAULT_HPADDING = 2
const TKPOPUPMENU_DEFAULT_VPADDING = 8
const PM_ALIGN_BELOW = 1
const PM_ALIGN_RIGHT = 2
const PM_CLOSED_OTHER = 0
const PM_CLOSED_ESCAPE = 1
```

### Types

```freebasic
type TKPOPUPMENU_COLORS
    BackColor         as ulong
    ForeColor         as ulong
    BackColorHot      as ulong
    ForeColorHot      as ulong
    ForeColorDisabled as ulong
    BorderColor       as ulong
    SeparatorColor    as ulong = &hFF808080ul
end type

type TKPOPUPMENU_PAINTINFO
    hPopup      as TK_MENU ptr
    itemID      as long             ' the row index
    id          as long             ' the row's command id (0 for separators)
    b           as TK_PAINT ptr
    rc          as TKRECT           ' the full row -- fill this
    rcCheck     as TKRECT
    rcText      as TKRECT           ' caption LEFT, accelerator RIGHT, same rect
    rcChevron   as TKRECT
    isSeparator as boolean
    isDisabled  as boolean
    isChecked   as boolean
    hasSubMenu  as boolean
    isHot       as boolean
    wszCaption  as ustring
    wszAccel    as ustring
end type

type TKPM_ITEM
    id          as long
    wszCaption  as ustring
    wszAccel    as ustring
    isSeparator as boolean
    isDisabled  as boolean
    isChecked   as boolean
    pSub        as TK_MENU ptr        ' OWNED
    rc          as TKRECT
end type

type TK_MENU_   ' per-instance state; reach it through the procedures

type TK_MENU as TK_MENU_
type PM_SelectCallbackSub as sub( byval hPopup as TK_MENU ptr, byval id as long )
type PM_InitPopupCallbackSub as sub( byval hPopup as TK_MENU ptr )
type PM_PaintItemCallbackSub as sub( byval p as TKPOPUPMENU_PAINTINFO ptr )
type PM_ClosedCallbackSub as sub( byval hPopup as TK_MENU ptr, byval nReason as long )
type PM_KeyHookFunc as function( byval hRoot as TK_MENU ptr, byval hInner as TK_MENU ptr, byval key as long ) as boolean
```

### Procedures

```freebasic
function tkPopupMenu_ThemeColors( byref t as TKTHEME_COLORS ) as TKPOPUPMENU_COLORS
sub tkPopupMenu_ApplyTheme( byval hPopup as TK_MENU ptr, byref t as TKTHEME_COLORS )
sub tkPopupMenu_Rescale( byval hPopup as TK_MENU ptr, byval fOld as single, byval fNew as single )
function tkPopupMenu_Create( byval hOwner as TK_HOST ptr, byval CtrlID as long = 0 ) as TK_MENU ptr
sub tkPopupMenu_Destroy( byval hPopup as TK_MENU ptr )
function tkPopupMenu_AddItem( byval hPopup as TK_MENU ptr, byval id as long, byval Caption as ustring, byval Accel as ustring = "", byval bDisabled as boolean = false, byval bChecked as boolean = false ) as long
function tkPopupMenu_AddSeparator( byval hPopup as TK_MENU ptr ) as long
function tkPopupMenu_GetItemCount( byval hPopup as TK_MENU ptr ) as long
function tkPopupMenu_SetItemText( byval hPopup as TK_MENU ptr, byval id as long, byval Caption as ustring, byval Accel as ustring = "" ) as boolean
function tkPopupMenu_SetItemEnabled( byval hPopup as TK_MENU ptr, byval id as long, byval bEnabled as boolean ) as boolean
function tkPopupMenu_GetItemEnabled( byval hPopup as TK_MENU ptr, byval id as long ) as boolean
function tkPopupMenu_SetItemChecked( byval hPopup as TK_MENU ptr, byval id as long, byval bChecked as boolean ) as boolean
function tkPopupMenu_GetItemChecked( byval hPopup as TK_MENU ptr, byval id as long ) as boolean
function tkPopupMenu_DeleteItem( byval hPopup as TK_MENU ptr, byval id as long ) as boolean
sub tkPopupMenu_Clear( byval hPopup as TK_MENU ptr )
function tkPopupMenu_SetItemSubMenu( byval hPopup as TK_MENU ptr, byval id as long, byval hSubMenu as TK_MENU ptr ) as boolean
function tkPopupMenu_GetItemSubMenu( byval hPopup as TK_MENU ptr, byval id as long ) as TK_MENU ptr
function tkPopupMenu_Show( byval hPopup as TK_MENU ptr, byval x as long, byval y as long ) as boolean
function tkPopupMenu_ShowForRect( byval hPopup as TK_MENU ptr, byref rcAnchor as TKRECT, byval nAlign as long ) as boolean
sub tkPopupMenu_Hide( byval hPopup as TK_MENU ptr )
sub tkPopupMenu_CloseChain( byval hPopup as TK_MENU ptr )
function tkPopupMenu_IsOpen( byval hPopup as TK_MENU ptr ) as boolean
function tkPopupMenu_GetOpenRoot() as TK_MENU ptr
function tkPopupMenu_GetCurSel( byval hPopup as TK_MENU ptr ) as long
function tkPopupMenu_SetCurSel( byval hPopup as TK_MENU ptr, byval idx as long ) as boolean
function tkPopupMenu_SelectFirst( byval hPopup as TK_MENU ptr ) as boolean
function tkPopupMenu_OpenSubMenu( byval hPopup as TK_MENU ptr, byval idx as long, byval bSelectFirst as boolean ) as boolean
function tkPopupMenu_GetItemRect( byval hPopup as TK_MENU ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkPopupMenu_HitTest( byval hPopup as TK_MENU ptr, byval x as long, byval y as long ) as long
function tkPopupMenu_GetIdealSize( byval hPopup as TK_MENU ptr, byref nWidth as long, byref nHeight as long ) as boolean
function tkPopupMenu_SetMinWidth( byval hPopup as TK_MENU ptr, byval nMinWidth as long ) as boolean
sub tkPopupMenu_SetItemHeight( byval hPopup as TK_MENU ptr, byval nItemHeight as long )
sub tkPopupMenu_SetSeparatorHeight( byval hPopup as TK_MENU ptr, byval nSeparatorHeight as long )
sub tkPopupMenu_SetSeparatorThickness( byval hPopup as TK_MENU ptr, byval nThickness as long )
sub tkPopupMenu_SetColors( byval hPopup as TK_MENU ptr, byval pColors as TKPOPUPMENU_COLORS ptr )
sub tkPopupMenu_GetColors( byval hPopup as TK_MENU ptr, byval pColors as TKPOPUPMENU_COLORS ptr )
sub tkPopupMenu_UnpinColors( byval hPopup as TK_MENU ptr )
sub tkPopupMenu_SetFonts( byval hPopup as TK_MENU ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr = 0 )
sub tkPopupMenu_ApplyFonts( byval hPopup as TK_MENU ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkPopupMenu_SetGlyphs( byval hPopup as TK_MENU ptr, byval wszCheck as ustring, byval wszChevron as ustring )
sub tkPopupMenu_SetSelectCallback( byval hPopup as TK_MENU ptr, byval usersub as PM_SelectCallbackSub )
sub tkPopupMenu_SetInitPopupCallback( byval hPopup as TK_MENU ptr, byval usersub as PM_InitPopupCallbackSub )
sub tkPopupMenu_SetPaintItemCallback( byval hPopup as TK_MENU ptr, byval usersub as PM_PaintItemCallbackSub )
sub tkPopupMenu_SetClosedCallback( byval hPopup as TK_MENU ptr, byval usersub as PM_ClosedCallbackSub )
sub tkPopupMenu_SetKeyHook( byval hPopup as TK_MENU ptr, byval userfunc as PM_KeyHookFunc )
function tkPopupMenu_Surface( byval hPopup as TK_MENU ptr ) as TK_HOST ptr
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsPopupMenu](PsPopupMenu), the PsControls control
