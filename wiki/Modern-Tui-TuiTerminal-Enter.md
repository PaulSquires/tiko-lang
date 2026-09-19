[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Enter**

# TuiTerminal.Enter

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiTerminal.Enter( byval opts as TuiTermOptions ) as TuiUnitResult
```

## Description

Takes the terminal: alternate screen, raw mode, cursor, mouse, bracketed paste, focus events -- whichever the options ask for. Fails with TUIERR_NOTATTY when stdout is not a terminal, which is the check that stops a dashboard being drawn into a pipe. Calling it twice is a no-op, not an error.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

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

[TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) · [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)