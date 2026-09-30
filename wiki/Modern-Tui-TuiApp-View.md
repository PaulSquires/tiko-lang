[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp.View**

# TuiApp.View

## Syntax

```freebasic
TuiApp.View( byref f as TuiFrame )
```

## Description

Draw the whole screen from your state. It must not mutate anything -- render the same state twice and you must get the same bytes, which is exactly what the module's own test asserts.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen a, b
a.Resize( 30, 6 )
b.Resize( 30, 6 )

dim as CounterApp app             '' see TuiApp for its definition
app.Init( )
app.n = 42

'' the same state rendered into two fresh screens gives identical bytes
print TuiRenderOnce( app, a ) = TuiRenderOnce( app, b )      '' true
print app.n                       '' 42 -- View changed nothing
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)