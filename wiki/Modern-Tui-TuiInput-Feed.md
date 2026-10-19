[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.Feed**

# TuiInput.Feed

Adds raw bytes from the terminal; an unfinished sequence is kept for later.

## Syntax

```freebasic
TuiInput.Feed( byref bytes as string )
```

## Description

Appends raw bytes. A sequence may arrive split across two reads; the parser keeps what it cannot yet decide about.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiInput keys
keys.Feed( chr( 27 ) )            '' half of a sequence
print keys.NextEvent( ).HasValue( )        '' false -- it waits
keys.Feed( "[B" )                 '' the rest
print keys.NextEvent( ).Value( ).key.code = TUIKEY_DOWN '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)