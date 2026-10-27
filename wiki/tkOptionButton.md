[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkOptionButton**

# tkOptionButton

Draws a radio button whose group allows at most one checked choice.

`tkOptionButton` is the [tkControls](Category-tkControls) radio button: a circle, an optional
single-line caption, and a dot in the circle when checked. Buttons belong to a group, named by
their parent widget and a group id, and checking one unchecks the others. Mutual exclusion is
handled inside the control: both state changes land before any callback runs, and the button
that lost is told first.

A group has one Tab stop. Inside it, the arrow keys move focus and the check (Up/Left to the
previous member, Down/Right to the next, wrapping and skipping disabled or hidden members), and
Space checks the focused button. Enter is left to the window. Arrow order is creation order.

## Importing

```freebasic
#import "vendor/tkControls/tkOptionButton"

using tkOptionButton
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` for a paint
callback.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
const as long GRP_QUALITY = 1

sub Quality_Changed( byval hOpt as TK_WIDGET ptr, byval isChecked as boolean )
    if isChecked then print "quality: " & tkOptionButton_GetText( hOpt )
end sub

dim as string captions(0 to 2) = { "Low", "Medium", "High" }
dim as TK_WIDGET ptr opt(0 to 2)
for i as long = 0 to 2
    opt(i) = tkOptionButton_Create( tkHost_Root( host ), 2000 + i, GRP_QUALITY )
    tkOptionButton_SetText( opt(i), captions(i) )
    tkOptionButton_SetCheckChangedCallback( opt(i), @Quality_Changed )
    dim as long w, h
    tkOptionButton_GetIdealSize( opt(i), w, h )
    tkWidget_SetPos( opt(i), tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 + i * 28 ), w, h )
next
tkOptionButton_SetChecked( opt(1), true )        ' silent: no callback

' later: which one is checked? (-1 when none)
print tkOptionButton_FindCheckedID( tkHost_Root( host ), GRP_QUALITY )
```

## Coming from PsOptionButton

[PsOptionButton](PsOptionButton) is the Win32 twin; its page remains the behaviour reference for
everything not listed here.

- Names: `PsOptionButton_*` → `tkOptionButton_*`, `PSOPTIONBUTTON_*` → `TKOPTIONBUTTON_*`.
  `OPT_BOXALIGN_*`, `OPT_TEXTALIGN_*`, `OPT_MOOD_*`, `OPT_PART_*` and the `OPT_*Callback*` types
  keep their names. The handle is `TK_WIDGET ptr`.
- `tkOptionButton_Create( hParent, ctrlId, nGroupID = 0 )` takes a `TK_WIDGET ptr` parent; for
  top-level buttons pass `tkHost_Root( host )`. The group is (parent, group id) as before.
- The group's Tab stop is the one focusable member. While focus is inside the group, the focused
  member holds the stop, so Tab always leaves the group. A disabled checked member hands the stop
  to an enabled one. `tkOptionButton_GetTabStop` says which member holds it.
- Ring and focus-ring thicknesses are drawn as given, not scaled.
- Out-of-range `SetBoxAlign` / `SetTextAlign` values are ignored; negative padding and box gap
  clamp to 0.
- Fonts are `TTF_Font ptr`, borrowed. There is no glyph font: `tkOptionButton_ApplyFonts`
  ignores its glyph argument.
- Colours start from the current [tkTheme](tkTheme) palette.
- `TKOPTIONBUTTON_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y` and `key` instead of
  `uMsg` / `wParam` / `lParam`.
- The tooltip is a [tkTooltip](tkTooltip); `tkOptionButton_GetTooltipHandle` returns it. There
  is no tooltip mode and no comctl32 tooltip.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call.
- No equivalent: window text (`WM_SETTEXT` / `WM_GETTEXT`), PsRegistry, the self-test.
- Added: `tkOptionButton_GetTabStop`, `GetHot`, `GetPressed` and `GetTextSize`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const as long TKOPTIONBUTTON_DEFAULT_PADLEFT = 4
const as long TKOPTIONBUTTON_DEFAULT_PADTOP = 2
const as long TKOPTIONBUTTON_DEFAULT_PADRIGHT = 4
const as long TKOPTIONBUTTON_DEFAULT_PADBOTTOM = 2
const as long TKOPTIONBUTTON_DEFAULT_BOXGAP = 8
const as long TKOPTIONBUTTON_DEFAULT_BOXWIDTH = 16
const as long TKOPTIONBUTTON_DEFAULT_BOXHEIGHT = 16
const as long TKOPTIONBUTTON_DEFAULT_RINGTHICK = 1 ' never scaled
const as long TKOPTIONBUTTON_DEFAULT_FOCUSTHICK = 1 ' never scaled
const as long TKOPTIONBUTTON_DEFAULT_DOTSIZE = 0 ' 0 = derive from the circle
const as long TKOPTIONBUTTON_DOTRATIO_PCT = 40
const as long TKOPTIONBUTTON_DEFAULT_FOCUSGAP = 2
const as long TKOPTIONBUTTON_DEFAULT_FOCUSCURV = 4 ' ellipse DIAMETER
const as long TKOPTIONBUTTON_DEFAULT_GROUPID = 0

enum
    OPT_BOXALIGN_LEFT = 0
    OPT_BOXALIGN_RIGHT
end enum

enum
    OPT_TEXTALIGN_LEFT = 0
    OPT_TEXTALIGN_CENTER
    OPT_TEXTALIGN_RIGHT
end enum

enum
    OPT_MOOD_IDLE = 0
    OPT_MOOD_HOT
    OPT_MOOD_PRESSED
    OPT_MOOD_DISABLED
end enum

enum
    OPT_PART_CONTROL = 0
    OPT_PART_BOX
    OPT_PART_TEXT
end enum
```

