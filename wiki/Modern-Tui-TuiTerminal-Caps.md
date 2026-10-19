[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Caps**

# TuiTerminal.Caps

Returns what the terminal can do, as detected once when it was entered.

## Syntax

```freebasic
TuiTerminal.Caps( ) as TuiCaps
```

## Description

The capabilities detected at Enter. Cached -- detection runs once.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
dim as TuiCaps c = term.Caps( )
print c.isTerminal, c.mouse, c.unicode
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)