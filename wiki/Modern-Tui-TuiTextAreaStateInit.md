[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiTextAreaStateInit**

# TuiTextAreaStateInit

Sets a text area's state to one empty line; call it before first use.

## Syntax

```freebasic
TuiTextAreaStateInit( byref s as TuiTextAreaState )
```

## Description

Initialises a text-area state in place. A SUB, like its single-line sibling.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTextAreaState st
TuiTextAreaStateInit( st )
print st.cursorLine, st.offsetY   '' 0 0
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)