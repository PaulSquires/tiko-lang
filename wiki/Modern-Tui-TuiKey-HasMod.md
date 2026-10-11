[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKey.HasMod**

# TuiKey.HasMod

## Syntax

```freebasic
TuiKey.HasMod( byval m as TuiMod ) as boolean
```

## Description

Tests one modifier bit: TUIMOD_SHIFT, TUIMOD_ALT or TUIMOD_CTRL. Also a bare boolean -- see IsChar.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiKey k
k.code = TUIKEY_LEFT
k.mods = TUIMOD_CTRL or TUIMOD_SHIFT
print k.HasMod( TUIMOD_CTRL )     '' true
print k.HasMod( TUIMOD_ALT )      '' false
print TuiKeyName( k )             '' Ctrl+Shift+Left
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)