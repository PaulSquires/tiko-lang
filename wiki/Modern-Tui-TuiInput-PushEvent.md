[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.PushEvent**

# TuiInput.PushEvent

Adds an event to the back of the queue, to inject input yourself.

## Syntax

```freebasic
TuiInput.PushEvent( byval e as TuiEvent )
```

## Description

Puts an event at the back of the queue. For synthesising input -- a replayed macro, a test, or a key your own code decided to inject.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiInput keys
dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
keys.PushEvent( e )
print keys.Queued( )                       '' 1
print keys.NextEvent( ).Value( ).key.code = TUIKEY_ENTER '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)