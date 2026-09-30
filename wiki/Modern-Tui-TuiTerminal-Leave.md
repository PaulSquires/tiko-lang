[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Leave**

# TuiTerminal.Leave

## Syntax

```freebasic
TuiTerminal.Leave( ) as TuiUnitResult
```

## Description

Undoes everything Enter did, in exactly the reverse order, and restores the saved console mode word or termios. The style is reset FIRST so nothing bleeds onto the main screen, and the alternate screen is left LAST. Safe to call when not active.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiTerminal term
print term.Leave( ).IsOk( )       '' true -- nothing to undo, still fine
print term.IsActive( )            '' false
```

## See also

[TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) · [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)