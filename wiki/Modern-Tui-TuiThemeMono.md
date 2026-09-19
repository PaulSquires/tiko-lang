[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiThemeMono**

# TuiThemeMono

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiThemeMono( ) as TuiTheme
```

## Description

A theme built from ATTRIBUTES rather than colours -- bold, dim, reverse, underline. Use it when TuiCaps reports TUIDEPTH_MONO, or for output that has to survive being piped through something colour-blind.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiTheme mo = TuiThemeMono( )
print mo.normal.fg.IsDefault( )        '' true -- it chooses no colours
print mo.selected.HasAttr( TUIATTR_REVERSE )   '' true

'' pick a theme from what the terminal can do
dim as TuiTerminal term
dim as TuiTheme th = iif( term.DetectCaps( ).depth = TUIDEPTH_MONO, _
                          TuiThemeMono( ), TuiThemeDefault( ) )
```

## See also

[TuiColor](Modern-Tui-TuiColor) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiRed](Modern-Tui-TuiRed) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiYellow](Modern-Tui-TuiYellow)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)