[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiSelectState**

# TuiSelectState

Holds a dropdown's chosen option, whether it is open, and the highlighted entry.

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

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)