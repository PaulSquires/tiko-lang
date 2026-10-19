[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiSgr**

# TuiSgr

Returns the escape sequence that changes the terminal from one style to another.

## Syntax

```freebasic
TuiSgr( byval prev as TuiStyle, byval want as TuiStyle, byval depth as TuiColorDepth ) as string
```

## Description

The escape sequence that moves a terminal from one style to another at a given depth, and NOTHING more -- it emits only the difference. This is the encoder the diff renderer drives; you need it only if you are writing bytes yourself.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiStyle a = TuiStyleDefault( )
dim as TuiStyle b = TuiStyleOf( TuiRgb( 235, 80, 80 ), TuiDefaultColor( ), TUIATTR_BOLD )

dim as ustring seq = TuiSgr( a, b, TUIDEPTH_TRUECOLOR )
print len( seq )                       '' 19 -- bold plus a 24-bit foreground
print len( TuiSgr( b, b, TUIDEPTH_TRUECOLOR ) )   '' 0 -- nothing changed,
                                       '' nothing emitted
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