[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Unicode Width](Category-Terminal-TUI-Library) › **TuiSetAmbiguousWide**

# TuiSetAmbiguousWide

## Syntax

```freebasic
TuiSetAmbiguousWide( byval on_ as boolean )
```

## Description

Switches the 179 East Asian AMBIGUOUS ranges between 1 and 2 columns. Narrow is the default, which is right for a Western terminal and wrong in a CJK locale. It is GLOBAL on purpose -- a per-call parameter would have to be threaded through every widget.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

print TuiCharWidth( &h00A1 )      '' 1 -- INVERTED EXCLAMATION MARK, ambiguous
TuiSetAmbiguousWide( TRUE )
print TuiCharWidth( &h00A1 )      '' 2 -- now measured as a CJK terminal does
TuiSetAmbiguousWide( FALSE )      '' put it back
```

## See also

[TuiCharWidth](Modern-Tui-TuiCharWidth) · [TuiStringWidth](Modern-Tui-TuiStringWidth) · [TuiTruncate](Modern-Tui-TuiTruncate) · [TuiWrap](Modern-Tui-TuiWrap) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Unicode Width  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)