[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Unicode Width](Category-Terminal-TUI-Library) › **TuiTruncate**

# TuiTruncate

## Syntax

```freebasic
TuiTruncate( byref s as ustring, byval maxCols as int32, byref ellipsis as ustring = "..." ) as ustring
```

## Description

Cuts a string to fit a column budget. THE ELLIPSIS DEFAULTS TO "..." and is itself counted, so the result never exceeds maxCols -- pass an empty string for a hard cut. It never splits a wide glyph in half, and when even the ellipsis will not fit, the ELLIPSIS is truncated rather than the budget exceeded.

## Example

```freebasic
#import "std/tui"
using FB

print TuiTruncate( "abcdefgh", 5 )                 '' ab... -- the ellipsis
                                                   '' DEFAULTS to "..." and
                                                   '' counts toward the 5
print TuiTruncate( "abcdefgh", 5, "" )             '' abcde -- a hard cut
print TuiTruncate( "abc", 10 )                     '' abc -- shorter is untouched

'' two wide glyphs in a 3-column budget: there is no room for a glyph AND the
'' ellipsis, so only the ellipsis survives -- and it still fits exactly
print TuiStringWidth( TuiTruncate( wchr( &h4E2D ) & wchr( &h4E2D ), 3 ) )   '' 3
```

## See also

[TuiCharWidth](Modern-Tui-TuiCharWidth) · [TuiStringWidth](Modern-Tui-TuiStringWidth) · [TuiWrap](Modern-Tui-TuiWrap) · [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Unicode Width  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)