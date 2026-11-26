[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkChart**

# tkChart

Draws line, area, column, bar, combo, HLOC, candlestick, scatter, bubble and pie charts.

tkChart is a display control with eleven chart types, chosen at create and fixed after:

- `TKCHART_TYPE_LINE`: smoothing, symbols, dash styles, area fills and a shaded band between two
  series.
- `TKCHART_TYPE_AREA`: each series a filled region under its line, overlapping, stacked or
  stacked to 100 %.
- `TKCHART_TYPE_COLUMN`: vertical bars, grouped, stacked or stacked to 100 %.
- `TKCHART_TYPE_BAR`: the same, horizontal: categories down the left, values along the bottom.
- `TKCHART_TYPE_COMBO`: line, column and area series on one chart, each on the left (primary) or
  the right (secondary) value axis.
- `TKCHART_TYPE_HLOC`: high, low, open, close bars.
- `TKCHART_TYPE_CANDLESTICK`: the same data as candles, a wick and an up or down body.
- `TKCHART_TYPE_SCATTER`: points on a numeric X axis.
- `TKCHART_TYPE_BUBBLE`: the same, each point a disc whose area follows a third number.
- `TKCHART_TYPE_PIE`: a pie or, with `tkChart_SetDoughnutRatio`, a doughnut, with exploded
  slices and labels inside, outside on leader lines, or placed automatically.
- `TKCHART_TYPE_DONUT`: a pie that opens with a hole and shows the total (or your text) in it.

Value axes scale themselves to 1-2-5 ticks; a legend, title and subtitle are optional.

You hand it series and points; it works out everything else. It picks readable gridline values,
measures the widest axis label and reserves a gutter for it, spaces the categories evenly and
drops every Nth category label when they would otherwise collide. The legend, title and subtitle
take their space out of the plot before the plot is measured, so turning any of them on never
overlaps anything.

The chart takes no focus, no keys and no mouse capture, and clicking it does nothing. Hovering
over a point makes it the hot point, shows a tooltip describing it, and calls the hot-change
callback; that is the only notification. Every message the chart receives is offered to your
message callback first, so anything interactive (click-to-drill-down being the obvious case) is
yours to add. All setters are silent, so wrap a batch of changes in `tkChart_BeginUpdate` /
`tkChart_EndUpdate` to lay out and repaint once.

## Importing

```freebasic
#import "vendor/tkControls/tkChart"

using tkChart
using tkHost
```

The module imports `tkHost`, `tkTheme` and `tkTooltip` publicly; open `tkTooltip` with `using`
to configure the chart's tip through `tkChart_GetTooltipHandle`. Line symbols are drawn as
geometry, not glyphs, so there is no icon font to load.

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

## Concepts

### The handle is a widget

`tkChart_Create( hParent, ctrlId [, nChartType] )` returns a `TK_WIDGET ptr` child of `hParent`
(`tkHost_Root( h )` for a top-level window). [tkHost](tkHost)'s `tkWidget_SetPos`,
`tkWidget_Show`, `tkWidget_Enable` and `tkWidget_Destroy` work on it directly, and there is no
chart wrapper for any of them. The chart never positions itself. Destroying it, or its parent,
frees the chart's state and its tooltip.

### The chart type is fixed at creation

`tkChart_Create` takes the type and there is no setter for it. The types do not share a data
shape: a pie has no value axis, an HLOC or candlestick point carries four numbers where a column
point carries one, and a scatter point carries an X of its own. To show the same data another
way, create a second chart.

Which call adds a point:

| Types | Add points with |
|---|---|
| LINE, AREA, COLUMN, BAR, COMBO, PIE, DONUT | `tkChart_AddPoint( hChart, iSeries, label, value )` |
| HLOC, CANDLESTICK | `tkChart_AddHlocPoint( hChart, iSeries, label, open, high, low, close )` |
| SCATTER | `tkChart_AddXYPoint( hChart, iSeries, x, y, label = "" )` |
| BUBBLE | `tkChart_AddBubblePoint( hChart, iSeries, x, y, size, label = "" )` |

### Series and points

A **series** is what the legend names and what the palette colours: one line, or one set of bars.
A **point** is one datum in a series. Series are indexed from 0 in creation order, and points from
0 within their series.

Categories along the X axis are **positional**: point 3 of every series lines up, whatever its
label says. Only series 0's labels are drawn on the axis; a second series' labels are still
carried, and a tooltip can use them. The number of categories is the length of the **longest**
visible series, so a series with fewer points simply stops early. On a **bar** chart the
categories run down the left edge instead, category 0 at the top.

**Scatter** and **bubble** charts have no categories: each point has its own X, and the X axis is
a second value axis, scaled the same 1-2-5 way. A point's label is for its tooltip only.

A **pie** reads only series 0, and enumerates the palette per *point* rather than per series: on a
pie the slices are what the colours have to distinguish. Its legend lists those points.

### The value axis is derived, not set

Unless you turn autoscaling off, the chart scans every visible series for its minimum and
maximum, then snaps the range outward to gridlines a person would have chosen; the step is always
1, 2 or 5 times a power of ten:

```
step  = the 1/2/5 x 10^n at or above (range / tick hint)
min   = floor( data minimum / step ) * step
max   = ceil ( data maximum / step ) * step
```

The bounds widen to that step deliberately: a top gridline exactly at the highest datum puts the
tallest bar flush against the edge of the plot with nothing above it. A flat series (every value
the same) opens a window of ±10 % around it, or −1 … 1 around zero.

Type-specific rules ride on top:

- A **column**, **bar** or **area** chart forces zero into the range, because bars and fills are
  drawn from a baseline. If the data straddles zero the origin therefore sits inside the plot and
  negative bars hang below it (on a bar chart, run left of it). A **stacked** chart scales to the
  stack totals, positives and negatives totalled separately; a **100 %** chart to the shares of
  each category's absolute sum, 0 … 100 (−100 … 100 when a category mixes signs).
- A **line**, **HLOC**, **candlestick**, **scatter** or **bubble** chart does **not** force zero.
  A price series trading at 1,120 plotted against a zero baseline is a flat line across the top of
  the plot.
- An HLOC or candlestick chart takes its range from the **low** and **high** of each point, never
  from the close.
- A **scatter** or **bubble** chart scales its X axis the same way, separately, and never forces
  zero into it either.
- A **combo** chart scales each value axis over the series that read it; an axis that a column or
  area series reads includes zero.
- A **pie** or **donut** has no value axis.

`CHT_NiceRange`, `CHT_AutoDecimals` and `CHT_FormatNumber` are public: they are the functions the
chart itself uses to pick the range, the decimal count and the label text, so code drawing its
own labels can match the chart's.

### Layout is lazy, and owns the rects

The plot rect, the axis gutters, the legend block, the title strips and the pie's square are all
derived from the widget's size and the measured text; you never set one. A mutator marks the
layout stale and the next repaint recomputes it, so populating a thousand points costs one layout.
Every geometry query (`tkChart_GetPlotRect` and the other rect queries, `tkChart_GetPointRect`,
`tkChart_GetPointAnchor`, `tkChart_HitTest`, `tkChart_ValueToY`, `tkChart_GetValueRange`,
`tkChart_GetSliceInfo`) forces a pending layout first, so none of them can answer from stale
numbers.

The same rects drive both the renderer and the hit test, so the tooltip always names the bar that
is drawn under the mouse.

### Everything is silent except the mouse

Every setter is silent: adding a point, hiding a series, changing a colour and re-ranging the
axis all repaint and fire nothing. Only the hot point changing under the mouse notifies, so any
setter is safe to call from inside any callback.

### Sizes and scale

The create-time defaults (padding, chrome gap, tick length, bar gap, HLOC tick, hit radius and
symbol size) are multiplied by the host's scale when the chart is created. Sizes you pass
afterwards (`tkChart_SetPadding`, `tkChart_SetBarGap`, `tkChart_SetHlocTickWidth`,
`tkChart_SetPointExplode`, symbol sizes) are pixels at the current scale; multiply design values
with `tkHost_Scale`. When the scale changes, `TKM_SCALECHANGED` multiplies the padding, chrome gap,
tick length, bar gap, HLOC tick, hit radius, every series' symbol size and every explode offset by
new / old, so they follow the window.

Line widths and the pie slice gap are given unscaled, because the drawing surface scales those
pens itself. Gridlines and axis rules are one pixel and are never scaled.

### Fonts are borrowed

Fonts are `TTF_Font ptr`. The chart never owns or closes one: whatever you pass to
`tkChart_SetFont`, `tkChart_SetTitleFont` or `tkChart_SetSubtitleFont` stays yours. With no label
font set the chart uses the host's default font; unset title and subtitle fonts fall back to the
label font.

## Behaviour and limits

- **The chart type cannot change** after `tkChart_Create`.
- **Column, bar and area charts are grouped, stacked or 100 %** (`tkChart_SetColumnMode`; on an
  area chart "grouped" means the regions overlap). Stacking totals positives and negatives
  separately: a category holding both reads as two piles meeting at zero, not as one pile that
  cancels itself out.
- **Bands and smoothing are line-chart features.** A combo chart's line series draw their line
  styles and symbols; an area series draws its edge in its line width and style, with symbols,
  but never smoothed, so the edge stays on its fill. Column, bar, HLOC, candlestick and pie charts
  ignore them.
- **A combo chart's column series are always grouped**: the column mode is not read there. Only
  the column series share a category's slot; line and area series take no room in it.
- **The secondary axis exists only while a visible series reads it.** Until then a combo chart has
  no right gutter, and `tkChart_GetSecondaryValueRange` reports 0 … 0.
- **Bubbles are clipped at the plot's edge** like every series: the axis is scaled to the points'
  centres, not to their discs. Widen the range with `tkChart_SetXRange` / `tkChart_SetValueRange`
  when an edge bubble matters.
- **Area fills and bands paint under every line.** `tkChart_SetSeriesFill` fills between a line
  series and the value baseline; `tkChart_SetSeriesBand` fills the ribbon between two line series,
  which is how a projection shows an uncertainty *range* rather than two unrelated forecast lines.
  The passes run bands, then fills, then every polyline, then the markers, so neither can cover a
  series it brackets. Pass a translucent alpha; an opaque fill hides whatever is behind it. A line
  that crosses the baseline is filled on both sides of it. Nothing checks that `seriesHi` is above
  `seriesLo`: where the two cross, the band pinches to a point, and where they coincide it has no
  width.
- **A band is carried, not drawn, while either edge is hidden** or has fewer than two points.
  Showing the series again brings the same band back. Bands name their series by index and are
  dropped wholesale by `tkChart_Clear`.
- **The series are clipped to the plot.** A smoothed line can overshoot its own data points; the
  overshoot is cut at the plot's edge.
- **A pie reads series 0 only.** Additional series on a pie chart are ignored.
- **`tkChart_SetPointExplode` is pie-only** and always addresses series 0.
- **A horizontal legend gets one row.** Entries that do not fit are dropped rather than drawn over
  the plot. A left or right legend is one column, capped at half the available width, and stops at
  its bottom edge. Use a left or right legend when you have many series.
- **Slice labels can be dropped.** In `CHT_PIEPLACE_INSIDE`, a label wider than its wedge's chord
  is not drawn at all. `CHT_PIEPLACE_AUTO` (the default) promotes those to an outside leader
  instead, and never drops one. `tkChart_GetSliceInfo` reports which happened to each slice.
- **A zero-valued column draws nothing** (a zero-height bar would put a stray hairline on the
  baseline where the data says there is nothing) and therefore cannot be hit-tested.
- **A zero-valued pie slice draws nothing**, has no sweep and cannot be hit.
- **The X axis is categorical**, except on scatter and bubble charts. Points are evenly spaced
  whatever their labels say, so a gap in a date sequence is not a gap on the axis; plot dates as
  numbers on a scatter chart when the gaps matter.
- **A paint callback replaces the entire renderer**: plot, axes, legend and chrome. Call
  `tkChart_PaintDefault` from it to draw the built-in chart and then add to it.
- **A disabled chart stops tracking the mouse.** `tkWidget_Enable( h, false )` clears the hot
  point (the hot-change callback sees `-1, -1`) and takes the tooltip down. The built-in renderer
  draws a disabled chart unchanged; a paint callback sees `isEnabled`.
- **Clicks do nothing.** Button messages are swallowed after your message callback has seen them.

## API reference

### Creation and type

| Function | Behaviour |
|---|---|
| `tkChart_Create( hParent, ctrlId, nChartType = TKCHART_TYPE_LINE ) as TK_WIDGET ptr` | Creates the chart as a child of `hParent`; position it with `tkWidget_SetPos`. An unrecognised `nChartType` falls back to `TKCHART_TYPE_LINE`. A `TKCHART_TYPE_DONUT` opens with a doughnut ratio of `TKCHART_DEFAULT_DONUTRATIO`. Returns 0 when `hParent` is 0. |
| `tkChart_GetChartType( hChart ) as long` | The `TKCHART_TYPE_*` fixed at creation. −1 for a handle that is not a chart. |

### Series

| Function | Behaviour |
|---|---|
| `tkChart_AddSeries( hChart, wszName = "" ) as long` | Appends a series and returns its index, or −1. The slot is fully reset, so a name, colour or style from a previously cleared series never leaks through. |
| `tkChart_GetSeriesCount( hChart ) as long` | How many series exist. |
| `tkChart_SetSeriesName( hChart, iSeries, wszName ) as boolean` | The legend text. False for a bad index. |
| `tkChart_GetSeriesName( hChart, iSeries ) as ustring` | `""` for a bad index. |
| `tkChart_SetSeriesColor( hChart, iSeries, clr ) as boolean` | Overrides the palette for this series. |
| `tkChart_ClearSeriesColor( hChart, iSeries ) as boolean` | Drops the override; the series goes back to palette entry `iSeries mod 10`. |
| `tkChart_SetSeriesLineWidth( hChart, iSeries, nWidth ) as boolean` | Line-chart pen width, unscaled. Clamped to a minimum of 1. Default 2. |
| `tkChart_SetSeriesFill( hChart, iSeries, clrFill, nAlpha ) as boolean` | Fills the area between a line series' polyline and the value baseline, the same baseline a column chart's bars stand on. `nAlpha` is 0–255, clamped. Off by default. |
| `tkChart_ClearSeriesFill( hChart, iSeries ) as boolean` | Turns the fill off. An alpha of 0 is a legal invisible fill, not a way off; this is the way off. |
| `tkChart_SetSeriesBand( hChart, seriesLo, seriesHi, clrFill, nAlpha ) as boolean` | Fills **between two line series**. The **pair is the identity**, in either order: setting a band for a pair that already has one replaces it rather than stacking a second fill in the same place. False for a bad index or for a series banded against itself. |
| `tkChart_ClearSeriesBand( hChart, seriesLo, seriesHi ) as boolean` | Takes the pair in either order. False when there was no band for that pair, so you can tell a removal from a no-op. |
| `tkChart_GetBandCount( hChart ) as long` | How many bands are set, drawn or not. |
| `tkChart_SetSeriesLineStyle( hChart, iSeries, nStyle ) as boolean` | Breaks a line series' stroke: one of the `CHT_LINE_*` constants. An unrecognised style is stored as `CHT_LINE_SOLID`, so what you read back is always something that draws. |
| `tkChart_GetSeriesLineStyle( hChart, iSeries ) as long` | `CHT_LINE_SOLID` for a bad index as well as for an unstyled series. |
| `tkChart_SetSeriesSymbol( hChart, iSeries, nSymbol, nSize = -1 ) as boolean` | A `CHT_SYM_*` marker at every vertex of a line series, in the point's colour when it has one. `nSize` is clamped to a minimum of 2; −1 keeps the current size. |
| `tkChart_SetSeriesSmooth( hChart, iSeries, bSmooth ) as boolean` | Draws the series as a cardinal spline through its points instead of straight segments. |
| `tkChart_SetSeriesVisible( hChart, iSeries, bVisible ) as boolean` | Hiding a series removes it from the **axis range** and the legend as well as from the drawing, so hiding an outlier rescales the chart. Also clears the hot point if it was in that series. |
| `tkChart_IsSeriesVisible( hChart, iSeries ) as boolean` | False for a bad index as well as for a hidden series. |
| `tkChart_SetSeriesKind( hChart, iSeries, nKind ) as boolean` | Combo charts: draw the series as `CHT_KIND_LINE` (the default), `CHT_KIND_COLUMN` or `CHT_KIND_AREA`. Stored on any chart, read only by a combo. False for a bad index or an unrecognised kind. |
| `tkChart_GetSeriesKind( hChart, iSeries ) as long` | −1 for a bad index. |
| `tkChart_SetSeriesAxis( hChart, iSeries, nAxis ) as boolean` | Combo charts: `CHT_AXIS_PRIMARY` (left, the default) or `CHT_AXIS_SECONDARY` (right). False for a bad index or an unrecognised axis. |
| `tkChart_GetSeriesAxis( hChart, iSeries ) as long` | −1 for a bad index. |

### Points

| Function | Behaviour |
|---|---|
| `tkChart_AddPoint( hChart, iSeries, wszLabel, fValue ) as long` | Appends a point; returns its index within the series, or −1. For line, column and pie charts. The slot is fully reset. |
| `tkChart_AddHlocPoint( hChart, iSeries, wszLabel, fOpenVal, fHighVal, fLowVal, fCloseVal ) as long` | Appends an HLOC or candlestick point. A high below its low is swapped into order. The point's value is set to the close, so a value query has one number without switching on the chart type. |
| `tkChart_AddXYPoint( hChart, iSeries, fX, fY, wszLabel = "" ) as long` | Scatter and bubble charts: a point at `fX`, `fY`. The value is `fY`; the label is for the tooltip. |
| `tkChart_AddBubblePoint( hChart, iSeries, fX, fY, fSize, wszLabel = "" ) as long` | Bubble charts: the same, with a size. The disc's **area** follows `abs( fSize )`. |
| `tkChart_SetPointX( hChart, iSeries, iPoint, fX ) as boolean` / `tkChart_GetPointX( ... ) as double` | A scatter or bubble point's X. |
| `tkChart_SetPointSize( hChart, iSeries, iPoint, fSize ) as boolean` / `tkChart_GetPointSize( ... ) as double` | A bubble point's size. |
| `tkChart_GetPointRadius( hChart, iSeries, iPoint ) as long` | A bubble's resolved radius in pixels; 0 on any other chart. Forces a pending layout. |
| `tkChart_GetPointCount( hChart, iSeries ) as long` | Points in that series; 0 for a bad index. |
| `tkChart_SetPointValue( hChart, iSeries, iPoint, fValue ) as boolean` | Line, column and pie value. Does not touch the four HLOC numbers. |
| `tkChart_GetPointValue( hChart, iSeries, iPoint ) as double` | 0 for a bad index. For an HLOC point this is the close. |
| `tkChart_SetPointLabel( hChart, iSeries, iPoint, wszLabel ) as boolean` | The category label. Only series 0's are drawn on the axis. |
| `tkChart_GetPointLabel( hChart, iSeries, iPoint ) as ustring` | `""` for a bad index. |
| `tkChart_SetPointColor( hChart, iSeries, iPoint, clr ) as boolean` | Overrides both the series colour and the palette for this one point: one highlighted bar, one wedge. |
| `tkChart_ClearPointColor( hChart, iSeries, iPoint ) as boolean` | Drops that override. |
| `tkChart_SetPointItemData( hChart, iSeries, iPoint, nData ) as boolean` | Your payload. Purely storage: it does **not** repaint. |
| `tkChart_GetPointItemData( hChart, iSeries, iPoint ) as integer` | 0 for a bad index. |
| `tkChart_SetPointExplode( hChart, iPoint, nOffset ) as boolean` | Pie only; always series 0. Pixels along the slice's bisector, clamped at 0. Layout reserves room for the largest offset before it cuts the pie's square, so the pie shrinks rather than the slice leaving the chart. |
| `tkChart_ClearPoints( hChart, iSeries ) as boolean` | Drops every point of one series, keeping the series and its styling. Clears the hot point if it was in that series. |
| `tkChart_Clear( hChart )` | Drops every series, point, band and the hot point. |

### Bulk population

| Function | Behaviour |
|---|---|
| `tkChart_BeginUpdate( hChart )` | Suspends repainting. |
| `tkChart_EndUpdate( hChart )` | Resumes it and repaints. **Nests**: a depth counter, not a flag, so a helper that brackets its own work does not end its caller's batch. Only the outermost `EndUpdate` repaints. Unbalanced extra calls are ignored. |
| `tkChart_GetUpdateDepth( hChart ) as long` | The current nesting depth; 0 outside a batch. |

### Value axis

| Function | Behaviour |
|---|---|
| `tkChart_SetAutoScale( hChart, bAuto )` | On by default. |
| `tkChart_GetAutoScale( hChart ) as boolean` | |
| `tkChart_SetValueRange( hChart, fLo, fHi )` | Fixes the range and turns **autoscaling off** as a side effect. An inverted or empty range is corrected to `fLo` … `fLo + 1`. |
| `tkChart_GetValueRange( hChart, byref fLo, byref fHi )` | The **resolved** range, autoscaled or not, which is wider than your data. Forces a pending layout. |
| `tkChart_GetValueStep( hChart ) as double` | The resolved gridline step. Forces a pending layout. |
| `tkChart_SetTickCountHint( hChart, nTicks )` | How many gridlines to aim for; a hint, not a count, because the step is snapped to 1/2/5×10ⁿ. Clamped 2…20 when used. Default 5. |
| `tkChart_SetGridLines( hChart, bHorz, bVert )` | Horizontal on, vertical off by default. Vertical gridlines are drawn at each category centre. |
| `tkChart_SetValueFormat( hChart, nDecimals, bThousands )` | `TKCHART_DECIMALS_AUTO` (−1, the default) derives the decimal count from the axis step; at most 8 are drawn. Thousands grouping is on by default, a plain `,` that does not depend on the locale, so the same data reads the same on every machine. |
| `tkChart_SetAxisLabelSkip( hChart, nSkip )` | `TKCHART_SKIP_AUTO` (0, the default) measures the widest label and works the stride out; 1 draws every label; N draws every Nth. Negative values are clamped to 0. |
| `tkChart_GetAxisLabelSkip( hChart ) as long` | The **resolved** stride actually in use, never 0. Forces a pending layout. |
| `tkChart_ValueToY( hChart, fValue ) as long` | The pixel row for a value, in the chart's own coordinates. The axis minimum maps exactly to the plot's bottom edge and the maximum exactly to its top. Values outside the range map outside the plot. |
| `tkChart_YToValue( hChart, y ) as double` | The inverse, to within a pixel. |
| `tkChart_ValueToX( hChart, fValue ) as long` | The horizontal value axis: an X value on a scatter or bubble chart, a value on a bar chart. The minimum maps exactly to the plot's left edge and the maximum to its right. |
| `tkChart_XToValue( hChart, x ) as double` | The inverse. |

### X axis (scatter and bubble)

| Function | Behaviour |
|---|---|
| `tkChart_SetXAutoScale( hChart, bAuto )` / `tkChart_GetXAutoScale( hChart ) as boolean` | On by default. |
| `tkChart_SetXRange( hChart, fLo, fHi )` | Fixes the X range and turns X autoscaling **off**. An inverted or empty range is corrected to `fLo` … `fLo + 1`. |
| `tkChart_GetXRange( hChart, byref fLo, byref fHi )` | The resolved X range. Forces a pending layout. |
| `tkChart_GetXStep( hChart ) as double` | The resolved X step. The X labels' decimals always follow it; `tkChart_SetValueFormat`'s count is for the value axis. |

The X labels are centred under their ticks, so the plot stops half the widest X label short of
the right padding to leave the last one room.

### Secondary value axis (combo)

| Function | Behaviour |
|---|---|
| `tkChart_SetSecondaryAutoScale( hChart, bAuto )` / `tkChart_GetSecondaryAutoScale( hChart ) as boolean` | On by default. |
| `tkChart_SetSecondaryValueRange( hChart, fLo, fHi )` | Fixes the secondary range and turns its autoscaling **off**. |
| `tkChart_GetSecondaryValueRange( hChart, byref fLo, byref fHi )` | The resolved range; 0 … 0 while no visible series reads the secondary axis. |
| `tkChart_GetSecondaryValueStep( hChart ) as double` | 0 while no visible series reads it. |
| `tkChart_SecondaryValueToY( hChart, fValue ) as long` | The secondary axis' row for a value; the primary's while no series reads the secondary. |

The secondary labels sit in a gutter right of the plot, left-aligned, as wide as the widest of
them. Gridlines follow the primary axis only.

### Title, subtitle, legend and fonts

| Function | Behaviour |
|---|---|
| `tkChart_SetTitle( hChart, wszText )` | Drawn left-aligned across the top, cut with an ellipsis when too long. An empty string reserves no space. |
| `tkChart_GetTitle( hChart ) as ustring` | |
| `tkChart_SetSubtitle( hChart, wszText )` | Drawn under the title, same rules. |
| `tkChart_GetSubtitle( hChart ) as ustring` | |
| `tkChart_SetLegendVisible( hChart, bVisible )` | Off by default. |
| `tkChart_IsLegendVisible( hChart ) as boolean` | |
| `tkChart_SetLegendPosition( hChart, nPos )` | A `CHT_LEGEND_*` edge. An unrecognised value is ignored and the position is left alone. |
| `tkChart_SetPadding( hChart, nPadding )` | Inset from the chart's edge on all four sides, in pixels, clamped at 0. Default 10, scaled. |
| `tkChart_SetFont( hChart, f )` | Axis, legend and slice labels. Borrowed: you still own and close it. |
| `tkChart_GetFont( hChart ) as TTF_Font ptr` | The label font you set; 0 when none is set and the host's default font is in use. |
| `tkChart_SetTitleFont( hChart, f )` | Falls back to the label font when unset. |
| `tkChart_SetSubtitleFont( hChart, f )` | Same. |
| `tkChart_ApplyFonts( hChart, fText, fGlyph )` | Sets the label font from `fText` (when not 0). The chart uses no glyph font, so `fGlyph` is ignored. This is how [tkApp](tkApp) hands a form's fonts to its controls. |

### Column, bar and area charts

| Function | Behaviour |
|---|---|
| `tkChart_SetColumnMode( hChart, nMode ) as boolean` | `CHT_COL_GROUPED` (the default), `CHT_COL_STACKED` or `CHT_COL_PERCENT`. An unrecognised mode falls back to grouped. Stacking rescales the value axis to the **stack totals**, 100 % to the category shares (the value-axis labels then carry a `%`); hit testing and `tkChart_GetPointRect` follow the segments, because they read the same rects the renderer draws. Read by column, bar and area charts. |
| `tkChart_GetColumnMode( hChart ) as long` | `CHT_COL_GROUPED` for a handle that is not a chart. |
| `tkChart_SetBarGap( hChart, nGap )` | Pixels between bars **within** one category group. Ignored when stacked: a stack is one bar however many series are piled up it. Clamped at 0. |
| `tkChart_SetGroupGapPercent( hChart, nPct )` | Percent of each category slot left empty between groups. Clamped 0…90. Default 25. |

A bar narrower than one pixel is drawn as a one-pixel hairline rather than vanishing: the chart
is too narrow for the data, and a hairline says so where nothing does not.

A **bar** chart is a column chart turned on its side: the category labels sit in a gutter left of
the plot, right-aligned (the stride now measured against the label's height), and the value
labels along the bottom. `tkChart_SetGridLines( h, bValue, bCategory )` keeps its meaning by
role, so the value gridlines run **down** the plot and the category ones across it.

An **area** series fills from its line down to zero (overlapping), or down to the pile beneath it
(stacked, 100 %). The fill is `tkChart_SetSeriesFill`'s colour when one is set, else the series
colour at alpha `TKCHART_DEFAULT_AREAALPHA`. Every fill is drawn before every edge.

### HLOC charts

| Function | Behaviour |
|---|---|
| `tkChart_SetHlocTickWidth( hChart, nWidth )` | The open/close tick's arm length per side, in pixels, clamped to a minimum of 1. |
| `tkChart_SetHlocUpDownColors( hChart, bEnable )` | Off by default (the whole series takes its series colour). On, a bar whose close is at or above its **own open** takes `UpColor` and one below takes `DownColor`; compared against its own open, not against the previous bar, so a bar means the same thing whether or not its neighbour is on screen. A per-point colour still wins over both. |

Each bar is a vertical high-to-low line with the open ticked to the left and the close ticked to
the right. The hit band is the whole category slot, not the one-pixel line.

A **candlestick** chart reads the same points. Each is a high-to-low wick and a body from the open
to the close, as wide as one grouped column (the group gap applies). A body closing at or above
its open is `UpColor`, one below `DownColor`, always; a per-point colour still wins. A doji (open
equal to close) is a 1 px body. The hit band and tooltip are the HLOC ones.

### Scatter and bubble charts

| Function | Behaviour |
|---|---|
| `tkChart_SetBubbleMaxSize( hChart, nRadius )` / `tkChart_GetBubbleMaxSize( hChart ) as long` | The largest bubble's radius in pixels at the current scale, rescaled with it. Default `TKCHART_DEFAULT_BUBBLEMAX` (24), scaled; clamped to a minimum of 1. |

A scatter point is a marker: the series' `tkChart_SetSeriesSymbol` symbol and size, or a circle
when the series has none. A bubble's radius is `nBubbleMax * sqr( abs( size ) / largest )`, the
largest `abs( size )` among the visible points, never under `TKCHART_DEFAULT_BUBBLEMIN` (3,
scaled). Each disc is filled translucent (`tkChart_SetSeriesFill`, else the series colour at alpha
`TKCHART_DEFAULT_BUBBLEALPHA`) and ringed in the series colour. A bubble is hit on its **disc**, not
its box, the last drawn first.

`tkChart_SetGridLines`' vertical flag draws gridlines at the X ticks, and a vertical zero rule is
drawn when X = 0 falls inside the plot.

### Pie charts

| Function | Behaviour |
|---|---|
| `tkChart_SetDoughnutRatio( hChart, fRatio )` | Hole radius as a fraction of the outer radius. Clamped 0.0…0.9; 0.0 is a solid pie. The hole is a hole for hit testing too. |
| `tkChart_GetDoughnutRatio( hChart ) as single` | |
| `tkChart_SetPieLabelMode( hChart, nMode )` | A `CHT_PIELABEL_*` mode. Default `CHT_PIELABEL_VALUE`. |
| `tkChart_SetPieLabelPlacement( hChart, nPlace )` | A `CHT_PIEPLACE_*` rule. Default `CHT_PIEPLACE_AUTO`. |
| `tkChart_SetPieStartAngle( hChart, fDegrees )` | Degrees: 0 is 3 o'clock and positive runs **clockwise**. Default −90, i.e. 12 o'clock. |
| `tkChart_SetPieSliceGap( hChart, nGap )` | Width of the separator stroked between wedges, in `SliceGapColor`. Default 1; 0 removes it. |
| `tkChart_GetSliceInfo( hChart, iPoint, byref fStart, byref fSweep, byref bLabelOut, byref bLabelHid ) as boolean` | Slice `iPoint`'s start and sweep in degrees, whether its label went outside on a leader, and whether it was dropped. Forces a pending layout. False for a bad index. |

| `tkChart_SetCenterText( hChart, wszText )` / `tkChart_GetCenterText( hChart ) as ustring` | Donut charts: the text in the hole, in the title font and `TitleColor`, centred in the square inscribed in the hole. `""` (the default) shows the total instead, formatted as a pie label (`CHT_FMT_PIELABEL`). |
| `tkChart_SetCenterTotal( hChart, bShow )` / `tkChart_GetCenterTotal( hChart ) as boolean` | Whether an empty centre text shows the total. On by default. Nothing is drawn while the ratio is 0. |

Everything else on this list applies to a **donut** exactly as to a pie: it *is* a pie that opens
with `TKCHART_DEFAULT_DONUTRATIO` and has a centre text.

Wedge sweeps come from the **absolute** value of each point over the sum of absolute values, so a
negative datum still gets a proportional slice instead of making the remaining wedges add up to
more than their total. Leader lines run from the wedge's rim, a short diagonal and then a
horizontal run into the text, and are drawn after every wedge so no neighbour paints over them.

### Colours

| Function | Behaviour |
|---|---|
| `tkChart_GetColors( hChart, pColors )` | Copies the struct out. Read-modify-write; there are no per-field setters. |
| `tkChart_SetColors( hChart, pColors )` | Copies it back in, **pins** it and repaints. |
| `tkChart_ThemeColors( t ) as TKCHART_COLORS` | The colour set a theme gives a chart. |
| `tkChart_ApplyTheme( hChart, t )` | Recolours from a theme. Does nothing while the colours are pinned. |
| `tkChart_UnpinColors( hChart )` | Drops the pin and re-applies the chart's current theme. |
| `tkChart_SetPaletteColor( hChart, idx, clr )` | Palette entry 0…9. An out-of-range index is ignored. |
| `tkChart_GetPaletteColor( hChart, idx ) as ulong` | 0 for an out-of-range index. |

### Query and hit testing

All coordinates are the chart's own, with 0, 0 at its top-left corner.

| Function | Behaviour |
|---|---|
| `tkChart_HitTest( hChart, x, y, byref iSeries, byref iPoint ) as boolean` | Both indices are set to −1 when nothing is there. Forces a pending layout. On the axis charts, later series are tested first so the series drawn on top answers; on a combo, lines before columns before areas, as they are drawn. On a pie or donut, the test accounts for the hole and for each slice's explode offset. |
| `tkChart_GetPlotRect( hChart, byref rc ) as boolean` | The plot area. |
| `tkChart_GetLegendRect`, `tkChart_GetTitleRect`, `tkChart_GetSubtitleRect` `( hChart, byref rc ) as boolean` | The legend block and the title and subtitle strips; empty when that part is off. |
| `tkChart_GetAxisYRect`, `tkChart_GetAxisXRect` `( hChart, byref rc ) as boolean` | The gutter left of the plot and the strip below it: value labels left and category labels below, or on a bar chart the reverse, or on a scatter chart value labels left and X labels below. Empty on a pie. |
| `tkChart_GetAxisY2Rect( hChart, byref rc ) as boolean` | A combo chart's secondary-axis gutter, right of the plot. Empty while no series reads that axis, and on every other type. |
| `tkChart_GetPieRect( hChart, byref rc ) as boolean` | The pie's square. Empty on every other type. |
| `tkChart_GetPointRect( hChart, iSeries, iPoint, byref rc ) as boolean` | The bar (or stacked segment) for a column or bar point, the full column band for an HLOC or candlestick point, the hit box around the vertex for a line, area or scatter point, the disc's box for a bubble, and the label box for a pie slice. Empty for a hidden series. |
| `tkChart_GetPointAnchor( hChart, iSeries, iPoint, byref pt ) as boolean` | The point's anchor: a line or area point's vertex (the top of its pile when stacked), a bar's value end, an HLOC or candle's close on its centre line, a scatter point's or bubble's centre, a pie slice's outer rim midpoint. |
| `tkChart_GetHotPoint( hChart, byref iSeries, byref iPoint ) as boolean` | The point currently under the mouse. Returns false when nothing is hot. Does **not** force a layout: it reports state, not geometry. |

The chart-part rect queries return false only for a handle that is not a chart;
`tkChart_GetPointRect` and `tkChart_GetPointAnchor` also return false for a bad index.

### Tooltips

The tip is a [tkTooltip](tkTooltip), and its text is resolved in this order: text you set with
`tkChart_SetTooltipText`, then your tooltip callback, then the chart's own description of the hot
point. There is no caption fallback; a chart has no caption of its own. The tip re-resolves for
each point the mouse moves to: moving to another point takes the tip down and brings it back up
with the new text.

The chart's own description is the point's label, a colon, and its value (just the value when
the point has no label). On a chart with more than one series, a named series' name precedes the
value; on a pie or a 100 % chart the share follows it as a percentage, `(23%)`; on an HLOC or
candlestick chart the value is all four numbers, `O … H … L … C …`; on a scatter chart it is
`x, y`, and a bubble adds its size, `x, y (size)`. A combo series on the secondary axis is
formatted at that axis' precision.

| Function | Behaviour |
|---|---|
| `tkChart_SetTooltipText( hChart, wszText )` | Fixed whole-chart text. Wins over the callback and over the per-point description. `""` restores them. |
| `tkChart_GetTooltipText( hChart ) as ustring` | |
| `tkChart_ResolveTooltipText( hChart ) as ustring` | What the tip would say now, by the order above. |
| `tkChart_GetTooltipHandle( hChart ) as TK_TIP ptr` | The chart's tip, for the tooltip's own styling functions. |
| `tkChart_SetHoverTime( hChart, ms )` | How long the mouse rests before the tip appears. |
| `tkChart_SetTapToInspect( hChart, bOn as boolean )` / `Get...` | Default FALSE. TRUE is for a touch screen, which has no hover: a tap picks the point under it -- or, off every point, the nearest one across inside the plot (a column's column, a line's vertex; on a bar chart the nearest **down** the categories, on a scatter or bubble chart the nearest by distance) -- makes it the hot point (`HotChange` fires) and shows its tip at once, until the next tap (on another point, on the same one, which lets it go, or off the plot). Moves and the leave are ignored meanwhile. Turning it off lets the point go. |

### Callback registration

| Function | Behaviour |
|---|---|
| `tkChart_SetPaintCallback( hChart, userfunc )` | Replaces the whole renderer. |
| `tkChart_PaintDefault( p )` | For use inside a paint callback: draws the built-in chart through `p->b`, over the background the chart has already filled. |
| `tkChart_SetMessageCallback( hChart, userfunc )` | Offered every message except `TKM_DESTROY`. |
| `tkChart_SetTooltipCallback( hChart, userfunc )` | Whole-chart tooltip text. |
| `tkChart_SetValueLabelCallback( hChart, userfunc )` | Formats numbers for the axis, pie labels and tooltips. |
| `tkChart_SetHotChangeCallback( hChart, userfunc )` | The hot point changed. |

Passing 0 to any of these removes the callback.

### Render probes

These render the chart through the **same** function `TKM_PAINT` uses, into the host's back buffer
at the chart's place, and read the pixels back before anything is presented. They exist so a
regression check measures what is actually drawn rather than a parallel implementation of it.

| Function | Behaviour |
|---|---|
| `tkChart_CountRenderedTones( hChart ) as long` | How many distinct colours appear on a fixed 32×32 sample grid, capped at 64. A useful "did anything get drawn" check: an empty chart still returns at least its background and its gridlines, and adding data raises the count. |
| `tkChart_HashRenderedPart( hChart ) as ulong` | An FNV-1a hash of the same sample. Identical state hashes identically; any visible change to the sampled pixels changes it. |
| `tkChart_GetRenderedPixel( hChart, x, y ) as ulong` | The colour of one rendered pixel, opaque. This is what lets a test assert a fill arithmetically (sample a point that must be inside it and one that must not) instead of judging a screenshot. 0 for a point outside the chart. |
| `tkChart_CountPlotInkPixels( hChart, clrBack ) as long` | How many pixels inside the plot rect are **not** `clrBack`: the series' ink, when you pass the plot background. Every pixel of the rect, not a sample grid, because a 32×32 grid is far too coarse to see a dash pattern. That makes it a *test* probe with no business near a repaint. |

All four return 0 when the chart has no size yet.

## Colors

`TKCHART_COLORS`, read and written whole:

```freebasic
dim as TKCHART_COLORS clrs
tkChart_GetColors( hChart, @clrs )
clrs.BackColor = tkRGB( 255, 255, 255 )
clrs.GridColor = tkRGB( 220, 220, 220 )
tkChart_SetColors( hChart, @clrs )
```

A new chart takes its colours from its [tkTheme](tkTheme) and recolours itself on
`TKM_THEMECHANGED`. `tkChart_SetColors` pins the set, so a theme change leaves it alone until
`tkChart_UnpinColors`. The struct's own initialisers are a dark set, used only by a
`TKCHART_COLORS` you declare yourself.

| Field | Paints | Theme role |
|---|---|---|
| `BackColor` | The whole chart. | `Window` |
| `PlotBackColor` | The plot rect, and only when it differs from `BackColor`: set it apart to make the plot area stand out. | `Window` |
| `GridColor` | Value gridlines, and category (or X) gridlines when those are on. | `Divider` |
| `AxisColor` | The baseline rule under the plot (left of it on a bar chart), and the zero rule when zero falls inside the plot. | `Border` |
| `LabelColor` | Every axis' text. | `TextDim` |
| `TitleColor` | The title, and a donut's centre text. | `Text` |
| `SubtitleColor` | The subtitle. | `TextDim` |
| `LegendTextColor` | Legend entry names. Swatches take the series or slice colour. | `Text` |
| `SliceLabelColor` | Pie labels drawn **inside** a wedge. | `SelectedText` |
| `SliceLabelOutColor` | Pie labels drawn **outside**, over the chart background. | `Text` |
| `LeaderColor` | Leader lines to outside pie labels. | `TextDim` |
| `SliceGapColor` | The separator stroked between pie wedges. Normally equal to the background. | `Window` |
| `UpColor` | Candles closing at or above their open; HLOC bars too, when `tkChart_SetHlocUpDownColors` turned them on. | `Success` |
| `DownColor` | Candles and (same condition) HLOC bars closing below their open. | `Error` |
| `ForeColorDisabled` | Not consulted by the built-in renderer; a paint callback can use it, and sees the state in `isEnabled`. | `TextDisabled` |

`SliceGapColor` takes the same role as `BackColor`, which is what makes the default pie read as
wedges separated by the background rather than as an outlined disc.

Series colours are **not** in this struct, and no theme touches them: they are data. They resolve
in this order: an explicit per-point colour, then an explicit per-series colour, then the palette.
On a pie the palette is indexed by **point**; everywhere else by series. The ten palette defaults
are a blue, orange, green, magenta, yellow, teal, red, periwinkle, tan and grey, wrapping after
ten.

## Callbacks

### Paint

```freebasic
type CHT_PaintCallbackSub as sub( byval p as TKCHART_PAINTINFO ptr )
```

Fires once per repaint, after the chart has filled its background with `BackColor` and resolved
every rect. **Supplying one replaces the entire built-in renderer**: the plot, the axes, the
gridlines, the legend and the chrome. Draw the chart yourself, or call `tkChart_PaintDefault( p )`
to draw the built-in one and then add to it.

Draw through `p->b`, the chart's [tkPaint](tkPaint) surface for this repaint, in the chart's own
coordinates.

Every sentinel is already resolved: `fMin` / `fMax` / `fStep` are the real range even when
autoscaling, `nDecimals` is the derived count and never −1, and `nLabelStride` is the measured
skip and never 0.

#### `TKCHART_PAINTINFO`

| Field | Meaning |
|---|---|
| `hChart` | The chart. |
| `b` | Its `TK_PAINT ptr` for this repaint. |
| `rcClient` | The whole chart rect. |
| `rcPlot` | The plot area. |
| `rcTitle` | The title strip; empty when there is no title. |
| `rcSubtitle` | The subtitle strip; empty when there is none. |
| `rcLegend` | The legend block; empty when the legend is off. |
| `rcAxisX` | The strip below the plot: category labels, or the value labels on a bar chart, or the X labels on a scatter chart. Empty on a pie. |
| `rcAxisY` | The gutter left of the plot: value labels, or the category labels on a bar chart. Empty on a pie. |
| `rcPie` | The pie's square. Empty on every other type. |
| `nChartType` | The `TKCHART_TYPE_*`. |
| `fMin`, `fMax`, `fStep` | The resolved value axis. |
| `nDecimals` | Resolved decimal places for value labels. |
| `nOriginY` | The pixel row of value 0, clamped into the plot. |
| `nCatCount` | Categories on the X axis. |
| `nLabelStride` | Draw category label *i* when `i mod nLabelStride = 0`. |
| `nHotSeries`, `nHotPoint` | The point under the mouse; −1 when none. |
| `isEnabled` | False while the chart is disabled. |
| `wszTitle`, `wszSubtitle` | The strings, so you need not query them. |
| `rcAxisY2` | A combo chart's secondary gutter, right of the plot; empty otherwise. |
| `fMin2`, `fMax2`, `fStep2`, `nOriginY2` | The secondary axis, resolved, and its zero row, clamped. Only meaningful while `rcAxisY2` is not empty. |
| `fXMin`, `fXMax`, `fXStep` | A scatter or bubble chart's X axis, resolved. |
| `nOriginX` | The pixel column of 0 on the horizontal value axis (bar, scatter, bubble), clamped into the plot. |

### Message

```freebasic
type CHT_MessageCallbackFunc as function( byval m as TKCHART_MESSAGEINFO ptr ) as boolean
```

Fires for every message the chart receives **except** `TKM_DESTROY`: offering that one would let a
callback suppress the cleanup that frees the state it is holding a pointer to. Return true to
suppress the chart's own handling of that message (returning true for `TKM_MOUSEMOVE`, for
instance, stops hot tracking), false to let it proceed.

`TKM_LBUTTONUP`'s return value is **ignored**, so a callback that swallows it can never strand a
press that something else is waiting to see released.

#### `TKCHART_MESSAGEINFO`

| Field | Meaning |
|---|---|
| `hChart` | The chart. |
| `msg` | The `TKM_*` message. |
| `x`, `y` | The mouse position, in the chart's coordinates, for mouse messages. |
| `key`, `mods`, `clicks` | The key, modifier state and click count the message carries. |
| `iSeries`, `iPoint` | The currently hot point, so you need not repeat the hit test; −1 when none. |

### Tooltip

```freebasic
type CHT_TooltipCallbackFunc as function( byval hChart as TK_WIDGET ptr ) as ustring
```

Consulted when no text was set with `tkChart_SetTooltipText`. Return `""` to fall through to the
chart's own description of the hot point. Call `tkChart_GetHotPoint` inside it to find out what
the mouse is over.

### Value label

```freebasic
type CHT_ValueLabelCallbackFunc as function( byval hChart as TK_WIDGET ptr, byval fValue as double, _
                                             byval nContext as long ) as ustring
```

Formats one number. `nContext` is `CHT_FMT_AXIS`, `CHT_FMT_PIELABEL`, `CHT_FMT_TOOLTIP`,
`CHT_FMT_XAXIS` (a scatter chart's X labels) or `CHT_FMT_AXIS2` (a combo chart's secondary
labels), so one function can format an axis tick and a tooltip differently. Return `""` to fall
back to the chart's own formatting, which lets you special-case a few values without formatting
all of them. A 100 % chart's value axis gets the share (0 … 100) and adds no `%` to what you
return.

Axis labels are measured to size the value gutter, so a callback that returns much wider strings
widens the gutter rather than overlapping the plot.

### Hot change

```freebasic
type CHT_HotChangeCallbackSub as sub( byval hChart as TK_WIDGET ptr, byval iSeries as long, _
                                      byval iPoint as long )
```

Fires when the data point under the mouse changes, including to `-1, -1` when the mouse leaves
the data or the chart, or the chart is disabled. Hiding a series, clearing its points or
`tkChart_Clear` reset the hot point without firing it. It fires *after* the state is updated, so
`tkChart_GetHotPoint` inside the handler already reports the new point.

## Constants

### Chart type

| Constant | Meaning |
|---|---|
| `TKCHART_TYPE_LINE` | Polyline or spline per series. The default. |
| `TKCHART_TYPE_COLUMN` | Vertical bars, series grouped, stacked or 100 % per category. |
| `TKCHART_TYPE_HLOC` | High-low-open-close price bars. |
| `TKCHART_TYPE_PIE` | Wedges from series 0; optionally a doughnut. |
| `TKCHART_TYPE_AREA` | A filled region per series, overlapping, stacked or 100 %. |
| `TKCHART_TYPE_SCATTER` | Markers on a numeric X axis. |
| `TKCHART_TYPE_BUBBLE` | Discs on a numeric X axis, area by a third number. |
| `TKCHART_TYPE_DONUT` | A pie with a hole and a centre total. |
| `TKCHART_TYPE_BAR` | Horizontal bars, grouped, stacked or 100 %. |
| `TKCHART_TYPE_COMBO` | Line, column and area series together, on two value axes. |
| `TKCHART_TYPE_CANDLESTICK` | HLOC data as candles. |

The first four values are the port's and keep their numbers; the rest follow them.

### Line symbols

`CHT_SYM_NONE` (the default), `CHT_SYM_CIRCLE`, `CHT_SYM_SQUARE`, `CHT_SYM_DIAMOND`,
`CHT_SYM_TRIANGLE`. Default size `TKCHART_DEFAULT_SYMBOLSIZE`, scaled. A scatter series with
`CHT_SYM_NONE` draws circles.

### Column mode

`CHT_COL_GROUPED` (the default), `CHT_COL_STACKED` and `CHT_COL_PERCENT`. Column, bar and area
charts.

### Series kind and axis (combo)

`CHT_KIND_LINE` (the default), `CHT_KIND_COLUMN`, `CHT_KIND_AREA`; `CHT_AXIS_PRIMARY` (the default,
left) and `CHT_AXIS_SECONDARY` (right).

### Line styles

`CHT_LINE_SOLID` (the default), `CHT_LINE_DASH`, `CHT_LINE_DOT`, `CHT_LINE_DASHDOT`. Line series
only. The dash lengths are in **pen-width units**, so one style reads the same at 1 px and at
3 px. Use a style rather than a second colour when the two runs are the same quantity: a forecast
drawn in a different colour reads as different data.

### Legend position

`CHT_LEGEND_BOTTOM` (the default), `CHT_LEGEND_TOP`, `CHT_LEGEND_LEFT`, `CHT_LEGEND_RIGHT`.
Top and bottom lay the entries out in one row; left and right in a column.

### Pie label mode

| Constant | Label reads |
|---|---|
| `CHT_PIELABEL_NONE` | nothing |
| `CHT_PIELABEL_VALUE` | the formatted value (the default) |
| `CHT_PIELABEL_PERCENT` | `23%` |
| `CHT_PIELABEL_NAME` | the point's label |
| `CHT_PIELABEL_NAME_PERCENT` | `Oranges 23%` |

### Pie label placement

| Constant | Behaviour |
|---|---|
| `CHT_PIEPLACE_INSIDE` | Inside the wedge, and **dropped** when it does not fit. |
| `CHT_PIEPLACE_OUTSIDE` | Always outside the rim, on a leader. |
| `CHT_PIEPLACE_AUTO` | Inside when it fits, promoted to an outside leader when it does not. The default, and the only one that never drops a label. |

### Value-label context

`CHT_FMT_AXIS`, `CHT_FMT_PIELABEL`, `CHT_FMT_TOOLTIP`, `CHT_FMT_XAXIS`, `CHT_FMT_AXIS2`.

### Sentinels

| Constant | Value | Meaning |
|---|---|---|
| `TKCHART_DECIMALS_AUTO` | −1 | Derive the decimal count from the axis step. 0 is a real request for none. |
| `TKCHART_SKIP_AUTO` | 0 | Measure the labels and work the stride out. 1 is a real request for every label. |
| `TKCHART_PALETTE_COUNT` | 10 | Palette entries before it wraps. |

### Defaults

| Constant | Value | Sets |
|---|---|---|
| `TKCHART_DEFAULT_PADDING` | 10 | Inset from the chart's edge. |
| `TKCHART_DEFAULT_CHROMEGAP` | 6 | Space between the title, subtitle, legend and plot. |
| `TKCHART_DEFAULT_TICKLEN` | 4 | Space between the axis labels and the plot. |
| `TKCHART_DEFAULT_BARGAP` | 1 | Space between grouped bars. |
| `TKCHART_DEFAULT_GROUPGAPPCT` | 25 | Percent of a category slot left between groups. |
| `TKCHART_DEFAULT_HLOCTICK` | 3 | HLOC tick arm length. |
| `TKCHART_DEFAULT_LINEWIDTH` | 2 | Line series pen width. |
| `TKCHART_DEFAULT_SYMBOLSIZE` | 6 | Line symbol size. |
| `TKCHART_DEFAULT_PIEGAP` | 1 | Pie slice separator width. |
| `TKCHART_DEFAULT_TICKHINT` | 5 | Gridlines to aim for. |
| `TKCHART_DEFAULT_LABELGAP` | 8 | Minimum space between category labels when the stride is worked out. |
| `TKCHART_DEFAULT_HITRADIUS` | 8 | Half-size of a line, area or scatter point's hit box. |
| `TKCHART_DEFAULT_BUBBLEMAX` | 24 | The largest bubble's radius. |
| `TKCHART_DEFAULT_BUBBLEMIN` | 3 | The smallest bubble's radius. |
| `TKCHART_DEFAULT_AREAALPHA` | 140 | An area series' fill alpha when it has no fill of its own. Not a size. |
| `TKCHART_DEFAULT_BUBBLEALPHA` | 170 | A bubble's fill alpha, likewise. |
| `TKCHART_DEFAULT_DONUTRATIO` | 0.55 | A donut's hole, as a fraction of its radius. Not a size. |

The pixel sizes are multiplied by the host's scale, except `TKCHART_DEFAULT_LINEWIDTH` and
`TKCHART_DEFAULT_PIEGAP`, whose pens the drawing surface scales when it draws them.

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
const TKCHART_DEFAULT_BUBBLEMAX = 24 ' the largest bubble's radius, px
const TKCHART_DEFAULT_BUBBLEMIN = 3 ' the smallest one's, px
const TKCHART_DEFAULT_AREAALPHA = 140 ' an AREA series' fill unless SetSeriesFill says
const TKCHART_DEFAULT_BUBBLEALPHA = 170
const TKCHART_DEFAULT_DONUTRATIO = 0.55
const TKCHART_PALETTE_COUNT = 10
const TKCHART_DECIMALS_AUTO = -1
const TKCHART_SKIP_AUTO = 0

enum
    TKCHART_TYPE_LINE = 0
    TKCHART_TYPE_COLUMN
    TKCHART_TYPE_HLOC
    TKCHART_TYPE_PIE
    TKCHART_TYPE_AREA
    TKCHART_TYPE_SCATTER
    TKCHART_TYPE_BUBBLE
    TKCHART_TYPE_DONUT
    TKCHART_TYPE_BAR
    TKCHART_TYPE_COMBO
    TKCHART_TYPE_CANDLESTICK
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
    CHT_COL_PERCENT
end enum

enum
    CHT_KIND_LINE = 0
    CHT_KIND_COLUMN
    CHT_KIND_AREA
end enum

enum
    CHT_AXIS_PRIMARY = 0
    CHT_AXIS_SECONDARY
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
    CHT_FMT_XAXIS
    CHT_FMT_AXIS2
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
    Value      as double       ' line / column / pie / Y of scatter; the close for HLOC
    XVal       as double       ' SCATTER / BUBBLE
    SizeVal    as double       ' BUBBLE
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
    fStackFrom as double       ' column / bar / area: the span in value space -- 0 to the value,
    fStackTo   as double       ' or where it sits on its category's pile (stacked, 100 %)
    ptBase     as TKPOINT      ' area: the vertex on the lower edge
    nRadius    as long         ' bubble: px
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
    nKind       as long = CHT_KIND_LINE         ' COMBO only
    nAxis       as long = CHT_AXIS_PRIMARY      ' COMBO only
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
    rcAxisY2      as TKRECT       ' COMBO: the secondary axis gutter, right
    fMin2         as double
    fMax2         as double
    fStep2        as double
    nOriginY2     as long
    fXMin         as double       ' SCATTER / BUBBLE
    fXMax         as double
    fXStep        as double
    nOriginX      as long         ' BAR / SCATTER / BUBBLE: 0 on the horizontal axis, clamped
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
function tkChart_SetSeriesKind( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval nKind as long ) as boolean
function tkChart_GetSeriesKind( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as long
function tkChart_SetSeriesAxis( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval nAxis as long ) as boolean
function tkChart_GetSeriesAxis( byval hChart as TK_WIDGET ptr, byval iSeries as long ) as long
function tkChart_AddPoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval wszLabel as ustring, byval fValue as double ) as long
function tkChart_AddHlocPoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval wszLabel as ustring, byval fOpenVal as double, byval fHighVal as double, byval fLowVal as double, byval fCloseVal as double ) as long
function tkChart_AddXYPoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval fX as double, byval fY as double, byval wszLabel as ustring = "" ) as long
function tkChart_AddBubblePoint( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval fX as double, byval fY as double, byval fSize as double, byval wszLabel as ustring = "" ) as long
function tkChart_SetPointX( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval fX as double ) as boolean
function tkChart_GetPointX( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as double
function tkChart_SetPointSize( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byval fSize as double ) as boolean
function tkChart_GetPointSize( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as double
function tkChart_GetPointRadius( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long ) as long
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
function tkChart_ValueToX( byval hChart as TK_WIDGET ptr, byval fValue as double ) as long
function tkChart_XToValue( byval hChart as TK_WIDGET ptr, byval x as long ) as double
sub tkChart_SetXAutoScale( byval hChart as TK_WIDGET ptr, byval bAuto as boolean )
function tkChart_GetXAutoScale( byval hChart as TK_WIDGET ptr ) as boolean
sub tkChart_SetXRange( byval hChart as TK_WIDGET ptr, byval fLo as double, byval fHi as double )
sub tkChart_GetXRange( byval hChart as TK_WIDGET ptr, byref fLo as double, byref fHi as double )
function tkChart_GetXStep( byval hChart as TK_WIDGET ptr ) as double
sub tkChart_SetSecondaryAutoScale( byval hChart as TK_WIDGET ptr, byval bAuto as boolean )
function tkChart_GetSecondaryAutoScale( byval hChart as TK_WIDGET ptr ) as boolean
sub tkChart_SetSecondaryValueRange( byval hChart as TK_WIDGET ptr, byval fLo as double, byval fHi as double )
sub tkChart_GetSecondaryValueRange( byval hChart as TK_WIDGET ptr, byref fLo as double, byref fHi as double )
function tkChart_GetSecondaryValueStep( byval hChart as TK_WIDGET ptr ) as double
function tkChart_SecondaryValueToY( byval hChart as TK_WIDGET ptr, byval fValue as double ) as long
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
sub tkChart_SetCenterText( byval hChart as TK_WIDGET ptr, byval wszText as ustring )
function tkChart_GetCenterText( byval hChart as TK_WIDGET ptr ) as ustring
sub tkChart_SetCenterTotal( byval hChart as TK_WIDGET ptr, byval bShow as boolean )
function tkChart_GetCenterTotal( byval hChart as TK_WIDGET ptr ) as boolean
sub tkChart_SetBubbleMaxSize( byval hChart as TK_WIDGET ptr, byval nRadius as long )
function tkChart_GetBubbleMaxSize( byval hChart as TK_WIDGET ptr ) as long
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
function tkChart_GetAxisY2Rect( byval hChart as TK_WIDGET ptr, byref rc as TKRECT ) as boolean
function tkChart_GetPointRect( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byref rc as TKRECT ) as boolean
function tkChart_GetPointAnchor( byval hChart as TK_WIDGET ptr, byval iSeries as long, byval iPoint as long, byref pt as TKPOINT ) as boolean
function tkChart_GetHotPoint( byval hChart as TK_WIDGET ptr, byref iSeries as long, byref iPoint as long ) as boolean
sub tkChart_SetTooltipText( byval hChart as TK_WIDGET ptr, byval wszText as ustring )
function tkChart_GetTooltipText( byval hChart as TK_WIDGET ptr ) as ustring
function tkChart_ResolveTooltipText( byval hChart as TK_WIDGET ptr ) as ustring
function tkChart_GetTooltipHandle( byval hChart as TK_WIDGET ptr ) as TK_TIP ptr
sub tkChart_SetTapToInspect( byval hChart as TK_WIDGET ptr, byval bOn as boolean )
function tkChart_GetTapToInspect( byval hChart as TK_WIDGET ptr ) as boolean
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
- [tkApp](tkApp), [tkHost](tkHost), [tkPaint](tkPaint), [tkTheme](tkTheme), [tkTooltip](tkTooltip)
