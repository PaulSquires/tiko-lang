[Home](Home) › [All Categories](Categories) › [tkControls](Category-tkControls) › **Form Designer**

# Form Designer

Draw a window in tkEdit, double-click a control, write the handler, press Run.

The Form Designer is part of tkEdit. A form is a `.tkform` file. Open one and it appears on a design
surface of real [tkControls](Category-tkControls), so what you see is what the program will show. The
result is ordinary tiko source that builds on Windows, Linux and macOS without the designer.

## Getting started

**File > New**, then **GUI Application**, makes a folder with everything a program needs, and opens its form:

```
myapp/
  tiko.toml
  main.tiko             starts the program and shows the first form
  appTheme/
    appTheme.tktheme    the project's theme: colours, fonts, shape, styles
    appTheme.design.tiko generated from it: don't edit, do commit
  frmMain/
    frmMain.tkform      the form: the designer owns this
    frmMain.design.tiko generated from it: don't edit, do commit
    frmMain.tiko        your code
```

**Form > New Form** adds another form to a program. Press **F5** to build and run.

From the designer, **Alt+F5** (Test Form) shows the form in its own window with working controls and no
handlers, so you can try the layout without building. Esc closes it.

## On the surface

| To do this | Do this |
|---|---|
| Place a control | Click it in the Toolbox, then click or drag on the form |
| Select | Click. Ctrl or Shift adds or removes. Drag on empty form for a band |
| Move | Drag. It snaps to the grid; hold Alt to place it freely |
| Resize | Drag a grip |
| Nudge | Arrow keys move a grid step, Shift+arrow resizes, Primary+arrow moves one unit |
| Next control | Tab, in tab order |
| Remove | Delete |
| Copy | Primary+X, C and V. Paste goes into the selected container |
| Undo | Primary+Z and Primary+Shift+Z, one step per gesture |
| Line up | The Form menu: align, same size, bring to front, send to back |

Primary is Ctrl on Windows and Linux, and Cmd on macOS.

The Toolbox and the Properties panel sit beside the form. **Float** puts either one in its own window;
closing that window docks it again.

A control's place in the list is both its stacking order and its tab order.

## Resizing with the window

Each control has an **Anchor** or a **Dock**, set in the Properties panel.

| Anchor | When the parent changes size |
|---|---|
| Left and top (default) | Stays put |
| Right or bottom | Keeps its distance from that edge |
| Both sides of an axis | Stretches |
| Neither side of an axis | Stays centred |

A **Dock** takes a slice of what's left of the parent, in list order: top, bottom, left or right. Fill
takes whatever remains after every other dock. [tkLayout](tkLayout) has the full rules.

A MenuBar or Toolbar docks to the top when you place it, and a StatusBar to the bottom.

## Handlers

Double-click a control and tkEdit binds its usual event, adds an empty handler to your file, and puts
the caret inside. Double-click the empty form for `Form_Load`. **Shift+F7** goes between a form and its
code. The event rows in the Properties panel name any other event: type a name to bind it, or press
`...` to go to its code.

A handler is a member of the form, so it can use the form's controls by name:

```freebasic
#module "frmMain"

public partial type Form
    Clicks as long
end type

sub Form.btnOK_Click( )
    Clicks += 1
    lblCount.Text = str( Clicks )
end sub
```

Each control is a typed value. `.Text`, `.Enabled` and the rest are properties, and `.Handle` reaches
the whole control API.

Some events ask your handler for an answer through a `byref` parameter, which starts at its default:
a Button's **Tooltip** handler sets `Text` to the tip it should show, and a **Message** handler
(Button, TextBox, NumericUpDown, DatePicker) sets `Handled` to keep a mouse or key message from the
control. A **Paint** handler (Button, NumericUpDown, DatePicker) draws the control instead; call its
`PaintDefault( p )` (`tkButton_PaintDefault` and the rest) first to draw the stock one and add to it.

A DatePicker needs a **Parse** handler before anyone can type a date: without one, typed text is
never accepted. `Accepted = tkDatePicker_ParseIso( sText, pDate )` takes ISO dates; **Format** sets
`sOut` (`tkDatePicker_FormatIso` is the default). Its **Tooltip** handler sets `t->outText` for the
day under the pointer (`Show` starts true), and **DayPaint** draws a calendar day, with
`tkDatePicker_PaintDayDefault( d )` for the stock cell.

Your file and the generated one are the same module, joined by a [partial type](Partial). A file's own
`#import` and `using` lines apply only to it, so add those your code needs.

Handlers follow what you do on the form:

| You | The code |
|---|---|
| Rename a control | Its name and handlers are renamed, as one undo step |
| Delete a control whose handler is empty | The handler goes too |
| Delete a control whose handler has code | The code stays, and still compiles, until you delete it |
| Delete a handler's body by hand | Its event is unbound when you next save the form |

