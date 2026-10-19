[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiInvalidate**

# TuiInvalidate

Returns a command that repaints the whole screen instead of only the changes.

## Syntax

```freebasic
TuiInvalidate( ) as TuiCmd
```

## Description

Force a FULL repaint rather than a diff. Use it after anything that changed the screen behind the module's back.

## Example

```freebasic
#import "std/tui"
using tui

print TuiInvalidate( ).kind = TUICMD_INVALIDATE '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiApp](Modern-Tui-TuiApp) | [TuiApp.Update](Modern-Tui-TuiApp-Update) | [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) | [TuiNone](Modern-Tui-TuiNone) | [TuiQuit](Modern-Tui-TuiQuit) | [TuiSuspend](Modern-Tui-TuiSuspend) |
| [TuiApp.Init](Modern-Tui-TuiApp-Init) | [TuiApp.View](Modern-Tui-TuiApp-View) | [TuiCmd](Modern-Tui-TuiCmd) | [TuiRedraw](Modern-Tui-TuiRedraw) | [TuiTick](Modern-Tui-TuiTick) | [TuiRun](Modern-Tui-TuiRun) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)