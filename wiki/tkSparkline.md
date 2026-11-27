[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkSparkline**

# tkSparkline

Draws a word-sized chart of one series: a line, an area, columns or win / loss.

`tkSparkline` is the [tkControls](Category-tkControls) sparkline. It shows the shape of a series
in the space of a word or a table cell, with no axes, labels or legend. It has four kinds:

| Kind | What it draws |
| --- | --- |
| `TKSPARK_LINE` | a line through the points, the first on the plot's left edge and the last on its right |
| `TKSPARK_AREA` | the line, filled down to the baseline |
| `TKSPARK_COLUMN` | a bar per point, up or down from the baseline, on whole pixels |
| `TKSPARK_WINLOSS` | the sign only: a bar up for a positive point, down for a negative one, nothing for zero |

A series can have missing points, drawn as a gap, as zero or joined across. A sparkline can also show:

- markers on its high, low, first, last and negative points
- a zero axis, a reference line and a shaded normal band
- the last value as text at its right end
- a rolling window for live data: `SetMaxPoints`, then `AddValue` as each sample comes

The point under the mouse is hot: it is marked and has its own tooltip. The range is the data's own
minimum and maximum unless you set one.

A sparkline is a display control. It takes no focus and no keys, every setter is silent, and Click
is its only event. The Form Designer's **Sparkline** binds its series, load only. A
[tkDataGrid](tkDataGrid) column and a [tkReport](tkReport) item draw sparklines with the same
painter, and `tkSparkline_PaintInto` draws one anywhere with no widget at all.

## Importing

```freebasic
#import "vendor/tkControls/tkSparkline"

using tkSparkline
using tkHost
using tkPaint             ' TK_PAINT, TKRECT: a paint callback, PaintInto
using tkTheme             ' TKTHEME_COLORS: ThemeColors, ApplyTheme
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3 and SDL_ttf),
[tkTheme](tkTheme), [tkTooltip](tkTooltip) and [tkPrint](tkPrint), all publicly. It links no
library of its own.

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example,
with the imports above.

```freebasic
function Sales_Tip( byval hSpark as TK_WIDGET ptr, byval i as int32, byval v as float64 ) as ustring
    return "Month " & (i + 1) & ": " & tkSparkline_FormatValue( v, 0 ) & "k"
end function

sub Spark_Click( byval hSpark as TK_WIDGET ptr, byval id as int32 )
    print "sparkline " & id & " clicked"
end sub

' a year of sales: a line, its high, low and last points marked, the last value as text
dim as TK_WIDGET ptr sales = tkSparkline_Create( tkHost_Root( host ), 100 )
tkSparkline_SetDataText( sales, "12,14,13,17,16,19,22,21,24,23,26,28" )
tkSparkline_SetMarkers( sales, TKSPARK_MK_HIGH or TKSPARK_MK_LOW or TKSPARK_MK_LAST )
tkSparkline_SetShowLastValue( sales, true )
tkSparkline_SetTooltipCallback( sales, @Sales_Tip )
tkSparkline_SetClickCallback( sales, @Spark_Click )
tkWidget_SetPos( sales, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), tkHost_Scale( host, 200 ), tkHost_Scale( host, 32 ) )

' profit and loss by month: columns, the losses below a zero axis
dim as float64 pnl(0 to 11) = { 4, -2, 6, 3, -5, 7, 2, -1, 5, 8, -3, 4 }
dim as TK_WIDGET ptr cols = tkSparkline_Create( tkHost_Root( host ), 101, TKSPARK_COLUMN )
tkSparkline_SetData( cols, @pnl(0), 12 )
tkSparkline_SetShowAxis( cols, true )
tkWidget_SetPos( cols, tkHost_Scale( host, 20 ), tkHost_Scale( host, 64 ), tkHost_Scale( host, 200 ), tkHost_Scale( host, 32 ) )

' a live reading: the newest 60 samples on a fixed 0..100 scale, a normal band behind them
dim as TK_WIDGET ptr cpu = tkSparkline_Create( tkHost_Root( host ), 102, TKSPARK_AREA )
tkSparkline_SetMaxPoints( cpu, 60 )
tkSparkline_SetRange( cpu, 0, 100 )
tkSparkline_SetNormalBand( cpu, 20, 60 )
tkSparkline_SetReference( cpu, 80 )
tkWidget_SetPos( cpu, tkHost_Scale( host, 20 ), tkHost_Scale( host, 108 ), tkHost_Scale( host, 200 ), tkHost_Scale( host, 32 ) )

for i as int32 = 1 to 80                              ' in a real program, a timer adds each one
    if (i mod 25) = 0 then
        tkSparkline_AddGap( cpu )                     ' a sample that did not arrive
    else
        tkSparkline_AddValue( cpu, 45 + 30 * sin( i / 5 ) )
    end if
next

