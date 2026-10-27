# tkTextBox: port notes (vendor PsTextBox's API on PsPlatform's self-drawn editor)

Vendor PsTextBox is a frame around a Win32 RichEdit50W: nothing of its editor ports. The
editor here is PsPlatform's (`ui/controls/PsTextBox.inc`): one UTF-8 string, derived visual
lines, one edit primitive, linear undo, word navigation, desired-column Up/Down, wrap at the
last space that fits. The API, the defaults and "Behaviour and limits" are vendor's.

**Name map:** `PsTextBox_*` → `tkTextBox_*`; `PSTEXTBOX_MESSAGEINFO` → `TKTEXTBOX_MESSAGEINFO`.
`TXT_ALIGN_*` and the `TXT_*Callback*` types are unchanged. The handle is the widget.

**Kept (vendor):**
- single-line / multiline fixed at create; multiline word-wraps, never scrolls horizontally;
- single-line: ENTER always claimed (+ `EnterPressedCallback`), Tab moves focus, text
  vertically centred in the frame; multiline: ENTER newline, TAB a tab character;
- programmatic `SetText` / `ReplaceSel` / `Clear` / `SetValue` / the numeric reformat are
  silent; typing, Cut, Paste, Undo (and Delete/Backspace) notify; `ReplaceSel` is undoable;
- numeric mode: single-line only, the same grammar, typing vetted against the text after the
  pending selection is replaced, a paste refused whole, reformat on focus loss BEFORE the focus
  callback, `ZeroWhenEmpty` stamps only an unfocused empty box;
- the scroll API in LINES (`GetVScrollInfo`, `ScrollToLine` silent, `ScrollChangedCallback`
  also for a programmatic SetText); the wheel scrolls 3 lines a notch, sub-notch deltas
  accumulate; a single-line box refuses the wheel;
- the frame: outer fill, then the rounded frame filled with BackColor and stroked in the border
  or focus-border colour; border width 0 = no border; cue banner shown whenever the buffer is
  empty (focused or not), its own colour and font, wrapped on multiline;
- the context menu: a `tkPopupMenu` created with the control, rebuilt on every open (Cut /
  Copy / Paste / Select All by selection, clipboard, read-only), no menu when nothing qualifies,
  `SetMenuText` localises, `GetContextMenu` is stable;
- select-on-focus for Tab / programmatic focus, a click still places the caret;
- the message callback with veto (key, char, mouse, wheel, focus, and the menu).

**Changed:**
- **Offsets are UTF-8 BYTE offsets** (`GetSel`, `SetSel`, `GetTextLength`, `PosFromChar`,
  `CharFromPos`), snapped to codepoint boundaries; for ASCII text they are vendor's character
  indices. `LimitText` counts CHARACTERS. Default limit 0 = none (vendor: RichEdit's default).
- Colours: a `TKTEXTBOX_COLORS` struct (vendor has none) with vendor's six plus `SelBackColor`,
  `SelForeColor`, `ForeColorDisabled`; `GetColors` / `SetColors` (pins) / `ThemeColors` beside
  vendor's per-colour setters (which pin, as vendor's do). Defaults are the dark theme.
- Corner "radius" stays a radius in the API; it is painted as the diameter `2 * radius`.
- `SetTextAlign` costs nothing: the undo history survives (vendor rewrote the RichEdit buffer).
- A pasted / set multi-line string in a single-line box keeps its first line (RichEdit's rule;
  PsPlatform stripped the breaks instead).
- ESCAPE is no longer claimed (it was swallowed only because the RichEdit beeped); a host still
  sees it in the message callback.
- The menu opens on the right button's RELEASE (`WM_CONTEXTMENU`), on the Menu key and on
  Shift+F10, reported first as `TKTEXTBOX_MSG_CONTEXTMENU`.
- The selection is kept, but not painted, while unfocused (RichEdit without ES_NOHIDESEL).
- The password character applies to single-line only (`ES_PASSWORD`'s rule); a password box
  does not copy or cut.
- Tabs are drawn and measured as one space (no tab stops).

**Added:**
- IME: `TKM_IMECOMPOSE` is drawn inline at the caret, underlined, with its own cursor;
  `tkHost_SetTextInputArea` follows the caret; keys while composing belong to the IME;
  `GetComposition`.
- Clipboard through `tkHost`; Redo (`Ctrl+Y`, `Ctrl+Shift+Z`), `Redo` / `CanRedo`; typing
  coalesces into one undo step until whitespace, a caret move or another edit.
- The opt-in embedded scrollbar: `SetScrollBarVisible` / `GetScrollBar` (a `tkVScrollBar`
  child; its strip is reserved, so nothing re-wraps). Off by default: vendor shows none.
- `GetTextRect`, `PosFromChar`, `CharFromPos`, `GetCaretRect`, `GetCaret`, `GetCaretVisible`,
  `SetCaretBlink` / `GetCaretBlink` (530 ms, 0 = steady), `ShowsCue`, `GetPasswordChar`, `GetID`.
- Legacy clipboard keys: Ctrl+Insert, Shift+Insert, Shift+Delete.

**Dropped (Win32-only):** `GetRichEditHandle`, the message door (EM_* / WM_SETTEXT forwarding),
`FilterMessage` (the host routes the menu's keys and dismisses it), `WM_GETDLGCODE`, the WM_CHAR
swallows, PsRegistry, `Rescale(oldDpi, newDpi)` (`TKM_SCALECHANGED` does it: margins, radius
and the bar strip times fNew/fOld; the border width is a pen width and is never scaled).

**Not verified:** IME with a real input method (only the SDL TEXT_EDITING events a method
produces are pushed); clipboard interplay with other applications.
