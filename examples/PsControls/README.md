# PsControls examples

One demo per control of `vendor/PsControls`, which comes with the toolchain. Each folder is a
`tiko build` project: `main.tiko` imports the control's module, `frmMain.tiko` lays out a window
that exercises it, and `tiko.toml` builds `main.exe` with `UNICODE` defined and `main.rc` linked in
(its manifest makes the process DPI-aware).

| Folder | Control |
| --- | --- |
| `PsApp` | **the starter**: a PsApp program (menubar, text box, combobox, button, modal About box) to copy |
| `PsTheme` | the shared theme: a gallery of the common controls, switched between System, Light and Dark (`main.exe light` / `main.exe dark` start in one) |
| `PsAppWorker` | background work: a `std/tasks` goroutine reporting progress through `app.RunOnUI` (built with `-mt`) |
| `PsBufferPaint` | the drawing surface every control paints through: a specimen sheet of its primitives |
| `PsButton`, `PsCheckBox`, `PsOptionButton`, `PsToggle` | buttons and switches |
| `PsTextBox`, `PsNumericUpDown`, `PsDatePicker`, `PsCalendar` | text, numbers and dates |
| `PsListTree`, `PsComboBox`, `PsSelectBar`, `PsTabBar` | lists and selection (`PsListTree` also builds `tree_demo.exe`) |
| `PsMenuBar`, `PsToolbar`, `PsIconPanel`, `PsStatusBar` | command surfaces |
| `PsSplitter`, `PsScrollPanel`, `PsVScrollBar`, `PsHScrollBar` | layout and scrolling |
| `PsMessageBox`, `PsColorPicker`, `PsTooltip`, `PsProgressBar` | popups and feedback |
| `PsChart` | line, column, HLOC and pie charts |
| `PsImage` | loading image files into icon slots |

## Building and running

From a demo's folder:

```
tiko build
main.exe
```

`tiko build` uses the `debug` profile (`-g -exx`); `tiko build --profile release` optimises.

## The icon font

The demos that draw icons use **Segoe Fluent Icons**, installed on Windows 11, and fall back to
**Segoe MDL2 Assets** on Windows 10, which carries the same codepoints. There is no font file to
copy.

## Self-tests

Most demos carry a geometry self-test that runs without interaction, prints `PASS`/`FAIL` lines
and closes the window. Set the control's variable before starting the demo, for example
`set PSBUTTON_SELFTEST=1`; the name is in each demo's `frmMain.tiko`.

The demos are under the [Mozilla Public License 2.0](LICENSE), as the controls are.
