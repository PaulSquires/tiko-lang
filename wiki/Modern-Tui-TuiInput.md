[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput**

# TuiInput

## Syntax

```freebasic
type TuiInput
    declare sub Feed( byref bytes as string )
    declare function NextEvent( byval escExpired as boolean = FALSE ) as TuiEventOpt
    ...
end type
```

## Description

The VT parser. Feed it bytes, take events out. You need this only when driving your own loop -- and it is also how the module's own input tests work, with no terminal at all.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiInput keys
keys.Feed( chr( 27 ) & "[A" )              '' CSI A -- cursor up

dim as TuiEventOpt ev = keys.NextEvent( )
print ev.HasValue( )                       '' true
print ev.Value( ).key.code = TUIKEY_UP '' -1 (true)
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)