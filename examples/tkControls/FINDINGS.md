# tkControls: findings

tkControls is the tk-named SDL3 + SDL_ttf twin of `vendor/PsControls`, in tiko. It runs on
Windows and Linux. The work began on 2026-10-22 with a PsButton prototype and was completed
on 2026-10-23: every vendor control has been ported, and PsApp's mappable parts. Toolchain: tiko packaged at 34347fd95, on
Windows and Linux.

## Verdict

**The port is complete for Windows and Linux.**
- Every control in vendor PsControls has a tk twin with vendor's API, minus the Win32-only
  parts. PsApp also has a twin, for the parts of it that map onto SDL. PsRegistry, the Win32
  registry layer, has none.
- Every twin passes its selftest on Windows (D3D11), Linux X11 and Linux Wayland.
- At scale 1.75 every demo's pixels match across platforms within 2 colour levels.

The cost was what the prototype predicted. The **host** carried the work, built once in
Stage 1. After that most controls ported case for case. Three things needed real
engineering:
- the self-drawn text editor (from PsPlatform);
- popups, which have to be created per open because Wayland fixes a popup's position at
  creation;
- modal loops.

macOS has not been attempted.

## What exists

| | Modules | Code lines* |
| --- | ---: | ---: |
| Core: tkHost, tkPaint, tkTheme, tkImage, tkTest | 5 | 2,636 |
| Support: tkTooltip + tkTipHost, the scrollbar engine + V/H, tkPopupMenu | 5 | 2,404 |
| Controls (23) + tkApp | 24 | 27,490 |
| **All modules** | **34 folders** | **32,530** |
| Selftests + demos (`tests/*`) | 30 suites, 24 demos | 15,272 |

\*Lines that are neither blank nor comments. Each module folder also has a `PORT.md`: the
Ps → tk name map, what was kept, what changed, what was dropped and why, and any vendor bug
found.

The work went in three stages:
- **Stage 0/1, here:** the repository, the host, paint and the support modules.
- **Stage 2, four parallel sessions in worktrees, merged at b25baab:**
  - A: toggle, check box, option button, progress bar, splitter, status bar, select bar;
  - B: icon panel, tab bar, scroll panel, menu bar, toolbar;
  - C: text box, numeric up-down, combo box, column header;
  - D: calendar, colour picker, message box, chart.
- **Stage 3, here:** date picker, list/tree, app.

## Measured (2026-10-23, master after Stage 3)

**Full battery:**
- **Windows:** 30/30 suites green, 5,096 assertions.
- **Linux:** each suite ran once under X11 and once under Wayland; 57 of the 60 runs were green.
  - The 3 misses were tkPopupMenu (Wayland, no summary line), tkToolbar (X11, 2 failures,
    then no summary line) and tkTextBox (Wayland, 6 context-menu and clipboard checks).
  - All three involve a popup menu.
  - All three passed 12/12 when rerun alone (2 runs × 2 drivers).
  - They are **open, intermittent and not diagnosed**. They are not a Stage 3 regression:
    none of these suites changed in Stage 3.

**Screenshots:** every demo at scale 1.75, Windows vs Wayland (`tools/shots.sh`, then
`tools/bmpdiff.py`):

| Demo | Pixels differing | Max delta |
| --- | ---: | ---: |
| tkApp | 0.75% | 1 |
| tkButton | 1.45% | 1 |
| tkCalendar | 1.06% | 1 |
| tkChart | 0.09% | 2 |
| tkCheckBox | 1.63% | 1 |
| tkColorPicker (form / popup) | 1.02% / 0.46% | 1 / 1 |
| tkColumnHeader | 1.19% | 1 |
| tkComboBox (form / list) | 2.00% / 3.44% | 2 / 2 |
| tkDatePicker | 1.05% | 1 |
| tkIconPanel | 0.69% | 1 |
| tkListTree | 1.15% | 2 |
| tkMenuBar | 0.49% | 1 |
| tkMessageBox (form / box) | 1.31% / 0.37% | 1 / 2 |
| tkNumericUpDown | 1.19% | 1 |
| tkOptionButton | 0.96% | 1 |
| tkProgressBar | 0.62% | 2 |
| tkScrollPanel | 0.70% | 1 |
| tkSelectBar | 0.29% | 1 |
| tkSplitter | 0.31% | 1 |
| tkStatusBar | 0.31% | 1 |
| tkTabBar | 0.60% | 1 |
| tkTextBox | 2.11% | 1 |
| tkToggle | 0.84% | 1 |
| tkToolbar | 0.33% | 1 |

Every difference is ±1–2 levels of anti-aliasing: D3D11 and GL rasterise the same geometry.
The prototype measured X11 and Wayland byte-identical. A demo whose content depends on the
clock or the OS pins it under `--shot`: the calendar and date picker pin "today", and tkApp
pins its theme.

