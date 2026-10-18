[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyle.Equals**

# TuiStyle.Equals

## Syntax

```freebasic
TuiStyle.Equals( byval o as TuiStyle ) as boolean
```

## Description

Full comparison including the mask. The renderer uses this to decide whether an SGR sequence is needed at all.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiStyle a = TuiStyleOf( TuiRgb( 1, 2, 3 ), TuiRgb( 4, 5, 6 ), TUIATTR_BOLD )
dim as TuiStyle b = TuiStyleOf( TuiRgb( 1, 2, 3 ), TuiRgb( 4, 5, 6 ), TUIATTR_BOLD )
print a.Equals( b )               '' true
print a.Equals( TuiStyleDefault( ) )         '' false
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