[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.Size**

# TuiTerminal.Size

Returns the terminal's size in columns and rows, or an error if it reports none.

## Syntax

```freebasic
TuiTerminal.Size( ) as TuiSizeResult
```

## Description

The current terminal size, as Result( of TuiSize, TuiError ). It is never zero: a terminal that reports nothing useful yields an error rather than a 0x0 screen you would then divide by.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
dim as TuiSizeResult sr = term.Size( )
if( sr.IsOk( ) ) then
    print sr.Value( ).cols; "x"; sr.Value( ).rows
else
    print "no size: " & sr.Failure( ).Message( )
end if
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)