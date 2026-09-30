[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTermOptions**

# TuiTermOptions

## Syntax

```freebasic
type TuiTermOptions
    as boolean altScreen, rawMode, hideCursor
    as boolean mouse, bracketedPaste, focusEvents
end type
```

## Description

What to take from the terminal. Every field is off in a default-constructed value, and TuiTermOptionsDefault turns on the usual set -- but NOT the mouse and NOT focus events, which are opt-in. Whatever Enter switches on, Leave switches off.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiTermOptions bare        '' everything FALSE
print len( TuiEnterSeq( bare ) )  '' 0 -- takes nothing, emits nothing

dim as TuiTermOptions o = TuiTermOptionsDefault( )
o.mouse = FALSE                   '' a keyboard-only application
print o.altScreen, o.rawMode      '' true true
```

## See also

[TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) · [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Terminal  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)