print tkSparkline_GetCount( cpu )                     ' 60: the oldest 20 dropped
print tkSparkline_GetMarkerIndex( sales, TKSPARK_MK_HIGH )   ' 11, the last month
```

`examples/tkControls/tkSparkline/demo.tiko` shows every kind, the three empty modes, a live feed
every 100 ms and a table drawn with no widgets. Click a sparkline there to cycle its kind.

## The series

A series is a list of values, each of which is either **present** or **missing**. The sparkline
keeps its own copy, so the array you pass can go away.

### The text form

`tkSparkline_SetDataText( h, "3,5,,2 4;7" )` sets a series from text. The Form Designer, a bound
field, a grid cell and a report item use the same form.

- **Separators** are `,`, `;` and runs of blanks (spaces, tabs, line breaks). A blank beside a `,`
  or `;` is not a separator of its own, so `3, 5` is two points.
- **An empty field is a missing point**: `3,5,,2` has four points, the third missing. A field that
  does not start with a digit, a sign or `.` is missing too (`n/a`).
- **Numbers** use `.` for the decimals. A lone `-`, `+` or `.` reads as 0.
- **Empty text** is an empty series.

`tkSparkline_GetDataText` gives the series back, each present value as `str` writes it and each
missing one empty: `3,5,,2,4,7`. It reads back into the same series, but not always into the same
text (`1.50` comes back as `1.5`, blanks as commas).

### SetData, AddValue, AddGap, MaxPoints

| Call | Does |
| --- | --- |
| `SetData( h, pValues, n )` | copies n values, every one present. `n <= 0` or a null pointer clears |
| `SetDataText( h, text )` | the text form above |
| `AddValue( h, v )` | appends a present point |
| `AddGap( h )` | appends a missing point: a sample that did not arrive |
| `Clear( h )` | empties the series |
| `SetMaxPoints( h, n )` | keeps the newest n points and drops the oldest, now and after each later change; 0 (the default) keeps them all |

A rolling window is `SetMaxPoints` and then `AddValue` (or `AddGap`) from a timer, as each sample
comes. Pair it with a manual range (`SetRange`) so the scale stays still while the data moves.

`GetCount` gives the number of points, missing ones included. `GetValue( h, i )` gives point i's
value, and 0 for a missing point; `IsPresent( h, i )` tells the two apart.

### Missing points

`tkSparkline_SetEmptyMode` sets how a missing point is drawn. These are Excel's three:

| Mode | LINE and AREA | COLUMN and WINLOSS |
| --- | --- | --- |
| `TKSPARK_EMPTY_GAP` (the default) | the line breaks; a point alone between two gaps is drawn as a dot | an empty slot |
| `TKSPARK_EMPTY_ZERO` | the point is drawn at 0, and 0 counts in the automatic range | a column 1 pixel tall at 0; no win or loss |
| `TKSPARK_EMPTY_CONNECT` | the line joins the points on either side | an empty slot |

The high, low, first and last points are always present points, whatever the mode.

## Kinds

`tkSparkline_Create( parent, id, kind )` picks the kind; LINE is the default. `tkSparkline_SetKind`
changes it, and a kind out of range is ignored.

- **The baseline** is 0 when the range holds 0. Otherwise it is the end of the range nearer 0: the
  minimum for an all-positive series, the maximum for an all-negative one. AREA fills to it and
  COLUMN draws its bars from it.
- **LINE and AREA** place the points evenly, the first on the plot's left edge and the last on its
  right. Room for a marker is kept round the plot, so the end markers are not cut off.
  `SetLineWidth` sets the line's width in design units (default 1.5). The joins are round up to
  `TKSPARK_ROUNDJOIN_MAX` (200) points with an opaque line colour, and mitred beyond that or with a
  translucent one.
- **AREA** fills in FillColor, the accent at a quarter alpha by default. Where the line crosses the
  baseline the fill is cut there, so the parts above and below are each filled on their own side.
- **COLUMN** gives each point an equal slot and a bar on whole pixels, `SetColumnGap` design units
  apart (default 1; 0 makes them touch). A negative bar is in NegativeColor. A value on the baseline
  is still drawn 1 pixel tall, so no point is invisible.
- **WINLOSS** draws only the sign. A positive point is a bar in the top half, a negative one a bar
  in the bottom half in NegativeColor, and a zero nothing. The range does not change it.

## Range

The range is **automatic** by default: the minimum and maximum of the drawn values, with no
rounding, so the highest point touches the top of the plot and the lowest the bottom.

- **A flat series** is opened by 10 % either way, or by 1 either way at 0.
- **An empty series** has the range 0 to 1.

`tkSparkline_SetRange( h, lo, hi )` sets a **manual** range and turns the automatic one off. An
inverted pair is swapped. `SetAutoRange( h, true )` goes back to the automatic range, and
`SetAutoRange( h, false )` returns to the last manual one. A value outside a manual range is cut
off at the plot's edge. `tkSparkline_GetRange` gives the range in force either way.

**To compare sparklines**, give them all the same `SetRange`. A [DataGrid](#in-a-datagrid) column
does this for its rows by itself.

## Decoration

### Markers

`tkSparkline_SetMarkers( h, bits )` marks points with dots, `MarkerSize` design units across
(default 5). The bits are:

| Bit | Marks | Colour |
| --- | --- | --- |
| `TKSPARK_MK_HIGH` | the highest point | HighColor |
| `TKSPARK_MK_LOW` | the lowest point | LowColor |
| `TKSPARK_MK_FIRST` | the first present point | FirstColor |
| `TKSPARK_MK_LAST` | the last present point | LastColor |
| `TKSPARK_MK_NEGATIVE` | every negative point | NegativeColor |
| `TKSPARK_MK_ALL` | every present point | LineColor |

- Markers are drawn on LINE and AREA. A COLUMN or WINLOSS sparkline shows its negatives in
  NegativeColor instead.
- When two points tie for the high or the low, the first one wins.
- A point that is several markers at once takes the first colour in this order: high, low, last,
  first, negative, all.
- `SetMarkersText( h, "high,low,last" )` takes the same bits as words, in any order and any case.
  Words it does not know are ignored, and `""` is no markers. `GetMarkersText` gives them back.
- `tkSparkline_GetMarkerIndex( h, TKSPARK_MK_HIGH )` gives the index of the high point, and the
  same for LOW, FIRST and LAST. It gives -1 with no data, and for the other bits.

### Axis, reference line and normal band

| Call | Draws |
| --- | --- |
| `SetShowAxis( h, true )` | the zero line, 1 pixel, in AxisColor. Only when the range holds 0, and never on WINLOSS |
| `SetReference( h, v )` | a 1-pixel line at v in ReferenceColor: a target or an average. `ClearReference` removes it |
| `SetNormalBand( h, lo, hi )` | a shaded band from lo to hi in BandColor, behind the data: the normal range. An inverted pair is swapped. `ClearNormalBand` removes it |

The 1-pixel lines are hairlines and stay 1 pixel at every scale. `GetReference` and
`GetNormalBand` return FALSE when there is none. **A reference or a band does not widen the
range**: one outside an automatic range is not seen, so give the sparkline a range that holds it.

The Designer's text forms are `SetReferenceText( h, "50" )` and `SetNormalBandText( h, "40..60" )`.
`""` clears either one, and so does a band without `..`. `GetReferenceText` and
`GetNormalBandText` give `""` when there is none.

### The last value

`tkSparkline_SetShowLastValue( h, true )` writes the last present value at the right end, in
TextColor. Its width is kept free, so the plot is narrower by that width and a gap of 4 design
units.

- **The font** is `SetFont`'s, or the host's default font when none is set. The sparkline borrows
  it.
- **The text** comes from the Format callback (below). When there is no callback, or it gives `""`,
  the value has `SetDecimals` decimals, from 0 to 9. `TKSPARK_DECIMALS_AUTO` (-1, the default) shows
  up to 2 and drops trailing zeros.
- `tkSparkline_FormatValue( v, nDecimals )` is the same formatter, for your own text. It never
  writes `-0`.

All sizes are design units, scaled with the host, so a change of scale only repaints. The plot is
also 2 design units in from each edge (`TKSPARK_DEFAULT_PADDING`; a spec's `nPadding` sets it on
a sparkline drawn with no widget).

## Hover, tooltip and click

**The point under the mouse is hot**, whatever the mouse's height. On LINE and AREA it is the point
nearest in x, and on COLUMN and WINLOSS the point whose slot it is. A missing point is not hot,
except under `TKSPARK_EMPTY_ZERO`.

- A hot point on LINE and AREA gets a dot in HotColor, 1 design unit larger than a marker. A hot
  column or win/loss bar is drawn in HotColor.
- The hot point clears when the mouse leaves. A disabled sparkline has no hot point.
- `GetHotPoint` gives it, -1 for none. `HitTest( h, x, y )` gives the point that would be hot at a
  widget-local x and y, -1 outside the control or where no point is drawn.

**The tooltip follows the hot point.** Its text is the first of these that is not empty:

1. `SetTooltipText`'s text, one for the whole control
2. the Tooltip callback's text for point i, value v
3. the value through the Format callback
4. the value with `SetDecimals` decimals

`ResolveTooltipText` gives the text that would show now, and `GetTooltipHandle` the
[tkTooltip](tkTooltip) itself.

**Click** fires when the left button is pressed and released over an enabled sparkline. It gives the
control's id. Nothing else notifies.

## Callbacks

| Callback | When |
| --- | --- |
| `SetClickCallback` | a left click |
| `SetTooltipCallback` | the tooltip wants point i's text (value v; a missing point gives 0). `""` falls through to the value |
| `SetFormatCallback` | a value is about to be shown as the last value or in the default tip. `""` falls back to the Decimals format |
| `SetPaintCallback` | the control paints. It replaces the stock drawing; the background is already filled with BackColor |
| `SetMessageCallback` | any message but the destroy, before the control sees it. TRUE eats it |

The Paint callback gets a `TKSPARK_PAINTINFO`: the paint target `b`, `rcClient`, `rcPlot` (the plot
rounded out to whole pixels), `isEnabled` and `nHot`. Call `tkSparkline_PaintDefault( p )` in it
for the stock drawing, then draw on top.

The Message callback gets a `TKSPARK_MESSAGEINFO`: the message, the mouse's x and y, and the hot
point. A left-button release is handled even when the callback eats it, so eat the press to stop a
click.

**Probes** give the layout the painter uses, in widget-local coordinates:

| Call | Gives |
| --- | --- |
| `GetPlotRect( h, rc )` | the plot, as an `SDL_FRect` |
| `IndexToX( h, i )` | point i's x: on the plot's edges for LINE and AREA, the slot's centre for COLUMN and WINLOSS |
| `ValueToY( h, v )` | the y of value v |
| `GetSpec( h, s )` | the `TKSPARK_SPEC` as painted now. Its series pointers are the control's, good until the series changes |

## Colours and theme

`TKSPARK_COLORS` has 14 colours. `tkSparkline_ThemeColors( t )` maps them from the theme's roles:

| Field | Role | Field | Role |
| --- | --- | --- | --- |
| BackColor | Window | HighColor | Success |
| LineColor | Accent | LowColor | Warning |
| FillColor | Accent at alpha `&h40` | FirstColor | TextDim |
| NegativeColor | Error | LastColor | Accent |
| AxisColor | Divider | HotColor | TextStrong |
| ReferenceColor | TextDim | TextColor | Text |
| BandColor | Window, 15 % toward TextDim | ForeColorDisabled | TextDisabled |

- A disabled sparkline draws everything in ForeColorDisabled. The fill keeps its alpha.
- A theme file's **Sparkline** part overrides the roles.
- The control recolours itself on a theme change. `SetColors` pins the colours: a theme change then
  leaves them alone until `UnpinColors`.
- Also: `GetColors`, `ApplyTheme`.

## In the Form Designer

The toolbox's **Sparkline** (under Data) is dropped at 120 × 32 with a 12-point series, so the
canvas shows something. Its properties, in the order the form sets them:

- **Kind** (Line, Area, Column, WinLoss), **Data** (the text form), **MaxPoints**.
- **Range** (Min, Max), then **AutoRange**. Range turns AutoRange off, so AutoRange comes after it
  and the designer's choice wins.
- **EmptyMode** (Gap, Zero, Connect), **Markers** (`high,low,last`), **MarkerSize**, **LineWidth**,
  **ColumnGap**, **ShowAxis**.
- **Reference** (`50`), **NormalBand** (`40..60`), **ShowLastValue**, **Decimals**, **Font** and
  **TooltipText**.
- **Colors:** the 14 fields of `TKSPARK_COLORS`.
- **Events:** Click (the default event), Tooltip, Format, Paint and Message.

**Bind** loads the series from a text field of the form's DataType. LoadFrom sets it through
`SetDataText`, and an empty field clears it. SaveTo leaves the field alone, because the sparkline
is load only.

The typed wrapper is `Sparkline` (`tkSparkline.forms.tiko`). See [Form Designer](Form-Designer),
Data binding.

## In a DataGrid

A [tkDataGrid](tkDataGrid) column of kind `TKDG_COL_SPARKLINE` draws each cell's text as a
sparkline, in the text form above:

```freebasic
#import "vendor/tkControls/tkDataGrid"

