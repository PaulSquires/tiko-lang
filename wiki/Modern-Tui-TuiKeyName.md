[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKeyName**

# TuiKeyName

## Syntax

```freebasic
TuiKeyName( byval k as TuiKey ) as ustring
```

## Description

A printable name, modifiers included -- for a status line, a keybinding list, or a log.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiKey k
k.code = TUIKEY_F5
print TuiKeyName( k )             '' F5

k.mods = TUIMOD_CTRL or TUIMOD_SHIFT
print TuiKeyName( k )             '' Ctrl+Shift+F5

k.code = TUIKEY_CHAR : k.ch = asc( "a" ) : k.mods = TUIMOD_ALT
print TuiKeyName( k )             '' Alt+a
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)