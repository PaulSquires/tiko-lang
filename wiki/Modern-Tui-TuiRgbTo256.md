[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiRgbTo256**

# TuiRgbTo256

Returns the nearest 256-palette colour number for red, green and blue values.

## Syntax

```freebasic
TuiRgbTo256( byval r as int32, byval g as int32, byval b as int32 ) as uint8
```

## Description

The 256-palette entry nearest an RGB triple -- the 6x6x6 cube, or the grey ramp when the components are close enough together. One rung of the downgrade ladder, exposed because it is occasionally useful on its own.

## Example

```freebasic
#import "std/tui"
using tui

print TuiRgbTo256( 255, 0, 0 )         '' 196 -- the cube's pure red
print TuiRgbTo256( 128, 128, 128 )     '' 244 -- a GREY-RAMP entry, not a
                                       '' cube entry: the ramp is finer
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)