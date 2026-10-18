[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiColor.Equals**

# TuiColor.Equals

## Syntax

```freebasic
TuiColor.Equals( byval o as TuiColor ) as boolean
```

## Description

Compares kind and components. Two colours that would render identically but were built differently are NOT equal -- TuiRgb( 0, 0, 0 ) is not TuiAnsi( TUIC_BLACK ).

## Example

```freebasic
#import "std/tui"
using tui

print TuiRgb( 10, 20, 30 ).Equals( TuiRgb( 10, 20, 30 ) )    '' true
print TuiRgb( 0, 0, 0 ).Equals( TuiAnsi( TUIC_BLACK ) )      '' false
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)