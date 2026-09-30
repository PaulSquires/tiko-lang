[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInput.SelectionStart**

# TuiTextInput.SelectionStart

## Syntax

```freebasic
TuiTextInput.SelectionStart( ) as long
```

## Description

The lower end of the selection in code units, or the cursor when nothing is selected. Selection is stored as a cursor plus an anchor, so it can run in either direction; Start and End sort them.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiTextInputState st
TuiTextInputStateInit( st )
st.text = "hello world"
st.selAnchor = 6 : st.cursor = 11

dim as TuiTextInput box
box.state = @st
print box.SelectionStart( ), box.SelectionEnd( )        '' 6 11

st.selAnchor = 11 : st.cursor = 6                       '' selected backwards
print box.SelectionStart( ), box.SelectionEnd( )        '' 6 11 -- same span
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup) · [TuiSelect](Modern-Tui-TuiSelect)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)