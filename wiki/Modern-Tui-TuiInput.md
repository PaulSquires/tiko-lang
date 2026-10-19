[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput**

# TuiInput

Holds the parser that turns raw terminal bytes into events.

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
#import "std/tui"
using tui

dim as TuiInput keys
keys.Feed( chr( 27 ) & "[A" )              '' CSI A -- cursor up

dim as TuiEventOpt ev = keys.NextEvent( )
print ev.HasValue( )                       '' true
print ev.Value( ).key.code = TUIKEY_UP '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)