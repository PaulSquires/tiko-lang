[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Colour and Style](Category-Terminal-TUI-Library) › **TuiLuminance**

# TuiLuminance

## Syntax

```freebasic
TuiLuminance( byval r as int32, byval g as int32, byval b as int32 ) as float64
```

## Description

Perceptual brightness, 0.0 to 1.0, using the Rec. 709 weights. This is the bottom rung of the ladder: on a mono terminal a colour becomes bold or not depending on which side of the threshold it lands.

## Example

```freebasic
#import "std/tui"
using tui

print TuiLuminance( 255, 255, 255 )    '' 0.9999999999999999 -- the weights
                                       '' sum to 1 in exact arithmetic, not in
                                       '' binary floating point. Compare with
                                       '' a threshold, never for equality.
print TuiLuminance( 0, 0, 0 )          '' 0
print TuiLuminance( 0, 255, 0 ) > TuiLuminance( 0, 0, 255 )   '' true: green
                                       '' reads brighter than blue
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