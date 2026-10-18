# Layout and widgets

A screen is built by dividing a rectangle with constraints and drawing a
widget into each piece. Widgets are values made in `View` and thrown away; what
must survive between frames, such as a list's selection, lives in a state
record the application owns.

```tiko
{{#include ../../examples/libraries/tui-layout.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/tui-layout.out}}
```

**Layout.** `TuiSplitV` stacks pieces top to bottom and `TuiSplitH` puts them
side by side. Each piece has a constraint: `TuiLength( n )` for exactly `n`
cells, `TuiPercent`, `TuiRatio`, `TuiMin_` and `TuiMax_`, and `TuiFill( )` for
a share of what is left. Splitting a piece again builds any screen, and the
result is the same for the same sizes on every platform.

**Widgets.** The example uses four:

| Widget | Draws |
|---|---|
| `TuiBlock` | a border with titles; `Inner` is the space inside it |
| `TuiList` | items, with the selected one marked by `selectPrefix` |
| `TuiParagraph` | text, aligned |
| `TuiGauge` | a bar filled to `ratio`, with a label |

`TuiList` reads its selection from the `TuiListState` its `state` points at,
which is a field of the app, not of the list. Among the others are `TuiTable`,
`TuiTabs`, `TuiTextInput`, `TuiCheckbox`, `TuiMenuBar`, `TuiTree` and
`TuiSparkline`.

The example draws `TUIBORDER_ASCII` borders so that its output prints
anywhere; a real program usually wants `TUIBORDER_ROUNDED` or
`TUIBORDER_PLAIN`, which use box-drawing characters, and colour from a
`TuiStyle`.

### Activities

1. Change the list's width to `TuiPercent( 50 )`.
2. Set the gauge's `ratio` to 0.3 and its `label` to `"3 of 10"`.
