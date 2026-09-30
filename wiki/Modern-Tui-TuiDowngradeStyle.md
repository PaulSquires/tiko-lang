[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiDowngradeStyle**

# TuiDowngradeStyle

## Syntax

```freebasic
TuiDowngradeStyle( byval s as TuiStyle, byval depth as TuiColorDepth ) as TuiStyle
```

## Description

Downgrades both colours of a style at once. At TUIDEPTH_MONO each colour collapses to ANSI black or white by luminance and the DIFFERENCE between styles is carried by the attributes -- which is why a selection is still visible on a monochrome terminal.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStyle s = TuiStyleOf( TuiRgb( 235, 80, 80 ), TuiRgb( 20, 20, 30 ), TUIATTR_BOLD )
dim as TuiStyle m = TuiDowngradeStyle( s, TUIDEPTH_MONO )
print m.fg.kind = TUICOLOR_ANSI16  '' -1 (true)  -- collapsed to the palette
print m.fg.Index( )                    '' 0 -- black, by luminance
print m.attrs <> 0                 '' -1 (true)  -- the difference is here
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)