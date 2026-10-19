[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiThemeDefault**

# TuiThemeDefault

Returns the stock colour theme.

## Syntax

```freebasic
TuiThemeDefault( ) as TuiTheme
```

## Description

The stock colour theme. Every example in the module starts here.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTheme th = TuiThemeDefault( )
dim as TuiStyle focusFill = th.normal.Patch( th.selected )
print focusFill.Equals( th.normal )    '' false -- selection is visible
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