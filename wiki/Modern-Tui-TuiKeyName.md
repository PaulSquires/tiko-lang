[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKeyName**

# TuiKeyName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiKeyName( byval k as TuiKey ) as ustring
```

## Description

A printable name, modifiers included -- for a status line, a keybinding list, or a log.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiKey k
k.code = TUIKEY_F5
print TuiKeyName( k )             '' F5

k.mods = TUIMOD_CTRL or TUIMOD_SHIFT
print TuiKeyName( k )             '' Ctrl+Shift+F5

k.code = TUIKEY_CHAR : k.ch = asc( "a" ) : k.mods = TUIMOD_ALT
print TuiKeyName( k )             '' Alt+a
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)