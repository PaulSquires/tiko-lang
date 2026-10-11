[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInputStateInit**

# TuiTextInputStateInit

## Syntax

```freebasic
TuiTextInputStateInit( byref s as TuiTextInputState )
```

## Description

Initialises a state in place -- a SUB, not a function returning one. Call it before first use so selAnchor is -1 rather than 0, which would mean \"a selection starting at the beginning\".

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextInputState st
TuiTextInputStateInit( st )
print st.selAnchor                '' -1 -- nothing selected
st.text = "start here"
print st.text
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup) · [TuiSelect](Modern-Tui-TuiSelect)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)