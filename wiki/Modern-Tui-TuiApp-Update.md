[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp.Update**

# TuiApp.Update

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiApp.Update( byref e as TuiEvent ) as TuiCmd
```

## Description

React to one event and return what the loop should do. NEVER DRAW HERE. Events are drained before rendering, so a held arrow key applies every repeat and the frame is drawn once with the final state.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

type App2 extends TuiApp
    as long sel
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
end type

function App2.Init( ) as TuiCmd : sel = 0 : return TuiNone( ) : end function

function App2.Update( byref e as TuiEvent ) as TuiCmd
    select case e.kind
    case TUIEVENT_KEY
        select case e.key.code
        case TUIKEY_ESCAPE : return TuiQuit( 0 )
        case TUIKEY_DOWN   : sel += 1 : return TuiRedraw( )
        case TUIKEY_UP     : sel -= 1 : return TuiRedraw( )
        end select
    case TUIEVENT_RESIZE
        return TuiRedraw( )       '' the loop already resized the screen
    end select
    return TuiNone( )
end function

sub App2.View( byref f as TuiFrame ) : end sub
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)