[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiError.Message**

# TuiError.Message

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiError.Message( ) as string
```

## Description

A formatted line: what went wrong, what was being attempted, and the OS error number when there is one. Print this, not the code.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiError e = TuiError( TUIERR_RAWMODE, "SetConsoleMode(in)", 5 )
print e.Message( )                '' includes the detail and the OS number 5
```

## See also

[TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) · [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)