[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiCmd**

# TuiCmd

## Syntax

```freebasic
type TuiCmd
    as uint8 kind      '' TuiCmdKind
    as int32 arg        '' ms for TICK, exit code for QUIT
end type
```

## Description

What Update and Init tell the loop to do. A plain value, so you can build one, pass it around, and return it later.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCmd c = TuiTick( 250 )
print c.kind = TUICMD_TICK         '' -1 (true)
print c.arg                       '' 250

c = TuiQuit( 3 )
print c.kind = TUICMD_QUIT, c.arg  '' -1 (true) 3
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)