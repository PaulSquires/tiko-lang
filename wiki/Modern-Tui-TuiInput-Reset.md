[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiInput.Reset**

# TuiInput.Reset

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiInput.Reset( )
```

## Description

Throws away both the byte buffer and the event queue. Use it after a suspend, when whatever was half-parsed is no longer meaningful.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiInput keys
keys.Feed( chr( 27 ) & "[1;5" )   '' a partial sequence
keys.Reset( )
print keys.Buffered( ), keys.Queued( )     '' 0 0
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)