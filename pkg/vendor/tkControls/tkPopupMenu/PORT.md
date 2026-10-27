# tkPopupMenu: port notes (from vendor PsPopupMenu)

**Name map:** `PsPopupMenu_*` → `tkPopupMenu_*`; `PSPOPUPMENU_*` → `TKPOPUPMENU_*`.
`PM_ALIGN_*` and the `PM_*CallbackSub` types are unchanged. The handle is `TK_MENU ptr`
(not a widget).

**Kept:**
- create once, show many;
- mixed row heights and a running y;
- the three cells;
- lazy layout and the ideal-size formula;
- one chain per process;
- hover IS selection, the 250 ms rest, click-to-open, the pinned parent, mouse-owned vs
  keyboard-owned selection;
- execute on release, AFTER the whole chain closes;
- the keyboard table;
- an outside press closes AND reaches its target;
- by-id operations across the tree;
- ownership of submenus;
- the colours (SeparatorColor the one non-zero default), the border painted last.

**Changed:**
- An open level is a `TK_SURF_POPUP` holding one widget; a submenu's surface is owned by its
  parent's, so the host's chain rule keeps a press inside the chain from closing it.
- No message filter: the host routes keys to the innermost popup and applies the dismissal
  rule; `bPassDismissClick` gives vendor's pass-through.
- Show / ShowForRect take the OWNER surface's window pixels (vendor: screen).
- `SetNotifyWindow` / `CPM_NOTIFY_*` → `SetClosedCallback( PM_CLOSED_ESCAPE / _OTHER )`.
- Theme and DPI are refreshed at show (and from the broadcast while open).
- `Create( hOwner as TK_HOST ptr )`.

**Added:**
- `SetKeyHook` (the seam tkMenuBar uses for Left/Right at the root);
- `OpenSubMenu`, `GetOpenRoot`, `Surface`.

**Fixed while porting:** the hover rest now acts only on a MOUSE-owned selection. A rest timer
armed by the mouse and firing after the keyboard had moved on reopened a submenu Escape had
just closed (measured on Wayland). Vendor's WM_MOUSEHOVER handler reads nCurSel the same way
and is worth checking.

**Dropped:** `FilterMessage`, the 100 ms foreground poll (the host closes popups when focus
leaves the application, 150 ms after the loss), PsRegistry.
