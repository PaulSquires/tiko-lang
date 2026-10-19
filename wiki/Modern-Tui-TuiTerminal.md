[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTerminal**

# TuiTerminal

Holds the terminal itself, for writing your own loop: modes, size and output.

## Syntax

```freebasic
type TuiTerminal
    declare function Enter( byval opts as TuiTermOptions ) as TuiUnitResult
    declare function Leave( ) as TuiUnitResult
    ...
end type
```

## Description

The terminal itself: raw mode, the alternate screen, capability detection and buffered output. TuiRun owns one for you, so you need this directly only when writing your own loop. Enter and Leave are symmetric and Leave is idempotent.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
dim as TuiUnitResult er = term.Enter( TuiTermOptionsDefault( ) )
if( er.IsOk( ) = false ) then
    print "cannot start: " & er.Failure( ).Message( )
    end 1
end if

'' THE DEFER GOES AT PROCEDURE SCOPE. Inside the IF above it would fire at
'' END IF and restore the terminal before you drew anything -- tiko-lang's
'' defer is scoped to the enclosing BLOCK, not the function.
defer term.Leave( )

term.Write( TuiClearScreenSeq( ) )
term.Flush( )
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) | [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) | [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) | [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) |
| [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) | [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) | [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) | [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) |
| [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) | [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) | [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) | [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)