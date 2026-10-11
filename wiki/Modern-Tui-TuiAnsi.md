[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiAnsi**

# TuiAnsi

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

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow) · [TuiBlue](Modern-Tui-TuiBlue)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)