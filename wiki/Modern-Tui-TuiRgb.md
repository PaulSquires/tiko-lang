[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiRgb**

# TuiRgb

Returns a 24-bit colour, reduced for you on terminals with fewer colours.

## Syntax

```freebasic
TuiRgb( byval r as int32, byval g as int32, byval b as int32 ) as TuiColor
```

## Description

A 24-bit colour. Write these freely: on a 256-colour or 16-colour terminal the renderer reduces them for you, and the reduction happens at WRITE time, so the same program looks right everywhere without a branch in your code.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor c = TuiRgb( 120, 220, 160 )
print c.r, c.g, c.b               '' 120 220 160

'' what it becomes on a lesser terminal
print TuiRgbTo256( 120, 220, 160 )           '' 115
print TuiRgbTo16 ( 120, 220, 160 )           '' 6  -- cyan
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)