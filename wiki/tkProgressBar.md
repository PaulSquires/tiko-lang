[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkProgressBar**

# tkProgressBar

Draws a horizontal or vertical progress bar, determinate or with a running marquee.

`tkProgressBar` is the [tkControls](Category-tkControls) progress indicator. A determinate bar
fills in proportion to its position within a range (0 to 100 by default); an indeterminate bar
runs a marquee chunk that bounces or wraps. The fill is solid or a two-stop gradient, continuous
or segmented into blocks, can grow from either end, and changes colour for the paused and error
states. An optional caption (percent, value, or your own text) is drawn across the bar in two
colours, one over the fill and one over the track.

The bar is output only: it has no change callback, and every setter is silent. The marquee is the
only timer it runs, and only while the bar is indeterminate, enabled and shown.

## Importing

```freebasic
#import "vendor/tkControls/tkProgressBar"

using tkProgressBar
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme) and [tkTooltip](tkTooltip). Add `using tkPaint` to name the
`TK_GRADIENT_*` modes or to write a paint callback; `tkProgressBar_PaintDefault( p )` in one draws
the stock bar first.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example.

```freebasic
function Copy_Text( byval hBar as TK_WIDGET ptr, byval nPos as long, _
                    byval nMin as long, byval nMax as long ) as ustring
    return nPos & " of " & nMax & " files"
end function

dim as TK_WIDGET ptr copyBar = tkProgressBar_Create( tkHost_Root( host ), 8000 )
tkProgressBar_SetRange( copyBar, 0, 250 )
tkProgressBar_SetFillStyle( copyBar, PRG_FILL_GRADIENT )
tkProgressBar_SetTextCallback( copyBar, @Copy_Text )
tkProgressBar_SetTextMode( copyBar, PRG_TEXT_CALLBACK )
tkWidget_SetPos( copyBar, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), _
                 tkHost_Scale( host, 300 ), tkHost_Scale( host, 22 ) )

' as work completes
tkProgressBar_SetPos( copyBar, 120 )

' a "busy" bar with no known end
dim as TK_WIDGET ptr busy = tkProgressBar_Create( tkHost_Root( host ), 8001 )
tkProgressBar_SetMarqueeStyle( busy, PRG_MARQUEE_WRAP )
tkProgressBar_SetMode( busy, PRG_MODE_INDETERMINATE )
tkWidget_SetPos( busy, tkHost_Scale( host, 20 ), tkHost_Scale( host, 50 ), _
                 tkHost_Scale( host, 300 ), tkHost_Scale( host, 6 ) )
