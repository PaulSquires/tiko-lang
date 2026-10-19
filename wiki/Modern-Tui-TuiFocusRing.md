[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing**

# TuiFocusRing

Holds the Tab order of your widgets and tells each one when it has focus.

## Syntax

```freebasic
type TuiFocusRing
    as int32 cur
    declare sub Add( byval w as TuiWidget ptr )
    declare sub Next_( )
    ...
end type
```

## Description

Tab order, as a ring. It calls SetFocused for you and never owns or frees anything. THE RING HOLDS POINTERS, so everything you Add must outlive the frame -- widgets built as locals inside View die at END SUB, and a form whose inputs were locals could not be Tabbed to at all. Make focusable widgets fields of your app.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

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

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) | [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)