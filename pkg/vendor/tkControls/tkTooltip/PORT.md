# tkTooltip + tkTipHost: port notes (from vendor PsTooltip, PsTipHost)

**Name map:** `PsTooltip_*` → `tkTooltip_*`; `PSTOOLTIP_*` → `TKTOOLTIP_*`; `PsTipHost_*` →
`tkTipHost_*`; `PSTIPHOST_STATE` → `TKTIPHOST_STATE`. `TIP_STYLE_*`, `TIP_ALIGN_*` and
`TIP_PART_*` are unchanged. `TTDT_*` → `TK_TIPDELAY_*`. The handle is `TK_TIP ptr`
(not a widget).

**Kept:**
- layout and the size formula;
- the painter (body, frame, the balloon-stem "house");
- ComputeOrigin / StemOnTop / ComputeStem / ComputeAlpha / ShouldShow;
- the tick: dwell, reshow vs initial delay, click suppression, auto-pop, a veto suppressing
  the rest of the hover, a no-op SetToolIndex being free;
- one tip on screen at a time;
- process defaults;
- render probes;
- TickForTest.

**Changed:**
- The window is a transparent `TK_SURF_TOOLTIP` popup made per show (no window region needed).
- It watches its control through a hidden zero-size listener child. That child carries the
  clock (a host timer) and gets the control's scale, theme and destruction, so the tip
  detaches when the control dies.
- The clock runs only while the cursor is over an attached control or a tip is up or fading;
  tkHost's hot-changed hook wakes it. Vendor polled at 100 ms forever.
- "Over" is the surface's hot widget (or, under capture, the cursor inside the rect).
  "Button down" is the surface's button mask.
- ShowForRect takes a rect in the ATTACHED CONTROL's coordinates (vendor: screen);
  placement clamps to `tkHost_WorkRect`. On Wayland the compositor clamps instead.
- The fade is `SDL_SetWindowOpacity`. Where that is unsupported (Wayland), the tip appears
  at once.
- TickForTest pins the module clock to its injected time, so a show inside a test tick is
  stamped on the test's timeline.
- Delays default to 500 / 5000 / 100 ms (SDL cannot read the double-click time).

**Dropped:**
- the message callback (the tip window receives nothing to observe);
- `GetSystemFont` (SPI_GETNONCLIENTMETRICS);
- the comctl32 backend: `SetMode`, `GetMode`, `SysHandle`, `PsHandle`.

**Not click-through:** an SDL window cannot be HTTRANSPARENT. Cursor placement keeps it clear
of the cursor; moving onto it leaves the control and hides it.
