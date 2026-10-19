[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInput.SelectionStart**

# TuiTextInput.SelectionStart

Returns where the selection starts, or the cursor position if nothing is selected.

## Syntax

```freebasic
TuiTextInput.SelectionStart( ) as int32
```

## Description

The lower end of the selection in code units, or the cursor when nothing is selected. Selection is stored as a cursor plus an anchor, so it can run in either direction; Start and End sort them.

## Example

```freebasic
#import "std/tui"
using tui

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

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)