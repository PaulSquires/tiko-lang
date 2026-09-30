[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Input Widgets](Category-Terminal-TUI-Library) › **TuiRadioGroup**

# TuiRadioGroup

## Syntax

```freebasic
type TuiRadioGroup extends TuiWidget
    as TuiStringArray options
    as int32 ptr selected        '' CALLER-OWNED
    as TuiStyle normal, focused_, activeStyle
    as boolean horizontal, useUnicode
end type
```

## Description

One-of-N. Like the checkbox it points at your own variable. `activeStyle` is COMPOSED over the widget background with Patch, not assigned -- assigning it once made a focused group highlight every option except the selected one.

## Example

```freebasic
#import "std/tui"
using FB

dim as int32 choice
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiRadioGroup rg
rg.options.Push( "small" )
rg.options.Push( "medium" )
rg.options.Push( "large" )
rg.selected = @choice
rg.normal = th.normal
rg.focused_ = th.selected
rg.activeStyle = th.accent
rg.SetFocused( TRUE )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_DOWN
rg.HandleEvent( e )
print choice                      '' 1 -- medium
```

## See also

[TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiSelect](Modern-Tui-TuiSelect)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)