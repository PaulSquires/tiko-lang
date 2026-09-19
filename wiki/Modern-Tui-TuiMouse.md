[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiMouse**

# TuiMouse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiMouse
    as ubyte kind, button, mods
    as long x, y       '' ZERO-BASED
end type
```

## Description

A mouse event. The coordinates are 0-based cell positions in the same space as every rect, so Contains is the hit test. The wire form is 1-based and is converted in the parser and nowhere else.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiEvent e
e.kind = TUIEVENT_MOUSE
e.mouse.kind = TUIMOUSE_PRESS
e.mouse.button = TUIBTN_LEFT
e.mouse.x = 12 : e.mouse.y = 4

dim as TuiRect panel = TuiRectOf( 10, 2, 20, 8 )
print panel.Contains( e.mouse.x, e.mouse.y )       '' true

'' the kinds: TUIMOUSE_PRESS RELEASE MOVE WHEELUP WHEELDOWN
'' the buttons: TUIBTN_NONE LEFT MIDDLE RIGHT
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)