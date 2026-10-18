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
#import "std/numeric"
#import "std/tui"
using tui, numeric

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

|   |   |   |   |
|---|---|---|---|
| [TuiTextInput](Modern-Tui-TuiTextInput) | [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) | [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) | [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) |
| [TuiTextInputState](Modern-Tui-TuiTextInputState) | [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) | [TuiTextArea](Modern-Tui-TuiTextArea) | [TuiCheckbox](Modern-Tui-TuiCheckbox) |
| [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) | [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) | [TuiTextAreaState](Modern-Tui-TuiTextAreaState) | [TuiSelect](Modern-Tui-TuiSelect) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Input Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)