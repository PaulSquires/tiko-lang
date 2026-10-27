# tkColorPicker (vendor PsColorPicker): port notes

**Name map:** `PsColorPicker_*` → `tkColorPicker_*`; `PSCOLORPICKER_COLORS` / `_PAINTINFO` /
`_MESSAGEINFO` → `TKCOLORPICKER_*`; `PSCOLORPICKER_DEFAULT_*` → `TKCOLORPICKER_DEFAULT_*`.
Prefix-free names stay: `CLR_TAB_*`, `CLR_PHASE_*`, `CLR_PART_*`, `CLR_FIELD_*`, the
`CLR_*Callback*` types. `COLORREF` → `ulong` in tkRGB's `&hAARRGGBB`, always opaque (alpha
still travels separately as a `ubyte`). `RECT` → `TKRECT`, `HFONT` → `TTF_Font ptr`.

**The shape (changed).** Vendor's handle was the popup HWND, created hidden. Here
`tkColorPicker_Create( hParent, id )` returns a HIDDEN zero-size widget in the owner's tree that
holds the state; `RunModal` creates a `TK_SURF_POPUP` surface for each run and closes it at the
end. Wayland cannot re-show an unmapped popup, and the state must outlive the surface so
`GetColor` answers after the run. `tkColorPicker_Destroy` replaces `DestroyWindow`. Geometry is
laid out against the ideal size when no run is open, so the rect getters, hit tests and probes
all work before the first run.

**Kept, unchanged:** the layout (tabs sized to their captions, fixed-height body, preview /
fields / OK block, ShowAlpha not changing the size); the matrix colour law; HSL with vendor's
double precision and `int(x+0.5)`; hex helpers; the Web table; one edit buffer with
select-all-on-entry; digits only, three max, clamp on commit, empty discarded; BEGIN / MOVE /
END with no END for an abandoned drag; selection derived from the value; scroll-into-view;
Esc cancels without committing; Enter commits a field and stays, or accepts; Tab walks the
visible fields and wraps; arrows navigate the body (clamp, start at 0); double-click a body cell
accepts the cell hit; OK press / slide-off / release; clicking Initial reverts; silent setters
with `RevertToInitial` as the action; theme mapping and pinning; `RenderInfo`; the two probes.

**Changed:**
- The outside press is tkHost's popup dismissal: it cancels and the press is consumed, as
  vendor's loop did. Keys reach the popup whatever window SDL names (the router's top-popup
  rule). The popup sets the new `bKeepOnFocusLoss`, so the application losing focus does not
  cancel it (vendor never did; menus still close).
- Placement takes OWNER window pixels, not screen pixels. The flip-above and work-area clamp
  use `tkHost_WorkRect`. On Wayland that is unbounded, so the compositor's positioner does the
  constraining.
- `PositionCentered( hCtrl, hRef = 0 )` centres on a widget of the owner, or on the whole owner
  window.
- Digits come from `TKM_KEYDOWN` (number row and keypad), not `WM_CHAR`. A popup never owns the
  OS text input, and the fields take nothing else. Every other key is claimed while the popup is
  up, so nothing leaks to the window behind it.
- The System tab is PsPlatform's frozen table of Windows 11's default system colours. SDL has no
  `GetSysColor`, and live Windows values on Linux would be fiction. `SetSystemColor` overrides
  one entry.
- The message callback gets `TKCOLORPICKER_MESSAGEINFO` (`msg` = a `TKM_*`, `x`, `y`, `key`,
  `mods`, `clicks`). The result is still ignored for LBUTTONUP, SETFOCUS and KILLFOCUS.
- Probes render into the popup's back buffer while a run is open, otherwise into the owner's at
  its top-left, and read it back before any present.

**Added:** `tkColorPicker_SetOpenCallback` (the popup is on screen and about to read its first
event: the seam for the live surface, and how the selftest drives a run),
`tkColorPicker_EndModal`, `IsOpen`, `GetSurface`, `GetContent`, `GetPosition`, `GetFocusField`,
`GetEditText`, `GetBodySel`, `GetScrollTop`, `GetFieldText`, `SetSystemColor` (PsPlatform).

**Dropped (Win32-only):** `WM_GETDLGCODE`, the `WM_CHAR` swallow, the 100 ms hot poll,
`CS_DBLCLKS`, `IsDialogMessage`, the signature word, `GetColorPickerPointer` as public API,
PsRegistry, `Rescale` → `TKM_SCALECHANGED` (on the handle only, so the popup does not rescale
twice), `RunSelfTest`.

**Vendor difference found (inferred, not run on Win32):** vendor's `RunModal` hides the focused
popup after a cancel. On Win32 that sends `WM_KILLFOCUS`, which commits the field, so a
Create+RunModal host would see Esc-cancelled typing committed. Here, closing the surface drops
the edit buffer; an accept has already committed it in `EndModal`. The selftest asserts this.

**Selftest:** 169 assertions at 1.0 and 1.75 (pure functions, ideal size and geometry against
the layout rules, silent setters, placement with the flip, probes, theme, eight driven modal runs
— drag, fields, Esc, Tab wrap / clamp / amend, list double-click, body keys, OK slide-off /
revert / tabs / preview pixels, wheel — plus DoModal with events queued before the popup existed:
Esc, and an outside press that is consumed). A/B: making `EndModal` skip the field commit fails
"accepting commits the half-typed field" and the check that depends on its colour, at both scales
(165/169).
