[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiTick**

# TuiTick

Returns a command that sends one tick event after a delay; return another to repeat.

## Syntax

```freebasic
TuiTick( byval ms as int32 ) as TuiCmd
```

## Description

Deliver one TUIEVENT_TICK after ms milliseconds. IT IS ONE-SHOT: to keep animating, return another TuiTick from the tick you receive. A negative delay clamps to 0 rather than scheduling in the past.

## Example

```freebasic
#import "std/tui"
using tui

print TuiTick( 250 ).arg          '' 250
print TuiTick( -5 ).arg           '' 0 -- clamped, never negative
print TuiTick( 250 ).kind = TUICMD_TICK '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiApp](Modern-Tui-TuiApp) | [TuiApp.Update](Modern-Tui-TuiApp-Update) | [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) | [TuiNone](Modern-Tui-TuiNone) | [TuiQuit](Modern-Tui-TuiQuit) | [TuiSuspend](Modern-Tui-TuiSuspend) |
| [TuiApp.Init](Modern-Tui-TuiApp-Init) | [TuiApp.View](Modern-Tui-TuiApp-View) | [TuiCmd](Modern-Tui-TuiCmd) | [TuiRedraw](Modern-Tui-TuiRedraw) | [TuiInvalidate](Modern-Tui-TuiInvalidate) | [TuiRun](Modern-Tui-TuiRun) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)