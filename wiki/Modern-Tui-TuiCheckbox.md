[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiCheckbox**

# TuiCheckbox

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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
#include once "fb/tui.bi"
using FB

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

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup) · [TuiSelect](Modern-Tui-TuiSelect)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)