```

## Coming from PsProgressBar

[PsProgressBar](PsProgressBar) is the Win32 twin; its page remains the behaviour reference for
everything not listed here.

- Names: `PsProgressBar_*` → `tkProgressBar_*`, `PSPROGRESSBAR_*` → `TKPROGRESSBAR_*`. The `PRG_*`
  enums and the `PRG_*Callback*` types keep their names. The handle is `TK_WIDGET ptr`.
- `tkProgressBar_Create( hParent, CtrlID, nOrientation = PRG_HORIZONTAL )` takes a
  `TK_WIDGET ptr` parent; for a top-level bar pass `tkHost_Root( host )`.
- Gradient directions are `TK_GRADIENT_*` (from [tkPaint](tkPaint)), with the same four values
  as GDI+'s `LinearGradientMode*`. On the two diagonal modes a segmented bar shades each block
  along its own diagonal.
- Colours are `&hAARRGGBB` values and start from the current [tkTheme](tkTheme) palette. Fonts
  are `TTF_Font ptr`; `tkProgressBar_SetFont( h, 0 )` returns to the host's default font.
- `tkProgressBar_SetEnabled` disables the widget itself; a direct `tkWidget_Enable` also stops
  and restarts the marquee.
- `TKPROGRESSBAR_MESSAGEINFO` carries `msg` (a `TKM_*` code), `x`, `y`, `key`, `timerId` and
  `bFlag` instead of `uMsg` / `wParam` / `lParam`.
- The tooltip is a [tkTooltip](tkTooltip); `tkProgressBar_GetTooltipHandle` returns its
  `TK_TIP ptr`. There is no tooltip mode and no comctl32 tooltip.
- `tkProgressBar_GetBlockRect` empties `rc` whenever it returns FALSE.
- Scale changes reach the control as `TKM_SCALECHANGED`; there is no `Rescale` call. Border
  thickness, curvature and the marquee interval are not scaled.
- No equivalent: PsRegistry, the self-test.
- Added: `tkProgressBar_GetID` and `tkProgressBar_GetMarqueeTick`.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKPROGRESSBAR_DEFAULT_THICKNESS = 0 ' 0 = fill the client's cross axis
const TKPROGRESSBAR_DEFAULT_BARINSET = 0
const TKPROGRESSBAR_DEFAULT_BORDERTHICK = 0 ' not scaled; 0 = no track border
const TKPROGRESSBAR_DEFAULT_CURVATURE = -1 ' not scaled; -1 = stadium
const TKPROGRESSBAR_DEFAULT_BLOCKLEN = 10
const TKPROGRESSBAR_DEFAULT_BLOCKGAP = 3
const TKPROGRESSBAR_DEFAULT_MARQUEE_MS = 30
const TKPROGRESSBAR_DEFAULT_MARQUEE_STEP = 2
const TKPROGRESSBAR_DEFAULT_CHUNK_PCT = 25
const TKPROGRESSBAR_CURVATURE_STADIUM = -1

enum
    PRG_HORIZONTAL = 0
    PRG_VERTICAL
end enum

enum
    PRG_MODE_DETERMINATE = 0
    PRG_MODE_INDETERMINATE
end enum

enum
    PRG_MARQUEE_BOUNCE = 0
    PRG_MARQUEE_WRAP
end enum

enum
    PRG_FILL_SOLID = 0
    PRG_FILL_GRADIENT
end enum

enum
    PRG_STATE_NORMAL = 0
    PRG_STATE_PAUSED
    PRG_STATE_ERROR
end enum

enum
    PRG_TEXT_NONE = 0
    PRG_TEXT_PERCENT
    PRG_TEXT_VALUE
    PRG_TEXT_CALLBACK
end enum

enum
    PRG_PART_CONTROL = 0
    PRG_PART_TRACK
    PRG_PART_BAR
    PRG_PART_TEXT
end enum
```

### Types

```freebasic
type TKPROGRESSBAR_COLORS
    BackColor            as ulong = &hFF21252Bul    ' ( 33, 37, 43)
    TrackColor           as ulong = &hFF33373Ful    ' ( 51, 55, 63)
    TrackBorderColor     as ulong = &hFF484D56ul    ' ( 72, 77, 86)
    BarColor             as ulong = &hFF569CD6ul    ' ( 86,156,214)
    BarColorEnd          as ulong = &hFF346EAAul    ' ( 52,110,170)
    BarColorPaused       as ulong = &hFFDEB846ul    ' (222,184, 70)
    BarColorPausedEnd    as ulong = &hFFB28C22ul    ' (178,140, 34)
    BarColorError        as ulong = &hFFE06060ul    ' (224, 96, 96)
    BarColorErrorEnd     as ulong = &hFFB03838ul    ' (176, 56, 56)
    BarColorDisabled     as ulong = &hFF545961ul    ' ( 84, 89, 97)
    BarColorDisabledEnd  as ulong = &hFF3E434Bul    ' ( 62, 67, 75)
    TextColor            as ulong = &hFFBEC4CEul    ' (190,196,206) over the EMPTY track
    TextColorOnBar       as ulong = &hFFFFFFFFul    ' over the FILLED bar
    TextColorDisabled    as ulong = &hFF5A606Aul    ' ( 90, 96,106) both halves, disabled
end type

type TKPROGRESSBAR_PAINTINFO
    hProgressBar     as TK_WIDGET ptr
    b                as TK_PAINT ptr
    rcClient         as TKRECT
    rcTrack          as TKRECT
    rcFill           as TKRECT
    rcBar            as TKRECT          ' indeterminate: the floating chunk
    nPos             as long
    nMin             as long
    nMax             as long
    nPercent         as long
    isIndeterminate  as boolean
    isEnabled        as boolean
    isReverse        as boolean
    isSegmented      as boolean
    nOrientation     as long
    nState           as long
    nFillStyle       as long
    nCurvature       as long            ' resolved: the stadium sentinel never reaches here
    nBlockLength     as long
    nBlockGap        as long
    wszText          as ustring         ' "" = draw nothing
end type

type TKPROGRESSBAR_MESSAGEINFO
    hProgressBar as TK_WIDGET ptr
    msg          as long                ' TKM_*
    x            as single
    y            as single
    key          as long
    timerId      as long
    bFlag        as boolean
end type

type TKPROGRESSBAR_STATE   ' per-instance state; reach it through the procedures

type PRG_PaintCallbackSub as sub( byval p as TKPROGRESSBAR_PAINTINFO ptr )
type PRG_MessageCallbackFunc as function( byval m as TKPROGRESSBAR_MESSAGEINFO ptr ) as boolean
type PRG_TooltipCallbackFunc as function( byval hProgressBar as TK_WIDGET ptr ) as ustring
type PRG_TextCallbackFunc as function( byval hProgressBar as TK_WIDGET ptr, byval nPos as long, byval nMin as long, byval nMax as long ) as ustring
```

