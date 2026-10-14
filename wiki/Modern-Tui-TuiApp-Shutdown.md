[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp.Shutdown**

# TuiApp.Shutdown

## Syntax

```freebasic
TuiApp.Shutdown( )
```

## Description

Called once as the loop exits, including on the early-exit path where Init returned TuiQuit. The terminal is still active at that point; ordinary PRINT becomes safe only after TuiRun returns.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

type Closer extends TuiApp
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
    declare sub Shutdown( ) override
end type

sub Closer.Shutdown( )
    '' flush your own state here. Do NOT print: the alternate screen is
    '' still up and on Linux a stray PRINT can emit CSI 6n and block.
end sub
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)