[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiDowngrade**

# TuiDowngrade

Returns the colour that a terminal with fewer colours would show instead.

## Syntax

```freebasic
TuiDowngrade( byval c as TuiColor, byval depth as TuiColorDepth ) as TuiColor
```

## Description

Reduces one colour to what a terminal of the given depth can show. You rarely call this -- the renderer does it for every cell -- but it is here so you can predict what a colour will become.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor c = TuiRgb( 235, 80, 80 )
print TuiDowngrade( c, TUIDEPTH_TRUECOLOR ).r     '' 235 -- untouched
print TuiDowngrade( c, TUIDEPTH_256 ).kind = TUICOLOR_INDEXED '' -1 (true)
print TuiDowngrade( c, TUIDEPTH_ANSI16 ).Index( ) '' 8
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