### Types

```freebasic
type TKOPTIONBUTTON_COLORS
    BackColor                as ulong = &hFF21252Bul    ' ( 33, 37, 43)
    BackColorHot             as ulong = &hFF21252Bul    ' = BackColor: flat out of the box
    BackColorPressed         as ulong = &hFF21252Bul
    BackColorDisabled        as ulong = &hFF21252Bul
    ForeColor                as ulong = &hFFC8CDD6ul    ' (200,205,214)
    ForeColorHot             as ulong = &hFFE2E6EEul    ' (226,230,238)
    ForeColorPressed         as ulong = &hFFFFFFFFul
    ForeColorDisabled        as ulong = &hFF606670ul    ' ( 96,102,112)
    RingColor                as ulong = &hFF8A9099ul    ' (138,144,153) the UNCHECKED outline
    RingColorHot             as ulong = &hFFB0B6BFul    ' (176,182,191)
    RingColorPressed         as ulong = &hFFC8CDD6ul    ' (200,205,214)
    RingColorDisabled        as ulong = &hFF545961ul    ' ( 84, 89, 97)
    RingColorChecked         as ulong = &hFF569CD6ul    ' ( 86,156,214) the CHECKED fill
    RingColorCheckedHot      as ulong = &hFF7AB4E6ul    ' (122,180,230)
    RingColorCheckedPressed  as ulong = &hFF96C8F0ul    ' (150,200,240)
    RingColorCheckedDisabled as ulong = &hFF384654ul    ' ( 56, 70, 84)
    DotColor                 as ulong = &hFFFFFFFFul    ' on the accent fill, not on the back
    DotColorHot              as ulong = &hFFFFFFFFul
    DotColorPressed          as ulong = &hFFFFFFFFul
    DotColorDisabled         as ulong = &hFF21252Bul    ' = BackColor: a hollow disabled ring
    FocusRingColor           as ulong = &hFF569CD6ul    ' ( 86,156,214)
end type

type TKOPTIONBUTTON_PAINTINFO
    hOptionButton as TK_WIDGET ptr
    b             as TK_PAINT ptr
    rcClient      as TKRECT
    rcContent     as TKRECT        ' rcClient deflated by the focus-ring band
    rcBox         as TKRECT        ' the declared box CELL
    rcCircle      as TKRECT        ' the largest centred square in rcBox: what is drawn round
    rcDot         as TKRECT        ' centred in rcCircle; computed checked or not
    rcText        as TKRECT        ' the caption SPAN, not the ink; empty with no caption
    rcVisual      as TKRECT        ' rcContent inflated by the band: where the ring goes
    isChecked     as boolean
    isHot         as boolean
    isPressed     as boolean       ' a live press AND the cursor still inside
    isEnabled     as boolean
    isFocused     as boolean
    wszText       as ustring
    nRingThick    as long          ' pen width in pixels (never scaled)
    nBoxAlign     as long
    nTextAlign    as long
end type

type TKOPTIONBUTTON_MESSAGEINFO
    hOptionButton as TK_WIDGET ptr
    msg           as long          ' TKM_*
    x             as single
    y             as single
    key           as long
end type

type TKOPTIONBUTTON_STATE   ' per-instance state; reach it through the procedures

type OPT_PaintCallbackSub as sub( byval p as TKOPTIONBUTTON_PAINTINFO ptr )
type OPT_MessageCallbackFunc as function( byval m as TKOPTIONBUTTON_MESSAGEINFO ptr ) as boolean
type OPT_TooltipCallbackFunc as function( byval hOptionButton as TK_WIDGET ptr ) as ustring
type OPT_CheckChangedCallbackSub as sub( byval hOptionButton as TK_WIDGET ptr, byval isChecked as boolean )
```

