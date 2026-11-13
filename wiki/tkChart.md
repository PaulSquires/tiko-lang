[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkChart**

# tkChart

Draws line, column, HLOC and pie charts from series of labelled values.

tkChart is a display control with four chart types, chosen at create and fixed after:
`TKCHART_TYPE_LINE` (smoothing, symbols, dash styles, area fills and a shaded band between two
series), `TKCHART_TYPE_COLUMN` (grouped or stacked), `TKCHART_TYPE_HLOC` (high, low, open,
close) and `TKCHART_TYPE_PIE` (a pie or, with `tkChart_SetDoughnutRatio`, a doughnut, with
exploded slices and labels inside, outside on leader lines, or placed automatically). Value axes
scale themselves to 1-2-5 ticks; a legend, title and subtitle are optional.

The chart takes no focus and no keys. Hovering over a point makes it the hot point, shows a
tooltip describing it, and calls the hot-change callback; that is the only notification. All
setters are silent, so wrap a batch of changes in `tkChart_BeginUpdate` / `tkChart_EndUpdate` to
lay out and repaint once.

## Importing

```freebasic
#import "vendor/tkControls/tkChart"

using tkChart
using tkHost
```

The module imports `tkHost`, `tkTheme` and `tkTooltip` publicly; open `tkTooltip` with `using`
to configure the chart's tip through `tkChart_GetTooltipHandle`.

## Example

A grouped column chart with a legend, reporting the point under the mouse:

```freebasic
sub Chart_HotChange( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long )
    if iPoint < 0 then exit sub            ' the mouse left the last point
    print tkChart_GetSeriesName( hChart, iSeries ) & " / " & _
          tkChart_GetPointLabel( hChart, iSeries, iPoint ) & " = " & _
          tkChart_GetPointValue( hChart, iSeries, iPoint )
end sub

dim as TK_WIDGET ptr hChart = tkChart_Create( tkHost_Root( gHost ), 100, TKCHART_TYPE_COLUMN )
tkChart_SetFont( hChart, gFont9 )
tkChart_SetTitle( hChart, "Sales by quarter" )
tkChart_SetLegendVisible( hChart, true )
tkChart_SetHotChangeCallback( hChart, @Chart_HotChange )

tkChart_BeginUpdate( hChart )
dim as long s2025 = tkChart_AddSeries( hChart, "Last year" )
dim as long s2026 = tkChart_AddSeries( hChart, "This year" )
tkChart_AddPoint( hChart, s2025, "Q1", 120 ) : tkChart_AddPoint( hChart, s2026, "Q1", 135 )
tkChart_AddPoint( hChart, s2025, "Q2", 150 ) : tkChart_AddPoint( hChart, s2026, "Q2", 171 )
tkChart_AddPoint( hChart, s2025, "Q3", 110 ) : tkChart_AddPoint( hChart, s2026, "Q3", 128 )
tkChart_EndUpdate( hChart )

tkWidget_SetPos( hChart, x, y, cx, cy )
```

An HLOC chart takes its points with `tkChart_AddHlocPoint( h, iSeries, label, open, high, low,
close )`. A pie uses the first series, one point per slice. The toolchain's
`examples/tkControls/tkChart/` shows all four types, a band with an area fill, and a doughnut with
an exploded slice.

## Coming from PsChart

[PsChart](PsChart) remains the behaviour reference for everything not listed here.

- Names: `PsChart_*` → `tkChart_*`, `PSCHART_*` → `TKCHART_*` (`TKCHART_TYPE_LINE`,
  `TKCHART_COLORS`, …). `CHT_SYM_*`, `CHT_COL_*`, `CHT_LINE_*`, `CHT_LEGEND_*`,
  `CHT_PIELABEL_*`, `CHT_PIEPLACE_*`, `CHT_FMT_*`, `CHT_NiceRange`, `CHT_AutoDecimals`,
  `CHT_FormatNumber` and the `CHT_*` callback types keep their names.
- Handles are `TK_WIDGET ptr`; fonts are `TTF_Font ptr` (`tkChart_SetFont`,
  `tkChart_SetTitleFont`, `tkChart_SetSubtitleFont`); colours are `ulong`; rectangles and points
  are `TKRECT` / `TKPOINT`.
- `tkChart_Create( hParent, ctrlId [, nChartType] )` takes a `TK_WIDGET ptr` parent
  (`tkHost_Root( h )` for a top-level window).
- Tooltips are always the owner-drawn [tkTooltip](tkTooltip); there is no `SetTooltipMode`. The
  tip re-resolves for each point the mouse moves to: authored text, then the tooltip callback,
  then a description of the hot point.
- `TKCHART_MESSAGEINFO` carries the `TKM_*` message, mouse position, key, mods, clicks and the
  hot point. Returning true eats the message, except `TKM_LBUTTONUP`.
- Line widths are given unscaled; the drawing surface scales them.
- Added: `GetBandCount`, `GetUpdateDepth`, `GetValueStep`, `GetFont`, `GetSliceInfo`,
  `GetPointAnchor`, the rectangle queries `GetLegendRect`, `GetTitleRect`, `GetSubtitleRect`,
  `GetAxisYRect`, `GetAxisXRect`, `GetPieRect`, and `GetTooltipHandle` and `SetHoverTime`.
- Gone: `WM_SETFONT` / `WM_GETFONT`, `PsChart_Rescale` (DPI changes are handled by the chart),
  `PsChart_RunSelfTest`, and PsRegistry.

## Public declarations

Every public name the module declares, as the source declares it. Signatures are exact; type bodies keep their field comments and drop the rest.

### Constants

```freebasic
const TKCHART_DEFAULT_PADDING = 10
const TKCHART_DEFAULT_CHROMEGAP = 6
const TKCHART_DEFAULT_TICKLEN = 4
const TKCHART_DEFAULT_BARGAP = 1
const TKCHART_DEFAULT_GROUPGAPPCT = 25
const TKCHART_DEFAULT_HLOCTICK = 3
const TKCHART_DEFAULT_LINEWIDTH = 2
const TKCHART_DEFAULT_SYMBOLSIZE = 6
const TKCHART_DEFAULT_PIEGAP = 1 ' a hairline: never scaled
const TKCHART_DEFAULT_TICKHINT = 5
const TKCHART_DEFAULT_LABELGAP = 8
const TKCHART_DEFAULT_HITRADIUS = 8
const TKCHART_PALETTE_COUNT = 10
const TKCHART_DECIMALS_AUTO = -1
const TKCHART_SKIP_AUTO = 0

enum
    TKCHART_TYPE_LINE = 0
    TKCHART_TYPE_COLUMN
    TKCHART_TYPE_HLOC
    TKCHART_TYPE_PIE
end enum

enum
    CHT_SYM_NONE = 0
    CHT_SYM_CIRCLE
    CHT_SYM_SQUARE
    CHT_SYM_DIAMOND
    CHT_SYM_TRIANGLE
end enum

enum
    CHT_COL_GROUPED = 0
    CHT_COL_STACKED
end enum

enum
    CHT_LINE_SOLID = 0
    CHT_LINE_DASH
    CHT_LINE_DOT
    CHT_LINE_DASHDOT
end enum

enum
    CHT_LEGEND_BOTTOM = 0
    CHT_LEGEND_TOP
    CHT_LEGEND_LEFT
    CHT_LEGEND_RIGHT
end enum

enum
    CHT_PIELABEL_NONE = 0
    CHT_PIELABEL_VALUE
    CHT_PIELABEL_PERCENT
    CHT_PIELABEL_NAME
    CHT_PIELABEL_NAME_PERCENT
end enum

enum
    CHT_PIEPLACE_INSIDE = 0
    CHT_PIEPLACE_OUTSIDE
    CHT_PIEPLACE_AUTO
end enum

enum
    CHT_FMT_AXIS = 0
    CHT_FMT_PIELABEL
    CHT_FMT_TOOLTIP
end enum
```

### Types

```freebasic
type TKCHART_COLORS
    BackColor          as ulong = &hFF21252Bul
    PlotBackColor      as ulong = &hFF21252Bul
    GridColor          as ulong = &hFF3E444Eul
    AxisColor          as ulong = &hFF5A616Cul
    LabelColor         as ulong = &hFF969CA6ul
    TitleColor         as ulong = &hFFD7DAE0ul
    SubtitleColor      as ulong = &hFF969CA6ul
    LegendTextColor    as ulong = &hFFBEC4CEul
    SliceLabelColor    as ulong = &hFFFFFFFFul
    SliceLabelOutColor as ulong = &hFFBEC4CEul
    LeaderColor        as ulong = &hFF787E88ul
    SliceGapColor      as ulong = &hFF21252Bul
    UpColor            as ulong = &hFF48970Dul
    DownColor          as ulong = &hFFD05050ul
    ForeColorDisabled  as ulong = &hFF6E737Dul
end type

type TKCHART_POINT
    Text       as ustring      ' only series 0's labels drive the X axis
    Value      as double       ' line / column / pie; the close for HLOC
    OpenVal    as double
    HighVal    as double
    LowVal     as double
    CloseVal   as double
    ItemData   as integer
    bHasColor  as boolean
    PointColor as ulong
    nExplode   as long         ' pie only: raw px along the bisector
    rc         as TKRECT       ' column: the bar. HLOC: the column band. line: the hit box. pie: the label box.
    ptPlot     as TKPOINT      ' line: the vertex. pie: the wedge's outer midpoint.
    fStart     as single       ' pie: degrees, 0 = 3 o'clock, + = clockwise
    fSweep     as single
    bLabelOut  as boolean
    bLabelHid  as boolean
end type

type TKCHART_SERIES
    SeriesName  as ustring
    bHasColor   as boolean
    SeriesColor as ulong
    nLineWidth  as long = TKCHART_DEFAULT_LINEWIDTH
    nLineStyle  as long = CHT_LINE_SOLID
    nSymbol     as long = CHT_SYM_NONE
    nSymbolSize as long = TKCHART_DEFAULT_SYMBOLSIZE
    bSmooth     as boolean
    bHasFill    as boolean
    FillColor   as ulong
    nFillAlpha  as long = 255
    bVisible    as boolean = true
    points(any) as TKCHART_POINT
    pointCount  as long
    declare sub EnsurePoints( byval n as long )
end type

type TKCHART_BAND
    iLo    as long = -1
    iHi    as long = -1
    clr    as ulong
    nAlpha as long = 255
end type

type TKCHART_PAINTINFO
    hChart        as TK_WIDGET ptr
    b             as TK_PAINT ptr
    rcClient      as TKRECT
    rcPlot        as TKRECT
    rcTitle       as TKRECT
    rcSubtitle    as TKRECT
    rcLegend      as TKRECT
    rcAxisX       as TKRECT
    rcAxisY       as TKRECT
    rcPie         as TKRECT
    nChartType    as long
    fMin          as double
    fMax          as double
    fStep         as double
    nDecimals     as long
    nOriginY      as long
    nCatCount     as long
    nLabelStride  as long
    nHotSeries    as long
    nHotPoint     as long
    isEnabled     as boolean
    wszTitle      as ustring
    wszSubtitle   as ustring
end type

type TKCHART_MESSAGEINFO
    hChart   as TK_WIDGET ptr
    msg      as long             ' TKM_*
    x        as single
    y        as single
    key      as long
    mods     as long
    clicks   as long
    iSeries  as long             ' the hot point, -1 when none
    iPoint   as long
end type

type TKCHART_STATE   ' per-instance state; reach it through the procedures

type CHT_PaintCallbackSub as sub( byval p as TKCHART_PAINTINFO ptr )
type CHT_MessageCallbackFunc as function( byval m as TKCHART_MESSAGEINFO ptr ) as boolean
type CHT_TooltipCallbackFunc as function( byval hChart as TK_WIDGET ptr ) as ustring
type CHT_ValueLabelCallbackFunc as function( byval hChart as TK_WIDGET ptr, byval fValue as double, byval nContext as long ) as ustring
type CHT_HotChangeCallbackSub as sub( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long )
```

### Procedures

```freebasic
sub CHT_NiceRange( byval fRawMin as double, byval fRawMax as double, byval nTickHint as long, byref fOutMin as double, byref fOutMax as double, byref fOutStep as double )
function CHT_AutoDecimals( byval fStep as double ) as long
function CHT_FormatNumber( byval fValue as double, byval nDecimals as long, byval bThousands as boolean ) as ustring
function tkChart_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as long, byval nChartType as long = TKCHART_TYPE_LINE ) as TK_WIDGET ptr
function tkChart_GetChartType( byval hChart as TK_WIDGET ptr ) as long
function tkChart_AddSeries( byval hChart as TK_WIDGET ptr, byval wszName as ustring = "" ) as long
function tkChart_GetSeriesCount( byval hChart as TK_WIDGET ptr ) as long
function tkChart_SetSeriesName( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval wszName as ustring ) as boolean
function tkChart_GetSeriesName( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as ustring
function tkChart_SetSeriesColor( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval clr as ulong ) as boolean
function tkChart_ClearSeriesColor( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as boolean
function tkChart_SetSeriesLineWidth( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval nWidth as long ) as boolean
function tkChart_SetSeriesFill( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval clrFill as ulong, byval nAlpha as long ) as boolean
function tkChart_ClearSeriesFill( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as boolean
function tkChart_SetSeriesBand( byval hChart as TK_WIDGET ptr, byval seriesLo as long, byval seriesHi as long, byval clrFill as ulong, byval nAlpha as long ) as boolean
function tkChart_ClearSeriesBand( byval hChart as TK_WIDGET ptr, byval seriesLo as long, byval seriesHi as long ) as boolean
function tkChart_GetBandCount( byval hChart as TK_WIDGET ptr ) as long
function tkChart_SetSeriesLineStyle( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval nStyle as long ) as boolean
function tkChart_GetSeriesLineStyle( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as long
function tkChart_SetSeriesSymbol( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval nSymbol as long, byval nSize as long = -1 ) as boolean
function tkChart_SetSeriesSmooth( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval bSmooth as boolean ) as boolean
function tkChart_SetSeriesVisible( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval bVisible as boolean ) as boolean
function tkChart_IsSeriesVisible( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as boolean
function tkChart_AddPoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval wszLabel as ustring, byval fValue as double ) as long
function tkChart_AddHlocPoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval wszLabel as ustring, byval fOpenVal as double, byval fHighVal as double, byval fLowVal as double, byval fCloseVal as double ) as long
function tkChart_GetPointCount( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as long
function tkChart_SetPointValue( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval fValue as double ) as boolean
function tkChart_GetPointValue( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as double
function tkChart_SetPointLabel( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval wszLabel as ustring ) as boolean
function tkChart_GetPointLabel( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as ustring
function tkChart_SetPointColor( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval clr as ulong ) as boolean
function tkChart_ClearPointColor( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as boolean
function tkChart_SetPointItemData( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval nData as integer ) as boolean
function tkChart_GetPointItemData( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as integer
function tkChart_SetPointExplode( byval hChart as TK_WIDGET ptr, byval iPoint as long, byval nOffset as long ) as boolean
function tkChart_ClearPoints( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as boolean
sub tkChart_Clear( byval hChart as TK_WIDGET ptr )
sub tkChart_BeginUpdate( byval hChart as TK_WIDGET ptr )
sub tkChart_EndUpdate( byval hChart as TK_WIDGET ptr )
function tkChart_GetUpdateDepth( byval hChart as TK_WIDGET ptr ) as long
sub tkChart_SetAutoScale( byval hChart as TK_WIDGET ptr, byval bAuto as boolean )
function tkChart_GetAutoScale( byval hChart as TK_WIDGET ptr ) as boolean
sub tkChart_SetValueRange( byval hChart as TK_WIDGET ptr, byval fLo as double, byval fHi as double )
sub tkChart_GetValueRange( byval hChart as TK_WIDGET ptr, byref fLo as double, byref fHi as double )
function tkChart_GetValueStep( byval hChart as TK_WIDGET ptr ) as double
sub tkChart_SetTickCountHint( byval hChart as TK_WIDGET ptr, byval nTicks as long )
sub tkChart_SetGridLines( byval hChart as TK_WIDGET ptr, byval bHorz as boolean, byval bVert as boolean )
sub tkChart_SetValueFormat( byval hChart as TK_WIDGET ptr, byval nDecimals as long, byval bThousands as boolean )
sub tkChart_SetAxisLabelSkip( byval hChart as TK_WIDGET ptr, byval nSkip as long )
function tkChart_GetAxisLabelSkip( byval hChart as TK_WIDGET ptr ) as long
function tkChart_ValueToY( byval hChart as TK_WIDGET ptr, byval fValue as double ) as long
function tkChart_YToValue( byval hChart as TK_WIDGET ptr, byval y as long ) as double
sub tkChart_SetTitle( byval hChart as TK_WIDGET ptr, byval wszText as ustring )
function tkChart_GetTitle( byval hChart as TK_WIDGET ptr ) as ustring
sub tkChart_SetSubtitle( byval hChart as TK_WIDGET ptr, byval wszText as ustring )
function tkChart_GetSubtitle( byval hChart as TK_WIDGET ptr ) as ustring
sub tkChart_SetLegendVisible( byval hChart as TK_WIDGET ptr, byval bVisible as boolean )
function tkChart_IsLegendVisible( byval hChart as TK_WIDGET ptr ) as boolean
sub tkChart_SetLegendPosition( byval hChart as TK_WIDGET ptr, byval nPos as long )
sub tkChart_SetPadding( byval hChart as TK_WIDGET ptr, byval nPadding as long )
sub tkChart_SetFont( byval hChart as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkChart_GetFont( byval hChart as TK_WIDGET ptr ) as TTF_Font ptr
sub tkChart_SetTitleFont( byval hChart as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkChart_SetSubtitleFont( byval hChart as TK_WIDGET ptr, byval f as TTF_Font ptr )
sub tkChart_ApplyFonts( byval hChart as TK_WIDGET ptr, byval fText as TTF_Font ptr, byval fGlyph as TTF_Font ptr )
sub tkChart_SetBarGap( byval hChart as TK_WIDGET ptr, byval nGap as long )
sub tkChart_SetGroupGapPercent( byval hChart as TK_WIDGET ptr, byval nPct as long )
function tkChart_SetColumnMode( byval hChart as TK_WIDGET ptr, byval nMode as long ) as boolean
function tkChart_GetColumnMode( byval hChart as TK_WIDGET ptr ) as long
sub tkChart_SetHlocTickWidth( byval hChart as TK_WIDGET ptr, byval nWidth as long )
sub tkChart_SetHlocUpDownColors( byval hChart as TK_WIDGET ptr, byval bEnable as boolean )
sub tkChart_SetDoughnutRatio( byval hChart as TK_WIDGET ptr, byval fRatio as single )
function tkChart_GetDoughnutRatio( byval hChart as TK_WIDGET ptr ) as single
sub tkChart_SetPieLabelMode( byval hChart as TK_WIDGET ptr, byval nMode as long )
sub tkChart_SetPieLabelPlacement( byval hChart as TK_WIDGET ptr, byval nPlace as long )
sub tkChart_SetPieStartAngle( byval hChart as TK_WIDGET ptr, byval fDegrees as single )
sub tkChart_SetPieSliceGap( byval hChart as TK_WIDGET ptr, byval nGap as long )
function tkChart_GetSliceInfo( byval hChart as TK_WIDGET ptr, byval iPoint as long, byref fStart as single, byref fSweep as single, byref bLabelOut as boolean, byref bLabelHid as boolean ) as boolean
sub tkChart_GetColors( byval hChart as TK_WIDGET ptr, byval pColors as TKCHART_COLORS ptr )
sub tkChart_SetColors( byval hChart as TK_WIDGET ptr, byval pColors as TKCHART_COLORS ptr )
function tkChart_ThemeColors( byref t as TKTHEME_COLORS ) as TKCHART_COLORS
sub tkChart_ApplyTheme( byval hChart as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkChart_UnpinColors( byval hChart as TK_WIDGET ptr )
sub tkChart_SetPaletteColor( byval hChart as TK_WIDGET ptr, byval idx as long, byval clr as ulong )
function tkChart_GetPaletteColor( byval hChart as TK_WIDGET ptr, byval idx as long ) as ulong
function tkChart_HitTest( byval hChart as TK_WIDGET ptr, byval x as long, byval y as long, byref iSeries as long, byref iPoint as long ) as boolean
function tkChart_GetPlotRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetLegendRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetTitleRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetSubtitleRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetAxisYRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetAxisXRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetPieRect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetPointRect( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byref rc as TKRECT ) as boolean
function tkChart_GetPointAnchor( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byref pt as TKPOINT ) as boolean
function tkChart_GetHotPoint( byval hChart as TK_WIDGET ptr, byref iSeries as long, byref iPoint as long ) as boolean
sub tkChart_SetTooltipText( byval hChart as TK_WIDGET ptr, byval wszText as ustring )
function tkChart_GetTooltipText( byval hChart as TK_WIDGET ptr ) as ustring
function tkChart_ResolveTooltipText( byval hChart as TK_WIDGET ptr ) as ustring
function tkChart_GetTooltipHandle( byval hChart as TK_WIDGET ptr ) as TK_TIP ptr
sub tkChart_SetHoverTime( byval hChart as TK_WIDGET ptr, byval ms as long )
sub tkChart_PaintDefault( byval p as TKCHART_PAINTINFO ptr )
sub tkChart_SetPaintCallback( byval hChart as TK_WIDGET ptr, byval userfunc as CHT_PaintCallbackSub )
sub tkChart_SetMessageCallback( byval hChart as TK_WIDGET ptr, byval userfunc as CHT_MessageCallbackFunc )
sub tkChart_SetTooltipCallback( byval hChart as TK_WIDGET ptr, byval userfunc as CHT_TooltipCallbackFunc )
sub tkChart_SetValueLabelCallback( byval hChart as TK_WIDGET ptr, byval userfunc as CHT_ValueLabelCallbackFunc )
sub tkChart_SetHotChangeCallback( byval hChart as TK_WIDGET ptr, byval userfunc as CHT_HotChangeCallbackSub )
function tkChart_CountRenderedTones( byval hChart as TK_WIDGET ptr ) as long
function tkChart_HashRenderedPart( byval hChart as TK_WIDGET ptr ) as ulong
function tkChart_GetRenderedPixel( byval hChart as TK_WIDGET ptr, byval x as long, byval y as long ) as ulong
function tkChart_CountPlotInkPixels( byval hChart as TK_WIDGET ptr, byval clrBack as ulong ) as long
```

### See also

- [tkControls](Category-tkControls)
- [tkApp](tkApp), [tkHost](tkHost)
- [PsChart](PsChart), the PsControls control
