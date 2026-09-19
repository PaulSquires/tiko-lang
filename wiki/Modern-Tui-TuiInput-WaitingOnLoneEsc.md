[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.WaitingOnLoneEsc**

# TuiInput.WaitingOnLoneEsc

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiInput.WaitingOnLoneEsc( ) as boolean
```

## Description

True when the parser is holding an ESC it cannot yet classify. This is what a loop watches to decide when to poll with a short timeout instead of blocking -- and why an Esc keypress is marginally slower than any other.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiInput keys
keys.Feed( chr( 27 ) )
print keys.WaitingOnLoneEsc( )    '' true
keys.Feed( "[C" )
print keys.NextEvent( ).Value( ).key.code = TUIKEY_RIGHT '' -1 (true)
print keys.WaitingOnLoneEsc( )    '' false
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)