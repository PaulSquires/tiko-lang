[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiCheckbox**

# TuiCheckbox

Draws a labelled checkbox that Space or Enter toggles, changing your own boolean.

## Syntax

```freebasic
type TuiCheckbox extends TuiWidget
    as ustring label
    as boolean ptr checked      '' CALLER-OWNED
    as TuiStyle normal, focused_
    as boolean useUnicode
end type
```

## Description

A labelled checkbox. Its whole state is one boolean, so it points at YOUR boolean rather than carrying a state struct. Space and Enter toggle it.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as boolean agreed
dim as TuiCheckbox c
c.label = "I agree"
c.checked = @agreed
c.useUnicode = TRUE
c.SetFocused( TRUE )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_CHAR : e.key.ch = 32   '' space
print c.HandleEvent( e )          '' true
print agreed                      '' true -- YOUR variable changed
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiRadioGroup](Modern-Tui-TuiRadioGroup) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)