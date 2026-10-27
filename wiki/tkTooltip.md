[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkTooltip**

# tkTooltip

Shows an owner-drawn tooltip for a widget after the mouse rests on it.

tkTooltip is a themed hover tip: an optional icon glyph and title over a word-wrapped
message, as a plain rounded rectangle (`TIP_STYLE_RECT`) or a balloon with a stem pointing at its
anchor (`TIP_STYLE_BALLOON`). Attach one to any widget and it waits for the mouse to rest there,
shows after the initial delay, fades in, hides after the auto-pop delay or when the mouse leaves
or a button is pressed. Only one tip is on screen at a time.

Every tkControls control that has tooltips already owns a tip, created with the control. Set its
text with the control's own setter (`tkButton_SetTooltipText`, for example) and reach the tip for
anything else (title, glyph, style, colours) with the control's `..._GetTooltipHandle`. Create a
tip yourself with `tkTooltip_Create` only for a widget of your own.

The handle is a `TK_TIP ptr`, not a widget. The tip opens its own small transparent window each
time it shows and closes it when it hides. It detaches itself when its widget is destroyed, and
follows the theme until `tkTooltip_SetColors` pins its colours.

## Importing

```freebasic
#import "vendor/tkControls/tkTooltip"

using tkTooltip
using tkHost
```

The module imports `tkHost` and `tkTheme` publicly. Every control with tooltips imports
`tkTooltip` itself, so a program that only sets tooltip text through a control needs no import.

## Example

A tip on a widget of your own, with a title and an icon, its text worked out when it shows:

```freebasic
function Canvas_TipText( byval hTooltip as TK_TIP ptr, byval hAttached as TK_WIDGET ptr, byval idx as long ) as ustring
    return "Zoom " & gZoom & "%"           ' called each time the tip is about to show
end function

dim as TTF_Font ptr fText  = tkHost_OpenFont( gHost, tkHost_FontDir() & TK_FONT_UI, 9 )
dim as TTF_Font ptr fTitle = tkHost_OpenFont( gHost, tkHost_FontDir() & TK_FONT_UI_BOLD, 9 )
dim as TTF_Font ptr fGlyph = tkHost_OpenFont( gHost, tkHost_FontDir() & TK_FONT_ICONS, 12 )

dim as TK_TIP ptr tip = tkTooltip_Create( hCanvas )     ' created AND attached
tkTooltip_SetFonts( tip, fText, fTitle, fGlyph )
tkTooltip_SetTitle( tip, "Canvas" )
tkTooltip_SetGlyph( tip, wchr( TK_ICON_INFO ) )
tkTooltip_SetStyle( tip, TIP_STYLE_BALLOON )
tkTooltip_SetTooltipCallback( tip, @Canvas_TipText )
' ...
tkTooltip_Destroy( tip )                  ' you own a tip you created
```

To give every tip the same look, set the process defaults before creating the controls:
`tkTooltip_SetDefaultFonts`, `tkTooltip_SetDefaultStyle`, `tkTooltip_SetDefaultColors`,
`tkTooltip_SetDefaultMaxWidth` and `tkTooltip_SetDefaultDelays` apply to each tip created
afterwards. `tkTooltip_ApplyDefaults` applies them to a tip that already exists.

## tkTipHost

The same module holds **tkTipHost**, the helper each control uses to own its tip:
`TKTIPHOST_STATE` and the `tkTipHost_*` procedures. There is no separate module to import;
`tkTipHost_*` comes with `using tkTooltip`. You need it only when writing a control of your own:
keep a `TKTIPHOST_STATE` in the control's state, call `tkTipHost_Ensure( @st, hCtrl, @TipText )`
at create and `tkTipHost_Destroy( @st )` when the control is destroyed. Delays set with
`tkTipHost_SetDelay( @st, TK_TIPDELAY_INITIAL, ms )` before the tip exists are kept and applied
when it does. `tkTipHost_TrackShow` / `tkTipHost_TrackHide` show text at once against a
rectangle, skipping the hover delay, for a tip that the control drives itself.

## Coming from PsTooltip and PsTipHost

[PsTooltip](PsTooltip) remains the behaviour reference for everything not listed here.

- Names: `PsTooltip_*` → `tkTooltip_*`, `PSTOOLTIP_*` → `TKTOOLTIP_*`, `PsTipHost_*` →
  `tkTipHost_*`, `PSTIPHOST_STATE` → `TKTIPHOST_STATE`. `TIP_STYLE_*`, `TIP_ALIGN_*` and
  `TIP_PART_*` keep their names; the `TTDT_*` delay selectors are `TK_TIPDELAY_*`.
- The handle is `TK_TIP ptr`; fonts are `TTF_Font ptr` (`tkTooltip_SetFonts( tip, fText [,
  fTitle [, fGlyph]] )`); colours are `ulong`.
- `tkTooltip_ShowForRect` takes a rectangle in the attached widget's coordinates, not screen
  coordinates.
- There is one backend, owner-drawn. `PsTipHost`'s `PSTIP_MODE_*` constants, the controls'
  `SetTooltipMode` / `GetTooltipMode` and the system tooltip handle have no equivalent.
- The delays default to 500, 5000 and 100 ms (initial, auto-pop, reshow).
- The tip window is not click-through. It is placed clear of the cursor, and moving onto it
  leaves the control and hides it.
- On Wayland the fade is skipped and the tip appears at once, and the compositor keeps it on
  screen.
- Gone: the message callback and `GetSystemFont`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKTOOLTIP_DEFAULT_PADX = 10
const TKTOOLTIP_DEFAULT_PADY = 7
const TKTOOLTIP_DEFAULT_CURVATURE = 6 ' corner ellipse DIAMETER
const TKTOOLTIP_DEFAULT_STEMW = 14
const TKTOOLTIP_DEFAULT_STEMH = 7
const TKTOOLTIP_DEFAULT_GLYPHCELL = 20
const TKTOOLTIP_DEFAULT_GLYPHGAP = 8
const TKTOOLTIP_DEFAULT_TITLEGAP = 4
const TKTOOLTIP_DEFAULT_MOVETOL = 3
const TKTOOLTIP_DEFAULT_FADEMS = 120
const TKTOOLTIP_CLOCK_IDLE_MS = 100
const TKTOOLTIP_CLOCK_FADE_MS = 15

enum
    TIP_STYLE_RECT    = 0
    TIP_STYLE_BALLOON = 1
end enum

enum
    TIP_ALIGN_CURSOR = 0         ' below-right of the cursor, cleared by the cursor's height
    TIP_ALIGN_BELOW  = 1         ' below the anchor, flipping above when there is no room
    TIP_ALIGN_ABOVE  = 2         ' above the anchor, flipping below when there is no room
end enum

enum
    TIP_PART_CLIENT = 0
    TIP_PART_BODY   = 1
    TIP_PART_GLYPH  = 2
    TIP_PART_TITLE  = 3
    TIP_PART_TEXT   = 4
    TIP_PART_STEM   = 5
end enum

enum
    TK_TIPDELAY_INITIAL = 0
    TK_TIPDELAY_AUTOPOP
    TK_TIPDELAY_RESHOW
end enum
```

### Types

```freebasic
type TKTOOLTIP_COLORS
    BackColor    as ulong = &hFF2D323Aul    ' ( 45, 50, 58)
    BorderColor  as ulong = &hFF4E545Eul    ' ( 78, 84, 94)
    ForeColor    as ulong = &hFFD4D9E2ul    ' (212,217,226)
    TitleColor   as ulong = &hFFFFFFFFul
    GlyphColor   as ulong = &hFF569CD6ul    ' ( 86,156,214)
end type

type TKTOOLTIP_PAINTINFO
    hTooltip     as TK_TIP ptr
    hAttached    as TK_WIDGET ptr
    b            as TK_PAINT ptr
    rcClient     as TKRECT              ' the whole window, INCLUDING the stem band
    rcBody       as TKRECT              ' the rounded frame (rcClient minus the stem band)
    rcGlyph      as TKRECT
    rcTitle      as TKRECT
    rcText       as TKRECT
    ptStem(0 to 2) as TKPOINT
    bHasStem     as boolean
    bStemOnTop   as boolean
    wszText      as ustring             ' the RESOLVED message
    wszTitle     as ustring
    wszGlyph     as ustring
    nStyle       as long
    nCurvature   as long
    nBorderWidth as long
    nToolIndex   as long
    nTextFlags   as long                ' the TK_DT_* flags the message was MEASURED with
end type

type TK_TIP_   ' per-instance state; reach it through the procedures

type TKTIPHOST_STATE   ' per-instance state; reach it through the procedures

type TK_TIP as TK_TIP_
type TIP_PaintCallbackSub as sub( byval p as TKTOOLTIP_PAINTINFO ptr )
type TIP_TooltipCallbackFunc as function( byval hTooltip as TK_TIP ptr, byval hAttached as TK_WIDGET ptr, byval idx as long ) as ustring
type TIP_ShowCallbackFunc as function( byval hTooltip as TK_TIP ptr, byval hAttached as TK_WIDGET ptr, byval idx as long, byval bShowing as boolean ) as boolean
```

### Procedures

```freebasic
function tkTooltip_ComputeOrigin( byref rcAnchor as TKRECT, byval tipW as long, byval tipH as long, byref rcWork as TKRECT, byval nAlign as long, byval nCursorOffset as long ) as TKPOINT
function tkTooltip_StemOnTop( byref rcAnchor as TKRECT, byref ptOrigin as TKPOINT, byval nAlign as long ) as boolean
function tkTooltip_ComputeStem( byval cxClient as long, byval cyClient as long, byval bStemOnTop as boolean, byval nStemW as long, byval nStemH as long, byval nTargetX as long, byval nCurvature as long, byval pts as TKPOINT ptr ) as boolean
function tkTooltip_ComputeAlpha( byval nElapsed as long, byval nFadeMs as long, byval bFadingIn as boolean ) as long
function tkTooltip_ShouldShow( byval bOver as boolean, byval bResting as boolean, byval bHasText as boolean, byval bButtonDown as boolean, byval bSuppressed as boolean ) as boolean
function tkTooltip_Create( byval hAttach as TK_WIDGET ptr ) as TK_TIP ptr
sub tkTooltip_Destroy( byval hTooltip as TK_TIP ptr )
sub tkTooltip_Attach( byval hTooltip as TK_TIP ptr, byval hAttach as TK_WIDGET ptr )
sub tkTooltip_Detach( byval hTooltip as TK_TIP ptr )
function tkTooltip_GetAttached( byval hTooltip as TK_TIP ptr ) as TK_WIDGET ptr
sub tkTooltip_SetText( byval hTooltip as TK_TIP ptr, byval wszText as ustring )
function tkTooltip_GetText( byval hTooltip as TK_TIP ptr ) as ustring
sub tkTooltip_SetTitle( byval hTooltip as TK_TIP ptr, byval wszTitle as ustring )
function tkTooltip_GetTitle( byval hTooltip as TK_TIP ptr ) as ustring
sub tkTooltip_SetGlyph( byval hTooltip as TK_TIP ptr, byval wszGlyph as ustring )
function tkTooltip_GetGlyph( byval hTooltip as TK_TIP ptr ) as ustring
sub tkTooltip_SetToolIndex( byval hTooltip as TK_TIP ptr, byval idx as long )
function tkTooltip_GetToolIndex( byval hTooltip as TK_TIP ptr ) as long
sub tkTooltip_SetColors( byval hTooltip as TK_TIP ptr, byval pColors as TKTOOLTIP_COLORS ptr )
sub tkTooltip_GetColors( byval hTooltip as TK_TIP ptr, byval pColors as TKTOOLTIP_COLORS ptr )
function tkTooltip_ThemeColors( byref t as TKTHEME_COLORS ) as TKTOOLTIP_COLORS
sub tkTooltip_ApplyTheme( byval hTooltip as TK_TIP ptr, byref t as TKTHEME_COLORS )
sub tkTooltip_UnpinColors( byval hTooltip as TK_TIP ptr )
sub tkTooltip_SetFonts( byval hTooltip as TK_TIP ptr, byval fText as TTF_Font ptr, byval fTitle as TTF_Font ptr = 0, byval fGlyph as TTF_Font ptr = 0 )
sub tkTooltip_ApplyFonts( byval hTooltip as TK_TIP ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkTooltip_Rescale( byval hTooltip as TK_TIP ptr, byval fOld as single, byval fNew as single )
sub tkTooltip_SetStyle( byval hTooltip as TK_TIP ptr, byval nStyle as long )
function tkTooltip_GetStyle( byval hTooltip as TK_TIP ptr ) as long
sub tkTooltip_SetMaxWidth( byval hTooltip as TK_TIP ptr, byval nMaxWidth as long )
function tkTooltip_GetMaxWidth( byval hTooltip as TK_TIP ptr ) as long
sub tkTooltip_SetPadding( byval hTooltip as TK_TIP ptr, byval nX as long, byval nY as long )
sub tkTooltip_SetCurvature( byval hTooltip as TK_TIP ptr, byval nCurvature as long )
sub tkTooltip_SetBorderWidth( byval hTooltip as TK_TIP ptr, byval nBorderWidth as long )
sub tkTooltip_SetStemSize( byval hTooltip as TK_TIP ptr, byval nW as long, byval nH as long )
sub tkTooltip_SetGlyphCell( byval hTooltip as TK_TIP ptr, byval nCell as long, byval nGap as long )
sub tkTooltip_SetInitialDelay( byval hTooltip as TK_TIP ptr, byval nMs as long )
sub tkTooltip_SetAutoPopDelay( byval hTooltip as TK_TIP ptr, byval nMs as long )
sub tkTooltip_SetReshowDelay( byval hTooltip as TK_TIP ptr, byval nMs as long )
sub tkTooltip_SetFadeTime( byval hTooltip as TK_TIP ptr, byval nMs as long )
sub tkTooltip_SetMoveTolerance( byval hTooltip as TK_TIP ptr, byval nPixels as long )
sub tkTooltip_SetDefaultColors( byval pColors as TKTOOLTIP_COLORS ptr )
sub tkTooltip_SetDefaultFonts( byval fText as TTF_Font ptr, byval fTitle as TTF_Font ptr = 0, byval fGlyph as TTF_Font ptr = 0 )
sub tkTooltip_SetDefaultStyle( byval nStyle as long )
sub tkTooltip_SetDefaultMaxWidth( byval nMaxWidth as long )
sub tkTooltip_SetDefaultDelays( byval nInitialMs as long, byval nAutoPopMs as long = -1, byval nReshowMs as long = -1 )
sub tkTooltip_ClearDefaults()
sub tkTooltip_ApplyDefaults( byval hTooltip as TK_TIP ptr )
function tkTooltip_Show( byval hTooltip as TK_TIP ptr ) as boolean
function tkTooltip_ShowForRect( byval hTooltip as TK_TIP ptr, byref rcAnchor as TKRECT, byval nAlign as long = TIP_ALIGN_BELOW ) as boolean
sub tkTooltip_Hide( byval hTooltip as TK_TIP ptr )
function tkTooltip_IsVisible( byval hTooltip as TK_TIP ptr ) as boolean
function tkTooltip_Surface( byval hTooltip as TK_TIP ptr ) as TK_HOST ptr
sub tkTooltip_SetPaintCallback( byval hTooltip as TK_TIP ptr, byval userfunc as TIP_PaintCallbackSub )
sub tkTooltip_SetTooltipCallback( byval hTooltip as TK_TIP ptr, byval userfunc as TIP_TooltipCallbackFunc )
sub tkTooltip_SetShowCallback( byval hTooltip as TK_TIP ptr, byval userfunc as TIP_ShowCallbackFunc )
sub tkTooltip_GetIdealSize( byval hTooltip as TK_TIP ptr, byref nW as long, byref nH as long )
function tkTooltip_GetPartRect( byval hTooltip as TK_TIP ptr, byval nPart as long ) as TKRECT
sub tkTooltip_TickForTest( byval hTooltip as TK_TIP ptr, byval cx as long, byval cy as long, byval bOver as boolean, byval bButtonDown as boolean, byval tNow as longint )
function tkTooltip_CountRenderedTones( byval hTooltip as TK_TIP ptr, byval nPart as long ) as long
function tkTooltip_HashRenderedPart( byval hTooltip as TK_TIP ptr, byval nPart as long ) as ulong
function tkTipHost_Ensure( byval pHost as TKTIPHOST_STATE ptr, byval hCtrl as TK_WIDGET ptr, byval TipCallback as TIP_TooltipCallbackFunc = 0 ) as boolean
sub tkTipHost_Destroy( byval pHost as TKTIPHOST_STATE ptr )
function tkTipHost_Tip( byval pHost as TKTIPHOST_STATE ptr ) as TK_TIP ptr
sub tkTipHost_SetToolIndex( byval pHost as TKTIPHOST_STATE ptr, byval idx as long )
sub tkTipHost_Pop( byval pHost as TKTIPHOST_STATE ptr )
sub tkTipHost_SetTracked( byval pHost as TKTIPHOST_STATE ptr, byval bTracked as boolean )
function tkTipHost_IsTracked( byval pHost as TKTIPHOST_STATE ptr ) as boolean
sub tkTipHost_TrackShow( byval pHost as TKTIPHOST_STATE ptr, byref rcAnchor as TKRECT, byval wszText as ustring )
sub tkTipHost_TrackHide( byval pHost as TKTIPHOST_STATE ptr )
sub tkTipHost_SetDelay( byval pHost as TKTIPHOST_STATE ptr, byval nWhich as long, byval nMs as long )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsTooltip](PsTooltip), the PsControls control
