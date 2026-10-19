[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiWhite**

# TuiWhite

Returns the classic white, palette colour 7.

## Syntax

```freebasic
TuiWhite( ) as TuiColor
```

## Description

Shorthand for TuiAnsi( TUIC_WHITE ) -- palette index 7.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor c = TuiWhite( )
print c.Index( )                  '' 7
dim as TuiStyle s = TuiStyleOf( c, TuiDefaultColor( ), TUIATTR_BOLD )
print s.HasAttr( TUIATTR_BOLD )   '' true
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