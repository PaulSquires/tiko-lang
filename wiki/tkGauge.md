[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **tkGauge**

# tkGauge

Draws a radial or linear gauge, or a bullet graph: a value on a scale with ranges.

`tkGauge` is the [tkControls](Category-tkControls) gauge. It shows one or more values against a
scale:

- **Two shapes**, chosen at create: radial, at any start angle and sweep from a short arc to a
  whole ring, and linear, horizontal or vertical.
- **One scale** with major and minor ticks and labels. The step is picked for you, or set.
- **Ranges**: coloured zones of the scale, each able to taper.
- **Pointers**: needles, bars and markers, as many as you need. Pointer 0 is the value.
- **Text**: the value with a prefix and a suffix, and a caption.
- **Animation**, off by default: a new value eases into place.

A gauge is a display control. It takes no focus and no keys; a tooltip and Click are its only
interaction, and every setter is silent. The Form Designer's **Gauge** binds its value, load
only. A report draws gauges as items ([In a report](#in-a-report)), and `tkGauge_PaintInto` and
`tkGauge_PaintPage` draw one with no widget at all.

## Importing

```freebasic
#import "vendor/tkControls/tkGauge"

using tkGauge
using tkHost
```

The module brings in [tkHost](tkHost) (and through it [tkPaint](tkPaint), SDL3, SDL_ttf and
SDL_image), [tkTheme](tkTheme), [tkTooltip](tkTooltip) and [tkPrint](tkPrint). It links no vendor
library. Add `using tkPaint` for `TK_PAINT` (a paint callback, `PaintInto`) and `using tkPrint` for
`TK_PAGE` (`PaintPage`).

## Example

`host` is a `TK_HOST ptr` from `tkHost_Create`, set up as in the [tkButton](tkButton) example,
with the imports above.

```freebasic
sub Speed_Click( byval hGauge as TK_WIDGET ptr, byval id as int32 )
    tkGauge_SetValue( hGauge, tkGauge_GetValue( hGauge ) + 20 )      ' eased there over 400 ms
end sub

dim as TTF_Font ptr fBig = tkHost_OpenFont( host, tkHost_FontDir() & TK_FONT_UI_BOLD, 16 )

' a speedometer: 0..240 by 40, three zones, the labels outside the track
dim as TK_WIDGET ptr speed = tkGauge_Create( tkHost_Root( host ), 100 )    ' radial: a needle
tkGauge_SetRange( speed, 0, 240 )
tkGauge_SetMajorStep( speed, 40 )
tkGauge_SetScalePlacement( speed, TKGAUGE_SCALE_OUTSIDE )
tkGauge_SetRangesText( speed, "0..120=#3C8C46;120..180=#C8A032;180..240=#C04646" )
tkGauge_SetCaption( speed, "Speed" )
tkGauge_SetSuffix( speed, " km/h" )
tkGauge_SetValueFont( speed, fBig )
tkGauge_SetShowFace( speed, true )
tkGauge_SetValue( speed, 96 )                       ' silent
tkGauge_SetAnimation( speed, 400 )                  ' later values ease there
tkGauge_SetClickCallback( speed, @Speed_Click )
tkWidget_SetPos( speed, tkHost_Scale( host, 20 ), tkHost_Scale( host, 20 ), tkHost_Scale( host, 220 ), tkHost_Scale( host, 220 ) )

' a KPI: a semicircle, the value a bar, a target marker at 75
dim as TK_WIDGET ptr kpi = tkGauge_Create( tkHost_Root( host ), 101 )
tkGauge_SetAngles( kpi, 180, 180 )                  ' from 9 o'clock, clockwise over the top
tkGauge_SetValueKind( kpi, TKGAUGE_PTR_BAR )
dim as int32 iTarget = tkGauge_AddPointer( kpi, TKGAUGE_PTR_MARKER )
tkGauge_SetPointerValue( kpi, iTarget, 75 )
tkGauge_SetSuffix( kpi, " %" )
tkGauge_SetCaption( kpi, "Quarter" )
tkGauge_SetValueFont( kpi, fBig )
tkGauge_SetValue( kpi, 62 )
tkWidget_SetPos( kpi, tkHost_Scale( host, 260 ), tkHost_Scale( host, 20 ), tkHost_Scale( host, 200 ), tkHost_Scale( host, 130 ) )

' a bullet graph: three bands, the measure a third-width bar, the target a marker
dim as TK_WIDGET ptr rev = tkGauge_Create( tkHost_Root( host ), 102, TKGAUGE_LINEAR )    ' linear: a bar
tkGauge_SetRange( rev, 0, 300 )
tkGauge_SetRangesText( rev, "0..150=#4A505A;150..240=#606670;240..300=#787E88" )
tkGauge_SetPointerWidth( rev, 0, 1 / 3 )
dim as int32 iGoal = tkGauge_AddPointer( rev, TKGAUGE_PTR_MARKER )
tkGauge_SetPointerValue( rev, iGoal, 250 )
tkGauge_SetCaption( rev, "Revenue" )
tkGauge_SetPrefix( rev, "$" )
tkGauge_SetSuffix( rev, "k" )
tkGauge_SetValue( rev, 215 )
tkWidget_SetPos( rev, tkHost_Scale( host, 20 ), tkHost_Scale( host, 255 ), tkHost_Scale( host, 440 ), tkHost_Scale( host, 52 ) )

if tkGauge_IsOverRange( speed, 0 ) then print "off the scale"   ' drawn at the end, still shown as text
print tkGauge_GetRangesText( speed )               ' "0..120=#3C8C46;120..180=#C8A032;180..240=#C04646"
```

The speedometer reads `96 km/h` under its hub, the KPI `62 %` with its marker at 75, and the
bullet graph `$215k` to the right of its track. A click on the speedometer moves it on by 20.

## The shapes

`tkGauge_Create( parent, id [, shape] )` makes a gauge of `TKGAUGE_RADIAL` (the default) or
`TKGAUGE_LINEAR` shape. The shape is fixed once created; `tkGauge_GetShape` reads it.

### Radial

A radial gauge's pointer 0 is a needle.

- **The arc**, `tkGauge_SetAngles( h, start, sweep )`, is in degrees, tkPaint's way: 0 is
  3 o'clock and angles grow clockwise. A negative sweep runs anticlockwise. A sweep is clamped to
  ±360, and one under 1 degree is ignored.

| Arc | Start, sweep |
| --- | --- |
| a three-quarter dial, open at the bottom (the default) | 135, 270 |
| a semicircle over the top | 180, 180 |
| a 240-degree dial | 150, 240 |
| a whole ring from 12 o'clock | 270, 360 |

- **The gauge is fitted to its arc**, not to the whole circle: it takes the largest radius whose
  arc, hub, labels and text fit the control, centred. A semicircle fills a 2:1 rectangle.
- **The track** is a band along the arc. `SetTrackWidth( h, frac )` sets its width as a fraction
  of the radius, 0.02 to 0.5 (default 0.12).
- **The face**, `SetShowFace( h, true )`, is a disc behind the dial in FaceColor.
- **A whole ring** puts Max on Min, so Max's label is left out.

### Linear

A linear gauge's pointer 0 is a bar.

- **Orientation.** `SetOrientation( h, TKGAUGE_HORIZONTAL )`, the default, puts Min at the left.
  `TKGAUGE_VERTICAL` puts Min at the bottom.
- **Reverse.** `SetReverse( h, true )` runs the scale the other way, Max at the left or at the
  bottom. The caption and the value text stay where they are.
- **The track** fills the room the scale leaves across the control, so the control's height
  (its width, when vertical) sizes it. TrackWidth is radial only.
- **The scale's side**, `SetScalePlacement`:

| Placement | Ticks | Labels |
| --- | --- | --- |
| `TKGAUGE_SCALE_NEAR` (= `INSIDE`, the default) | below a horizontal track, left of a vertical one | beside the ticks |
| `TKGAUGE_SCALE_FAR` (= `OUTSIDE`) | above a horizontal track, right of a vertical one | beside the ticks |
| `TKGAUGE_SCALE_BOTH` | on both sides | on the near side |
| `TKGAUGE_SCALE_NONE` | none | none |

- **The end labels stay inside the control**: the track is inset by half the widest label.
- **The caption is before the track** (left of a horizontal one, above a vertical one) and **the
  value text after it** (right, or below). A horizontal gauge keeps room for the wider of Min's and
  Max's value text, so the track does not move as the value changes.
- **The face** fills the gauge's padded box.

### The bullet graph

A bullet graph is a linear gauge set up three ways, not a mode of its own:

- **Ranges** at the full width of the track: the qualitative bands (poor, fair, good).
- **Pointer 0, the measure,** a bar a third as wide as the track: `SetPointerWidth( h, 0, 1 / 3 )`.
- **The target**, a marker: `AddPointer( h, TKGAUGE_PTR_MARKER )`, then `SetPointerValue`. It is
  a line across two thirds of the track.

The Example's `rev` is one. A vertical bullet graph adds `SetOrientation( h, TKGAUGE_VERTICAL )`.

## Scale and ticks

- **The range**, `SetRange( h, lo, hi )`, is 0 to 100 by default. An inverted pair is swapped. A
  range of zero width draws everything at Min.
- **Values are stored as given and drawn clamped.** A pointer past the scale stops at its end,
  and the value text still shows the real value. `IsOverRange( h, i )` says so, and
  `GetPointerValue` gives what was set.
- **Major ticks.** `SetMajorStep( h, step )`, or 0 (the default) for a step of 1, 2 or 5 × 10ⁿ
  that gives about `SetTickHint` intervals (default 5). `tkGauge_NiceStep( span, n )` is that
  rule.
- **Minor ticks.** `SetMinorCount( h, n )` between each pair of majors, 0 to 20 (default 4).
- **Labels** sit at the majors. On a radial gauge they are inside the track
  (`TKGAUGE_SCALE_INSIDE`, the default) or outside it (`OUTSIDE`); `BOTH` reads as `INSIDE`, and
  `NONE` draws no ticks and no labels. Labels that would overlap are thinned to every second, every
  third, and so on. On a small radial gauge an inside label that would meet the hub is left out.
- **Decimals.** `SetDecimals( h, n )`, 0 to 9, sets the labels and the value text together.
  `TKGAUGE_DECIMALS_AUTO` (the default) gives the labels the step's decimals, so a 0 to 1 scale
  by 0.2 reads `0.0`, `0.2` … `1.0`, and the value up to 2 decimals with trailing zeros dropped.
  `tkGauge_FormatValue( v, n )` formats a value the same way, and never gives `-0`.

## Ranges

- **`AddRange( h, lo, hi, clr )`** adds a zone and returns its index. `ClearRanges` removes them
  all and `GetRangeCount` counts them.
- **Ranges are clamped to the scale** and drawn in order, a later one over an earlier one.
- **Their colours are yours**: a theme change leaves them alone. A disabled gauge fades them toward
  the track's colour.
- **Tapers.** `SetRangeWidth( h, i, fStart, fEnd )` sets a range's width at its two ends, as
  fractions of the track's (above 0, at most 1; default 1 and 1). A range keeps to the scale's
  edge as it narrows:
  - on a radial gauge its outer edge stays on the track's outer edge
  - on a linear one it rises from the scale's side of the track (the near side, unless the scale
    is FAR), so a taper is a wedge growing from the ticks
- **The text form** is for the Designer, a report and a file: `0..60=#2E7D32;60..85=#F9A825;85..100=#C62828`.
  - Each entry is `from..to=#RRGGBB` (opaque) or `from..to=#AARRGGBB`, and `;` separates them.
    A malformed entry is skipped.
  - `SetRangesText` replaces every range, at full width. `GetRangesText` gives them back in the
    same form, without their widths.
  - `tkGauge_ParseRanges( text, rg() )` and `tkGauge_FormatRanges( p, n )` do the same with a
    `TKGAUGE_RANGE` array.

## Pointers

**Pointer 0 always exists and is the value.** `SetValue` and `GetValue` are pointer 0's, the
value text shows it, and the Designer binds it. `AddPointer( h, kind )` adds another pointer and
returns its index (-1 for a kind that is not one of the three). A new pointer starts at Min.

| Kind | Radial | Linear |
| --- | --- | --- |
| `TKGAUGE_PTR_NEEDLE` (radial pointer 0) | a needle from the centre, with a hub over its base | a triangle beside the track, its tip on the track's edge, on the side without labels |
| `TKGAUGE_PTR_BAR` (linear pointer 0) | a band along the track, from the bar origin | a band along the middle of the track, from the bar origin |
| `TKGAUGE_PTR_MARKER` | a short line across the track | a line across two thirds of the track: a bullet graph's target |

- **Value.** `SetPointerValue( h, i, v )`, `GetPointerValue( h, i )`; `GetPointerCount`.
- **Kind.** `SetPointerKind( h, i, kind )`, `GetPointerKind`. `SetValueKind` and `GetValueKind`
  are pointer 0's (the Designer's **PointerKind**).
- **Colour.** `SetPointerColor( h, i, clr )`. 0, the default, is the kind's colour: NeedleColor,
  BarColor or MarkerColor.
- **Width.** `SetPointerWidth( h, i, f )` multiplies the kind's width. For a bar it is a fraction
  of the track: 1, the default, fills it. 0 or less is ignored.
- **Visible.** `SetPointerVisible( h, i, b )`.
- **Drawing order:** bars first, then markers, then needles and the hub; each kind in index
  order.
- **The bar origin.** Bars grow from Min. `SetBarOrigin( h, v )` makes every bar of the gauge grow
  from `v` instead, so on a -50..50 scale a bar from 0 goes either way. `ClearBarOrigin` goes back
  to Min.

## Text

- **The caption**, `SetCaption( h, text )`, is a title such as "Speed".
- **The value text** is the prefix, the value and the suffix: `SetPrefix( h, "$" )`,
  `SetSuffix( h, " km/h" )`. It shows pointer 0's drawn value, so it counts along with an
  animation.
- **Your own value text.** `SetValueFormatCallback( h, @fn )` gets each value and returns the
  text. "" falls back to the default; otherwise the prefix and suffix are yours to add.
- **Where the value text goes**, `SetValueTextPos`:

| Position | Radial | Linear |
| --- | --- | --- |
| `TKGAUGE_VALUE_AUTO` (the default) | below the hub for an arc under 300 degrees, at the centre otherwise | after the track |
| `TKGAUGE_VALUE_CENTER` | at the centre | after the track |
| `TKGAUGE_VALUE_BELOW` | below the hub | after the track |
| `TKGAUGE_VALUE_END` | below the hub | after the track |
| `TKGAUGE_VALUE_NONE` | not drawn | not drawn |

- **The caption's place.** On a radial gauge the caption is under the value text. On a linear one
  it is before the track.
- **Fonts.** `SetFont( h, f )` sets the labels' and the caption's font; 0, the default, is the
  host's default font. `SetValueFont( h, f )` sets the value text's; 0 is the labels' font. The
  gauge opens no fonts of its own: open a bigger one for the value with `tkHost_OpenFont`, as the
  Example does.

## Animation

Animation is off by default. `SetAnimation( h, ms )` with `ms` above 0 eases each new value into
place over that many milliseconds (ease-out cubic):

- **Target and drawn value.** `GetValue` and `GetPointerValue` give the new value at once.
  `GetDisplayedValue( h, i )` gives where the pointer is drawn now.
- **A new value in flight** starts again from where the pointer is drawn.
- **It runs only while the gauge is enabled and shown.** Hidden or disabled, the pointer stops
  where it is, and goes on from there when the gauge is shown and enabled again.
- **`SetAnimation( h, 0 )`** lands anything in flight at once.
- **No notification** arrives when a pointer gets there.

Values set while the animation is 0 jump straight there, so set the first values before
`SetAnimation`, as the Example does.

## Colours and theme

| `TKGAUGE_COLORS` field | Theme role | Paints |
| --- | --- | --- |
| `BackColor` | Window | the control's background (the widget only) |
| `FaceColor` | Surface | the face, with `ShowFace` |
| `TrackColor` | Track | the track |
| `TickColor` | TextDim | the ticks |
| `LabelColor` | TextDim | the labels |
| `NeedleColor` | Accent | needles |
| `HubColor` | Text | the hub |
| `BarColor` | Accent | bars |
| `MarkerColor` | Warning | markers |
| `ValueTextColor` | TextStrong | the value text |
| `CaptionColor` | TextDim | the caption |
| `ForeColorDisabled` | TextDisabled | every tick, label, pointer and text while disabled |

- **The theme.** A gauge follows the theme as the other controls do. `GetColors`, `SetColors`
  (it pins them: a theme change leaves this gauge alone until `UnpinColors`), `ThemeColors( t )`,
  `ApplyTheme( h, t )`. Styles and theme files reach it as **Gauge** (see the
  [Themes tutorial](Themes-Tutorial)).
- **Range and pointer colours are yours**, not the theme's.
- **Disabled** (`tkGauge_SetEnabled( h, false )` or `tkWidget_Enable`): the ink turns
  ForeColorDisabled, ranges fade toward TrackColor, Click stops and the animation pauses.

## Tooltip and Click

- **The tooltip** is the first of these that has text: `SetTooltipText`'s; then
  `SetTooltipCallback`'s, which gets pointer 0's value; then the value text. The tooltip shows the
  value that was set, not one on its way there. `ResolveTooltipText` gives what it would show, and
  `GetTooltipHandle` the [tkTooltip](tkTooltip).
- **Click.** `SetClickCallback( h, @fn )` is called when the left button is pressed and released
  over the gauge while it is enabled, with the gauge and its id.
- **Your own drawing.** `SetPaintCallback( h, @fn )` replaces the gauge's drawing. The background
  is already filled in BackColor. `TKGAUGE_PAINTINFO` has the gauge, the `TK_PAINT`, the client
  rectangle and whether it is enabled. Call `tkGauge_PaintDefault( p )` to draw the stock gauge,
  then add to it.
- **Messages.** `SetMessageCallback( h, @fn )` sees every message first, in a
  `TKGAUGE_MESSAGEINFO` (the gauge, the message, the mouse position). Return TRUE to eat it. The
  gauge still handles a left-button release, so a press is never left hanging.

## Probes

| Call | Gives |
| --- | --- |
| `tkGauge_ValueToAngle( h, v )` | radial: the angle `v` is drawn at, in degrees, clamped to the scale |
| `tkGauge_ValueToPos( h, v )` | linear: the position along the track `v` is drawn at (x when horizontal, y when vertical), clamped; radial: 0 |
| `tkGauge_GetGeom( h, geo )` | the layout as painted now, a `GG_GEOM`: the centre and radii, or the track's ends and edges; the majors and their label boxes; the value and caption boxes |
| `tkGauge_GetSpec( h, s )` | the gauge's `TKGAUGE_SPEC` as painted now. Its pointer and range arrays are the gauge's own, so use it before the next change |
| `GetMin`, `GetMax`, `GetStartAngle`, `GetSweepAngle`, `GetID` | what they say |

`tkGauge_SpecValueToAngle`, `tkGauge_GeomValueToPos` and `tkGauge_Layout` do the same without a
widget.

## In the Form Designer

The toolbox's **Gauge** (under Data) is 160 × 160 and has these properties:

- **Shape** (Radial, Linear): the gauge is created with it.
- **Range** (Min, Max) and **Angles** (Start, Sweep), each a pair.
- **The rest:** Value, PointerKind, Orientation, Reverse, MajorStep, MinorCount, TickHint,
  Decimals, ScalePlacement, TrackWidth, ShowFace, Ranges (the text form), Caption, Prefix, Suffix,
  ValueTextPos, Animation, Font, ValueFont and TooltipText.
- **Rows for the other shape** show for both shapes and do nothing where they do not apply: Angles
  and TrackWidth are radial, Orientation and Reverse linear. On a linear gauge ScalePlacement's
  Inside is near and Outside is far.
- **Colours:** the twelve `TKGAUGE_COLORS` fields.
- **Code only:** more pointers, a pointer's width, colour and visibility, range tapers and the
  bar origin. A bullet graph's third-width bar and its target are set in code.
- **Events:** Click (the default event), Tooltip, ValueFormat, Paint and Message.

A dropped Gauge starts at Value 60, so the canvas shows something.

**Bind** loads pointer 0's value from a field of the form's DataType, of any number type (an
`int32` goes through tkBind's float conversion). It is load only: **SaveTo** leaves the field
alone. A value past the scale is drawn at its end and still shown as text.

See [Form Designer](Form-Designer#data-binding), Data binding.

## In a report

[tkReport](tkReport) draws gauge items itself, through `tkGauge_PaintPage`. There is nothing to
install and no vendor library to link. With `vendor/tkControls/tkReport` imported and
`using tkReport`:

```freebasic
dim as TKRECTF rc
tkRectF_Set( rc, 0, 0, 160, 24 )                    ' points, in the band
dim as TKREPORT_ITEM ptr it = tkRBand_AddGauge( tkReport_GetBand( rpt, TKRB_DETAIL ), rc, _
    tkReport_FindField( rpt, "revenue" ), "shape=linear;max=300;width=0.33;target=250" )
```

- **The value** is the item's expression (`it->expr`, such as `[revenue] / 1000`), else its field,
  else its text, read as a number. For an expression alone, pass -1 for the field.
- **The text** uses the item's font for the labels and the caption, and the same font, bold, at 1.5
  times the size, for the value text. The colours are `tkTheme_Light`'s, for paper.
- **The settings** are the item's `opts`: `key=value` pairs separated by `;`, the keys and words
  in any case. A value writes `%`, `;` and `=` as `%25`, `%3B` and `%3D`, so zones read
  `ranges=0..60=#2E7D32%3B60..100=#C62828`. A key that is not known is skipped.

| Key | Value | As |
| --- | --- | --- |
| `shape` | `radial`, `linear` | the shape. A linear gauge's pointer 0 is a bar unless `pointer` names it |
| `min`, `max` | numbers | `SetRange` |
| `start`, `sweep` | degrees | `SetAngles` |
| `orient` | `horizontal` (`h`), `vertical` (`v`) | `SetOrientation` |
| `reverse` | `1` or `true` | `SetReverse` |
| `step`, `minor`, `hint`, `dec` | numbers | `SetMajorStep`, `SetMinorCount`, `SetTickHint`, `SetDecimals` |
| `scale` | `inside` (`near`), `outside` (`far`), `none`, `both` | `SetScalePlacement` |
| `track` | a fraction | `SetTrackWidth` |
| `face` | `1` or `true` | `SetShowFace` |
| `ranges` | the text form, `;` written `%3B` | `SetRangesText` |
| `pointer` | `needle`, `bar`, `marker` | `SetValueKind` |
| `width` | a number | `SetPointerWidth` of pointer 0 |
| `origin` | a number | `SetBarOrigin` |
| `target` | a number | a marker at that value, as `AddPointer`; it can be given more than once |
| `caption`, `prefix`, `suffix` | text | `SetCaption`, `SetPrefix`, `SetSuffix` |
| `value` | `auto`, `center`, `below`, `none`, `end` | `SetValueTextPos` |

A linear gauge with `width=0.33`, zones and a `target` is a bullet graph. The Report Designer has a
Gauge in its toolbox, with `expr` and `opts` rows; its canvas shows the gauge at 60 % of its scale.
See [Report Designer](Report-Designer#gauges-and-sparklines).

## Without a widget

`tkGauge_PaintInto( b, rc, spec )` lays a gauge out in `rc` and draws it on any `TK_PAINT`: in a
paint callback, a grid cell or a list row.

```freebasic
dim as TKGAUGE_POINTER pp
pp.fValue = 7.5                                   ' pointer 0: a needle by default
dim as TKGAUGE_RANGE rg(0 to 1)
rg(0).fFrom = 0 : rg(0).fTo = 5 : rg(0).clr = &hFFC04646ul
rg(1).fFrom = 5 : rg(1).fTo = 10 : rg(1).clr = &hFF3C8C46ul
dim as TKGAUGE_SPEC s
s.fMax = 10 : s.fStart = 180 : s.fSweep = 180     ' a semicircle
s.pPointers = @pp : s.nPointers = 1
s.pRanges = @rg(0) : s.nRanges = 2
s.fText = gFont : s.sCaption = "Score"            ' fText 0: no text at all
tkGauge_PaintInto( b, rc, s )                     ' in any paint callback
```

- **The spec** is everything that decides the gauge's look. Its pointers and ranges are arrays of
  yours that it points at.
- **The defaults:** `fText` 0 draws no text; `fValueFont` 0 is `fText`; `fScale` 0 is the
  painter's; `pColors` 0 is the app theme's.
- **The value text.** `sValueText`, when set, replaces the value text; "" formats pointer 0.
- **No background** is filled, and nothing is animated: the values are drawn as they are.

`tkGauge_PaintPage( pg, rc, spec )` does the same on a [tkPrint](tkPrint) page. Here the settings
come from opts text, as a report's do:

```freebasic
dim as TKGAUGE_SPEC s
dim as TKGAUGE_RANGE rg()
dim as TKGAUGE_POINTER ptrs()
tkGauge_OptsToSpec( "shape=linear;max=300;ranges=0..150=#A0A0A0%3B150..300=#D0D0D0;width=0.33;target=250", s, rg(), ptrs() )
ptrs(0).fValue = 215                              ' the value: pointer 0 (a bar here)
tkGauge_PaintPage( pg, rc, s )                    ' rc in points; the page's font, paper colours
```

- **`rc` is in points**, and a design unit is 1/96 inch, as on a 96 dpi screen. The gauge is
  recorded as page shapes and text, so it stays sharp in a PDF.
- **Fonts** must be page fonts. 0 is the page's current font (`tkPage_SetFont`); with none set,
  no text is drawn.
- **Colours** 0 are `tkTheme_Light`'s, for paper.
- It returns FALSE when nothing was drawn, as for an empty `rc`.

`tkGauge_OptsToSpec( opts, s, rg(), ptrs() )` fills a spec from opts text with the keys in
[In a report](#in-a-report), defaults for the rest. `rg()` and `ptrs()` hold what the spec points
at, so keep them while it is used. `ptrs(0)` is the value; set its `fValue` yourself. It returns
FALSE for a key or a word it does not know, with the spec read as far as it went.

For the layout alone, `tkGauge_Layout( s, rc, fScale, geo )` fills a `GG_GEOM`, and
`tkGauge_PaintSpec( b, s, geo )` draws from it (its `pColors` must be set).

## Public declarations

### Constants

- **Shapes:** `TKGAUGE_RADIAL`, `TKGAUGE_LINEAR`.
- **Pointer kinds:** `TKGAUGE_PTR_NEEDLE`, `TKGAUGE_PTR_BAR`, `TKGAUGE_PTR_MARKER`.
- **Linear orientation:** `TKGAUGE_HORIZONTAL`, `TKGAUGE_VERTICAL`.
- **Scale placement:** `TKGAUGE_SCALE_INSIDE`, `TKGAUGE_SCALE_OUTSIDE`, `TKGAUGE_SCALE_NONE`,
  `TKGAUGE_SCALE_BOTH`; `TKGAUGE_SCALE_NEAR` (= INSIDE) and `TKGAUGE_SCALE_FAR` (= OUTSIDE).
- **Value text position:** `TKGAUGE_VALUE_AUTO`, `TKGAUGE_VALUE_CENTER`, `TKGAUGE_VALUE_BELOW`,
  `TKGAUGE_VALUE_NONE`, `TKGAUGE_VALUE_END`.
- **Decimals:** `TKGAUGE_DECIMALS_AUTO` (-1).
- **Defaults:** `TKGAUGE_DEFAULT_START` (135), `TKGAUGE_DEFAULT_SWEEP` (270),
  `TKGAUGE_DEFAULT_TRACKWIDTH` (0.12, a fraction of the radius), `TKGAUGE_DEFAULT_TICKHINT` (5),
  `TKGAUGE_DEFAULT_MINORCOUNT` (4), `TKGAUGE_DEFAULT_PADDING` (4).
- **Sizes, in design units:** `TKGAUGE_TICKGAP` (3), `TKGAUGE_MAJORLEN` (8), `TKGAUGE_MINORLEN`
  (4), `TKGAUGE_MAJORTHICK` (2), `TKGAUGE_MINORTHICK` (1), `TKGAUGE_NEEDLEWIDTH` (6),
  `TKGAUGE_MARKERWIDTH` (3), `TKGAUGE_TEXTGAP` (4); `TKGAUGE_HUBFRAC` (0.06, the hub's radius as a
  fraction of the gauge's).

### Types

```freebasic
type TKGAUGE_COLORS
    BackColor         as uint32 = &hFF21252Bul
    FaceColor         as uint32 = &hFF2C313Aul
    TrackColor        as uint32 = &hFF3E444Eul
    TickColor         as uint32 = &hFF969CA6ul
    LabelColor        as uint32 = &hFF969CA6ul
    NeedleColor       as uint32 = &hFF569CD6ul
    HubColor          as uint32 = &hFFC8CDD6ul
    BarColor          as uint32 = &hFF569CD6ul
    MarkerColor       as uint32 = &hFFE5C07Bul
    ValueTextColor    as uint32 = &hFFFFFFFFul
    CaptionColor      as uint32 = &hFF969CA6ul
    ForeColorDisabled as uint32 = &hFF606670ul
end type

' A zone of the scale. Widths are fractions of the track's, at each end (a taper).
type TKGAUGE_RANGE
    fFrom   as float64
    fTo     as float64
    clr     as uint32
    fStartW as float32 = 1
    fEndW   as float32 = 1
end type

type TKGAUGE_POINTER
    nKind    as int32 = TKGAUGE_PTR_NEEDLE
    fValue   as float64
    clr      as uint32                 ' 0 = the kind's colour from TKGAUGE_COLORS
    fWidth   as float32 = 1            ' x the kind's width (BAR: a fraction of the track)
    bVisible as boolean = true
end type

' Everything that decides a gauge's look, with or without a widget. Pointers and ranges are
' borrowed arrays.
type TKGAUGE_SPEC
    nShape       as int32 = TKGAUGE_RADIAL
    nOrient      as int32 = TKGAUGE_HORIZONTAL   ' linear
    bReverse     as boolean                      ' linear: Max at the left / the bottom
    fMin         as float64 = 0
    fMax         as float64 = 100
    pPointers    as TKGAUGE_POINTER ptr
    nPointers    as int32
    pRanges      as TKGAUGE_RANGE ptr
    nRanges      as int32
    fStart       as float32 = TKGAUGE_DEFAULT_START
    fSweep       as float32 = TKGAUGE_DEFAULT_SWEEP
    fMajorStep   as float64               ' 0 = auto (1-2-5 for about nTickHint intervals)
    nTickHint    as int32 = TKGAUGE_DEFAULT_TICKHINT
    nMinorCount  as int32 = TKGAUGE_DEFAULT_MINORCOUNT
    nDecimals    as int32 = TKGAUGE_DECIMALS_AUTO
    nScale       as int32 = TKGAUGE_SCALE_INSIDE
    fTrackWidth  as float32 = TKGAUGE_DEFAULT_TRACKWIDTH   ' radial; a linear track fills what its scale leaves
    bShowFace    as boolean
    bBarOrigin   as boolean               ' FALSE: bars grow from Min
    fBarOrigin   as float64
    sCaption     as ustring
    sPrefix      as ustring
    sSuffix      as ustring
    sValueText   as ustring               ' "" = pointer 0 formatted (the widget's callback fills it)
    nValueText   as int32 = TKGAUGE_VALUE_AUTO
    nPadding     as int32 = TKGAUGE_DEFAULT_PADDING
    bEnabled     as boolean = true
    fText        as TTF_Font ptr          ' labels and caption; 0 = none drawn
    fValueFont   as TTF_Font ptr          ' 0 = fText
    fScale       as float32               ' 0 = the painter's
    pColors      as TKGAUGE_COLORS ptr    ' 0 = the app theme's
end type

type TKGAUGE_PAINTINFO
    hGauge    as TK_WIDGET ptr
    b         as TK_PAINT ptr
    rcClient  as TKRECT
    isEnabled as boolean
end type

type TKGAUGE_MESSAGEINFO
    hGauge as TK_WIDGET ptr
    msg    as int32
    x      as single
    y      as single
end type

type GGE_ClickCallbackSub as sub( byval hGauge as TK_WIDGET ptr, byval id as int32 )
' The tip; "" falls through to the value text.
type GGE_TooltipCallbackFunc as function( byval hGauge as TK_WIDGET ptr, byval v as float64 ) as ustring
' Pointer 0's value as the gauge shows it (prefix and suffix are yours to add); "" = the default.
type GGE_ValueFormatCallbackFunc as function( byval hGauge as TK_WIDGET ptr, byval v as float64 ) as ustring
type GGE_PaintCallbackSub as sub( byval p as TKGAUGE_PAINTINFO ptr )
type GGE_MessageCallbackFunc as function( byval m as TKGAUGE_MESSAGEINFO ptr ) as boolean
```

- `GG_GEOM`: the layout, in the control's own coordinates, that the painter draws from and the
  probes read (`tkGauge_Layout`, `tkGauge_GetGeom`). Radial: the centre `cx`, `cy`, the track's
  outer radius `r`, its width `tw`, its inner radius `rIn`, `hubR`. Linear (`bLinear`, `bVert`):
  Min's and Max's positions along the track `p0`, `p1`, its edges across `c0`, `c1`. Both: the
  step in force `fStep`, the majors `majors()`, their label boxes and texts `labRc()`, `labS()`,
  which are shown `labOn()`, and the boxes `rcValue`, `rcCaption`.
- `TKGAUGE_STATE`: the widget's own state, behind its handle. A program does not use it.

The Form Designer's typed wrapper is `Gauge` (`tkGauge.forms.tiko`): `Create( parent, id, Shape )`,
`Range( min, max )`, `Angles( start, sweep )`, `SetFocus( )`, and a property for Enabled, Visible
and each Designer row from Value to TooltipText.

### Procedures

`tkGaugeWidget.tiko`, the widget:

```freebasic
function tkGauge_Create( byval hParent as TK_WIDGET ptr, byval ctrlId as int32, byval nShape as int32 = TKGAUGE_RADIAL ) as TK_WIDGET ptr
function tkGauge_GetID( byval hGauge as TK_WIDGET ptr ) as int32
function tkGauge_GetShape( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetEnabled( byval hGauge as TK_WIDGET ptr, byval isEnabled as boolean )
sub tkGauge_SetRange( byval hGauge as TK_WIDGET ptr, byval lo as float64, byval hi as float64 )
function tkGauge_GetMin( byval hGauge as TK_WIDGET ptr ) as float64
function tkGauge_GetMax( byval hGauge as TK_WIDGET ptr ) as float64
function tkGauge_AddPointer( byval hGauge as TK_WIDGET ptr, byval nKind as int32 ) as int32
function tkGauge_GetPointerCount( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetPointerValue( byval hGauge as TK_WIDGET ptr, byval i as int32, byval v as float64 )
function tkGauge_GetPointerValue( byval hGauge as TK_WIDGET ptr, byval i as int32 ) as float64
function tkGauge_GetDisplayedValue( byval hGauge as TK_WIDGET ptr, byval i as int32 ) as float64
sub tkGauge_SetValue( byval hGauge as TK_WIDGET ptr, byval v as float64 )
function tkGauge_GetValue( byval hGauge as TK_WIDGET ptr ) as float64
function tkGauge_IsOverRange( byval hGauge as TK_WIDGET ptr, byval i as int32 ) as boolean
sub tkGauge_SetPointerKind( byval hGauge as TK_WIDGET ptr, byval i as int32, byval nKind as int32 )
function tkGauge_GetPointerKind( byval hGauge as TK_WIDGET ptr, byval i as int32 ) as int32
sub tkGauge_SetValueKind( byval hGauge as TK_WIDGET ptr, byval nKind as int32 )
function tkGauge_GetValueKind( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetPointerColor( byval hGauge as TK_WIDGET ptr, byval i as int32, byval clr as uint32 )
sub tkGauge_SetPointerWidth( byval hGauge as TK_WIDGET ptr, byval i as int32, byval fWidth as float32 )
sub tkGauge_SetPointerVisible( byval hGauge as TK_WIDGET ptr, byval i as int32, byval bVisible as boolean )
sub tkGauge_SetAnimation( byval hGauge as TK_WIDGET ptr, byval nMs as int32 )
function tkGauge_GetAnimation( byval hGauge as TK_WIDGET ptr ) as int32
function tkGauge_AddRange( byval hGauge as TK_WIDGET ptr, byval lo as float64, byval hi as float64, byval clr as uint32 ) as int32
sub tkGauge_SetRangeWidth( byval hGauge as TK_WIDGET ptr, byval i as int32, byval fStart as float32, byval fEnd as float32 )
sub tkGauge_ClearRanges( byval hGauge as TK_WIDGET ptr )
function tkGauge_GetRangeCount( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetRangesText( byval hGauge as TK_WIDGET ptr, byval Text as ustring )
function tkGauge_GetRangesText( byval hGauge as TK_WIDGET ptr ) as ustring
sub tkGauge_SetAngles( byval hGauge as TK_WIDGET ptr, byval fStart as float32, byval fSweep as float32 )
function tkGauge_GetStartAngle( byval hGauge as TK_WIDGET ptr ) as float32
function tkGauge_GetSweepAngle( byval hGauge as TK_WIDGET ptr ) as float32
sub tkGauge_SetOrientation( byval hGauge as TK_WIDGET ptr, byval nOrient as int32 )
function tkGauge_GetOrientation( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetReverse( byval hGauge as TK_WIDGET ptr, byval bReverse as boolean )
function tkGauge_GetReverse( byval hGauge as TK_WIDGET ptr ) as boolean
sub tkGauge_SetMajorStep( byval hGauge as TK_WIDGET ptr, byval fStep as float64 )
function tkGauge_GetMajorStep( byval hGauge as TK_WIDGET ptr ) as float64
sub tkGauge_SetMinorCount( byval hGauge as TK_WIDGET ptr, byval n as int32 )
function tkGauge_GetMinorCount( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetTickHint( byval hGauge as TK_WIDGET ptr, byval n as int32 )
function tkGauge_GetTickHint( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetDecimals( byval hGauge as TK_WIDGET ptr, byval nDecimals as int32 )
function tkGauge_GetDecimals( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetScalePlacement( byval hGauge as TK_WIDGET ptr, byval nPlace as int32 )
function tkGauge_GetScalePlacement( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetTrackWidth( byval hGauge as TK_WIDGET ptr, byval fFrac as float32 )
function tkGauge_GetTrackWidth( byval hGauge as TK_WIDGET ptr ) as float32
sub tkGauge_SetShowFace( byval hGauge as TK_WIDGET ptr, byval bShow as boolean )
function tkGauge_GetShowFace( byval hGauge as TK_WIDGET ptr ) as boolean
sub tkGauge_SetBarOrigin( byval hGauge as TK_WIDGET ptr, byval v as float64 )
sub tkGauge_ClearBarOrigin( byval hGauge as TK_WIDGET ptr )
sub tkGauge_SetCaption( byval hGauge as TK_WIDGET ptr, byval Text as ustring )
function tkGauge_GetCaption( byval hGauge as TK_WIDGET ptr ) as ustring
sub tkGauge_SetPrefix( byval hGauge as TK_WIDGET ptr, byval Text as ustring )
function tkGauge_GetPrefix( byval hGauge as TK_WIDGET ptr ) as ustring
sub tkGauge_SetSuffix( byval hGauge as TK_WIDGET ptr, byval Text as ustring )
function tkGauge_GetSuffix( byval hGauge as TK_WIDGET ptr ) as ustring
sub tkGauge_SetValueTextPos( byval hGauge as TK_WIDGET ptr, byval nPos as int32 )
function tkGauge_GetValueTextPos( byval hGauge as TK_WIDGET ptr ) as int32
sub tkGauge_SetFont( byval hGauge as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkGauge_GetFont( byval hGauge as TK_WIDGET ptr ) as TTF_Font ptr
sub tkGauge_SetValueFont( byval hGauge as TK_WIDGET ptr, byval f as TTF_Font ptr )
function tkGauge_GetValueFont( byval hGauge as TK_WIDGET ptr ) as TTF_Font ptr
function tkGauge_ValueToAngle( byval hGauge as TK_WIDGET ptr, byval v as float64 ) as float32
function tkGauge_ValueToPos( byval hGauge as TK_WIDGET ptr, byval v as float64 ) as float32
sub tkGauge_GetGeom( byval hGauge as TK_WIDGET ptr, byref geo as GG_GEOM )
sub tkGauge_GetSpec( byval hGauge as TK_WIDGET ptr, byref s as TKGAUGE_SPEC )
sub tkGauge_SetTooltipText( byval hGauge as TK_WIDGET ptr, byval Text as ustring )
function tkGauge_GetTooltipText( byval hGauge as TK_WIDGET ptr ) as ustring
sub tkGauge_SetTooltipCallback( byval hGauge as TK_WIDGET ptr, byval userfunc as GGE_TooltipCallbackFunc )
function tkGauge_ResolveTooltipText( byval hGauge as TK_WIDGET ptr ) as ustring
function tkGauge_GetTooltipHandle( byval hGauge as TK_WIDGET ptr ) as TK_TIP ptr
sub tkGauge_GetColors( byval hGauge as TK_WIDGET ptr, byval pColors as TKGAUGE_COLORS ptr )
sub tkGauge_SetColors( byval hGauge as TK_WIDGET ptr, byval pColors as TKGAUGE_COLORS ptr )
sub tkGauge_ApplyTheme( byval hGauge as TK_WIDGET ptr, byref t as TKTHEME_COLORS )
sub tkGauge_UnpinColors( byval hGauge as TK_WIDGET ptr )
sub tkGauge_SetClickCallback( byval hGauge as TK_WIDGET ptr, byval usersub as GGE_ClickCallbackSub )
sub tkGauge_SetValueFormatCallback( byval hGauge as TK_WIDGET ptr, byval userfunc as GGE_ValueFormatCallbackFunc )
sub tkGauge_PaintDefault( byval pi as TKGAUGE_PAINTINFO ptr )
sub tkGauge_SetPaintCallback( byval hGauge as TK_WIDGET ptr, byval usersub as GGE_PaintCallbackSub )
sub tkGauge_SetMessageCallback( byval hGauge as TK_WIDGET ptr, byval userfunc as GGE_MessageCallbackFunc )
```

`tkGauge.tiko`, the drawing, with or without a widget:

```freebasic
function tkGauge_NiceStep( byval fSpan as float64, byval nIntervals as int32 ) as float64
function tkGauge_FormatValue( byval v as float64, byval nDecimals as int32 = TKGAUGE_DECIMALS_AUTO ) as string
function tkGauge_ParseRanges( byref sText as string, rg() as TKGAUGE_RANGE ) as int32
function tkGauge_FormatRanges( byval pRanges as TKGAUGE_RANGE ptr, byval n as int32 ) as string
function tkGauge_SpecValueToAngle( byref s as TKGAUGE_SPEC, byval v as float64 ) as float32
function tkGauge_GeomValueToPos( byref s as TKGAUGE_SPEC, byref geo as GG_GEOM, byval v as float64 ) as float32
sub tkGauge_Layout( byref s as TKGAUGE_SPEC, byref rc as TKRECT, byval fScale as float32, byref geo as GG_GEOM )
sub tkGauge_PaintSpec( byval b as TK_PAINT ptr, byref s as TKGAUGE_SPEC, byref geo as GG_GEOM )
function tkGauge_OptsToSpec( byref opts as const ustring, byref s as TKGAUGE_SPEC, rg() as TKGAUGE_RANGE, ptrs() as TKGAUGE_POINTER ) as boolean
sub tkGauge_PaintInto( byval b as TK_PAINT ptr, byref rc as TKRECT, byref s as TKGAUGE_SPEC )
function tkGauge_PaintPage( byval pg as TK_PAGE ptr, byref rc as TKRECTF, byref s as TKGAUGE_SPEC ) as boolean
function tkGauge_ThemeColors( byref t as TKTHEME_COLORS ) as TKGAUGE_COLORS
```

`tkGauge_ParseRanges` returns the number of ranges it read, with `rg()` resized to them.

### See also

- [tkControls](Category-tkControls)
- [tkSparkline](tkSparkline), a word-sized chart of a series; [tkProgressBar](tkProgressBar), a
  plain progress bar; [tkSlider](tkSlider), a value the user sets; [tkChart](tkChart)
- [tkReport](tkReport) and [Report Designer](Report-Designer), gauge items
- [Form Designer](Form-Designer), data binding
- [tkPrint](tkPrint), pages for `tkGauge_PaintPage`
