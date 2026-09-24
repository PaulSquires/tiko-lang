[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiSgr**

# TuiSgr

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiSgr( byval prev as TuiStyle, byval want as TuiStyle, byval depth as TuiColorDepth ) as string
```

## Description

The escape sequence that moves a terminal from one style to another at a given depth, and NOTHING more -- it emits only the difference. This is the encoder the diff renderer drives; you need it only if you are writing bytes yourself.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiStyle a = TuiStyleDefault( )
dim as TuiStyle b = TuiStyleOf( TuiRgb( 235, 80, 80 ), TuiDefaultColor( ), TUIATTR_BOLD )

dim as string seq = TuiSgr( a, b, TUIDEPTH_TRUECOLOR )
print len( seq )                       '' 19 -- bold plus a 24-bit foreground
print len( TuiSgr( b, b, TUIDEPTH_TRUECOLOR ) )   '' 0 -- nothing changed,
                                       '' nothing emitted
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)