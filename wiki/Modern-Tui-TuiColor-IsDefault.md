[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiColor.IsDefault**

# TuiColor.IsDefault

Returns true if the colour is the terminal's own default.

## Syntax

```freebasic
TuiColor.IsDefault( ) as boolean
```

## Description

True when this is the terminal's own default colour rather than a chosen one. It matters because a default background does not paint: drawing with it leaves whatever was underneath, which is the whole reason TuiStyle.Patch exists.

## Example

```freebasic
#import "std/tui"
using tui

print TuiDefaultColor( ).IsDefault( )        '' true
print TuiRgb( 0, 0, 0 ).IsDefault( )         '' false -- black is not default
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)