**Discipline:**
- Every control was committed with exactly one A/B plant, which made its selftest fail and
  was reverted by inverse replace.
- Two plants were not caught at first, and both exposed a weak test:
  - tkListTree's click-away check typed nothing;
  - tkApp's modal check hung instead of failing; it now has a watchdog.
  Each test was strengthened, then the plant was re-run.

## What the host became (prototype → now)

The prototype listed what the remaining controls would need. All of it was built, with
PsPlatform's `ui/core` as the reference:
- a widget **tree**: parent/child, clipping, z-order, inherited enable/visibility, Tab order;
- the right and middle buttons, double clicks, both wheel axes, key up, text input and IME
  composition, cursors, the clipboard;
- **surfaces**: main, popup, tooltip, dialog. Each has its own renderer and text engine;
- **popups**:
  - placement with edge flipping;
  - the dismissal rule (an outside press closes; the press is consumed unless the popup
    passes it through);
  - keys routed to the top popup;
  - popups closed 150 ms after focus leaves the application;
- **modal loops**, with owner input dropped;
- timers carrying generation numbers;
- hooks: renderer-gone (tkImage), hot-changed (tkTooltip), the event hook (tkApp) and the
  press serial (the date picker's reopen guard);
- **paint**: AA polygons by ear clipping, strokes, dashes, pies and rings, gradients, the clip
  stack, images and the UTF-8 text helpers.

## Pitfalls (paid for; most are in PORTING.md's trap list)

1. **tiko:**
   - identifiers are case-insensitive (`r` is `R`, a helper named `Paint` is the keyword);
   - a forward `declare` must be `public declare`, or the procedure is silently not exported;
   - namespaces re-exported two levels deep are not visible;
   - there is no `format()`;
   - `iif` with string arms does not compile in some argument positions;
   - `private:` members cannot be read by module-level procedures.
2. **SDL3 ends a `PollEvent` round at a sentinel.** A pump that stops at the first `false`
   can miss the event its caller just pushed. Pump until `SDL_HasEvents` is false.
3. **Wayland:**
   - popups are positioned relative to their parent only;
   - mapping a popup can report a transient focus loss. The focus-loss rule is therefore
     deferred 150 ms; dismissing at once closed a submenu the instant it opened, 1 run in 4.
4. **X11** sends real pointer events into a window that maps under the cursor. `tkTest_Init`
   parks the pointer, and tests settle after a window shows.
5. **Never run the Windows and Linux batteries at the same time.** WSLg windows take the
   Windows focus, and the focus-loss rule then closes popups and tips mid-test.
6. **A timer armed by the mouse must not act on a keyboard-set state.** That was the popup
   menu's hover bug, and vendor's code has the same shape.
7. **Never destroy a widget from inside its own callback.** tkListTree's editor is hidden
   instead.
8. **Block only after testing the quit flag.** `tkApp_Run` drained the queue, the drain ran a
   Quit, and then it slept in `SDL_WaitEvent` (1 hang in 8).

## Vendor bugs found (to check on Win32)

- **Scrollbar:** keeps capture when the auto-repeat stopped before the button came up
  (`tkScrollBar/PORT.md`).
- **Popup menu:** the hover handler acts on a keyboard-set selection (`tkPopupMenu/PORT.md`).
- **Date picker:** a calendar pick fires DateChanged even when the date did not change. The
  README says it fires only on a change (`tkDatePicker/PORT.md`).
- **tiko-lang `vendor/SDL3`:** the `SDL_CreateThread` macro does not compile in tiko
  (`tkApp/PORT.md`). **Fixed** in tiko-lang 348b8e12b (2026-10-26), packaged 3d30e09f5:
  `SDL_CreateThread` compiles and runs. With that toolchain every tests/ package builds (34/34).
  `tkCodeEdit_SetFont` now takes `byref sFile as const ustring` (77da307): tiko refuses a const
  object's field for a non-const byref (fbc's 181), and tiko-studio passes `look.FontFile` of a
  `const ViewLook` (editor.tiko 1116).
- The Stage 2 sessions recorded more in their own `PORT.md` files.

## Still owed / not verified

- **Interactive passes** on the Stage 1–3 controls. The author's 2026-10-22 pass covered
  tkButton only: hover, slide-off, tooltip, Tab, and a release outside the window.
