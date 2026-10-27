[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkToggle**

# tkToggle

Draws an on/off switch: a rounded track and a knob that marks the state.

`tkToggle` is the [tkControls](Category-tkControls) switch for a single setting that takes
effect at once. It is a track and a knob and nothing else: no caption, no font, no tooltip and no
animation, so put a label beside it. A click, Space or Enter flips it; a held key does not
re-flip it. The arrow keys are not claimed.

`tkToggle_SetChecked` is silent; the check-changed callback runs only when the user flips the
switch. The switch sits left, centred or right inside its client area (`TOG_JUSTIFY_*`), and a
client too short for the track clips it rather than squeezing it.

## Importing

```freebasic
#import "vendor/tkControls/tkToggle"

using tkToggle
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image) and [tkTheme](tkTheme). Add `using tkPaint` for a paint callback.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Wifi_Changed( byval hToggle as TK_WIDGET ptr, byval isChecked as boolean )
    print "Wi-Fi " & iif( isChecked, "on", "off" )
end sub

dim as TK_WIDGET ptr tog = tkToggle_Create( tkHost_Root( host ), 3000 )
tkToggle_SetChecked( tog, true )                   ' silent: no callback
tkToggle_SetCheckChangedCallback( tog, @Wifi_Changed )

dim as long w, h
tkToggle_GetIdealSize( tog, w, h )
tkWidget_SetPos( tog, tkHost_Scale( host, 20 ), tkHost_Scale( host, 100 ), w, h )
```

## Coming from PsToggle

[PsToggle](PsToggle) is the Win32 twin; its page remains the behaviour reference for everything
not listed here.

- Names: `PsToggle_*` → `tkToggle_*`, `PSTOGGLE_*` → `TKTOGGLE_*`. `TOG_JUSTIFY_*` and the
  `TOG_*Callback*` types keep their names. The handle is `TK_WIDGET ptr`.
- `tkToggle_Create( hParent, ctrlId )` takes a `TK_WIDGET ptr` parent; for a top-level control
  pass `tkHost_Root( host )`.
- `tkToggle_SetEnabled` disables the widget itself: input stops, Tab skips it, and hot, press
  and focus are dropped at once. Hiding the widget also clears hot and the press.
- Colours start from the current [tkTheme](tkTheme) palette; `tkToggle_UnpinColors` goes back
  to it.
- `TKTOGGLE_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y` and `key` instead of
  `uMsg` / `wParam` / `lParam`. A key the control does not claim is reported, but the callback's
  result for it is ignored.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call. Border and
  focus-ring thicknesses are not scaled.
- No equivalent: `PsToggle_RenderDefault`, PsRegistry.
- Added: `tkToggle_GetHot`, `tkToggle_GetPressed` and `tkToggle_GetID`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKTOGGLE_DEFAULT_TRACKW = 40
const as long TKTOGGLE_DEFAULT_TRACKH = 20
const as long TKTOGGLE_DEFAULT_KNOBINSET = 2
const as long TKTOGGLE_DEFAULT_BORDERTHICK = 1
const as long TKTOGGLE_DEFAULT_FOCUSGAP = 3
const as long TKTOGGLE_DEFAULT_FOCUSTHICK = 1

enum
    TOG_JUSTIFY_LEFT = 0
    TOG_JUSTIFY_CENTER
    TOG_JUSTIFY_RIGHT
end enum
```

### Types

```freebasic
type TKTOGGLE_COLORS
    BackColor                   as ulong = &hFF21252Bul    ' ( 33, 37, 43) the control's own background
    FocusRingColor              as ulong = &hFF569CD6ul    ' ( 86,156,214)
    TrackColorOn                as ulong = &hFF4A6C8Cul    ' ( 74,108,140)
    TrackColorOnHot             as ulong = &hFF5C84AAul    ' ( 92,132,170)
    TrackColorOnDisabled        as ulong = &hFF384654ul    ' ( 56, 70, 84)
    TrackBorderColorOn          as ulong = &hFF4A6C8Cul    ' = TrackColorOn
    TrackBorderColorOnHot       as ulong = &hFF5C84AAul    ' = TrackColorOnHot
    TrackBorderColorOnDisabled  as ulong = &hFF384654ul    ' = TrackColorOnDisabled
    KnobColorOn                 as ulong = &hFFD8DCE2ul    ' (216,220,226)
    KnobColorOnHot              as ulong = &hFFFFFFFFul
    KnobColorOnDisabled         as ulong = &hFF787E86ul    ' (120,126,134)
    TrackColorOff               as ulong = &hFF33373Ful    ' ( 51, 55, 63)
    TrackColorOffHot            as ulong = &hFF3E434Dul    ' ( 62, 67, 77)
    TrackColorOffDisabled       as ulong = &hFF2C3037ul    ' ( 44, 48, 55)
    TrackBorderColorOff         as ulong = &hFF6B7280ul    ' (107,114,128)
    TrackBorderColorOffHot      as ulong = &hFF8A92A1ul    ' (138,146,161)
    TrackBorderColorOffDisabled as ulong = &hFF484D56ul    ' ( 72, 77, 86)
    KnobColorOff                as ulong = &hFF8A9099ul    ' (138,144,153)
    KnobColorOffHot             as ulong = &hFFB0B6BFul    ' (176,182,191)
    KnobColorOffDisabled        as ulong = &hFF545961ul    ' ( 84, 89, 97)
end type

type TKTOGGLE_PAINTINFO
    hToggle    as TK_WIDGET ptr
    b          as TK_PAINT ptr          ' the control's paint for this frame (borrowed)
    rcClient   as TKRECT
    rcTrack    as TKRECT
    rcKnob     as TKRECT                ' already at the end the current state calls for
    rcVisual   as TKRECT                ' rcTrack inflated by the focus-ring band
    isChecked  as boolean
    isHot      as boolean
    isPressed  as boolean               ' a live left press AND the cursor still inside
    isEnabled  as boolean
    isFocused  as boolean
end type

type TKTOGGLE_MESSAGEINFO
    hToggle as TK_WIDGET ptr
    msg     as long                     ' TKM_*
    x       as single
    y       as single
    key     as long
end type

type TKTOGGLE_STATE   ' per-instance state; reach it through the procedures

type TOG_PaintCallbackSub as sub( byval p as TKTOGGLE_PAINTINFO ptr )
type TOG_MessageCallbackFunc as function( byval m as TKTOGGLE_MESSAGEINFO ptr ) as boolean
type TOG_CheckChangedCallbackSub as sub( byval hToggle as TK_WIDGET ptr, byval isChecked as boolean )
```

### Procedures

```freebasic
function tkToggle_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long ) as TK_WIDGET ptr
function tkToggle_GetChecked( byval hToggle as TK_WIDGET ptr ) as boolean
sub tkToggle_SetChecked( byval hToggle as TK_WIDGET ptr, byval isChecked as boolean )
function tkToggle_GetEnabled( byval hToggle as TK_WIDGET ptr ) as boolean
sub tkToggle_SetEnabled( byval hToggle as TK_WIDGET ptr, byval isEnabled as boolean )
function tkToggle_GetFocused( byval hToggle as TK_WIDGET ptr ) as boolean
sub tkToggle_Refresh( byval hToggle as TK_WIDGET ptr )
function tkToggle_GetHot( byval hToggle as TK_WIDGET ptr ) as boolean
function tkToggle_GetPressed( byval hToggle as TK_WIDGET ptr ) as boolean
function tkToggle_GetID( byval hToggle as TK_WIDGET ptr ) as long
sub tkToggle_GetTrackSize( byval hToggle as TK_WIDGET ptr, byref nTrackWidth as long, byref nTrackHeight as long )
sub tkToggle_SetTrackSize( byval hToggle as TK_WIDGET ptr, byval nTrackWidth as long, byval nTrackHeight as long )
function tkToggle_GetKnobInset( byval hToggle as TK_WIDGET ptr ) as long
sub tkToggle_SetKnobInset( byval hToggle as TK_WIDGET ptr, byval nKnobInset as long )
function tkToggle_GetBorderThickness( byval hToggle as TK_WIDGET ptr ) as long
sub tkToggle_SetBorderThickness( byval hToggle as TK_WIDGET ptr, byval nThickness as long )
sub tkToggle_GetFocusRing( byval hToggle as TK_WIDGET ptr, byref nGap as long, byref nThickness as long )
sub tkToggle_SetFocusRing( byval hToggle as TK_WIDGET ptr, byval nGap as long, byval nThickness as long )
function tkToggle_GetJustify( byval hToggle as TK_WIDGET ptr ) as long
sub tkToggle_SetJustify( byval hToggle as TK_WIDGET ptr, byval nJustify as long )
sub tkToggle_GetIdealSize( byval hToggle as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkToggle_GetTrackRect( byval hToggle as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkToggle_GetKnobRect( byval hToggle as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkToggle_GetVisualRect( byval hToggle as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkToggle_GetColors( byval hToggle as TK_WIDGET ptr, byval pColors as TKTOGGLE_COLORS ptr )
sub tkToggle_SetColors( byval hToggle as TK_WIDGET ptr, byval pColors as TKTOGGLE_COLORS ptr )
function tkToggle_ThemeColors( byref t as TKTHEME_COLORS ) as TKTOGGLE_COLORS
sub tkToggle_ApplyTheme( byval hToggle as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkToggle_UnpinColors( byval hToggle as TK_WIDGET ptr )
sub tkToggle_SetPaintCallback( byval hToggle as TK_WIDGET ptr, byval usersub as TOG_PaintCallbackSub )
sub tkToggle_SetMessageCallback( byval hToggle as TK_WIDGET ptr, byval userfunc as TOG_MessageCallbackFunc )
sub tkToggle_SetCheckChangedCallback( byval hToggle as TK_WIDGET ptr, byval usersub as TOG_CheckChangedCallbackSub )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsToggle](PsToggle), the PsControls control
