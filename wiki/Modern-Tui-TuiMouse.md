[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiMouse**

# TuiMouse

## Syntax

```freebasic
type TuiMouse
    as uint8 kind, button, mods
    as int32 x, y       '' ZERO-BASED
end type
```

## Description

A mouse event. The coordinates are 0-based cell positions in the same space as every rect, so Contains is the hit test. The wire form is 1-based and is converted in the parser and nowhere else.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

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

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)