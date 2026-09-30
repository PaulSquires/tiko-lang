[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiIndexed**

# TuiIndexed

## Syntax

```freebasic
TuiIndexed( byval idx as uint8 ) as TuiColor
```

## Description

A colour from the 256-entry palette: 0-15 the classic set, 16-231 a 6x6x6 cube, 232-255 a grey ramp.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiColor orange = TuiIndexed( 214 )
dim as TuiColor grey   = TuiIndexed( 244 )
print orange.Index( ), grey.Index( )         '' 214 244
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow) · [TuiBlue](Modern-Tui-TuiBlue)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)