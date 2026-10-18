[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiTermOptionsDefault**

# TuiTermOptionsDefault

## Syntax

```freebasic
TuiTermOptionsDefault( ) as TuiTermOptions
```

## Description

Alternate screen, raw mode, hidden cursor and bracketed paste. MOUSE AND FOCUS EVENTS ARE OFF -- both are opt-in, because a program that does not use them should not make the terminal send them. examples/dashboard.tiko turns the mouse on explicitly, and a program that forgets to will never see a mouse event however much else is right.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTermOptions o = TuiTermOptionsDefault( )
print o.altScreen, o.rawMode, o.hideCursor      '' true true true
print o.bracketedPaste                          '' true
print o.mouse, o.focusEvents                    '' false false -- OPT-IN

'' asking for the mouse, the way examples/dashboard.tiko does
o.mouse = TRUE
print o.mouse                                   '' true
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