[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiSelect**

# TuiSelect

## Syntax

```freebasic
type TuiSelect extends TuiWidget
    as TuiStringArray options
    as TuiSelectState ptr state
    as TuiStyle normal, focused_, listStyle, highlightStyle
    as int32 maxVisible
end type
```

## Description

A dropdown. When open it draws OUTSIDE its own area, over whatever is beneath -- that is what a dropdown is, and it uses a frame layer to do it.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiSelectState st
dim as TuiSelect s
s.options.Push( "red" ) : s.options.Push( "green" ) : s.options.Push( "blue" )
s.state = @st
s.maxVisible = 5
s.SetFocused( TRUE )

print s.IsOpen( )                 '' false

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
s.HandleEvent( e )
print s.IsOpen( )                 '' true -- Enter opens it
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)