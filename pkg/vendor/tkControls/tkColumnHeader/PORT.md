# tkColumnHeader: port notes (from vendor PsColumnHeader, plus PsPlatform's painter)

**Name map:** `PsColumnHeader_*` → `tkColumnHeader_*`; `PSCOLUMNHEADER_*` → `TKCOLUMNHEADER_*`.
`CCOLHDR_*` (not a Ps name) and the `HDR_*Callback*` types are unchanged. The handle is the
widget.

**Kept (vendor):**
- the column model: pixel widths (100 default), minimums (0 = the 16 px floor, scaled at use),
  item data, captions that never drive layout;
- the layout: fixed columns raised to their minimum, the fill column taking the rest (never below
  its minimum), contiguous from `-XOffset`, rects running honestly past the edge on overflow;
- the fill designation `CCOLHDR_FILL_LAST` / `CCOLHDR_FILL_NONE` / an index tracked across
  inserts and deletes (deleting it falls back to LAST; `Clear` resets it);
- the divider gutters (± 3 px, scaled at use) tested right to left, the fill's never grabbable;
  `idx = -1` on a gutter;
- the matched click (press and release on the same body; slide off = nothing; a body
  double-click is two clicks); capture taken on the press, before the message callback;
- the live drag: clamped widths, `bLive = TRUE` per change, exactly one `bLive = FALSE` at the
  end; ESC and capture loss restore the pre-drag width and carry it in that final call;
  `SetColumnWidth` on the dragged column re-bases the drag at the current cursor x;
- the divider double-click asking `AutoSizeCallback` (≤ 0 = no change, clamped to the minimum,
  `bLive = FALSE`);
- silent setters; inserts and deletes abandon a live gesture silently and clear hover;
- the message callback's answer ignored for LBUTTONUP and for MOUSEMOVE during a drag; the right
  button reported, never acted on; never focusable;
- per-column tooltips: one tip, its text from the callback or the caption (`""` suppresses),
  re-queried when the hot column changes; the 250 ms hover default; Hover/AutoPop/Reshow times;
- `SetBackColor` returns the previous colour and pins; `ApplyTheme` (Surface), `UnpinColors`;
  rescale of widths, minimums, padding and XOffset.

**Added from PsPlatform:**
- **a built-in painter**, used whenever no paint callback is set (vendor drew only the
  background): hover and press fills, the caption inset by the padding with an ellipsis, a sort
  triangle, and a divider tick on every column but the fill, accented while its gutter is hot or
  dragged; `tkColumnHeader_PaintColumnDefault( p )` lets a callback draw on top of it;
- a `TKCOLUMNHEADER_COLORS` struct for it (`GetColors` / `SetColors` / `ThemeColors`; vendor's
  `BackColor` is its first field);
- a sort INDICATOR the host sets — `SetSortColumn( idx, HDR_SORT_ASC / DESC / NONE )`,
  `GetSortColumn`, `GetSortDirection` — tracked across inserts and deletes and handed to painters
  as `nSortDir`. The control still never sorts: the click callback remains the hook.

**Added (tk):** `HitTestColumn`, `GetHotColumn`, `GetHotDivider`, `GetPressedColumn`,
`GetDragColumn`, `GetXOffset`, `GetID`.

**Changed:**
- ESC during a drag arrives as a key: **tkHost now routes Escape to the capture widget first**
  when it is not the focus (separate commit 4644983). Vendor polled `GetAsyncKeyState(VK_ESCAPE)`
  on its 100 ms timer and on every move, which SDL cannot do for synthetic input and which a
  test cannot drive.
- The divider double-click comes from SDL's click count (`m->clicks = 2`) instead of
  `CS_DBLCLKS` / `WM_LBUTTONDBLCLK`; the second press is otherwise an ordinary press.
- `TKCOLUMNHEADER_MESSAGEINFO` carries `msg` (TKM_*), `x`, `y`, `idx`. There is no
  `WM_MOUSEHOVER` (the tooltip watches the hover itself).
- `GetTooltipHandle` returns the `TK_TIP ptr`.

**Dropped (Win32-only):** the comctl32 tooltip backend (`SetTooltipMode`, `GetTooltipMode`,
`GetPsTooltipHandle`), `CS_DBLCLKS`, `WM_SETCURSOR` (`w->cursor` = SIZEWE over a gutter and
during a drag), the 100 ms hover / ESC poll and its timer id, `WM_NOTIFY`/`TTN_GETDISPINFOW`,
PsRegistry, `Rescale(oldDpi, newDpi)` (`TKM_SCALECHANGED`).
