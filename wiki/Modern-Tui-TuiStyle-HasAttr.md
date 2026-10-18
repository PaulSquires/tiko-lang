[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyle.HasAttr**

# TuiStyle.HasAttr

## Syntax

```freebasic
TuiStyle.HasAttr( byval a as TuiAttr ) as boolean
```

## Description

Tests one attribute bit. The attributes are TUIATTR_BOLD, _DIM, _ITALIC, _UNDERLINE, _BLINK, _REVERSE, _STRIKE and _HIDDEN.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiStyle s = TuiStyleOf( TuiWhite( ), TuiBlack( ), TUIATTR_BOLD or TUIATTR_UNDERLINE )
print s.HasAttr( TUIATTR_BOLD )        '' true
print s.HasAttr( TUIATTR_UNDERLINE )   '' true
print s.HasAttr( TUIATTR_REVERSE )     '' false
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