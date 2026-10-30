# tkKeys: notes

tkKeys is new in tkControls, with no Ps twin. Win32 gave tiko-editor accelerator tables
(`CreateAcceleratorTable` / `TranslateAccelerator`) and the "Ctrl+S" text in keybindings.ini;
SDL has neither. Built for tiko-studio.

**What it is:**
- **The chord.** `TK_CHORD`: an SDL keycode plus `TKKEY_SHIFT/CTRL/ALT/GUI`, with left and
  right merged.
- **Text, both ways.**
  - `tkKeys_Parse` reads chords, case-insensitive, with aliases: Control, Cmd/Super/Win/Meta,
    Option, PageUp/PgUp, Esc …
  - `tkKeys_Format( c, bPortable )` writes them. The portable form writes the platform's
    command modifier as `Primary`, so one keybindings file serves every OS. The display form is
    `Ctrl+S`, or `Cmd+S` on macOS.
- **The unshifted key.** SDL3 applies the modifiers to a key event's keycode: Shift+/ arrives
  as `?`. `tkKeys_FromMsg` matches on `SDL_GetKeyFromScancode( scancode, NONE )` instead, so
  `Ctrl+Shift+/` can match. tkHost's `TK_MSG` gained `scancode` for this.
- **Key maps.** `tkKeys_MapCreate` / `Bind` / `BindText` / `Lookup`: one command per chord, and
  rebinding a chord replaces it.
- **Accelerators.** `tkKeys_Attach( host, map, cb )` sets the host's new `OnPreKey`, which is
  asked BEFORE the focused widget, as `TranslateAccelerator` ran before `WM_KEYDOWN`. It is per
  surface, so a dialog or popup never runs the main window's commands.

**Vocabulary:** all 47 chords of tiko-editor's default keybindings round-trip. "Plus" is the =+
key (VK_OEM_PLUS) and "Tilde" the `~ key (VK_OEM_3), as the editor wrote them.

**tkHost changes (appended, nothing moved):** `TK_MSG.scancode`; `TK_HOST.OnPreKey` and
`tkHostKeyFunc`; DispatchKey asks `OnPreKey` for key DOWN only. tkTest_PushKey takes an optional
scancode.

**Measured (2026-10-25):**
- examples/tkControls/tkKeys 121/121 on Windows, X11 and Wayland; tkHost 138/138 on all three.
- A/B plant: the hook running the command but not consuming the key failed 4 checks; reverted.

**Not verified:**
- A real keyboard: tests push events with scancodes.
- Non-US layouts. A chord is a PHYSICAL key's unshifted keycode in the current layout, so
  AZERTY's `/` is elsewhere, as it was under Win32's VK codes.
- macOS (Primary = Cmd is designed in, not run).
