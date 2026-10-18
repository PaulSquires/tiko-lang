# PsControls examples

One demo per control of `vendor/PsControls`, which comes with the toolchain. Each folder is a
`tiko build` project: `main.tiko` imports the control's module, `frmMain.tiko` lays out a window
that exercises it, and `tiko.toml` builds `main.exe` with `UNICODE` defined and `main.rc` linked in
(its manifest makes the process DPI-aware).

| Folder | Control |
| --- | --- |
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

Eight demos — `PsButton`, `PsCheckBox`, `PsIconPanel`, `PsListTree`, `PsMessageBox`,
`PsStatusBar`, `PsTabBar`, `PsToolbar` — load **Segoe Fluent Icons** at start-up from this folder
(`examples/PsControls/SegoeFluentIcons.ttf`, one copy for all of them). The font belongs to
Microsoft and is not included. Windows 11 has it; copy it in once, renaming it on the way:

```
copy C:\Windows\Fonts\SegoeIcons.ttf SegoeFluentIcons.ttf
```

Windows stores the file as `SegoeIcons.ttf`; the family name is "Segoe Fluent Icons". A demo that
cannot find it says so and exits.

## Self-tests

Most demos carry a geometry self-test that runs without interaction, prints `PASS`/`FAIL` lines
and closes the window. Set the control's variable before starting the demo, for example
`set PSBUTTON_SELFTEST=1`; the name is in each demo's `frmMain.tiko`.

The demos are under the [Mozilla Public License 2.0](LICENSE), as the controls are.
