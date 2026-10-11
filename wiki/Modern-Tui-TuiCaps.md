[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Terminal](Category-Terminal-TUI-Library) › **TuiCaps**

# TuiCaps

## Syntax

```freebasic
type TuiCaps
    as boolean isTerminal
    as int32 depth          '' TuiColorDepth
    as boolean mouse, bracketedPaste, focusEvents, unicode
end type
```

## Description

What this terminal can do, from TERM, COLORTERM, WT_SESSION, the Windows build number and GetConsoleMode. There is no terminfo database involved.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTerminal term
dim as TuiCaps c = term.DetectCaps( )
if( c.unicode = FALSE ) then
    '' fall back to ASCII borders rather than drawing boxes out of mojibake
    print "ASCII mode"
end if
print c.depth = TUIDEPTH_TRUECOLOR orelse c.depth = TUIDEPTH_256 _
      orelse c.depth = TUIDEPTH_ANSI16 orelse c.depth = TUIDEPTH_MONO   '' true
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