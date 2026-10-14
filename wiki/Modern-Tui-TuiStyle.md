[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyle**

# TuiStyle

## Syntax

```freebasic
type TuiStyle
    as TuiColor fg, bg
    as uint16 attrs
    as uint16 mask
end type
```

## Description

Foreground, background, attribute bits, and a MASK saying which of those this style actually sets. The mask is what makes Patch work: a style that sets only a foreground can be composed over another without erasing its background.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiStyle s = TuiStyleOf( TuiRgb( 200, 200, 200 ), TuiRgb( 20, 20, 30 ), TUIATTR_BOLD )
print s.fg.r, s.bg.b              '' 200 30
print s.HasAttr( TUIATTR_BOLD )   '' true
print s.HasAttr( TUIATTR_ITALIC ) '' false
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