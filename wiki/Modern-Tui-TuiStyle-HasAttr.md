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

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)