[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.Buffered**

# TuiInput.Buffered

Counts the bytes held that do not yet make a whole event.

## Syntax

```freebasic
TuiInput.Buffered( ) as int32
```

## Description

Bytes held that have not yet formed an event.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiInput keys
keys.Feed( chr( 27 ) & "[" )
print keys.Buffered( ) > 0         '' -1 (true)  -- an incomplete sequence
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)