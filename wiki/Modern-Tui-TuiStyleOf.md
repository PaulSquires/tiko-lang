[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyleOf**

# TuiStyleOf

## Syntax

```freebasic
TuiStyleOf( byval fg as TuiColor, byval bg as TuiColor, byval attrs as uint16 = TUIATTR_NONE ) as TuiStyle
```

## Description

Builds a style that sets all three things. For a style that sets only some of them -- so that Patch leaves the rest alone -- use TuiStylePatch.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStyle s = TuiStyleOf( TuiRgb( 235, 80, 80 ), TuiDefaultColor( ), TUIATTR_BOLD )
print s.fg.r, s.bg.IsDefault( ), s.HasAttr( TUIATTR_BOLD )   '' 235 true true
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)