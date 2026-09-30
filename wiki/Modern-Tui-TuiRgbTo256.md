[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiRgbTo256**

# TuiRgbTo256

## Syntax

```freebasic
TuiRgbTo256( byval r as long, byval g as long, byval b as long ) as ubyte
```

## Description

The 256-palette entry nearest an RGB triple -- the 6x6x6 cube, or the grey ramp when the components are close enough together. One rung of the downgrade ladder, exposed because it is occasionally useful on its own.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

print TuiRgbTo256( 255, 0, 0 )         '' 196 -- the cube's pure red
print TuiRgbTo256( 128, 128, 128 )     '' 244 -- a GREY-RAMP entry, not a
                                       '' cube entry: the ramp is finer
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)