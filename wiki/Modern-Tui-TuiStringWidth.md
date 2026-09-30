[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Unicode Width](Category-Terminal-TUI-Library) › **TuiStringWidth**

# TuiStringWidth

## Syntax

```freebasic
TuiStringWidth( byref s as ustring ) as int32
```

## Description

Columns for a whole string. Use this and never LEN when deciding whether text fits -- LEN counts UTF-16 code units, which is neither characters nor columns. WHAT THIS DOES NOT DO: there is no UAX-29 clustering, so an emoji ZWJ sequence measures as the sum of its parts and will overrun a box.

## Example

```freebasic
#import "std/tui"
using FB

print TuiStringWidth( "hello" )                    '' 5
print TuiStringWidth( wchr( &h4E2D ) & "x" )       '' 3 -- 2 + 1
print TuiStringWidth( "e" & wchr( &h0301 ) )       '' 1 -- the mark is free
```

## See also

[TuiCharWidth](Modern-Tui-TuiCharWidth) · [TuiTruncate](Modern-Tui-TuiTruncate) · [TuiWrap](Modern-Tui-TuiWrap) · [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Unicode Width  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)