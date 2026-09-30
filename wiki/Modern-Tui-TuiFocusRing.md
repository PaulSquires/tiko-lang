[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing**

# TuiFocusRing

## Syntax

```freebasic
type TuiFocusRing
    as long cur
    declare sub Add( byval w as TuiWidget ptr )
    declare sub Next_( )
    ...
end type
```

## Description

Tab order, as a ring. It calls SetFocused for you and never owns or frees anything. THE RING HOLDS POINTERS, so everything you Add must outlive the frame -- widgets built as locals inside View die at END SUB, and a form whose inputs were locals could not be Tabbed to at all. Make focusable widgets fields of your app.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

type FormApp extends TuiApp
    as TuiTextInput  nameBox      '' FIELDS, not locals
    as TuiCheckbox   agree
    as TuiFocusRing  ring
    as TuiTextInputState nameState
    as boolean agreed
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
end type

function FormApp.Init( ) as TuiCmd
    TuiTextInputStateInit( nameState )
    nameBox.state = @nameState
    agree.checked = @agreed

    ring.Add( @nameBox )          '' both outlive every frame
    ring.Add( @agree )
    return TuiNone( )
end function
```

## See also

[TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) · [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)