## Menus, toolbars and lists

Select a MenuBar, Toolbar, StatusBar, ListTree, ComboBox or TabControl and press **Edit items** in the
Properties panel. Menu items are indented to make drop-downs and submenus. A menu item can have a
shortcut such as `Primary+O`, and a handler. Set the text of a menu item to `-` for a separator.

A MenuBar dropped on a form opens this editor straight away, filled with a standard menu -- **File**
(New, Open, Save, Save As, Exit), **Edit** (Undo, Redo, Cut, Copy, Paste, Select All) and **Help**
(About), with the usual shortcuts. Change what you like; **Cancel** leaves the bar empty. In the editor
the arrow buttons move the selected item up or down and out or in a level, **+** adds one and the bin
removes it.

A StatusBar panel has a text, a width, a **Handler** and **Stretch**. The handler runs when the panel is
clicked and is told how many clicks (`sub Form.OnPanel( byval clicks as long )`, 2 for a double click).
**Stretch** gives that panel a share of the space the others leave; when several panels stretch they share
it evenly. It is saved per panel (`stretch = true`). A form from before this keeps its bar's `ExpandPanel`
property until the panels are next edited, when it becomes that panel's Stretch.

## Your own controls

The Toolbox's **Custom** row places a labelled stand-in. In the Properties panel, give it the name of
your type and the module it's in. Your type needs:

```freebasic
public type Gauge
    Handle as TK_WIDGET ptr
    declare sub Create( byval hParent as TK_WIDGET ptr, byval id as long )
end type
```

The module is imported as written, so a path like `../gauges` is relative to the form's folder. The type
can't have the same name as its module.

## Using a form

```freebasic
#import "vendor/tkControls/tkApp"
#import "./appTheme"
#import "./frmMain"
using tkApp

dim as TKAPP_OPTIONS options
appTheme.ApplyOptions( options )        ' the theme's fonts, read by tkApp_Init
if tkApp_Init( options ) = false then end 1
appTheme.Install( )                     ' the theme's colours, shape and styles
dim as frmMain.Form mainForm
mainForm.Build( )
end tkApp_Run( mainForm.Wnd )
```

`Build` makes the window, hidden. A second form can be shown beside the first with `Show`, or as a dialog
with `ShowModal`, after which its controls can still be read. [tkForms](tkForms) has the details.

## Colours and themes

A project's look lives in `appTheme/appTheme.tktheme`: **Form > Project Theme...** picks or edits it,
and each control's **Colors** row gives it a style or its own colours. The
[Themes Tutorial](Themes-Tutorial) walks through it step by step.

## The form's own properties and events

Click the empty form and the Properties panel shows the window's settings. **StartPosition** is where
it first appears (Default, CenterScreen, CenterOwner), **WindowState** how (Normal, Maximized,
Minimized; a maximized window must be resizable), **Resizable** blank for the default (a top-level
form resizes, an owned one doesn't), true or false. **MinWidth**, **MinHeight**, **MaxWidth** and
**MaxHeight** limit the client the user can size it to, in design units; blank is no limit.
**AlwaysOnTop** keeps it above other windows, and **Icon** names an image file for its title bar.

Its events:

| Event | Handler | When |
|---|---|---|
| Load | `( )` | At the end of `Build`, the controls made |
| Close | `( byref Cancel as boolean )` | The close button or `Close`; set `Cancel` to keep the form open |
| Resize | `( byval cx as long, byval cy as long )` | After every resize and the first show, the layout applied; pixels |
| KeyDown | `( byval keyCode as long, byval mods as long, byref Handled as boolean )` | A key no control claimed; set `Handled` to consume it |
| Paint | `( byval pPaint as TK_PAINT ptr )` | The form's background, under its controls |
| Destroy | `( )` | The window is going, its controls still there |
| ThemeChanged | `( )` | The application's theme changed |

## Other languages

Tick **Translatable** on the form and its captions go through `tkForms_Tr`, with keys like
`frmMain.btnOK.Text`. Install your lookup with `tkForms_SetTranslator` before `Build`.

## The files

A `.tkform` is TOML, one table per control, in stacking order. It's meant to diff well: one form has one
spelling, and values that are the default aren't written.

`tkEdit --generate-forms DIR` writes the generated file of every form below a folder. `tkEdit --check-forms DIR`
lists any that are stale and exits with the count, which suits a build check.

## See also

- [tkForms](tkForms): the form base
- [tkLayout](tkLayout): anchors and docks
- [Themes Tutorial](Themes-Tutorial): themes, styles and colours, in tkEdit and in code
- [tkControls](Category-tkControls): every control
- [partial type](Partial)
- The toolchain's `examples/tkControls/tkContacts`: a small program built this way
