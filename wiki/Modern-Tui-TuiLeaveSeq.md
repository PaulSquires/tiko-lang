[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiLeaveSeq**

# TuiLeaveSeq

## Syntax

```freebasic
TuiLeaveSeq( byval o as TuiTermOptions ) as string
```

## Description

The sequence Leave writes -- every mode Enter set, undone in reverse. It is deliberately short: the emergency restore path writes it from a fixed async-signal-safe buffer after a crash, so it must fit.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTermOptions o = TuiTermOptionsDefault( )
dim as string lv = TuiLeaveSeq( o )
print instr( lv, "[0m" ) = 2                      '' the reset comes FIRST
print instr( lv, "[?1049l" ) > instr( lv, "[?25h" )   '' alt screen goes LAST
print len( lv ) < 128              '' -1 (true)  -- it has to fit
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) |
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)