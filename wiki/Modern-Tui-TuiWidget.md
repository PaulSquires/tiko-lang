[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiWidget**

# TuiWidget

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiWidget extends Object
    declare abstract sub Render( byref f as TuiFrame, byval area as TuiRect )
    declare abstract function Kind( ) as ustring
    declare virtual function HandleEvent( byref e as TuiEvent ) as boolean
    declare virtual function SizeHint( byval avail as TuiRect ) as TuiSize
    declare virtual function CanFocus( ) as boolean
    declare virtual sub SetFocused( byval on_ as boolean )
    declare virtual destructor( )
end type
```

## Description

The abstract base every widget derives from, so a container can hold a mixed Array( of TuiWidget ptr ). Render and Kind are abstract; the rest have sensible defaults, so a display-only widget overrides two methods and no more.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

type Ticker extends TuiWidget
    as long n
    declare sub Render( byref f as TuiFrame, byval area as TuiRect ) override
    declare function Kind( ) as ustring override
end type

sub Ticker.Render( byref f as TuiFrame, byval area as TuiRect )
    f.DrawText( area.x, area.y, "n=" & str( n ), TuiStyleDefault( ) )
end sub

function Ticker.Kind( ) as ustring
    return "Ticker"
end function

dim as Ticker t
t.n = 7
print t.Kind( )                   '' Ticker
print t.CanFocus( )               '' false -- the default
```

## See also

[TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) · [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)