### Procedures

```freebasic
function tkOptionButton_ResolveMood( byval isEnabled as boolean, byval isPressed as boolean, byval isHot as boolean ) as long
sub tkOptionButton_ResolveColors( byval pColors as TKOPTIONBUTTON_COLORS ptr, byval nMood as long, byval isChecked as boolean, byref clrBack as ulong, byref clrFore as ulong, byref clrRing as ulong, byref clrDot as ulong )
function tkOptionButton_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long, byval nGroupID as long = TKOPTIONBUTTON_DEFAULT_GROUPID ) as TK_WIDGET ptr
function tkOptionButton_GetGroupID( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetGroupID( byval hOptionButton as TK_WIDGET ptr, byval nGroupID as long )
function tkOptionButton_GetGroupCount( byval hOptionButton as TK_WIDGET ptr ) as long
function tkOptionButton_GetGroupMember( byval hOptionButton as TK_WIDGET ptr, byval idx as long ) as TK_WIDGET ptr
function tkOptionButton_GetGroupChecked( byval hOptionButton as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkOptionButton_FindChecked( byval hParent as TK_WIDGET ptr, byval nGroupID as long ) as TK_WIDGET ptr
function tkOptionButton_FindCheckedID( byval hParent as TK_WIDGET ptr, byval nGroupID as long ) as long
sub tkOptionButton_ClearGroup( byval hOptionButton as TK_WIDGET ptr )
function tkOptionButton_GetTabStop( byval hOptionButton as TK_WIDGET ptr ) as boolean
function tkOptionButton_GetText( byval hOptionButton as TK_WIDGET ptr ) as ustring
sub tkOptionButton_SetText( byval hOptionButton as TK_WIDGET ptr, byval Text as ustring )
function tkOptionButton_GetID( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetID( byval hOptionButton as TK_WIDGET ptr, byval id as long )
function tkOptionButton_GetItemData( byval hOptionButton as TK_WIDGET ptr ) as integer
sub tkOptionButton_SetItemData( byval hOptionButton as TK_WIDGET ptr, byval itemData as integer )
function tkOptionButton_GetChecked( byval hOptionButton as TK_WIDGET ptr ) as boolean
sub tkOptionButton_SetChecked( byval hOptionButton as TK_WIDGET ptr, byval isChecked as boolean )
function tkOptionButton_GetEnabled( byval hOptionButton as TK_WIDGET ptr ) as boolean
sub tkOptionButton_SetEnabled( byval hOptionButton as TK_WIDGET ptr, byval isEnabled as boolean )
function tkOptionButton_GetFocused( byval hOptionButton as TK_WIDGET ptr ) as boolean
function tkOptionButton_GetHot( byval hOptionButton as TK_WIDGET ptr ) as boolean
function tkOptionButton_GetPressed( byval hOptionButton as TK_WIDGET ptr ) as boolean
sub tkOptionButton_Refresh( byval hOptionButton as TK_WIDGET ptr )
sub tkOptionButton_Click( byval hOptionButton as TK_WIDGET ptr )
function tkOptionButton_GetBoxAlign( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetBoxAlign( byval hOptionButton as TK_WIDGET ptr, byval nBoxAlign as long )
function tkOptionButton_GetTextAlign( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetTextAlign( byval hOptionButton as TK_WIDGET ptr, byval nTextAlign as long )
sub tkOptionButton_GetPadding( byval hOptionButton as TK_WIDGET ptr, byref nLeft as long, byref nTop as long, byref nRight as long, byref nBottom as long )
sub tkOptionButton_SetPadding( byval hOptionButton as TK_WIDGET ptr, byval nLeft as long, byval nTop as long, byval nRight as long, byval nBottom as long )
function tkOptionButton_GetBoxGap( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetBoxGap( byval hOptionButton as TK_WIDGET ptr, byval nBoxGap as long )
sub tkOptionButton_GetBoxSize( byval hOptionButton as TK_WIDGET ptr, byref nBoxWidth as long, byref nBoxHeight as long )
sub tkOptionButton_SetBoxSize( byval hOptionButton as TK_WIDGET ptr, byval nBoxWidth as long, byval nBoxHeight as long )
function tkOptionButton_GetRingThickness( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetRingThickness( byval hOptionButton as TK_WIDGET ptr, byval nThickness as long )
function tkOptionButton_GetDotSize( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetDotSize( byval hOptionButton as TK_WIDGET ptr, byval nDotSize as long )
sub tkOptionButton_GetFocusRing( byval hOptionButton as TK_WIDGET ptr, byref nGap as long, byref nThickness as long )
sub tkOptionButton_SetFocusRing( byval hOptionButton as TK_WIDGET ptr, byval nGap as long, byval nThickness as long )
function tkOptionButton_GetFocusCurvature( byval hOptionButton as TK_WIDGET ptr ) as long
sub tkOptionButton_SetFocusCurvature( byval hOptionButton as TK_WIDGET ptr, byval nCurvature as long )
function tkOptionButton_GetAutoSize( byval hOptionButton as TK_WIDGET ptr ) as boolean
sub tkOptionButton_SetAutoSize( byval hOptionButton as TK_WIDGET ptr, byval bAutoSize as boolean )
sub tkOptionButton_GetIdealSize( byval hOptionButton as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
sub tkOptionButton_GetTextSize( byval hOptionButton as TK_WIDGET ptr, byref tw as long, byref nTextH as long )
function tkOptionButton_GetContentRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkOptionButton_GetBoxRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkOptionButton_GetCircleRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkOptionButton_GetDotRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkOptionButton_GetTextRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkOptionButton_GetVisualRect( byval hOptionButton as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
sub tkOptionButton_GetColors( byval hOptionButton as TK_WIDGET ptr, byval pColors as TKOPTIONBUTTON_COLORS ptr )
sub tkOptionButton_SetColors( byval hOptionButton as TK_WIDGET ptr, byval pColors as TKOPTIONBUTTON_COLORS ptr )
function tkOptionButton_ThemeColors( byref t as TKTHEME_COLORS ) as TKOPTIONBUTTON_COLORS
sub tkOptionButton_ApplyTheme( byval hOptionButton as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkOptionButton_UnpinColors( byval hOptionButton as TK_WIDGET ptr )
function tkOptionButton_GetFont( byval hOptionButton as TK_WIDGET ptr ) as TTF_Font ptr
sub tkOptionButton_SetFont( byval hOptionButton as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkOptionButton_ApplyFonts( byval hOptionButton as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkOptionButton_SetTooltipText( byval hOptionButton as TK_WIDGET ptr, byval Text as ustring )
function tkOptionButton_GetTooltipText( byval hOptionButton as TK_WIDGET ptr ) as ustring
function tkOptionButton_GetTooltipHandle( byval hOptionButton as TK_WIDGET ptr ) as TK_TIP ptr
sub tkOptionButton_SetHoverTime( byval hOptionButton as TK_WIDGET ptr, byval ms as long )
sub tkOptionButton_SetAutoPopTime( byval hOptionButton as TK_WIDGET ptr, byval ms as long )
sub tkOptionButton_SetReshowTime( byval hOptionButton as TK_WIDGET ptr, byval ms as long )
sub tkOptionButton_SetPaintCallback( byval hOptionButton as TK_WIDGET ptr, byval usersub as OPT_PaintCallbackSub )
sub tkOptionButton_SetMessageCallback( byval hOptionButton as TK_WIDGET ptr, byval userfunc as OPT_MessageCallbackFunc )
sub tkOptionButton_SetTooltipCallback( byval hOptionButton as TK_WIDGET ptr, byval userfunc as OPT_TooltipCallbackFunc )
sub tkOptionButton_SetCheckChangedCallback( byval hOptionButton as TK_WIDGET ptr, byval usersub as OPT_CheckChangedCallbackSub )
function tkOptionButton_CountRenderedTones( byval hOptionButton as TK_WIDGET ptr, byval nPart as long ) as long
function tkOptionButton_HashRenderedPart( byval hOptionButton as TK_WIDGET ptr, byval nPart as long ) as ulong
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsOptionButton](PsOptionButton), the PsControls control