### Procedures

```freebasic
function tkProgressBar_ComputeBarLength( byval nPos as long, byval nMin as long, byval nMax as long, byval nTrackLen as long ) as long
function tkProgressBar_ComputeMarqueeOffset( byval nTrackLen as long, byval nChunkLen as long, byval nStep as long, byval nTick as long, byval nStyle as long ) as long
function tkProgressBar_ComputeBlockCount( byval nLength as long, byval nBlockLen as long, byval nBlockGap as long ) as long
function tkProgressBar_Create( byval hParent as TK_WIDGET ptr, byval CtrlID as long, byval nOrientation as long = PRG_HORIZONTAL ) as TK_WIDGET ptr
sub tkProgressBar_Refresh( byval hProgressBar as TK_WIDGET ptr )
function tkProgressBar_GetOrientation( byval hProgressBar as TK_WIDGET ptr ) as long
function tkProgressBar_GetID( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_GetRange( byval hProgressBar as TK_WIDGET ptr, byref nMin as long, byref nMax as long )
sub tkProgressBar_SetRange( byval hProgressBar as TK_WIDGET ptr, byval nMin as long, byval nMax as long )
function tkProgressBar_GetPos( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetPos( byval hProgressBar as TK_WIDGET ptr, byval nPos as long )
function tkProgressBar_GetStep( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetStep( byval hProgressBar as TK_WIDGET ptr, byval nStep as long )
function tkProgressBar_StepIt( byval hProgressBar as TK_WIDGET ptr ) as long
function tkProgressBar_DeltaPos( byval hProgressBar as TK_WIDGET ptr, byval nDelta as long ) as long
function tkProgressBar_GetPercent( byval hProgressBar as TK_WIDGET ptr ) as long
function tkProgressBar_GetMode( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetMode( byval hProgressBar as TK_WIDGET ptr, byval nMode as long )
function tkProgressBar_GetState( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetState( byval hProgressBar as TK_WIDGET ptr, byval nState as long )
function tkProgressBar_GetEnabled( byval hProgressBar as TK_WIDGET ptr ) as boolean
sub tkProgressBar_SetEnabled( byval hProgressBar as TK_WIDGET ptr, byval isEnabled as boolean )
function tkProgressBar_GetMarqueeStyle( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetMarqueeStyle( byval hProgressBar as TK_WIDGET ptr, byval nStyle as long )
sub tkProgressBar_GetMarqueeSpeed( byval hProgressBar as TK_WIDGET ptr, byref nIntervalMs as long, byref nStepPx as long )
sub tkProgressBar_SetMarqueeSpeed( byval hProgressBar as TK_WIDGET ptr, byval nIntervalMs as long, byval nStepPx as long )
function tkProgressBar_GetMarqueeChunkPercent( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetMarqueeChunkPercent( byval hProgressBar as TK_WIDGET ptr, byval nPercent as long )
function tkProgressBar_GetMarqueeTick( byval hProgressBar as TK_WIDGET ptr ) as long
function tkProgressBar_GetFillStyle( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetFillStyle( byval hProgressBar as TK_WIDGET ptr, byval nFillStyle as long )
function tkProgressBar_GetGradientMode( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetGradientMode( byval hProgressBar as TK_WIDGET ptr, byval nMode as long )
function tkProgressBar_GetSegmented( byval hProgressBar as TK_WIDGET ptr ) as boolean
sub tkProgressBar_SetSegmented( byval hProgressBar as TK_WIDGET ptr, byval isSegmented as boolean )
sub tkProgressBar_GetBlockMetrics( byval hProgressBar as TK_WIDGET ptr, byref nBlockLen as long, byref nBlockGap as long )
sub tkProgressBar_SetBlockMetrics( byval hProgressBar as TK_WIDGET ptr, byval nBlockLen as long, byval nBlockGap as long )
function tkProgressBar_GetBlockCount( byval hProgressBar as TK_WIDGET ptr ) as long
function tkProgressBar_GetBlockRect( byval hProgressBar as TK_WIDGET ptr, byval idx as long, byref rc as TKRECT ) as boolean
function tkProgressBar_GetThickness( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetThickness( byval hProgressBar as TK_WIDGET ptr, byval nThickness as long )
function tkProgressBar_GetBarInset( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetBarInset( byval hProgressBar as TK_WIDGET ptr, byval nBarInset as long )
function tkProgressBar_GetBorderThickness( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetBorderThickness( byval hProgressBar as TK_WIDGET ptr, byval nThickness as long )
function tkProgressBar_GetCurvature( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetCurvature( byval hProgressBar as TK_WIDGET ptr, byval nCurvature as long )
function tkProgressBar_GetReverse( byval hProgressBar as TK_WIDGET ptr ) as boolean
sub tkProgressBar_SetReverse( byval hProgressBar as TK_WIDGET ptr, byval isReverse as boolean )
function tkProgressBar_GetTrackRect( byval hProgressBar as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkProgressBar_GetFillRect( byval hProgressBar as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkProgressBar_GetBarRect( byval hProgressBar as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkProgressBar_GetTextMode( byval hProgressBar as TK_WIDGET ptr ) as long
sub tkProgressBar_SetTextMode( byval hProgressBar as TK_WIDGET ptr, byval nTextMode as long )
function tkProgressBar_GetFont( byval hProgressBar as TK_WIDGET ptr ) as TTF_Font ptr
sub tkProgressBar_SetFont( byval hProgressBar as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkProgressBar_GetDisplayText( byval hProgressBar as TK_WIDGET ptr ) as ustring
sub tkProgressBar_GetColors( byval hProgressBar as TK_WIDGET ptr, byval pColors as TKPROGRESSBAR_COLORS ptr )
sub tkProgressBar_SetColors( byval hProgressBar as TK_WIDGET ptr, byval pColors as TKPROGRESSBAR_COLORS ptr )
function tkProgressBar_ThemeColors( byref t as TKTHEME_COLORS ) as TKPROGRESSBAR_COLORS
sub tkProgressBar_ApplyTheme( byval hProgressBar as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkProgressBar_UnpinColors( byval hProgressBar as TK_WIDGET ptr )
sub tkProgressBar_ApplyFonts( byval hProgressBar as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkProgressBar_ResolveBarColors( byval hProgressBar as TK_WIDGET ptr, byref clr1 as ulong, byref clr2 as ulong )
function tkProgressBar_GetTooltipText( byval hProgressBar as TK_WIDGET ptr ) as ustring
sub tkProgressBar_SetTooltipText( byval hProgressBar as TK_WIDGET ptr, byval Text as ustring )
function tkProgressBar_GetTooltipHandle( byval hProgressBar as TK_WIDGET ptr ) as TK_TIP ptr
sub tkProgressBar_SetHoverTime( byval hProgressBar as TK_WIDGET ptr, byval ms as long )
sub tkProgressBar_SetAutoPopTime( byval hProgressBar as TK_WIDGET ptr, byval ms as long )
sub tkProgressBar_SetReshowTime( byval hProgressBar as TK_WIDGET ptr, byval ms as long )
sub tkProgressBar_PaintDefault( byval p as TKPROGRESSBAR_PAINTINFO ptr )
sub tkProgressBar_SetPaintCallback( byval hProgressBar as TK_WIDGET ptr, byval usersub as PRG_PaintCallbackSub )
sub tkProgressBar_SetMessageCallback( byval hProgressBar as TK_WIDGET ptr, byval userfunc as PRG_MessageCallbackFunc )
sub tkProgressBar_SetTooltipCallback( byval hProgressBar as TK_WIDGET ptr, byval userfunc as PRG_TooltipCallbackFunc )
sub tkProgressBar_SetTextCallback( byval hProgressBar as TK_WIDGET ptr, byval userfunc as PRG_TextCallbackFunc )
function tkProgressBar_CountRenderedTones( byval hProgressBar as TK_WIDGET ptr, byval nPart as long ) as long
function tkProgressBar_HashRenderedPart( byval hProgressBar as TK_WIDGET ptr, byval nPart as long ) as ulong
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsProgressBar](PsProgressBar), the PsControls control
