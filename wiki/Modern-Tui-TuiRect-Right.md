[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Right**

# TuiRect.Right

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiRect.Right( ) as long
```

## Description

x + w -- one column PAST the last one inside the rect, the way an end iterator works. `Right( ) - 1` is the last column.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiRect r = TuiRectOf( 4, 2, 20, 6 )
print r.Right( )                  '' 24
print r.Contains( 23, 2 )         '' true  -- the last column
print r.Contains( 24, 2 )         '' false -- Right( ) itself is outside
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)