[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiRenderOnce**

# TuiRenderOnce

## Syntax

```freebasic
TuiRenderOnce( byref app as TuiApp, byref scr as TuiScreen ) as string
```

## Description

One Init/View cycle against a screen with NO TERMINAL AT ALL, returning the bytes the renderer would have written. This is how the module tests applications and how the benchmark measures frame cost -- and it is how you should test yours.

## Example

```freebasic
#import "std/tui"
using tui

dim as CounterApp app             '' see TuiApp for its definition
dim as TuiScreen scr
scr.Resize( 40, 10 )
app.Init( )

print len( TuiRenderOnce( app, scr ) ) > 0   '' true  -- the first frame
print len( TuiRenderOnce( app, scr ) )       '' 0     -- nothing changed

app.n = 1
print len( TuiRenderOnce( app, scr ) ) > 0   '' true  -- one change, one frame
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)