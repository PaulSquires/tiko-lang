[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextArea**

# TuiTextArea

Draws a multi-line text editor with optional line numbers.

## Syntax

```freebasic
type TuiTextArea extends TuiWidget
    as TuiTextAreaState ptr state
    as TuiStyle normal, focused_, gutterStyle
    as boolean showGutter
end type
```

## Description

A multi-line editor with an optional line-number gutter.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextAreaState st
TuiTextAreaStateInit( st )
print st.lines_.Count( )          '' 1 -- Init leaves ONE EMPTY LINE. A text
                                  '' area with no lines at all has nowhere to
                                  '' put the cursor.
st.lines_[0] = "first line"
st.lines_.Push( "second line" )

dim as TuiTextArea ta
ta.state = @st
ta.showGutter = TRUE
print st.lines_.Count( )          '' 2
print st.cursorLine               '' 0
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)