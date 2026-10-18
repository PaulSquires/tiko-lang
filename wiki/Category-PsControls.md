[Home](Home) › [All Categories](Categories) › [Vendor Packages](Vendor-Packages) › **PsControls**

# PsControls

> **In tiko.** Owner-drawn custom controls for **Win32**, written in tiko and built on the `sys/win` package. They ship with the toolchain as modules of the `vendor` package, source only: `#import "vendor/PsControls/PsButton"` and nothing on the command line.

Every control draws itself, top to bottom. There is no `comctl32` control underneath, so a window built from these looks the same on every machine and can be themed to any palette, dark ones included.

## Importing a control

Each control is one module, `vendor/PsControls/<name>`:

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

`using` lets every name be written bare: `PsButton_Create`, `BTN_ALIGN_CENTER`, `PsBufferPaint`'s drawing calls. Without it, write `PsButton.PsButton_Create`.

A module imports the modules it is built from, so importing `PsButton` compiles `PsBufferPaint`, `PsImage`, `PsTipHost` and `PsTooltip` too. Import one yourself only to name something of its own: `PsBufferPaint` for a paint callback, `PsTooltip` to configure a shared tooltip, `PsTipHost` for the `PSTIP_MODE_*` constants.

Runnable demos for every control are in the toolchain's `examples/PsControls/`, one folder each, built with [`tiko build`](Category-Tiko-Build).

## The controls

| Group | Pages |
|---|---|
| Text, numbers and dates | [PsTextBox](PsTextBox), [PsNumericUpDown](PsNumericUpDown), [PsDatePicker](PsDatePicker), [PsCalendar](PsCalendar) |
| Buttons and switches | [PsButton](PsButton), [PsCheckBox](PsCheckBox), [PsOptionButton](PsOptionButton), [PsToggle](PsToggle) |
| Lists and selection | [PsListTree](PsListTree), [PsComboBox](PsComboBox), [PsSelectBar](PsSelectBar), [PsTabBar](PsTabBar) |
| Command surfaces | [PsMenuBar](PsMenuBar), [PsToolbar](PsToolbar), [PsIconPanel](PsIconPanel), [PsStatusBar](PsStatusBar) |
| Layout and scrolling | [PsSplitter](PsSplitter), [PsScrollPanel](PsScrollPanel), [PsVScrollBar](PsVScrollBar), [PsHScrollBar](PsHScrollBar) |
| Popups and feedback | [PsMessageBox](PsMessageBox), [PsColorPicker](PsColorPicker), [PsTooltip](PsTooltip), [PsProgressBar](PsProgressBar) |
| Data display | [PsChart](PsChart) |

## Support modules

| Module | What it is |
|---|---|
| [PsBufferPaint](PsBufferPaint) | The flicker-free drawing surface every control paints through |
| [PsImage](PsImage) | Image files (`.ico`, `.png`, `.bmp`, `.jpg`) for icon slots |
| [PsPopupMenu](PsPopupMenu) | The dropdown behind menus, combo boxes and toolbars |
| [PsColumnHeader](PsColumnHeader) | The column header band; PsListTree places one above its rows |
| [PsTipHost](PsTipHost) | The tooltip backend switch: system tooltip or PsTooltip |

## Type names

A module may not have a public name equal to its own, so each control's state type carries a `_STATE` suffix (`PSBUTTON_STATE`, `PSLISTTREE_STATE`, `PSTOOLTIP_STATE`, ...), the drawing-surface type of `PsBufferPaint` is `PsPaintBuffer`, and the image type of `PsImage` is `PsImageFile`. The procedures keep the module's name as their prefix: `PsBufferPaint_...`, `PsImage_...`.

Every constant the controls define (`PSTOGGLE_DEFAULT_TRACKW`, `CCOLHDR_FILL_LAST`, `PM_ALIGN_BELOW`, the timer ids, ...) is a `public const`, reached through `using` like any other name. Where a page names a constant or enum of another module (`PSTIP_MODE_PS` is PsTipHost's, for instance), import that module too.

## Requirements

- **Windows.** The controls call the Win32 API directly.
- **`UNICODE` on your build.** The modules are compiled with it (the `vendor` package defines it for its own modules), and your program must match. A file cannot `#define UNICODE` ahead of `#import "sys/win"`, so set it in `tiko.toml` or with `-d UNICODE`:

  ```toml
  [target.main.defines]
  UNICODE = "1"
  ```

- **GDI+ running** from before the first repaint to after the last window is destroyed: `gdiplus.Init()` / `gdiplus.Uninit( token )` around the message loop.
- **Segoe Fluent Icons** for the glyphs most controls draw. It ships with Windows 11 as `SegoeIcons.ttf` in the Windows fonts folder, but belongs to Microsoft and does not ship with tiko.

## Licence

[Mozilla Public License 2.0](https://github.com/PaulSquires/tiko-lang/blob/master/pkg/vendor/PsControls/LICENSE), file-level copyleft: use the controls in closed-source software freely; if you modify these files, publish those files' changes. The Exhibit B "Incompatible With Secondary Licenses" notice is not applied, which keeps the controls GPL-compatible.

### See also

- [Vendor Packages](Vendor-Packages)
- [Packages and Modules Tutorial](Packages-and-Modules-Tutorial)
- [tiko build](Category-Tiko-Build)
