[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiRunOptions**

# TuiRunOptions

## Syntax

```freebasic
type TuiRunOptions
    as int32 fps            '' 0 = the default 60
    as boolean quitOnCtrlC
end type
```

## Description

Loop tuning. quitOnCtrlC exists because raw mode clears ISIG: Ctrl+C arrives neither as a signal nor as a key unless the loop synthesises it.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRunOptions ro = TuiRunOptionsDefault( )
print ro.fps, ro.quitOnCtrlC      '' 60 true

ro.fps = 30                       '' a dashboard does not need 60
ro.quitOnCtrlC = FALSE            '' an editor wants Ctrl+C for itself
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)