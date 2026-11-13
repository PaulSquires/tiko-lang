[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkNumericUpDown**

# tkNumericUpDown

Draws a numeric spinner: a typed value between minus and plus buttons, kept in range.

`tkNumericUpDown` is the [tkControls](Category-tkControls) number entry: a rounded frame with a
"−" button, an editable value cell and a "+" button. The value lives on a decimal grid
(`SetDecimalPlaces`) and is clamped to its range; it never wraps. A button steps on the press and
repeats while held (`SetAutoRepeat`); the arrow keys, Page Up/Page Down (the large increment) and
the mouse wheel step too, and a button at its limit draws as disabled.

The value-changed callback runs at once for buttons, keys and the wheel, and on commit (Enter or
focus loss) for typed text. Every setter is silent. Read-only blocks typing but not stepping.

`tkNumericUpDown_SetTooltipText` gives the control a tooltip, shown while the pointer rests on any
part of it, the value field included; `SetHoverTime`, `SetAutoPopTime` and `SetReshowTime` set its
delays, and `GetTooltipHandle` reaches the tkTooltip itself. The border follows the theme's
`BorderWidth` until `SetBorderThickness` is called. A paint callback replaces the drawing; call
`tkNumericUpDown_PaintDefault( p )` in it to draw the stock control first and add to it.

## Importing

```freebasic
#import "vendor/tkControls/tkNumericUpDown"

using tkNumericUpDown
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme) and [tkTextBox](tkTextBox), whose single-line numeric box is the
value cell. Add `using tkPaint` for a paint callback.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
sub Zoom_Changed( byval hCtrl as TK_WIDGET ptr, byval nValue as double )
    print "zoom " & nValue & "x"
end sub

dim as TK_WIDGET ptr zoom = tkNumericUpDown_Create( tkHost_Root( host ), 5000 )
tkNumericUpDown_SetDecimalPlaces( zoom, 2 )
tkNumericUpDown_SetRange( zoom, 0.5, 3 )
tkNumericUpDown_SetIncrement( zoom, 0.25 )
tkNumericUpDown_SetLargeIncrement( zoom, 1 )
tkNumericUpDown_SetValue( zoom, 1.5 )               ' silent: no callback
tkNumericUpDown_SetValueChangedCallback( zoom, @Zoom_Changed )

dim as long w, h
tkNumericUpDown_GetIdealSize( zoom, w, h )         ' measured from both ends of the range
tkWidget_SetPos( zoom, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), w, h )
```

## Coming from PsNumericUpDown

[PsNumericUpDown](PsNumericUpDown) is the Win32 twin; its page remains the behaviour reference
for everything not listed here.

- Names: `PsNumericUpDown_*` → `tkNumericUpDown_*`, `PSNUMERICUPDOWN_*` → `TKNUMERICUPDOWN_*`,
  `CNUD_DEFAULT_*` → `TKNUD_DEFAULT_*`. `NUD_PART_*` and the `NUD_*Callback*` types keep their
  names. The handle is `TK_WIDGET ptr`.
- `tkNumericUpDown_Create( hParent, CtrlID )` takes a `TK_WIDGET ptr` parent; for a top-level
  control pass `tkHost_Root( host )`.
- The value cell is a [tkTextBox](tkTextBox) child widget; `tkNumericUpDown_GetTextBoxHandle`
  returns it. Its focus, Enter and message callbacks belong to the spinner, so leave them alone.
- Disabling the spinner (`tkNumericUpDown_SetEnabled` or `tkWidget_Enable`) disables the field
  with it.
- `tkNumericUpDown_HitTest( h, x, y )` takes widget pixels rather than a `POINT`.
- `TKNUMERICUPDOWN_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y`, `key`, `mods` and
  `wheelY`. Messages relayed from the field arrive with `hCtrl` set to the spinner.
- Fonts are `TTF_Font ptr` (`tkNumericUpDown_SetFont`); there is no glyph font, the "−" and "+"
  are drawn as bars.
- Colours start from the current [tkTheme](tkTheme) palette.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call.
- No equivalent: `FilterMessage`, PsRegistry.
- Added: `tkNumericUpDown_GetID`, `GetHotPart`, `GetPressedPart` and `IsRepeating`, for custom
  painters.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKNUD_DEFAULT_BUTTONW = 28
const TKNUD_DEFAULT_VALUEPAD = 6 ' left and right, inside the value cell
const TKNUD_DEFAULT_VERTPAD = 5 ' above and below the text
const TKNUD_DEFAULT_CORNERRADIUS = 6
const TKNUD_DEFAULT_BORDERTHICK = 1 ' not scaled
const TKNUD_DEFAULT_DIVIDERTHICK = 1 ' not scaled
const TKNUD_DEFAULT_GLYPHLENGTH = 10
const TKNUD_DEFAULT_GLYPHTHICK = 1 ' SCALED: an icon stroke, not a rule
const TKNUD_DEFAULT_REPEATDELAY = 400
const TKNUD_DEFAULT_REPEATINTERVAL = 60
const TKNUD_DEFAULT_MIN = -1000000.0
const TKNUD_DEFAULT_MAX = 1000000.0
const TKNUD_DEFAULT_INCREMENT = 1.0
const TKNUD_DEFAULT_DECIMALPLACES = 0

enum
    NUD_PART_NONE = 0
    NUD_PART_MINUS
    NUD_PART_VALUE       ' reported by HitTest, never acted on
    NUD_PART_PLUS
end enum
```

### Types

```freebasic
type TKNUMERICUPDOWN_COLORS
    BackColor                as ulong = &hFF21252Bul    ' behind the rounded corners
    BorderColor              as ulong = &hFF3C424Dul
    FocusBorderColor         as ulong = &hFF569CD6ul
    BorderColorDisabled      as ulong = &hFF30343Cul
    DividerColor             as ulong = &hFF3C424Dul
    DividerColorDisabled     as ulong = &hFF30343Cul
    ValueBackColor           as ulong = &hFF2C313Aul    ' handed to the tkTextBox
    ValueForeColor           as ulong = &hFFD7DAE0ul
    ValueBackColorDisabled   as ulong = &hFF262A31ul
    ValueForeColorDisabled   as ulong = &hFF5A606Aul
    ButtonBackColor          as ulong = &hFF2C313Aul    ' = ValueBackColor: one flat cell at rest
    ButtonBackColorHot       as ulong = &hFF383E49ul
    ButtonBackColorPressed   as ulong = &hFF264F78ul
    ButtonBackColorDisabled  as ulong = &hFF262A31ul
    GlyphColor               as ulong = &hFFBEC4CEul
    GlyphColorHot            as ulong = &hFFFFFFFFul
    GlyphColorPressed        as ulong = &hFFFFFFFFul
    GlyphColorDisabled       as ulong = &hFF5A606Aul
end type

type TKNUMERICUPDOWN_PAINTINFO
    hCtrl        as TK_WIDGET ptr
    b            as TK_PAINT ptr
    rcClient     as TKRECT
    rcFrame      as TKRECT
    rcMinus      as TKRECT
    rcDiv1       as TKRECT
    rcValue      as TKRECT
    rcDiv2       as TKRECT
    rcPlus       as TKRECT
    rcMinusBar   as TKRECT
    rcPlusBarH   as TKRECT
    rcPlusBarV   as TKRECT
    hotPart      as long
    pressedPart  as long
    isEnabled    as boolean
    isFocused    as boolean
    bAtMin       as boolean
    bAtMax       as boolean
    nValue       as double
end type

type TKNUMERICUPDOWN_MESSAGEINFO
    hCtrl as TK_WIDGET ptr            ' this control, ALWAYS -- also for the field's relayed messages
    msg   as long                     ' TKM_*
    x     as single
    y     as single
    key   as long
    mods  as long
    wheelY as single                  ' TKM_MOUSEWHEEL: notches, positive = away
end type

type TKNUMERICUPDOWN_STATE   ' per-instance state; reach it through the procedures

type NUD_PaintCallbackSub as sub( byval p as TKNUMERICUPDOWN_PAINTINFO ptr )
type NUD_MessageCallbackFunc as function( byval m as TKNUMERICUPDOWN_MESSAGEINFO ptr ) as boolean
type NUD_ValueChangedCallbackSub as sub( byval hCtrl as TK_WIDGET ptr, byval nValue as double )
```

### Procedures

```freebasic
function tkNumericUpDown_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long ) as TK_WIDGET ptr
function tkNumericUpDown_GetTextBoxHandle( byval hCtrl as TK_WIDGET ptr ) as TK_WIDGET ptr
function tkNumericUpDown_HasFocus( byval hCtrl as TK_WIDGET ptr ) as boolean
function tkNumericUpDown_GetID( byval hCtrl as TK_WIDGET ptr ) as long
function tkNumericUpDown_GetEnabled( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkNumericUpDown_SetEnabled( byval hCtrl as TK_WIDGET ptr, byval isEnabled as boolean )
sub tkNumericUpDown_Refresh( byval hCtrl as TK_WIDGET ptr )
function tkNumericUpDown_GetValue( byval hCtrl as TK_WIDGET ptr ) as double
sub tkNumericUpDown_SetValue( byval hCtrl as TK_WIDGET ptr, byval nValue as double )
sub tkNumericUpDown_GetRange( byval hCtrl as TK_WIDGET ptr, byref nMin as double, byref nMax as double )
sub tkNumericUpDown_SetRange( byval hCtrl as TK_WIDGET ptr, byval nMin as double, byval nMax as double )
function tkNumericUpDown_GetIncrement( byval hCtrl as TK_WIDGET ptr ) as double
sub tkNumericUpDown_SetIncrement( byval hCtrl as TK_WIDGET ptr, byval nIncrement as double )
function tkNumericUpDown_GetLargeIncrement( byval hCtrl as TK_WIDGET ptr ) as double
sub tkNumericUpDown_SetLargeIncrement( byval hCtrl as TK_WIDGET ptr, byval nIncrement as double )
function tkNumericUpDown_GetDecimalPlaces( byval hCtrl as TK_WIDGET ptr ) as long
sub tkNumericUpDown_SetDecimalPlaces( byval hCtrl as TK_WIDGET ptr, byval nPlaces as long )
sub tkNumericUpDown_StepUp( byval hCtrl as TK_WIDGET ptr )
sub tkNumericUpDown_StepDown( byval hCtrl as TK_WIDGET ptr )
sub tkNumericUpDown_GetAutoRepeat( byval hCtrl as TK_WIDGET ptr, byref nDelayMs as long, byref nIntervalMs as long )
sub tkNumericUpDown_SetAutoRepeat( byval hCtrl as TK_WIDGET ptr, byval nDelayMs as long, byval nIntervalMs as long )
function tkNumericUpDown_GetReadOnly( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkNumericUpDown_SetReadOnly( byval hCtrl as TK_WIDGET ptr, byval bReadOnly as boolean )
function tkNumericUpDown_GetFont( byval hCtrl as TK_WIDGET ptr ) as TTF_Font ptr
sub tkNumericUpDown_SetFont( byval hCtrl as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkNumericUpDown_GetButtonWidth( byval hCtrl as TK_WIDGET ptr ) as long
sub tkNumericUpDown_SetButtonWidth( byval hCtrl as TK_WIDGET ptr, byval nWidth as long )
sub tkNumericUpDown_GetValuePadding( byval hCtrl as TK_WIDGET ptr, byref nLeft as long, byref nRight as long, byref nVert as long )
sub tkNumericUpDown_SetValuePadding( byval hCtrl as TK_WIDGET ptr, byval nLeft as long, byval nRight as long, byval nVert as long )
function tkNumericUpDown_GetCornerRadius( byval hCtrl as TK_WIDGET ptr ) as long
sub tkNumericUpDown_SetCornerRadius( byval hCtrl as TK_WIDGET ptr, byval nRadius as long )
function tkNumericUpDown_GetBorderThickness( byval hCtrl as TK_WIDGET ptr ) as long
sub tkNumericUpDown_SetBorderThickness( byval hCtrl as TK_WIDGET ptr, byval nThickness as long )
function tkNumericUpDown_GetDividerThickness( byval hCtrl as TK_WIDGET ptr ) as long
sub tkNumericUpDown_SetDividerThickness( byval hCtrl as TK_WIDGET ptr, byval nThickness as long )
sub tkNumericUpDown_GetGlyphSize( byval hCtrl as TK_WIDGET ptr, byref nLength as long, byref nThickness as long )
sub tkNumericUpDown_SetGlyphSize( byval hCtrl as TK_WIDGET ptr, byval nLength as long, byval nThickness as long )
sub tkNumericUpDown_GetIdealSize( byval hCtrl as TK_WIDGET ptr, byref nWidth as long, byref nHeight as long )
function tkNumericUpDown_GetFrameRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkNumericUpDown_GetMinusRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkNumericUpDown_GetValueRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkNumericUpDown_GetPlusRect( byval hCtrl as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkNumericUpDown_HitTest( byval hCtrl as TK_WIDGET ptr, byval x as long, byval y as long ) as long
function tkNumericUpDown_GetHotPart( byval hCtrl as TK_WIDGET ptr ) as long
function tkNumericUpDown_GetPressedPart( byval hCtrl as TK_WIDGET ptr ) as long
function tkNumericUpDown_IsRepeating( byval hCtrl as TK_WIDGET ptr ) as boolean
sub tkNumericUpDown_GetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKNUMERICUPDOWN_COLORS ptr )
sub tkNumericUpDown_SetColors( byval hCtrl as TK_WIDGET ptr, byval pColors as TKNUMERICUPDOWN_COLORS ptr )
function tkNumericUpDown_ThemeColors( byref t as TKTHEME_COLORS ) as TKNUMERICUPDOWN_COLORS
sub tkNumericUpDown_ApplyTheme( byval hCtrl as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkNumericUpDown_UnpinColors( byval hCtrl as TK_WIDGET ptr )
sub tkNumericUpDown_ApplyFonts( byval hCtrl as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkNumericUpDown_SetPaintCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as NUD_PaintCallbackSub )
sub tkNumericUpDown_SetMessageCallback( byval hCtrl as TK_WIDGET ptr, byval userfunc as NUD_MessageCallbackFunc )
sub tkNumericUpDown_SetValueChangedCallback( byval hCtrl as TK_WIDGET ptr, byval usersub as NUD_ValueChangedCallbackSub )
sub tkNumericUpDown_PaintDefault( byval pi as TKNUMERICUPDOWN_PAINTINFO ptr )
sub tkNumericUpDown_SetTooltipText( byval hCtrl as TK_WIDGET ptr, byval Text as ustring )
function tkNumericUpDown_GetTooltipText( byval hCtrl as TK_WIDGET ptr ) as ustring
function tkNumericUpDown_GetTooltipHandle( byval hCtrl as TK_WIDGET ptr ) as TK_TIP ptr
sub tkNumericUpDown_SetHoverTime( byval hCtrl as TK_WIDGET ptr, byval ms as long )
sub tkNumericUpDown_SetAutoPopTime( byval hCtrl as TK_WIDGET ptr, byval ms as long )
sub tkNumericUpDown_SetReshowTime( byval hCtrl as TK_WIDGET ptr, byval ms as long )
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsNumericUpDown](PsNumericUpDown), the PsControls control
