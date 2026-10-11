[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiSelectState**

# TuiSelectState

## Syntax

```freebasic
type TuiSelectState
    as int32 selected
    as boolean open_
    as int32 highlight
end type
```

## Description

The dropdown's state. `selected` is the committed choice; `highlight` is where the cursor is while the list is open, so cancelling leaves the choice alone. `open_` has the underscore because OPEN is a statement.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiSelectState st
print st.selected, st.open_       '' 0 false

st.selected = 2                   '' committed
st.highlight = 0                  '' just browsing
print st.selected                 '' 2
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)