dim as integer cTrend = tkDataGrid_AddColumnEx( grid, "Trend", TKDG_COL_SPARKLINE, 140 )
dim as TKSPARK_SPEC look
look.nKind = TKSPARK_LINE
look.nMarkers = TKSPARK_MK_LAST
tkDataGrid_SetColumnSparkline( grid, cTrend, look, true )      ' true: one range for every row
tkDataGrid_SetCellText( grid, 0, cTrend, "12,14,13,17,16,19" )
tkDataGrid_SetCellText( grid, 1, cTrend, "30,28,,25,24" )
```

- **The look** is the spec's: kind, empty mode, range, markers, sizes, axis, reference, band, the
  last value and decimals. Its series, colours and hot point are not taken. The setter is silent.
- **A shared range** puts every row on one range, the minimum and maximum over all the column's
  rows, so the rows compare. It is worked out again after the grid's data changes.
  `tkDataGrid_GetColumnSparkRange` gives it, and FALSE when the column has no shared range or no
  values.
- **The cell** is drawn inside its padding, in the theme's colours on the cell's back colour. On a
  selected row the line and the text take the row's fore colour. The last value is in the grid's
  font.
- **The column is not editable** and has no text tip.
- **Sorting** the column sorts by each series' last present value. A row with none sorts as an
  empty number does.

The column is set up in code: the Form Designer's Columns editor has no sparkline kind.

```freebasic
function tkDataGrid_SetColumnSparkline( byval hGrid as TK_WIDGET ptr, byval col as int32, byref spec as TKSPARK_SPEC, byval bSharedRange as boolean ) as boolean
function tkDataGrid_GetColumnSparkRange( byval hGrid as TK_WIDGET ptr, byval col as int32, byref lo as float64, byref hi as float64 ) as boolean
```

## In a report

A [tkReport](tkReport) item of kind `TKRI_SPARKLINE` draws a sparkline in a band, through
`tkSparkline_PaintPage`:

```freebasic
dim as TKRECTF rc
tkRectF_Set( rc, 340, 0, 440, 16 )
tkRBand_AddSparkline( tkReport_GetBand( rpt, TKRB_DETAIL ), rc, _
                      tkReport_FindField( rpt, "Trend" ), "kind=column;axis=1;last=1" )
