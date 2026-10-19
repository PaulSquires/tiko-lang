[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInput.DeleteSelection**

# TuiTextInput.DeleteSelection

Removes the selected text, or does nothing if none is selected.

## Syntax

```freebasic
TuiTextInput.DeleteSelection( )
```

## Description

Removes the selected span and puts the cursor where it was. A no-op when nothing is selected.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextInputState st
TuiTextInputStateInit( st )
st.text = "hello world"
st.selAnchor = 5 : st.cursor = 11

dim as TuiTextInput box
box.state = @st
box.DeleteSelection( )
print st.text                     '' hello
print st.selAnchor                '' -1 -- the selection is gone too
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)