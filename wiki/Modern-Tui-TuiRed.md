[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiRed**

# TuiRed

## Syntax

```freebasic
TuiRed( ) as TuiColor
```

## Description

Shorthand for TuiAnsi( TUIC_RED ) -- palette index 1.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor c = TuiRed( )
print c.Index( )                  '' 1
dim as TuiStyle s = TuiStyleOf( c, TuiDefaultColor( ), TUIATTR_BOLD )
print s.HasAttr( TUIATTR_BOLD )   '' true
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)