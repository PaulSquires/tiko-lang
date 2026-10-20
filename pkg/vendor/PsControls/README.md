# PsControls

Owner-drawn custom controls for tiko on **Win32**, built on the `sys/win` package. Every control
draws itself, top to bottom: there is no `comctl32` control underneath, so a window built from
these looks the same on every machine and can be themed to any palette, dark ones included.

Each control is a module of the `vendor` package, reached with one `#import`:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
#import "vendor/PsControls/PsBufferPaint"
#import "vendor/PsControls/PsButton"

using gui
using gdiplus
using PsBufferPaint
using PsButton
```

`using` keeps every name as it has always been written — `PsButton_Create`, `BTN_ALIGN_CENTER`,
`PsBufferPaint`'s drawing calls. Without it, write `PsButton.PsButton_Create`.

Runnable demos for every control are in the toolchain's `examples/PsControls/`.

## The application framework

[PsApp](PsApp/README.md) is the quick way to a running program. It does the start-up, the
message loop and the tear-down, and each form's messages arrive as callbacks:

```freebasic
#import "vendor/PsControls/PsApp"
#import "vendor/PsControls/PsButton"
using PsApp
using PsButton

dim app as PsApplication
app.Init( )
dim f as PsForm ptr = app.NewForm( "Hello", 640, 400 )
dim hOk as HWND = PsButton_Create( f->hWindow, 1001 )   ' themed, with the form's font
PsButton_SetText( hOk, "OK" )
f->OnSize( sub( byval f as PsForm ptr, byval cx as long, byval cy as long )
               SetWindowPos( f->Item( 1001 ), null, cx - f->ScaleX( 100 ), cy - f->ScaleY( 44 ), _
                             f->ScaleX( 88 ), f->ScaleY( 32 ), SWP_NOZORDER or SWP_SHOWWINDOW )
           end sub )
end app.Run( f )
```

A control that needs the message loop to do something for it (PsComboBox, PsMenuBar,
PsToolbar, PsPopupMenu, PsTextBox, PsNumericUpDown, PsDatePicker, PsListTree) registers that
obligation with [PsRegistry](PsRegistry/README.md) when it is created. PsApp's loop then meets
it, and an app needs no hand-written message loop. Every control also follows a shared
[theme](PsTheme/README.md) (light, dark, or the Windows setting, switched live) and is given its
form's fonts as it is created. `examples/PsControls/PsApp` is a starter to copy;
`examples/PsControls/PsTheme` shows the theme.

## The modules

Each directory is one module, `vendor/PsControls/<name>`, with its own README.

| Group | Modules |
|---|---|
| Text, numbers and dates | [PsTextBox](PsTextBox/README.md), [PsNumericUpDown](PsNumericUpDown/README.md), [PsDatePicker](PsDatePicker/README.md), [PsCalendar](PsCalendar/README.md) |
| Buttons and switches | [PsButton](PsButton/README.md), [PsCheckBox](PsCheckBox/README.md), [PsOptionButton](PsOptionButton/README.md), [PsToggle](PsToggle/README.md) |
| Lists and selection | [PsListTree](PsListTree/README.md), [PsComboBox](PsComboBox/README.md), [PsSelectBar](PsSelectBar/README.md), [PsTabBar](PsTabBar/README.md) |
| Command surfaces | [PsMenuBar](PsMenuBar/README.md), [PsToolbar](PsToolbar/README.md), [PsIconPanel](PsIconPanel/README.md), [PsStatusBar](PsStatusBar/README.md) |
| Layout and scrolling | [PsSplitter](PsSplitter/README.md), [PsScrollPanel](PsScrollPanel/README.md), [PsVScrollBar](PsVScrollBar/README.md), [PsHScrollBar](PsHScrollBar/README.md) |
| Popups and feedback | [PsMessageBox](PsMessageBox/README.md), [PsColorPicker](PsColorPicker/README.md), [PsTooltip](PsTooltip/README.md), [PsProgressBar](PsProgressBar/README.md) |
| Data display | [PsChart](PsChart/README.md) |
| Application | [PsApp](PsApp/README.md) (start-up, forms with message callbacks, the message loop, modal forms), [PsTheme](PsTheme/README.md) (the shared theme), [PsRegistry](PsRegistry/README.md) (the controls' message-loop obligations, theme and fonts) |
| Support | [PsBufferPaint](PsBufferPaint/README.md) (the drawing surface every control paints through), [PsImage](PsImage/README.md) (image files for icon slots), [PsPopupMenu](PsPopupMenu/README.md) (the dropdown behind menus, combos and toolbars), [PsColumnHeader](PsColumnHeader/README.md) (PsListTree's header band), PsTipHost (the tooltip backend switch) |

A module imports the modules it is built from, so importing `PsButton` compiles `PsBufferPaint`,
`PsImage`, `PsTipHost` and `PsTooltip` too. Import one yourself only to name something of its
own — `PsBufferPaint` for a paint callback, `PsTooltip` to configure a shared tooltip.

## Names that changed

A module may not have a public name equal to its own, so each control's state type gained a
suffix, and the two support classes were renamed:

| Was | Is |
|---|---|
| `PSBUTTON`, `PSLISTTREE`, `PSTOOLTIP`, ... (each control's state type) | `PSBUTTON_STATE`, `PSLISTTREE_STATE`, `PSTOOLTIP_STATE`, ... |
| `PsBufferPaint` (the drawing-surface type) | `PsPaintBuffer` |
| `PsImage` (the image type) | `PsImageFile` |

The module names, and every procedure (`PsBufferPaint_...`, `PsImage_...`), are unchanged.
Every constant the controls' headers used to `#define` (`PSTOGGLE_DEFAULT_TRACKW`,
`CCOLHDR_FILL_LAST`, `PM_ALIGN_BELOW`, the timer ids, ...) is a `public const`, since a macro does
not cross a module boundary bare; `using` reaches them as before.

The per-control READMEs describe the module layout; where one names a constant or enum of a
dependency (`PSTIP_MODE_PS` is PsTipHost's, for instance), import that module too.

## Requirements

- **Windows.** The controls call the Win32 API directly.
- **`UNICODE` on your build.** The modules are compiled with it (the `vendor` package defines it
  for its own modules), and your program must match: a file cannot `#define UNICODE` ahead of
  `#import "sys/win"`, so set it in `tiko.toml` or with `-d UNICODE`:

  ```toml
  [target.main.defines]
  UNICODE = "1"
  ```

- **GDI+ running** from before the first repaint to after the last window is destroyed:
  `gdiplus.Init()` / `gdiplus.Uninit( token )` around the message loop.
- **Segoe Fluent Icons** for the glyphs most controls draw. It ships with Windows 11 as
  `C:\Windows\Fonts\SegoeIcons.ttf` but belongs to Microsoft and is not redistributed here.

## Licence

[Mozilla Public License 2.0](LICENSE), file-level copyleft: use the controls in closed-source
software freely; if you modify these files, publish those files' changes. The Exhibit B
"Incompatible With Secondary Licenses" notice is not applied, which keeps the controls
GPL-compatible.
