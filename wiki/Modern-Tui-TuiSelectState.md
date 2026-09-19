[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiSelectState**

# TuiSelectState

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiSelectState
    as long selected
    as boolean open_
    as long highlight
end type
```

## Description

The dropdown's state. `selected` is the committed choice; `highlight` is where the cursor is while the list is open, so cancelling leaves the choice alone. `open_` has the underscore because OPEN is a statement.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiSelectState st
print st.selected, st.open_       '' 0 false

st.selected = 2                   '' committed
st.highlight = 0                  '' just browsing
print st.selected                 '' 2
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)