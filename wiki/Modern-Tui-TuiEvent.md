[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiEvent**

# TuiEvent

## Syntax

```freebasic
type TuiEvent
    as ubyte kind
    as TuiKey key
    as TuiMouse mouse
    as TuiSize size
    as ustring text
    as boolean focused
end type
```

## Description

A tagged union by convention rather than by UNION -- a ustring cannot live in one. Read `kind` first and only then the matching field. The kinds are TUIEVENT_KEY, _MOUSE, _RESIZE, _PASTE, _FOCUS and _TICK.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiEvent e
e.kind = TUIEVENT_KEY
e.key.code = TUIKEY_CHAR
e.key.ch = asc( "q" )

select case e.kind
case TUIEVENT_KEY   : print "key "; TuiKeyName( e.key )
case TUIEVENT_MOUSE : print "mouse at "; e.mouse.x; ","; e.mouse.y
case TUIEVENT_RESIZE: print "resize to "; e.size.cols
case TUIEVENT_PASTE : print "pasted "; len( e.text ); " units"
case TUIEVENT_FOCUS : print "focus "; e.focused
end select
```

## See also

[TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)