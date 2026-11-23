# tkControls

Owner-drawn controls for tiko on **SDL3 + SDL_ttf**, for Windows, Linux and macOS. Every
control draws itself into SDL windows; setters change a control silently, and only what the
user does fires a callback.

Each control is a module of the `vendor` package, reached with one `#import`:

```freebasic
#import "vendor/tkControls/tkApp"
#import "vendor/tkControls/tkButton"

using tkApp
using tkHost
using tkButton
```

Every module imports `vendor/tkControls/tkHost` (the widget core) and, through it,
`vendor/SDL3/ttf` and `vendor/SDL3/image`.

**Fonts come with the package**: Inter (text), Cascadia Mono (code) and Fluent UI System Icons
(glyphs), copied beside every program that imports tkHost. `tkHost_FontDir() & TK_FONT_UI` is
always a file that is there; the `TK_ICON_*` constants name the glyphs.

`tkCodeEdit` hosts **scintk**, a Scintilla build for tkControls (`tkCodeEdit/scintk`), loaded at
run time and copied beside the program as `scintk.dll` / `libscintk.so`.

Runnable demos and a self-test for every control are in the toolchain's `examples/tkControls/`,
with the porting notes (`FINDINGS.md`, `PORTING.md`).

## The modules

Each directory is one module, `vendor/tkControls/<name>`.

| Module | What it is |
| --- | --- |
| `tkApp` | the application framework: start-up, loop, forms, fonts, theme |
| `tkHost` | the widget core: surfaces, widget tree, focus, capture, timers, popups, bundled fonts |
| `tkPaint` | the drawing surface on SDL_Renderer + SDL_ttf |
| `tkTheme` | the shared light / dark theme |
| `tkThemeFile` | a `.tktheme` read at run time: `tkTheme_Load( path )` installs a theme a user picks |
| `tkKeys` | keyboard shortcuts and key maps |
| `tkTest` | the self-test kit the examples use |
| `tkButton`, `tkCheckBox`, `tkOptionButton`, `tkToggle` | buttons and switches |
| `tkTextBox`, `tkNumericUpDown`, `tkDatePicker`, `tkCalendar`, `tkCodeEdit` | text, numbers, dates, code |
| `tkListTree`, `tkComboBox`, `tkSelectBar`, `tkTabBar`, `tkColumnHeader` | lists and selection |
| `tkMenuBar`, `tkPopupMenu`, `tkToolbar`, `tkIconPanel`, `tkStatusBar` | command surfaces |
| `tkLayout` | automatic position and size: Anchor and Dock, in design units; a hidden docked control takes no space, and a dock can take its height from the control |
| `tkLabel`, `tkPanel`, `tkGroupBox`, `tkPicture`, `tkTabControl` | text, containers, images and tabbed pages |
| `tkSplitter`, `tkScrollPanel`, `tkScrollBar`, `tkVScrollBar`, `tkHScrollBar` | layout and scrolling |
| `tkMessageBox`, `tkColorPicker`, `tkTooltip`, `tkProgressBar`, `tkSpinner`, `tkFileDialog` | popups and feedback |
| `tkInfoBar` | an inline message bar in the layout: severity, title, message, actions, close |
| `tkToast` | toasts: transient cards in a corner of a window, queued, timed, with actions; one toaster per window |
| `tkNotify` | what the info bar and the toasts share: severities, colours, the item painter |
| `tkChart` | line, column, HLOC and pie charts |
| `tkPrint` | print documents: pages recorded once in points (the `tkPage_*` API, or any widget's own painting), replayed to the screen, PNG and (later) PDF and printers |
| `tkPrintPreview` | a print document's pages as paper: fit / custom zoom, columns, continuous or single view, links, pages generated while shown |
| `tkPdf` | a print document as a PDF file: vector shapes, real (searchable) text in embedded fonts, images, links; no library linked |
| `tkPrinter` | printers and print jobs: Windows (winspool, raster at the printer's resolution), CUPS on Linux / macOS (a PDF job; libcups loaded at run time, `lp` without it) |
| `tkPrintDialog` | the Print and Page Setup dialogs, tk-drawn on every OS |
| `tkReportViewer` | a print document with its tools: toolbar (print, page setup, PDF, pages, zoom), preview, status bar |
| `tkTimer` | a component: calls a procedure every so many milliseconds |
| `tkContextMenu` | a component: a right-click menu attached to widgets (the designer's PopupMenu) |
| `tkImage`, `tkFontList` | image files; the fonts installed on the machine |
| `tkBind` | the conversions a designed form's `LoadFrom` / `SaveTo` use to move record fields in and out of controls, and their strict checks, rules and error report |
| `tkAutoComplete` | a text box with a filter-as-you-type list of suggestions (stored items; the list never takes the keyboard focus) |
| `tkNavigator` | a record navigator: First, Previous, the position ("3 of 120"), Next, Last, New, Delete; a designed form steps it through an array of its records |
| `tkMatch` | filter-as-you-type matching, no SDL: prefix, word-prefix, contains and fuzzy (fzy) with highlight runs, narrowing, ranked and capped filters |
| `tkSlider` | a value on a track (or a lower and upper value, range mode): horizontal or vertical, ticks and labels, a value tip, jump or page clicks; the designer's Slider |
| `tkTimePicker`, `tkTimePanel` | a time of day: a segmented field you type into and step, with a column or list dropdown (or spin buttons), 12- or 24-hour by pattern, a range and a step; the panel alone embeds in a form; the designer's TimePicker and TimePanel, bound as `time` |

The controls are under the [Mozilla Public License 2.0](LICENSE). The fonts keep their own
licences (SIL OFL 1.1, MIT), shipped beside them in `fonts/`; scintk's Scintilla and Lexilla
keep theirs in `tkCodeEdit/scintk/vendor/`.
