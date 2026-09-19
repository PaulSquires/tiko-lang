[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiColor**

# TuiColor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiColor
    as ubyte kind      '' TuiColorKind
    as ubyte r, g, b
end type
```

## Description

A tagged colour value, four bytes, deliberately not a UNION -- a ustring inside a union is rejected by the compiler and the layout was designed around that. You always write the colour you mean; the downgrade ladder reduces it at write time to whatever the terminal can actually show.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiColor d = TuiDefaultColor( )       '' the terminal's own default
dim as TuiColor a = TuiAnsi( TUIC_BRIGHTBLUE )
dim as TuiColor x = TuiIndexed( 214 )        '' the 256-colour cube
dim as TuiColor t = TuiRgb( 235, 80, 80 )    '' 24-bit

print d.IsDefault( )              '' true
print t.r, t.g, t.b               '' 235 80 80
print a.Equals( TuiAnsi( TUIC_BRIGHTBLUE ) ) '' true

'' r, g and b MEAN SOMETHING ONLY FOR AN RGB COLOUR. For an ANSI16 or a
'' 256-colour value the palette entry is in Index( ), and reading .r gives
'' you the raw storage instead of a red component.
print a.Index( )                  '' 12
print x.Index( )                  '' 214
```

## See also

[TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow) · [TuiBlue](Modern-Tui-TuiBlue)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)