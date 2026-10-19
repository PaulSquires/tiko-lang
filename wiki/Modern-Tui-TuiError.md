[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiError**

# TuiError

Holds a terminal error: a code and what was being attempted.

## Syntax

```freebasic
type TuiError
    as int32 code       '' TuiErrorCode
    as string detail
    declare function Message( ) as string
end type
```

## Description

The error carried by every Result in the module. Errors exist only at the terminal layer: drawing never fails, and lookups return Optional instead.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiError e = TuiError( TUIERR_NOTATTY, "stdout is not a console", 0 )
print e.code = TUIERR_NOTATTY      '' -1 (true)
print e.detail                    '' stdout is not a console
print len( e.Message( ) ) > 0      '' -1 (true)
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