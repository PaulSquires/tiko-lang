[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStylePatch**

# TuiStylePatch

## Syntax

```freebasic
TuiStylePatch( byval fg as TuiColor, byval bg as TuiColor, byval attrs as uint16, byval which as uint16 ) as TuiStyle
```

## Description

Builds a PARTIAL style: `which` is the mask of what this style actually sets. Everything outside the mask is left for Patch to inherit from below. This is how you write \"just make it bold\" without also deciding the colours.

## Example

```freebasic
#import "std/tui"
using tui

'' a style that sets ONLY the bold bit
dim as TuiStyle boldOnly = TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
                                          TUIATTR_BOLD, TUIATTR_BOLD )

dim as TuiStyle base_ = TuiStyleOf( TuiRgb( 90, 200, 90 ), TuiRgb( 20, 20, 30 ) )
dim as TuiStyle out_  = base_.Patch( boldOnly )
print out_.fg.g                        '' 200 -- the colour survived
print out_.HasAttr( TUIATTR_BOLD )     '' true
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiColor.Index](Modern-Tui-TuiColor-Index) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)