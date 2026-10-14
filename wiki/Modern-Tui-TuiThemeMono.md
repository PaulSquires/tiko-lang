[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiThemeMono**

# TuiThemeMono

## Syntax

```freebasic
TuiThemeMono( ) as TuiTheme
```

## Description

A theme built from ATTRIBUTES rather than colours -- bold, dim, reverse, underline. Use it when TuiCaps reports TUIDEPTH_MONO, or for output that has to survive being piped through something colour-blind.

## Example

```freebasic
#import "std/tui"
using tui

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

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)