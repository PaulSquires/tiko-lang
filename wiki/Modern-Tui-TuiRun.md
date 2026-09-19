[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiRun**

# TuiRun

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiRun( byref app as TuiApp, byval opts as TuiTermOptions ) as TuiRunResult
TuiRun( byref app as TuiApp, byval opts as TuiTermOptions, byval runOpts as TuiRunOptions ) as TuiRunResult
```

## Description

Enters the terminal, runs the loop, and restores everything on the way out -- including after a crash or a signal. It returns the application's exit code, or the TuiError that stopped it STARTING, so a program whose stdout is a pipe gets an honest message instead of a dashboard drawn into a file.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as CounterApp app             '' see TuiApp for its definition
dim as TuiRunResult r = TuiRun( app, TuiTermOptionsDefault( ) )

'' PRINT is safe HERE and only here: TuiRun has fully restored the terminal
'' by the time it returns. Inside a session it is banned -- on Linux a stray
'' PRINT can emit CSI 6n and block.
if( r.IsOk( ) = false ) then
    print "myapp: " & r.Failure( ).Message( )
    end 1
end if
end r.Value( )
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)