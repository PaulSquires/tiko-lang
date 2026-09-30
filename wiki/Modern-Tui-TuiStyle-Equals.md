[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiStyle.Equals**

# TuiStyle.Equals

## Syntax

```freebasic
TuiStyle.Equals( byval o as TuiStyle ) as boolean
```

## Description

Full comparison including the mask. The renderer uses this to decide whether an SGR sequence is needed at all.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStyle a = TuiStyleOf( TuiRgb( 1, 2, 3 ), TuiRgb( 4, 5, 6 ), TUIATTR_BOLD )
dim as TuiStyle b = TuiStyleOf( TuiRgb( 1, 2, 3 ), TuiRgb( 4, 5, 6 ), TUIATTR_BOLD )
print a.Equals( b )               '' true
print a.Equals( TuiStyleDefault( ) )         '' false
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