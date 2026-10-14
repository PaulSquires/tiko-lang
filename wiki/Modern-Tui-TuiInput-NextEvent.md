[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.NextEvent**

# TuiInput.NextEvent

## Syntax

```freebasic
TuiInput.NextEvent( byval escExpired as boolean = FALSE ) as TuiEventOpt
```

## Description

The next complete event, or nothing. ESC IS AMBIGUOUS and always will be: a lone Esc and the start of a CSI sequence are the same byte, so the parser holds it until more bytes arrive or you pass escExpired to say the timeout elapsed.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiInput keys
keys.Feed( chr( 27 ) )
print keys.NextEvent( FALSE ).HasValue( )  '' false -- might be a sequence
print keys.WaitingOnLoneEsc( )             '' true

'' the timeout fired: it really was a lone Esc
print keys.NextEvent( TRUE ).Value( ).key.code = TUIKEY_ESCAPE '' -1 (true)
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)