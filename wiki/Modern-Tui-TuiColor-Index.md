[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiColor.Index**

# TuiColor.Index

Returns the palette number of a 16-colour or 256-colour value.

## Syntax

```freebasic
TuiColor.Index( ) as uint8
```

## Description

The palette index, for an ANSI-16 or 256-colour value. Meaningless for RGB and default colours.

## Example

```freebasic
#import "std/tui"
using tui

print TuiIndexed( 214 ).Index( )             '' 214
print TuiAnsi( TUIC_BRIGHTBLUE ).Index( )    '' 12
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiColor](Modern-Tui-TuiColor) | [TuiColor.Equals](Modern-Tui-TuiColor-Equals) | [TuiAnsi](Modern-Tui-TuiAnsi) | [TuiRgb](Modern-Tui-TuiRgb) | [TuiRed](Modern-Tui-TuiRed) | [TuiYellow](Modern-Tui-TuiYellow) |
| [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) | [TuiDefaultColor](Modern-Tui-TuiDefaultColor) | [TuiIndexed](Modern-Tui-TuiIndexed) | [TuiBlack](Modern-Tui-TuiBlack) | [TuiGreen](Modern-Tui-TuiGreen) | [TuiBlue](Modern-Tui-TuiBlue) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Colour and Style  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)