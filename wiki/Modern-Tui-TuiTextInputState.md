[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInputState**

# TuiTextInputState

Holds a text box's text, cursor, selection and scroll position.

## Syntax

```freebasic
type TuiTextInputState
    as ustring text
    as int32 cursor      '' CODE UNITS
    as int32 selAnchor   '' -1 = no selection
    as int32 scrollX     '' COLUMNS
end type
```

## Description

The editor's state, owned by you. Note the units: `cursor` and `selAnchor` are UTF-16 code-unit indices while `scrollX` is columns -- they are different things and conflating them is how a cursor ends up half inside a CJK glyph.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextInputState st
TuiTextInputStateInit( st )
print st.cursor, st.selAnchor     '' 0 -1 -- no selection

st.text = "hello"
st.cursor = 5
print st.text, st.cursor          '' hello 5
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)