```

- **The series** is the item's expression (`->expr`) when it has one, else its field, else its
  text, read in the text form above.
- **The settings** are the item's `opts`: `key=value` pairs separated by `;`. A value writes `%`,
  `;` and `=` as `%25`, `%3B` and `%3D`.
- **The last value** is in the item's font. The colours are the light theme's, for paper.

| Key | Value |
| --- | --- |
| `kind` | `line`, `area`, `column`, `winloss` |
| `min`, `max` | both together: a manual range |
| `empty` | `gap`, `zero`, `connect` |
| `markers` | `high,low,first,last,negative,all` |
| `ref` | the reference line's value |
| `band` | the normal band, `40..60` |
| `last` | `1` or `true`: the last value as text |
| `dec` | the decimals |
| `linewidth`, `markersize`, `gap` | the sizes, in design units |
| `axis` | `1` or `true`: the zero axis |

The [Report Designer](Report-Designer) has a sparkline item in its toolbox (100 × 20) and an `opts`
row, and draws a sample series on its canvas. See its "Gauges and sparklines" section.

## Without a widget

`tkSparkline_PaintInto` draws a sparkline into a rectangle of any paint target: a list row, a
cell of your own table, a custom control. It paints no background.

```freebasic
dim as float64 v(0 to 5) = { 3, 5, 4, 8, 6, 9 }
dim as TKSPARK_SPEC s
s.nKind = TKSPARK_AREA
s.pValues = @v(0)
s.nCount = 6                                      ' pHas = 0: every point present
s.nMarkers = TKSPARK_MK_LAST
tkSparkline_PaintInto( b, rc, s )                 ' in any paint callback (b: a TK_PAINT ptr, rc: a TKRECT)
```

A `TKSPARK_SPEC` holds everything that decides the look, with the same defaults as the control.

- **The series is borrowed**: `pValues` and `pHas` point at your arrays, and `pHas = 0` means every
  point is present.
- **The range** is automatic unless `bAutoRange = false`, then `fMin` and `fMax`.
- **The last value** needs `bShowLast` and a font in `fText`. `sLastText` overrides its text.
- **The scale** is `fScale`, or the paint target's when 0.
- **The colours** are `pColors`, or the app theme's when 0.

`tkSparkline_PaintPage( pg, rc, s )` draws the same on a [tkPrint](tkPrint) page, in `rc` in
points. A design unit is 1/96 inch on paper. Text is in `fText`, or the page's current font
(`tkPage_SetFont`) when 0, and no text when the page has none. Colours default to the light theme's.
It returns FALSE when nothing was drawn.

```freebasic
dim as TKRECTF r
tkRectF_Set( r, 72, 72, 172, 90 )                 ' 100 x 18 pt, an inch in from the corner
tkSparkline_PaintPage( pg, r, s )                 ' in a print page callback
```

For drawing of your own around it:

- `tkSparkline_Layout( s, rc, fScale, g )` fills an `SP_GEOM` with the plot, the range in force,
  the baseline, the slot width, the high, low, first and last indices and the last value's
  rectangle.
- `tkSparkline_GeomIndexToX`, `GeomValueToY` and `GeomHitTest` read it.
- `tkSparkline_PaintSpec( b, rc, s, g )` paints from it. It needs `s.pColors` set: with none it
  draws nothing.

**The text forms** work without a widget too:

- `tkSparkline_ParseText( text, vals(), has() )` reads the series text into two arrays and returns
  the count. `tkSparkline_FormatText( pValues, pHas, n )` writes it back.
- `tkSparkline_ParseMarkers` and `FormatMarkers` turn the marker words into the bits and back.
- `tkSparkline_OptsToSpec( opts, s )` reads a report item's `opts` into a spec, starting from the
  defaults. It returns FALSE for an unknown key, an unknown `kind` or `empty` word, or a `band`
  without `..`, having still read the rest. Marker words it does not know are ignored, as in
  `SetMarkersText`.

## Public declarations

### Constants

- **Kinds:** `TKSPARK_LINE`, `TKSPARK_AREA`, `TKSPARK_COLUMN`, `TKSPARK_WINLOSS`.
- **Empty modes:** `TKSPARK_EMPTY_GAP`, `TKSPARK_EMPTY_ZERO`, `TKSPARK_EMPTY_CONNECT`.
- **Markers** (`int32` bits): `TKSPARK_MK_NONE` (0), `TKSPARK_MK_HIGH` (1), `TKSPARK_MK_LOW` (2),
  `TKSPARK_MK_FIRST` (4), `TKSPARK_MK_LAST` (8), `TKSPARK_MK_NEGATIVE` (16), `TKSPARK_MK_ALL` (32).
- **Decimals:** `TKSPARK_DECIMALS_AUTO` (-1).
- **Defaults, in design units:** `TKSPARK_DEFAULT_LINEWIDTH` (`float32`, 1.5),
  `TKSPARK_DEFAULT_MARKERSIZE` (`float32`, 5, a diameter), `TKSPARK_DEFAULT_COLUMNGAP` (1),
  `TKSPARK_DEFAULT_PADDING` (2), `TKSPARK_DEFAULT_TEXTGAP` (4).
- **Limits:** `TKSPARK_ROUNDJOIN_MAX` (200): above this many points the line's joins are mitred.

### Types

- `TKSPARK_COLORS`: the 14 colours, each a `uint32`.
- `TKSPARK_SPEC`: everything that decides a sparkline's look, with or without a widget.

  | Field | Type | Default |
  | --- | --- | --- |
  | `nKind`, `nEmpty` | `int32` | `TKSPARK_LINE`, `TKSPARK_EMPTY_GAP` |
  | `pValues`, `pHas`, `nCount` | `float64 ptr`, `boolean ptr`, `int32` | the series, borrowed |
  | `bAutoRange`, `fMin`, `fMax` | `boolean`, `float64`, `float64` | true |
  | `nMarkers`, `fMarkerSize`, `fLineWidth` | `int32`, `float32`, `float32` | none, 5, 1.5 |
  | `nColumnGap`, `nPadding` | `int32` | 1, 2 |
  | `bShowAxis` | `boolean` | false |
  | `bHasRef`, `fRef` | `boolean`, `float64` | false |
  | `bHasBand`, `fBandLo`, `fBandHi` | `boolean`, `float64`, `float64` | false |
  | `bShowLast`, `nDecimals`, `sLastText` | `boolean`, `int32`, `ustring` | false, `TKSPARK_DECIMALS_AUTO`, `""` |
  | `nHot`, `bEnabled` | `int32`, `boolean` | -1, true |
  | `fText`, `fScale`, `pColors` | `TTF_Font ptr`, `float32`, `TKSPARK_COLORS ptr` | 0: no text, the painter's scale, the theme's colours |

- `SP_GEOM`: the layout. `pl`, `pt`, `pr`, `pb` (the plot), `lo`, `hi` (the range in force),
  `axisV` (the baseline), `slotW`, `mr` (the marker room), `rcText`, `sText`, `iHigh`, `iLow`,
  `iFirst`, `iLast`, `nPresent`, `fScale`.
- `TKSPARK_PAINTINFO`: `hSpark`, `b`, `rcClient`, `rcPlot`, `isEnabled`, `nHot`.
- `TKSPARK_MESSAGEINFO`: `hSpark`, `msg`, `x`, `y` (`single`), `nHot`.
- `TKSPARK_STATE`: the control's own state, reached through the procedures.
- The callback types:

```freebasic
type SPK_ClickCallbackSub as sub( byval hSpark as TK_WIDGET ptr, byval id as int32 )
type SPK_TooltipCallbackFunc as function( byval hSpark as TK_WIDGET ptr, byval i as int32, byval v as float64 ) as ustring
type SPK_FormatCallbackFunc as function( byval hSpark as TK_WIDGET ptr, byval v as float64 ) as ustring
type SPK_PaintCallbackSub as sub( byval p as TKSPARK_PAINTINFO ptr )
type SPK_MessageCallbackFunc as function( byval m as TKSPARK_MESSAGEINFO ptr ) as boolean
```

The Form Designer's typed wrapper is `Sparkline` (`tkSparkline.forms.tiko`).

### Procedures

The control:

```freebasic
function tkSparkline_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as int32, byval nKind as int32 = TKSPARK_LINE ) as TK_WIDGET ptr
function tkSparkline_GetID( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetEnabled( byval hSpark as TK_WIDGET ptr, byval isEnabled as boolean )
sub tkSparkline_SetKind( byval hSpark as TK_WIDGET ptr, byval nKind as int32 )
function tkSparkline_GetKind( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetData( byval hSpark as TK_WIDGET ptr, byval pValues as float64 ptr, byval n as int32 )
sub tkSparkline_SetDataText( byval hSpark as TK_WIDGET ptr, byval Text as ustring )
function tkSparkline_GetDataText( byval hSpark as TK_WIDGET ptr ) as ustring
sub tkSparkline_AddValue( byval hSpark as TK_WIDGET ptr, byval v as float64 )
sub tkSparkline_AddGap( byval hSpark as TK_WIDGET ptr )
sub tkSparkline_Clear( byval hSpark as TK_WIDGET ptr )
sub tkSparkline_SetMaxPoints( byval hSpark as TK_WIDGET ptr, byval n as int32 )
function tkSparkline_GetMaxPoints( byval hSpark as TK_WIDGET ptr ) as int32
function tkSparkline_GetCount( byval hSpark as TK_WIDGET ptr ) as int32
function tkSparkline_GetValue( byval hSpark as TK_WIDGET ptr, byval i as int32 ) as float64
function tkSparkline_IsPresent( byval hSpark as TK_WIDGET ptr, byval i as int32 ) as boolean
sub tkSparkline_SetRange( byval hSpark as TK_WIDGET ptr, byval lo as float64, byval hi as float64 )
sub tkSparkline_SetAutoRange( byval hSpark as TK_WIDGET ptr, byval bAuto as boolean )
function tkSparkline_GetAutoRange( byval hSpark as TK_WIDGET ptr ) as boolean
sub tkSparkline_GetRange( byval hSpark as TK_WIDGET ptr, byref lo as float64, byref hi as float64 )
sub tkSparkline_SetEmptyMode( byval hSpark as TK_WIDGET ptr, byval nMode as int32 )
function tkSparkline_GetEmptyMode( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetMarkers( byval hSpark as TK_WIDGET ptr, byval nMarkers as int32 )
function tkSparkline_GetMarkers( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetMarkersText( byval hSpark as TK_WIDGET ptr, byval Text as ustring )
function tkSparkline_GetMarkersText( byval hSpark as TK_WIDGET ptr ) as ustring
sub tkSparkline_SetMarkerSize( byval hSpark as TK_WIDGET ptr, byval fSize as float32 )
function tkSparkline_GetMarkerSize( byval hSpark as TK_WIDGET ptr ) as float32
sub tkSparkline_SetLineWidth( byval hSpark as TK_WIDGET ptr, byval fWidth as float32 )
function tkSparkline_GetLineWidth( byval hSpark as TK_WIDGET ptr ) as float32
sub tkSparkline_SetColumnGap( byval hSpark as TK_WIDGET ptr, byval nGap as int32 )
function tkSparkline_GetColumnGap( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetShowAxis( byval hSpark as TK_WIDGET ptr, byval bShow as boolean )
function tkSparkline_GetShowAxis( byval hSpark as TK_WIDGET ptr ) as boolean
sub tkSparkline_SetReference( byval hSpark as TK_WIDGET ptr, byval v as float64 )
sub tkSparkline_ClearReference( byval hSpark as TK_WIDGET ptr )
function tkSparkline_GetReference( byval hSpark as TK_WIDGET ptr, byref v as float64 ) as boolean
sub tkSparkline_SetNormalBand( byval hSpark as TK_WIDGET ptr, byval lo as float64, byval hi as float64 )
sub tkSparkline_ClearNormalBand( byval hSpark as TK_WIDGET ptr )
function tkSparkline_GetNormalBand( byval hSpark as TK_WIDGET ptr, byref lo as float64, byref hi as float64 ) as boolean
sub tkSparkline_SetReferenceText( byval hSpark as TK_WIDGET ptr, byval Text as ustring )
function tkSparkline_GetReferenceText( byval hSpark as TK_WIDGET ptr ) as ustring
sub tkSparkline_SetNormalBandText( byval hSpark as TK_WIDGET ptr, byval Text as ustring )
function tkSparkline_GetNormalBandText( byval hSpark as TK_WIDGET ptr ) as ustring
sub tkSparkline_SetShowLastValue( byval hSpark as TK_WIDGET ptr, byval bShow as boolean )
function tkSparkline_GetShowLastValue( byval hSpark as TK_WIDGET ptr ) as boolean
sub tkSparkline_SetDecimals( byval hSpark as TK_WIDGET ptr, byval nDecimals as int32 )
function tkSparkline_GetDecimals( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_SetFont( byval hSpark as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkSparkline_GetFont( byval hSpark as TK_WIDGET ptr ) as TTF_Font ptr
sub tkSparkline_GetPlotRect( byval hSpark as TK_WIDGET ptr, byref rc as SDL_FRect )
function tkSparkline_IndexToX( byval hSpark as TK_WIDGET ptr, byval i as int32 ) as float32
function tkSparkline_ValueToY( byval hSpark as TK_WIDGET ptr, byval v as float64 ) as float32
function tkSparkline_HitTest( byval hSpark as TK_WIDGET ptr, byval x as float32, byval y as float32 ) as int32
function tkSparkline_GetMarkerIndex( byval hSpark as TK_WIDGET ptr, byval nWhich as int32 ) as int32
function tkSparkline_GetHotPoint( byval hSpark as TK_WIDGET ptr ) as int32
sub tkSparkline_GetSpec( byval hSpark as TK_WIDGET ptr, byref s as TKSPARK_SPEC )
sub tkSparkline_SetTooltipText( byval hSpark as TK_WIDGET ptr, byval Text as ustring )
function tkSparkline_GetTooltipText( byval hSpark as TK_WIDGET ptr ) as ustring
sub tkSparkline_SetTooltipCallback( byval hSpark as TK_WIDGET ptr, byval userfunc as SPK_TooltipCallbackFunc )
function tkSparkline_ResolveTooltipText( byval hSpark as TK_WIDGET ptr ) as ustring
function tkSparkline_GetTooltipHandle( byval hSpark as TK_WIDGET ptr ) as TK_TIP ptr
sub tkSparkline_GetColors( byval hSpark as TK_WIDGET ptr, byval pColors as TKSPARK_COLORS ptr )
sub tkSparkline_SetColors( byval hSpark as TK_WIDGET ptr, byval pColors as TKSPARK_COLORS ptr )
sub tkSparkline_ApplyTheme( byval hSpark as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkSparkline_UnpinColors( byval hSpark as TK_WIDGET ptr )
sub tkSparkline_SetClickCallback( byval hSpark as TK_WIDGET ptr, byval usersub as SPK_ClickCallbackSub )
sub tkSparkline_SetFormatCallback( byval hSpark as TK_WIDGET ptr, byval userfunc as SPK_FormatCallbackFunc )
sub tkSparkline_PaintDefault( byval pi as TKSPARK_PAINTINFO ptr )
sub tkSparkline_SetPaintCallback( byval hSpark as TK_WIDGET ptr, byval usersub as SPK_PaintCallbackSub )
sub tkSparkline_SetMessageCallback( byval hSpark as TK_WIDGET ptr, byval userfunc as SPK_MessageCallbackFunc )
```

Drawing, the text forms and the colours, with or without a widget:

```freebasic
function tkSparkline_FormatValue( byval v as float64, byval nDecimals as int32 = TKSPARK_DECIMALS_AUTO ) as string
function tkSparkline_ParseText( byref sText as string, vals() as float64, has() as boolean ) as int32
function tkSparkline_FormatText( byval pValues as float64 ptr, byval pHas as boolean ptr, byval n as int32 ) as string
function tkSparkline_ParseMarkers( byref sText as string ) as int32
function tkSparkline_FormatMarkers( byval nMarkers as int32 ) as string
sub tkSparkline_Layout( byref s as TKSPARK_SPEC, byref rc as TKRECT, byval fScale as float32, byref g as SP_GEOM )
function tkSparkline_GeomIndexToX( byref s as TKSPARK_SPEC, byref g as SP_GEOM, byval i as int32 ) as float32
function tkSparkline_GeomValueToY( byref g as SP_GEOM, byval v as float64 ) as float32
function tkSparkline_GeomHitTest( byref s as TKSPARK_SPEC, byref g as SP_GEOM, byval x as float32 ) as int32
sub tkSparkline_PaintSpec( byval b as TK_PAINT ptr, byref rc as TKRECT, byref s as TKSPARK_SPEC, byref g as SP_GEOM )
sub tkSparkline_PaintInto( byval b as TK_PAINT ptr, byref rc as TKRECT, byref s as TKSPARK_SPEC )
function tkSparkline_OptsToSpec( byref opts as const ustring, byref s as TKSPARK_SPEC ) as boolean
function tkSparkline_PaintPage( byval pg as TK_PAGE ptr, byref rc as TKRECTF, byref s as TKSPARK_SPEC ) as boolean
function tkSparkline_ThemeColors( byref t as TKTHEME_COLORS ) as TKSPARK_COLORS
```

### See also

- [tkControls](Category-tkControls)
- [tkGauge](tkGauge), one value on a dial or a bar; [tkChart](tkChart), a full chart with axes,
  several series and a legend
- [tkDataGrid](tkDataGrid), sparkline columns; [tkReport](tkReport) and
  [Report Designer](Report-Designer), sparkline items
- [tkPrint](tkPrint), the page `PaintPage` draws on
- [Form Designer](Form-Designer), data binding
