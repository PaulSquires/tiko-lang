[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Unicode Width](Category-Terminal-TUI-Library) › **TuiCharWidth**

# TuiCharWidth

## Syntax

```freebasic
TuiCharWidth( byval cp as uint32 ) as int32
```

## Description

How many columns one codepoint occupies: 0, 1 or 2. From a table generated out of Unicode 17.0.0 -- East Asian Wide and Fullwidth measure 2; the Mn, Me and Cf categories measure 0.

## Example

```freebasic
#import "std/tui"
using FB

print TuiCharWidth( asc( "A" ) )  '' 1
print TuiCharWidth( &h4E2D )      '' 2 -- a CJK ideograph
print TuiCharWidth( &h0301 )      '' 0 -- COMBINING ACUTE ACCENT
print TuiCharWidth( &h200B )      '' 0 -- ZERO WIDTH SPACE
```

## See also

[TuiStringWidth](Modern-Tui-TuiStringWidth) · [TuiTruncate](Modern-Tui-TuiTruncate) · [TuiWrap](Modern-Tui-TuiWrap) · [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Unicode Width  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)