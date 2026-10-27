[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkButton**

# tkButton

Draws a momentary command button with an optional glyph or image on either side.

`tkButton` is the [tkControls](Category-tkControls) command button: a rounded rectangle with an
optional left icon, an optional caption and an optional right icon. It fires on release and never
latches, so its only states are transient (hot, pressed, focused) or yours (enabled, default). It
takes focus, so Tab reaches it and Space or Enter operates it.

Either icon slot holds a glyph from a font (the bundled icon font's `TK_ICON_*` codepoints, or any
font's) or an image file loaded through SDL_image. Setters are silent; the click callback runs
only for a real click or for `tkButton_Click`.

## Importing

```freebasic
#import "vendor/tkControls/tkButton"

using tkButton
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` for a paint
callback and `using tkTooltip` to configure the shared tooltip.

## Example

A complete program: one window, one button with a glyph, a click callback.

```freebasic
#import "vendor/tkControls/tkButton"
using tkButton
using tkHost

sub Save_Click( byval hButton as TK_WIDGET ptr, byval id as long )
    print "clicked " & tkButton_GetText( hButton ) & " (id " & id & ")"
end sub

SDL_Init( SDL_INIT_VIDEO )
TTF_Init()
dim as TK_HOST ptr host = tkHost_Create( "tkButton", 400, 200, tkHost_FontDir() & TK_FONT_UI )
dim as TTF_Font ptr fGlyph = tkHost_OpenFont( host, tkHost_FontDir() & TK_FONT_ICONS, 10 )

dim as TK_WIDGET ptr btn = tkButton_Create( tkHost_Root( host ), 1000 )
tkButton_SetGlyphFont( btn, fGlyph )
tkButton_SetText( btn, "Save" )
tkButton_SetGlyphLeft( btn, wchr( TK_ICON_SAVE ) )
tkButton_SetDefault( btn, true )
tkButton_SetClickCallback( btn, @Save_Click )

dim as long w, h
tkButton_GetIdealSize( btn, w, h )
tkWidget_SetPos( btn, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), w, h )
tkHost_Show( host )
tkHost_Run( host )
tkHost_Destroy( host )
TTF_Quit()
SDL_Quit()
```

With no font set, the caption uses the host's default font. Fonts opened with `tkHost_OpenFont`
belong to the host and are rescaled with it; the button only borrows them.

## Coming from PsButton

[PsButton](PsButton) is the Win32 twin; its page remains the behaviour reference for everything
not listed here.

- Names: `PsButton_*` → `tkButton_*`, `PSBUTTON_*` → `TKBUTTON_*`. `BTN_ALIGN_*`, `BTN_MOOD_*`,
  `BTN_PART_*` and the `BTN_*Callback*` types keep their names. The handle is `TK_WIDGET ptr`.
- `tkButton_Create( hParent, ctrlId )` takes a `TK_WIDGET ptr` parent; for a top-level control
  pass `tkHost_Root( host )`. Position it with `tkWidget_SetPos`.
- Fonts are `TTF_Font ptr` (`tkButton_SetFont`, `tkButton_SetGlyphFont`, `tkButton_ApplyFonts`).
  Glyphs come from the bundled Fluent UI System Icons font, named by `TK_ICON_*`, not Segoe
  Fluent Icons codepoints.
- `tkButton_SetImageLeft` / `SetImageRight` load through SDL_image (`.png`, `.bmp`, `.jpg`,
  `.gif`, `.ico` and more) and return 0 on failure.
- Colours start from the current [tkTheme](tkTheme) palette.
- `TKBUTTON_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y` and `key` instead of
  `uMsg` / `wParam` / `lParam`.
- The tooltip is a [tkTooltip](tkTooltip); `tkButton_GetTooltipHandle` returns it as a
  `TK_TIP ptr`. There is no tooltip mode and no comctl32 tooltip.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call.
- No equivalent: window text (`WM_SETTEXT` / `WM_GETTEXT`), item data, PsRegistry, the
  self-test, and the getters for font, glyph, alignment, curvature and auto-size, plus the
  setters for border thickness, icon gap, icon size and focus ring.
- Added: `tkButton_GetHot`, `tkButton_GetPressed` and `tkButton_GetTextWidth`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKBUTTON_DEFAULT_PADLEFT = 12
const as long TKBUTTON_DEFAULT_PADRIGHT = 12
const as long TKBUTTON_DEFAULT_PADTOP = 6
const as long TKBUTTON_DEFAULT_PADBOTTOM = 6
const as long TKBUTTON_DEFAULT_ICONGAP = 8
const as long TKBUTTON_DEFAULT_ICONWIDTH = 16
const as long TKBUTTON_DEFAULT_ICONHEIGHT = 16
const as long TKBUTTON_DEFAULT_CURVATURE = 12
const as long TKBUTTON_DEFAULT_BORDERTHICK = 1
const as long TKBUTTON_DEFAULT_FOCUSGAP = 2
const as long TKBUTTON_DEFAULT_FOCUSTHICK = 1

enum
    BTN_ALIGN_LEFT = 0
    BTN_ALIGN_CENTER
    BTN_ALIGN_RIGHT
end enum

enum
    BTN_MOOD_IDLE = 0
    BTN_MOOD_HOT
    BTN_MOOD_PRESSED
    BTN_MOOD_DISABLED
end enum

enum
    BTN_PART_BUTTON = 0
    BTN_PART_TEXT
    BTN_PART_ICONLEFT
    BTN_PART_ICONRIGHT
end enum
```

### Types

```freebasic
type TKBUTTON_COLORS
    BackColor           as ulong = &hFF2C313Aul    ' ( 44, 49, 58)
    ForeColor           as ulong = &hFFC8CDD6ul    ' (200,205,214)
    BorderColor         as ulong = &hFF2C313Aul
    IconColor           as ulong = &hFFC8CDD6ul
    BackColorHot        as ulong = &hFF373D48ul    ' ( 55, 61, 72)
    ForeColorHot        as ulong = &hFFE2E6EEul    ' (226,230,238)
    BorderColorHot      as ulong = &hFF373D48ul
    IconColorHot        as ulong = &hFFE2E6EEul
    BackColorPressed    as ulong = &hFF264F78ul    ' ( 38, 79,120)
    ForeColorPressed    as ulong = &hFFFFFFFFul
    BorderColorPressed  as ulong = &hFF264F78ul
    IconColorPressed    as ulong = &hFFFFFFFFul
    BackColorDisabled   as ulong = &hFF282C33ul    ' ( 40, 44, 51)
    ForeColorDisabled   as ulong = &hFF606670ul    ' ( 96,102,112)
    BorderColorDisabled as ulong = &hFF282C33ul
    IconColorDisabled   as ulong = &hFF606670ul
    FocusRingColor      as ulong = &hFF61AFEFul    ' ( 97,175,239)
    DefaultBorderColor  as ulong = &hFF61AFEFul
end type

type TKBUTTON_PAINTINFO
    hButton       as TK_WIDGET ptr
    b             as TK_PAINT ptr
    rcClient      as TKRECT
    rcButton      as TKRECT
    rcIconLeft    as TKRECT
    rcText        as TKRECT            ' the caption SPAN between the icon blocks, not the ink
    rcIconRight   as TKRECT
    rcVisual      as TKRECT
    isHot         as boolean
    isPressed     as boolean
    isEnabled     as boolean
    isFocused     as boolean
    isDefault     as boolean
    wszText       as ustring
    wszGlyphLeft  as ustring
    wszGlyphRight as ustring
    pImageLeft    as SDL_Texture ptr
    pImageRight   as SDL_Texture ptr
    nTextAlign    as long
end type

type TKBUTTON_MESSAGEINFO
    hButton as TK_WIDGET ptr
    msg     as long                    ' TKM_*
    x       as single
    y       as single
    key     as long
end type

type TKBUTTON_STATE   ' per-instance state; reach it through the procedures

type BTN_PaintCallbackSub as sub( byval p as TKBUTTON_PAINTINFO ptr )
type BTN_MessageCallbackFunc as function( byval m as TKBUTTON_MESSAGEINFO ptr ) as boolean
type BTN_TooltipCallbackFunc as function( byval hButton as TK_WIDGET ptr ) as ustring
type BTN_ClickCallbackSub as sub( byval hButton as TK_WIDGET ptr, byval id as long )
```

### Procedures

```freebasic
function tkButton_ResolveMood( byval isEnabled as boolean, byval isPressed as boolean, byval isHot as boolean ) as long
sub tkButton_ResolveColors( byval pColors as TKBUTTON_COLORS ptr, byval nMood as long, byval isDefault as boolean, byref clrBack as ulong, byref clrFore as ulong, byref clrBorder as ulong, byref clrIcon as ulong )
function tkButton_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long ) as TK_WIDGET ptr
function tkButton_GetText( byval hButton as TK_WIDGET ptr ) as ustring
sub tkButton_SetText( byval hButton as TK_WIDGET ptr, byval Text as ustring )
sub tkButton_SetGlyphLeft( byval hButton as TK_WIDGET ptr, byval Glyph as ustring )
sub tkButton_SetGlyphRight( byval hButton as TK_WIDGET ptr, byval Glyph as ustring )
function tkButton_SetImageLeft( byval hButton as TK_WIDGET ptr, byval Path as ustring ) as long
function tkButton_SetImageRight( byval hButton as TK_WIDGET ptr, byval Path as ustring ) as long
function tkButton_GetID( byval hButton as TK_WIDGET ptr ) as long
sub tkButton_SetID( byval hButton as TK_WIDGET ptr, byval id as long )
function tkButton_GetEnabled( byval hButton as TK_WIDGET ptr ) as boolean
sub tkButton_SetEnabled( byval hButton as TK_WIDGET ptr, byval isEnabled as boolean )
function tkButton_GetFocused( byval hButton as TK_WIDGET ptr ) as boolean
function tkButton_GetHot( byval hButton as TK_WIDGET ptr ) as boolean
function tkButton_GetPressed( byval hButton as TK_WIDGET ptr ) as boolean
function tkButton_GetDefault( byval hButton as TK_WIDGET ptr ) as boolean
sub tkButton_SetDefault( byval hButton as TK_WIDGET ptr, byval isDefault as boolean )
sub tkButton_Click( byval hButton as TK_WIDGET ptr )
sub tkButton_SetTextAlign( byval hButton as TK_WIDGET ptr, byval nTextAlign as long )
sub tkButton_SetPadding( byval hButton as TK_WIDGET ptr, byval l as long, byval t as long, byval r as long, byval b as long )
sub tkButton_GetPadding( byval hButton as TK_WIDGET ptr, byref l as long, byref t as long, byref r as long, byref b as long )
function tkButton_GetIconGap( byval hButton as TK_WIDGET ptr ) as long
sub tkButton_GetIconSize( byval hButton as TK_WIDGET ptr, byref iw as long, byref ih as long )
sub tkButton_GetFocusRing( byval hButton as TK_WIDGET ptr, byref nGap as long, byref nThick as long )
sub tkButton_SetCornerCurvature( byval hButton as TK_WIDGET ptr, byval nCurvature as long )
sub tkButton_SetAutoSize( byval hButton as TK_WIDGET ptr, byval bAutoSize as boolean )
sub tkButton_GetIdealSize( byval hButton as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
sub tkButton_GetTextWidth( byval hButton as TK_WIDGET ptr, byref tw as long, byref th as long )
function tkButton_GetButtonRect( byval hButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkButton_GetTextRect( byval hButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkButton_GetIconLeftRect( byval hButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkButton_GetIconRightRect( byval hButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkButton_GetVisualRect( byval hButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkButton_GetColors( byval hButton as TK_WIDGET ptr, byval pColors as TKBUTTON_COLORS ptr )
sub tkButton_SetColors( byval hButton as TK_WIDGET ptr, byval pColors as TKBUTTON_COLORS ptr )
function tkButton_ThemeColors( byref t as TKTHEME_COLORS ) as TKBUTTON_COLORS
sub tkButton_ApplyTheme( byval hButton as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkButton_UnpinColors( byval hButton as TK_WIDGET ptr )
sub tkButton_ApplyFonts( byval hButton as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkButton_SetFont( byval hButton as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkButton_SetGlyphFont( byval hButton as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkButton_SetTooltipText( byval hButton as TK_WIDGET ptr, byval Text as ustring )
function tkButton_GetTooltipText( byval hButton as TK_WIDGET ptr ) as ustring
function tkButton_GetTooltipHandle( byval hButton as TK_WIDGET ptr ) as TK_TIP ptr
sub tkButton_SetHoverTime( byval hButton as TK_WIDGET ptr, byval ms as long )
sub tkButton_SetAutoPopTime( byval hButton as TK_WIDGET ptr, byval ms as long )
sub tkButton_SetReshowTime( byval hButton as TK_WIDGET ptr, byval ms as long )
sub tkButton_SetPaintCallback( byval hButton as TK_WIDGET ptr, byval usersub as BTN_PaintCallbackSub )
sub tkButton_SetMessageCallback( byval hButton as TK_WIDGET ptr, byval userfunc as BTN_MessageCallbackFunc )
sub tkButton_SetTooltipCallback( byval hButton as TK_WIDGET ptr, byval userfunc as BTN_TooltipCallbackFunc )
sub tkButton_SetClickCallback( byval hButton as TK_WIDGET ptr, byval usersub as BTN_ClickCallbackSub )
function tkButton_CountRenderedTones( byval hButton as TK_WIDGET ptr, byval nPart as long ) as long
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsButton](PsButton), the PsControls control
