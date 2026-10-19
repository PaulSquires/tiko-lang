[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp.Update**

# TuiApp.Update

Reacts to one event and returns what the loop should do next; it never draws.

## Syntax

```freebasic
TuiApp.Update( byref e as TuiEvent ) as TuiCmd
```

## Description

React to one event and return what the loop should do. NEVER DRAW HERE. Events are drained before rendering, so a held arrow key applies every repeat and the frame is drawn once with the final state.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

type App2 extends TuiApp
    as int32 sel
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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiApp](Modern-Tui-TuiApp) | [TuiApp.View](Modern-Tui-TuiApp-View) | [TuiCmd](Modern-Tui-TuiCmd) | [TuiRedraw](Modern-Tui-TuiRedraw) | [TuiTick](Modern-Tui-TuiTick) | [TuiSuspend](Modern-Tui-TuiSuspend) |
| [TuiApp.Init](Modern-Tui-TuiApp-Init) | [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) | [TuiNone](Modern-Tui-TuiNone) | [TuiQuit](Modern-Tui-TuiQuit) | [TuiInvalidate](Modern-Tui-TuiInvalidate) | [TuiRun](Modern-Tui-TuiRun) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)