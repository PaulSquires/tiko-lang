# tkFileDialog: notes

tkFileDialog is new in tkControls (tiko-studio P3, PLAN.md deficiency 4). It replaces tiko-editor's
COM `IFileOpenDialog` and tpad's hand-rolled pump around `SDL_ShowOpenFileDialog`.

**What it is:**
- **The callback form.** `tkFileDialog_Show( kind, owner, filters, default, allowMany, cb, user )`
  returns at once. `cb( owner, paths, filterIndex, bError, user )` runs ON THE UI THREAD when the
  user answers, from whichever loop is pumping (a modal one included).
- **The waiting form.** `tkFileDialog_Wait` pumps until answered; `OpenFile` / `SaveFile` /
  `PickFolder` are its one-path shorthands.
- **Filters** are Win32's string shape, `"Tiko source|*.tiko;*.ti|All files|*.*"`. They become
  SDL's `tiko;ti` / `*`.
- **The answer crosses a thread.** SDL may call back on another thread (the portal's, a worker's).
  The callback copies the paths into one `SDL_malloc` block, with no tiko strings, sets an atomic,
  and pushes a user event. tkHost's new `tkHost_AddEventHook` (several hooks; tkApp keeps the
  single `SetEventHook`) delivers it.
- **A driver seam.** `tkFileDialog_SetDriver` replaces the native dialogs for tests.

**tkHost change:** `tkHost_AddEventHook` / `RemoveEventHook`, a list asked after tkApp's hook.

**Measured (2026-10-25):** examples/tkControls/tkFileDialog 17/17 on Windows, X11 and Wayland.
- The driver answers from a real second thread (`SDL_CreateThreadRuntime`). Covered: both paths
  (UTF-8, CJK), the filter, the UI thread, cancel, error, the waiting forms, and folder/save
  kinds.
- A/B plant: dropping all but the first path failed 2 checks; reverted.

**Not verified:**
- The NATIVE dialogs: Windows' IFileDialog through SDL, the xdg portal or zenity on Linux. They
  are the author's interactive checklist; tpad's README shows the pattern working by hand.
- `SDL_ShowFileDialogWithProperties` (title, accept label) is not wrapped.
