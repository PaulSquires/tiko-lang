[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextInput**

# TuiTextInput

Draws a one-line text box with a cursor, selection and optional password masking.

## Syntax

```freebasic
type TuiTextInput extends TuiWidget
    as TuiTextInputState ptr state
    as ustring placeholder
    as TuiStyle normal, focused_, placeholderStyle, selectionStyle
    as boolean password
end type
```

## Description

A one-line editor: cursor, selection, word movement, password masking. Editing keys are left/right, Ctrl+left/right by word, home/end, backspace, delete, and shift+arrows to select. MAKE `normal` AND `focused_` DIFFERENT, or focus is invisible and the application looks broken.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextInputState st
TuiTextInputStateInit( st )
st.text = "quinn"

dim as TuiTheme th = TuiThemeDefault( )
dim as TuiTextInput box
box.state = @st
box.placeholder = "your name"
box.normal = th.normal
box.focused_ = th.selected        '' visibly different

'' Inside an app's View( byref f as TuiFrame ) it is drawn with
'' box.Render( f, area )

print st.text                     '' quinn -- read the value straight out
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)