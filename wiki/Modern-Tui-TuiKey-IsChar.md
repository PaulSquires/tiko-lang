[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Events](Category-Terminal-TUI-Library) › **TuiKey.IsChar**

# TuiKey.IsChar

Returns true if the key is a typed character rather than a named key.

## Syntax

```freebasic
TuiKey.IsChar( ) as boolean
```

## Description

True when this is a printable character rather than a named key -- that is, when `ch` is worth reading. It returns a BARE BOOLEAN, so mixing it with a comparison in one ANDALSO chain is warning 38; hoist to a boolean local.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiKey k
k.code = TUIKEY_CHAR : k.ch = asc( "q" )
print k.IsChar( )                 '' true

'' the correct shape -- warning 38 is only visible at -w all
dim as boolean wasChar = k.IsChar( )
dim as boolean isQ = ( k.ch = asc( "q" ) )
if( wasChar andalso isQ ) then print "quit"
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiEvent](Modern-Tui-TuiEvent) | [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) | [TuiKeyName](Modern-Tui-TuiKeyName) | [TuiInput.Feed](Modern-Tui-TuiInput-Feed) | [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) | [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) |
| [TuiKey](Modern-Tui-TuiKey) | [TuiMouse](Modern-Tui-TuiMouse) | [TuiInput](Modern-Tui-TuiInput) | [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) | [TuiInput.Reset](Modern-Tui-TuiInput-Reset) | [TuiInput.Queued](Modern-Tui-TuiInput-Queued) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Events  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)