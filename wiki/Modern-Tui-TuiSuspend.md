[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiSuspend**

# TuiSuspend

## Syntax

```freebasic
TuiSuspend( ) as TuiCmd
```

## Description

Leave the terminal, raise SIGTSTP, and come back with the screen invalidated. Ctrl+Z does NOT suspend in raw mode -- ISIG is cleared -- so an application that wants it must ask deliberately.

## Example

```freebasic
#import "std/tui"
using tui

print TuiSuspend( ).kind = TUICMD_SUSPEND '' -1 (true)

'' in Update: bind it yourself, since the terminal will not
''     if( e.key.IsChar( ) andalso e.key.ch = 26 ) then return TuiSuspend( )
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)