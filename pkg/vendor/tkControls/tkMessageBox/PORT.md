# tkMessageBox (vendor PsMessageBox): port notes

**Name map:** `PsMessageBox_*` → `tkMessageBox_*`; `PSMESSAGEBOX_*` constants →
`TKMESSAGEBOX_*` (`IDC_CMESSAGEBOX_BUTTON_BASE` → `IDC_TKMESSAGEBOX_BUTTON_BASE`). The
prefix-free names stay: `MBX_COLORS`, `MBX_PAINTINFO`, `MBX_MESSAGEINFO`, `MBX_ICON_*`, `MBX_BTN_*`,
`MBX_PART_*`, the `MBX_*Callback*` types. Win32's `IDOK` … `IDNO` → `MBX_IDOK` … `MBX_IDNO`, value
for value, so they cannot collide with a host's `sys/win`. `HWND` → `TK_WIDGET ptr`, `HFONT` →
`TTF_Font ptr`, `COLORREF` → tkRGB's `ulong`, `PSBUTTON_COLORS` → `TKBUTTON_COLORS`.

**The shape.** `tkMessageBox_Create( hParent )` makes a hidden, borderless DIALOG surface
(`tkHost_CreateDialog`) owned by hParent's surface. The handle is the box widget that fills it.
The footer buttons are `tkButton` children, so `AddButton` / `GetButtonHandle` return real
buttons, as vendor's returned `HWND`s. `DoModal` measures, sizes and centres the box, gives the
caption band to `tkHost_SetDragRect` (the X excluded), focuses the resolved button, runs
`tkHost_RunModal`, destroys the surface, and returns the id. **The handle is dead afterwards**,
as vendor's was. `tkHost_RunModal` drops the owner's input meanwhile (vendor disabled the parent).
A QUIT ends the loop with 0 and is re-posted.

**Kept, unchanged:** `LayoutBox` (shrink-to-fit wrap; the max of content, footer, caption and
minimum widths; one button height and per-button widths; a right-aligned footer in the order
added; icon and text sharing a vertical centre; honest overflow); the dismissal contract (a
button's own id; Esc, the X and the window's close return the cancel id, which defaults to the
LAST button's; 0 with no buttons); default > first focus resolution, with an explicit
`SetFocusButton` winning; the six presets and their ids; at most three buttons; the X's
press / slide-off / release with three moods, invisible when idle; the colours and the theme
mapping (box and buttons, with pinning); the latching icon colour; the paint and message
callbacks (result ignored for LBUTTONUP, close and DESTROY); silent, lazy setters;
`LayoutForTest`; `CountRenderedTones`.

**Changed:**
- **The dialog is recreated, never resized.** Create makes a staging surface. The first layout
  that knows the real size (`LayoutForTest` / `DoModal`) makes a new dialog at that size and
  moves the box onto it with the new `tkWidget_Reparent` (shared commit acedb1e). The reason was
  measured under WSLg: on Wayland, a window resized after its renderer exists keeps a stale
  drawable. Every read came back black, even after presents; a dialog created at its final size
  reads correctly. Consequence: `GetSurface` is final only after `LayoutForTest`.
- Esc is the box's own key, bubbled up from the focused button (which refuses it). Enter goes to
  the focused button; it reaches the box, which fires the default, only when no button claims it.
  Tab is the host's.
- The window's own close (`SDL_EVENT_WINDOW_CLOSE_REQUESTED`: Alt+F4, the compositor) goes
  through `OnCloseRequest` to the cancel id. The message callback sees it as `TKMBX_MSG_CLOSE`
  (vendor `WM_CLOSE`) and cannot veto it.
- Text measuring: wrapped by `tkText_Wrap` at the wrap width, and the box takes the widest line
  actually used, which is vendor's `DT_CALCRECT`. CR is dropped and a tab becomes four spaces
  (vendor's `DT_EXPANDTABS` used 8-column stops).
- Centring: on the owner window, else on the display, clamped to the usable bounds. Wayland
  places toplevels itself, so there it is advice.

**Added:** `tkMessageBox_Destroy` (for a box never run; vendor used `DestroyWindow`),
`GetSurface`, `GetBeep`, `GetCloseHot`, `TKMBX_MSG_CLOSE`.

**Dropped (Win32-only):** `MessageBeep` (SDL has no system sound; `SetBeep` is kept and
stored), `CS_DROPSHADOW`, `WM_NCHITTEST` (now `tkHost_SetDragRect`), `IsDialogMessage`,
`WS_EX_CONTROLPARENT`, the hot poll, `WM_ACTIVATE` tracking (`isActive` is read from the keyboard
focus at paint time), PsRegistry, `Rescale` → `TKM_SCALECHANGED`, `RunSelfTest`.

**Vendor bugs found:** none.

**Selftest:** 108 assertions at 1.0 and 1.75. They cover the ideal size against the README
formula before sizing, geometry, presets, default / focus / cancel resolution, pixels (probe,
flood, the hot and idle X), theme and pinning, and rescale. Modal runs are driven by events
queued at the box's window before `DoModal`: a button click returns its id, Esc, the window's
close, X slide-off then Tab + Enter, a click on the X, Enter on the default, Space with a focus
split, Shift+Tab wrap, a vetoed press, and QUIT. Owner input is dropped while modal. A/B: making
an unset cancel id resolve to the first button fails exactly the two cancel-id checks at both
scales (104/108).
