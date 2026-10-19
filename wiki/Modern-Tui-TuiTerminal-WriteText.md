[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal.WriteText**

# TuiTerminal.WriteText

Adds a string to the output buffer as UTF-8.

## Syntax

```freebasic
TuiTerminal.WriteText( byref u as ustring ) as TuiUnitResult
```

## Description

Appends a ustring, encoded as UTF-8. On Windows this is why Enter sets the console output code page to 65001 -- without that the console would decode these bytes in code page 437 and every non-ASCII glyph would arrive as mojibake.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
term.WriteText( "CJK: " & wchr( &h4E2D ) )
print term.Pending( ) > 0          '' -1 (true)
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal](Modern-Tui-TuiTerminal) | [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)