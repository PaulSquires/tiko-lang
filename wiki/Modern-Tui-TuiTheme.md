[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiTheme**

# TuiTheme

## Syntax

```freebasic
type TuiTheme
    as TuiStyle normal, dim_, accent, selected, disabled
    as TuiStyle border, borderFocused, title
    as TuiStyle success, warning, danger, info
end type
```

## Description

Twelve named styles. There is NO ambient theme singleton -- you hold a theme and pass it where it is needed, which is what lets two panels in one program look different without a global to fight over. `dim_` has the underscore because DIM is a statement.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTheme th = TuiThemeDefault( )
print th.accent.fg.IsDefault( )        '' false -- the accent picks a colour
print th.accent.fg.Index( )            '' 14 -- bright cyan
print th.danger.fg.Index( )            '' 9  -- bright red

'' The stock theme is built from ANSI16 entries on purpose, so it honours a
'' user's terminal palette. Read Index( ), not .r -- see TuiColor.

'' a theme is a value: copy it and change one entry
dim as TuiTheme mine = th
mine.accent = TuiStyleOf( TuiRgb( 250, 180, 60 ), TuiDefaultColor( ), TUIATTR_BOLD )
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