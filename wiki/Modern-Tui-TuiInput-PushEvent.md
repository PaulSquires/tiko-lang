[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.PushEvent**

# TuiInput.PushEvent

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiInput.PushEvent( byval e as TuiEvent )
```

## Description

Puts an event at the back of the queue. For synthesising input -- a replayed macro, a test, or a key your own code decided to inject.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiInput keys
dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
keys.PushEvent( e )
print keys.Queued( )                       '' 1
print keys.NextEvent( ).Value( ).key.code = TUIKEY_ENTER '' -1 (true)
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)