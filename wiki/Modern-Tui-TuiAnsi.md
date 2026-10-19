[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiAnsi**

# TuiAnsi

Returns one of the 16 classic colours, which follow the user's terminal theme.

## Syntax

```freebasic
TuiAnsi( byval idx as TuiAnsiIndex ) as TuiColor
```

## Description

One of the sixteen classic colours. Use these when you want the user's palette honoured rather than a colour you chose -- a terminal theme remaps them and yours will fit in.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor c = TuiAnsi( TUIC_BRIGHTGREEN )
print c.Index( )                  '' 10

'' the sixteen names: TUIC_BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
'' and the TUIC_BRIGHT* forms of each
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)