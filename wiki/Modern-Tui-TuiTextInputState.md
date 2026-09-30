[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInputState**

# TuiTextInputState

## Syntax

```freebasic
type TuiTextInputState
    as ustring text
    as long cursor      '' CODE UNITS
    as long selAnchor   '' -1 = no selection
    as long scrollX     '' COLUMNS
end type
```

## Description

The editor's state, owned by you. Note the units: `cursor` and `selAnchor` are UTF-16 code-unit indices while `scrollX` is columns -- they are different things and conflating them is how a cursor ends up half inside a CJK glyph.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiTextInputState st
TuiTextInputStateInit( st )
print st.cursor, st.selAnchor     '' 0 -1 -- no selection

st.text = "hello"
st.cursor = 5
print st.text, st.cursor          '' hello 5
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup) · [TuiSelect](Modern-Tui-TuiSelect)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)