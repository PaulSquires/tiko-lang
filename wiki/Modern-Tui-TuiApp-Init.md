[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp.Init**

# TuiApp.Init

## Syntax

```freebasic
TuiApp.Init( ) as TuiCmd
```

## Description

Set up, and return a command the loop honours BEFORE the first poll. It returns a command because it has to: TuiTick is one-shot and Update only re-arms it in response to a tick, so the first tick can come from nowhere else. When Init was a `sub`, an application could not express \"start animating\" at all and every timer-driven view was frozen by construction.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

type DashApp extends TuiApp
    as int32 frames
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
end type

function DashApp.Init( ) as TuiCmd
    frames = 0
    return TuiTick( 250 )         '' ARM THE FIRST TICK. Nothing else can.
end function

function DashApp.Update( byref e as TuiEvent ) as TuiCmd
    if( e.kind = TUIEVENT_TICK ) then
        frames += 1
        return TuiTick( 250 )     '' and RE-ARM it: TuiTick is one-shot
    end if
    return TuiNone( )
end function

sub DashApp.View( byref f as TuiFrame )
    dim as TuiParagraph p
    p.text = str( frames )
    p.Render( f, f.Area( ) )
end sub
```

## See also

[TuiApp](Modern-Tui-TuiApp) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)