[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKey**

# TuiKey

## Syntax

```freebasic
type TuiKey
    as uint16 code     '' TuiKeyCode
    as uint8 mods      '' TuiMod bits
    as uint32 ch        '' the codepoint, when code = TUIKEY_CHAR
end type
```

## Description

A key press. `code` is either TUIKEY_CHAR -- in which case `ch` holds the codepoint -- or a named key. The named keys are ENTER, TAB, BACKSPACE, ESCAPE, the four arrows, HOME, END_, PAGEUP, PAGEDOWN, INSERT, DELETE and F1 to F12. END_ carries the underscore because END is a statement.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiKey k
k.code = TUIKEY_CHAR
k.ch = asc( "s" )
k.mods = TUIMOD_CTRL
print k.IsChar( )                 '' true
print k.HasMod( TUIMOD_CTRL )     '' true
print TuiKeyName( k )             '' Ctrl+s

dim as TuiKey f5
f5.code = TUIKEY_F5
print f5.IsChar( )                '' false
print TuiKeyName( f5 )            '' F5
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)