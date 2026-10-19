[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.WaitingOnLoneEsc**

# TuiInput.WaitingOnLoneEsc

Returns true if the parser holds an Esc it cannot yet tell from a key sequence.

## Syntax

```freebasic
TuiInput.WaitingOnLoneEsc( ) as boolean
```

## Description

True when the parser is holding an ESC it cannot yet classify. This is what a loop watches to decide when to poll with a short timeout instead of blocking -- and why an Esc keypress is marginally slower than any other.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiInput keys
keys.Feed( chr( 27 ) )
print keys.WaitingOnLoneEsc( )    '' true
keys.Feed( "[C" )
print keys.NextEvent( ).Value( ).key.code = TUIKEY_RIGHT '' -1 (true)
print keys.WaitingOnLoneEsc( )    '' false
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)