[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKey.IsChar**

# TuiKey.IsChar

## Syntax

```freebasic
TuiKey.IsChar( ) as boolean
```

## Description

True when this is a printable character rather than a named key -- that is, when `ch` is worth reading. It returns a BARE BOOLEAN, so mixing it with a comparison in one ANDALSO chain is warning 38; hoist to a boolean local.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiKey k
k.code = TUIKEY_CHAR : k.ch = asc( "q" )
print k.IsChar( )                 '' true

'' the correct shape -- warning 38 is only visible at -w all
dim as boolean wasChar = k.IsChar( )
dim as boolean isQ = ( k.ch = asc( "q" ) )
if( wasChar andalso isQ ) then print "quit"
```

## See also

[TuiEvent](Modern-Tui-TuiEvent) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)