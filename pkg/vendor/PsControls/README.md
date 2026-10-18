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
A constant a program or another module uses (`PSTOGGLE_DEFAULT_TRACKW`, `CVSCROLL_DEFAULT_WIDTH`,
`PM_ALIGN_BELOW`, ...) is a `public const` rather than a `#define`, since a macro does not cross a
module boundary bare.

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

The per-control READMEs were written for the copy-the-files layout these controls had before
they were modules; where a README lists files to copy or `#include` lines, the `#import` above
replaces them.
