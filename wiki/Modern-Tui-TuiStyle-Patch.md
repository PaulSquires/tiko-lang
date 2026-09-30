[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyle.Patch**

# TuiStyle.Patch

## Syntax

```freebasic
TuiStyle.Patch( byval over as TuiStyle ) as TuiStyle
```

## Description

Compose two styles: `over` supplies only what it SETS, and everything else is kept. This is the single most important call in the styling layer, because ASSIGNING a style replaces it -- drawing with a style whose background is default erases whatever was filled underneath. A focused text input once punched a black hole through its own focus fill exactly this way.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStyle base_ = TuiStyleOf( TuiRgb( 200, 200, 200 ), TuiRgb( 20, 20, 30 ), TUIATTR_NONE )
dim as TuiStyle accent = TuiStyleOf( TuiRgb( 250, 180, 60 ), TuiDefaultColor( ), TUIATTR_BOLD )

dim as TuiStyle merged = base_.Patch( accent )
print merged.fg.r, merged.fg.g, merged.fg.b     '' 250 180 60 -- accent's fg
print merged.bg.r, merged.bg.g, merged.bg.b     '' 20 20 30   -- base's bg SURVIVES
print merged.HasAttr( TUIATTR_BOLD )            '' true

'' the wrong way, kept here because it is the bug people write
'' merged = accent          <- the background is now the terminal default
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