- **The three intermittent popup failures** on Linux above.
- **macOS.** There is no Mac, and `vendor/SDL3` has no macOS entries.
- **IME with a real input method** (only SDL's TEXT_EDITING events are pushed), screen
  readers (SDL has no accessibility bridge), and a real second monitor at another DPI (scale
  changes are simulated).
- **Distribution:**
  - **Fonts:** Segoe UI and Segoe Fluent Icons are Microsoft's and are loaded from the
    Windows fonts folder, via `/mnt/c` on Linux. Shipping needs redistributable fonts, and
    an icon font with other codepoints.
  - **Linux SDL3:** Ubuntu 24.04 has no SDL3 packages; `linux-lib/` is built by
    `tools/build-linux-libs.sh`.
- **A native Linux font directory** for tkApp: its default assumes WSL.
- **Damage regions:** every invalidation repaints the whole surface. This was fine in every
  demo; a very large list may want dirty rects.

## Reproduce

```bash
bash tools/run-all.sh
```

```bash
MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tkControls/tools/run-linux.sh
```

```bash
bash tools/shots.sh
```

```bash
MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tkControls/tools/shots.sh
```

```bash
python tools/bmpdiff.py out/shots/tkButton-windows.bmp out/shots/tkButton-wayland.bmp
```

The prototype's own measurements (tkButton against Win32 PsButton: ideal sizes identical,
idle costs 0 frames, a full repaint takes 1.3–3.7 ms) are in this file's git history at
e609ea0.

## tkCodeEdit (2026-10-25, for tiko-studio P1 + P2)

A 32nd suite: Scintilla 5.5.7 as a widget, over the `scintk` library. Notes, numbers and
what changed from PsPlatform are in `tkCodeEdit/PORT.md`.

**Battery after P2:**
- Windows 31/31 suites.
- Linux 62/62 runs (31 suites × X11 + Wayland).

**The three intermittent popup failures did not reproduce** in that battery, including tkPopupMenu,
tkToolbar and tkTextBox under the load of a full run.

Hypothesis, NOT verified:
- The mechanism is the 150 ms focus-loss rule (`FocusCheck`). If WSLg has not landed keyboard
  focus on a newly mapped popup 150 ms after the owner's focus loss, `SDL_GetKeyboardFocus()` is
  still nobody, and every popup is dismissed.
- That fits failures seen only under a full battery's load, and always in a popup.
- A fix would re-check while focus is nobody (up to ~600 ms) instead of deciding once.
- It is left unchanged until a failing run can be caught and confirmed.

**Seen again, 2026-10-25, in a FOURTH suite.** The battery after the tkTest const change had 61 of
62 runs green. tkMenuBar failed at scale 1.75 on one driver: the dropdown did not stay open, and
6 checks failed. Rerun alone it was 124/124 on X11 and Wayland. It is again in a popup and again
only under a full battery's load, which fits the FocusCheck hypothesis and does not prove it.

**P3 battery, 2026-10-25:** Windows 34/34 suites; Linux 66/68 runs. tkTextBox (X11, a mouse
drag) and tkToolbar (Wayland, a tooltip) failed once each under the full battery's load, then
passed on both drivers rerun alone. Same class: pointer and popup timing, only under load.

## Live resize (2026-10-27, for tkEdit)

- Windows runs its own loop while a window edge is dragged; tkHost's loop saw no event until the
  drag ended, so a form kept its old layout (the author saw it in tkEdit). SDL3 still calls event
  watchers from that loop with SDL_EVENT_WINDOW_EXPOSED, data1 = 1 ("live-resize expose",
  SDL_events.h). tkHost now adds one watcher (on the first host): for that event, on the main
  thread, it sizes the host's root, calls OnSize and renders. Everything else is left to the loop.
- tkHost selftest 154/0 Windows, X11, Wayland. tkEdit's selftest pushes a live-resize expose after
  SDL_SetWindowSize and asserts the layout followed before the loop ran; a plant (watcher off)
  failed it. A real drag on Windows, captured mid-drag: the panes followed.

## tkStatusBar: hidden panels (2026-10-27, for tkEdit)

- `tkStatusBar_SetPanelVisible` / `GetPanelVisible`: a hidden panel is laid out at width 0 (the
  paint loop already skips an empty rect, divider included; HitTest never lands on it). tkEdit's
  settings.toml [statusbar] switches use it. tkStatusBar selftest 242/0 Windows, X11, Wayland.

## The close button and SDL's QUIT (2026-10-27, for tkEdit)

- Clicking the X of SDL's LAST window queues SDL_EVENT_WINDOW_CLOSE_REQUESTED and then SDL_EVENT_QUIT
  (SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE, on by default). A form whose OnClose opens a modal box
  ("save the changes?") lost: tkHost_RunModal took the queued QUIT, ended the box as 0 (Cancel) and
  re-posted it, and the main loop quit past the veto -- the box flashed, unsaved work was gone.
- tkHost_Create turns the hint off: the close button reaches OnCloseRequest only, and an unvetoed
  close still ends the loop through bQuit. A QUIT from elsewhere (session end, SDL_Quit) is unchanged.
- tkApp selftest asserts the hint. A PUSHED close request never brings the QUIT (SDL sends it only for
  an OS close), so no self-test can replay the race; the X button itself is a hand check.
