[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Size**

# TuiTerminal.Size

## Syntax

```freebasic
TuiTerminal.Size( ) as TuiSizeResult
```

## Description

The current terminal size, as Result( of TuiSize, TuiError ). It is never zero: a terminal that reports nothing useful yields an error rather than a 0x0 screen you would then divide by.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiTerminal term
dim as TuiSizeResult sr = term.Size( )
if( sr.IsOk( ) ) then
    print sr.Value( ).cols; "x"; sr.Value( ).rows
else
    print "no size: " & sr.Failure( ).Message( )
end if
```

## See also

[TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) · [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) · [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)