[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiClockMs**

# TuiClockMs

## Syntax

```freebasic
TuiClockMs( ) as float64
```

## Description

A monotonic millisecond clock. The loop schedules ticks and frames from it; it is exposed so your own timing uses the same one.

## Example

```freebasic
#import "std/tui"
using FB

dim as float64 t0 = TuiClockMs( )
print t0 >= 0                      '' -1 (true)
print TuiClockMs( ) >= t0          '' -1 (true)  -- monotonic, never goes backwards
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