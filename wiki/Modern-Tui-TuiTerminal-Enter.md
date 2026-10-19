[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Enter**

# TuiTerminal.Enter

Takes over the terminal with the options asked for; fails if output is not a terminal.

## Syntax

```freebasic
TuiTerminal.Enter( byval opts as TuiTermOptions ) as TuiUnitResult
```

## Description

Takes the terminal: alternate screen, raw mode, cursor, mouse, bracketed paste, focus events -- whichever the options ask for. Fails with TUIERR_NOTATTY when stdout is not a terminal, which is the check that stops a dashboard being drawn into a pipe. Calling it twice is a no-op, not an error.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
dim as TuiTermOptions o = TuiTermOptionsDefault( )
o.mouse = TRUE

dim as TuiUnitResult r = term.Enter( o )
if( r.IsOk( ) = false ) then
    '' under a test harness or a pipe this is the branch that runs
    print r.Failure( ).code = TUIERR_NOTATTY
end if
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |
| [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)