[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiCmd**

# TuiCmd

Holds a command for the loop: what to do, plus a delay or an exit code.

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
using tui

dim as TuiCmd c = TuiTick( 250 )
print c.kind = TUICMD_TICK         '' -1 (true)
print c.arg                       '' 250

c = TuiQuit( 3 )
print c.kind = TUICMD_QUIT, c.arg  '' -1 (true) 3
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiApp](Modern-Tui-TuiApp) | [TuiApp.Update](Modern-Tui-TuiApp-Update) | [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) | [TuiRedraw](Modern-Tui-TuiRedraw) | [TuiTick](Modern-Tui-TuiTick) | [TuiSuspend](Modern-Tui-TuiSuspend) |
| [TuiApp.Init](Modern-Tui-TuiApp-Init) | [TuiApp.View](Modern-Tui-TuiApp-View) | [TuiNone](Modern-Tui-TuiNone) | [TuiQuit](Modern-Tui-TuiQuit) | [TuiInvalidate](Modern-Tui-TuiInvalidate) | [TuiRun](Modern-Tui-TuiRun) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)