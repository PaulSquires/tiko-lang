
## OS drops (2026-10-25, tiko-studio P3)

Win32's WM_DROPFILES had no twin: SDL's `SDL_EVENT_DROP_*` were not handled. Now:
- tkHost collects a drop: BEGIN, then one FILE or TEXT per item.
- On COMPLETE it sends ONE message to the widget under the drop point, WM_DROPFILES' shape:
  - `TKM_DROPFILES`: `m->text` = the paths LF-separated (UTF-8 as SDL gives them), `m->nStart`
    = how many, `m->x / y` widget-local;
  - or `TKM_DROPTEXT`.
- A refused drop bubbles up the parents, then to the surface's new `OnDrop`, in window pixels.
- The router maps `SDL_EVENT_DROP_*` to their window.
- `tkTest_PushDrop` pushes the sequence SDL would.

Not done: drag-over feedback (`SDL_EVENT_DROP_POSITION`), and dragging OUT of the app.

Measured: examples/tkControls/tkHost 154/154 (16 new) on Windows, X11 and Wayland. The plant (a refused drop
not bubbling) failed 8 checks. Not verified: a real drag from Explorer / a file manager. The
tests push SDL's events.
