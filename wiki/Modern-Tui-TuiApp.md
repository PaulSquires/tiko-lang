[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Application Loop](Category-Terminal-TUI-Library) › **TuiApp**

# TuiApp

## Syntax

```freebasic
type TuiApp extends Object
    declare abstract function Init( ) as TuiCmd
    declare abstract function Update( byref e as TuiEvent ) as TuiCmd
    declare abstract sub View( byref f as TuiFrame )
    declare virtual sub Shutdown( )
    declare virtual destructor( )
end type
```

## Description

The application. Three methods you must write: Init to set up, Update to react, View to draw. UPDATE NEVER DRAWS AND VIEW NEVER MUTATES -- that separation is the only rule, and it is what makes a frame reproducible from state and testable without a terminal.

## Example

```freebasic
#import "std/tui"
using FB

type CounterApp extends TuiApp
    as int32 n
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
end type

function CounterApp.Init( ) as TuiCmd
    n = 0
    return TuiNone( )
end function

function CounterApp.Update( byref e as TuiEvent ) as TuiCmd
    if( e.kind <> TUIEVENT_KEY ) then return TuiNone( )
    if( e.key.code = TUIKEY_ESCAPE ) then return TuiQuit( 0 )
    n += 1
    return TuiRedraw( )
end function

sub CounterApp.View( byref f as TuiFrame )
    dim as TuiParagraph p
    p.text = "n = " & str( n )
    p.Render( f, f.Area( ) )
end sub

dim as CounterApp app
dim as TuiRunResult r = TuiRun( app, TuiTermOptionsDefault( ) )
```

## See also

[TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiNone](Modern-Tui-TuiNone) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiTick](Modern-Tui-TuiTick) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiRun](Modern-Tui-TuiRun)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Application Loop  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)