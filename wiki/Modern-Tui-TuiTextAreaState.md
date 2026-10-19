[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextAreaState**

# TuiTextAreaState

Holds a text area's lines, cursor line and column, and scroll position.

## Syntax

```freebasic
type TuiTextAreaState
    as TuiStringArray lines_
    as int32 cursorLine, cursorCol
    as int32 offsetY
end type
```

## Description

The multi-line editor's state, owned by you. `lines_` carries the underscore because LINE is a statement.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextAreaState st
TuiTextAreaStateInit( st )
st.lines_[0] = "one"              '' Init already made line 0
st.lines_.Push( "two" )
st.cursorLine = 1
print st.lines_[st.cursorLine]    '' two
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)