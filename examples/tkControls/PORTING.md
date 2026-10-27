# Porting a control to tkControls

How every Ps control becomes its tk twin. Read this once before starting; it is short on
purpose and every rule in it was paid for.

## Sources

- **API and behaviour = the vendor README**:
  `C:\dev\tiko-lang\pkg\vendor\PsControls\Ps<Name>\README.md`. Its API reference plus its
  "Behaviour and limits" section are the spec, and its `Ps<Name>.tiko` is the reference
  implementation.
- **Platform-neutral logic = PsPlatform**: `C:\dev\utils\PsPlatform\src\ui\controls\Ps<Name>.bi/.inc`.
  It already solved the non-Win32 parts (popups, the self-drawn text editor, the scrolling combo
  list). Reuse its internals where vendor depends on Win32. Do not copy its OOP surface.
- Where PsPlatform has something vendor lacks, keep it unless it contradicts vendor (examples:
  built-in StatusBar and TabBar painters, the polygon checkbox tick, the combo list's scrolling).

## Naming: Ps becomes tk

- `PsXxx_Func` → `tkXxx_Func`, `PSXXX_COLORS` → `TKXXX_COLORS`, module `tkXxx`.
- Prefix-free vendor constants stay as they are (`BTN_ALIGN_*`, `PM_ALIGN_*`).
- Comments that mean the Win32 original keep the Ps name.
- Never rename across the two families.

## The shape of a control

Copy `tkButton/tkButton.tiko` (a leaf control) or `tkScrollBar/` (a shared engine plus thin
public modules). The rules:

- **One widget, one proc.** `tkXxx_Create( hParent as TK_WIDGET ptr, CtrlID )`. A top-level
  control's parent is `tkHost_Root( h )`. State is allocated with `new` and stored in `w->pData`;
  the proc is `function( w as TK_WIDGET ptr, m as TK_MSG ptr ) as boolean`. It is freed on
  `TKM_DESTROY`.
- **The handle is the widget**: every public function takes `byval hXxx as TK_WIDGET ptr`.
- **Messages are WM_\* in disguise**: `TKM_PAINT` (paint through `m->pPaint`, widget-local
  coordinates), `TKM_LBUTTONDOWN` (`m->clicks = 2` for a double click), `TKM_MOUSEWHEEL`
  (`m->wheelX`/`wheelY` in notches; return FALSE to let the parent have it), `TKM_KEYDOWN`
  (`m->key` is an `SDL_Keycode`; return FALSE for keys you do not claim, so Tab still moves
  focus), `TKM_CHAR` (UTF-8 in `m->text`), `TKM_IMECOMPOSE`, `TKM_TIMER`, `TKM_SCALECHANGED`,
  `TKM_THEMECHANGED`, `TKM_ENABLE`, `TKM_SHOW`, `TKM_CAPTURECHANGED`, `TKM_SETFOCUS`/`KILLFOCUS`.
- **Host services**:
  - capture: `tkHost_SetCapture` / `ReleaseCapture`; CAPTURECHANGED arrives synchronously,
    as in Win32;
  - focus: `tkHost_SetFocus`, `w->isFocusable`;
  - timers: `tkWidget_SetTimer`, using the reserved ids `TK_TIMER_*`, or your own from
    `TK_TIMER_APP`;
  - cursor: `tkWidget_SetCursor`;
  - text input: `w->bWantsText`, `tkHost_SetTextInputArea`;
  - clipboard: `tkHost_SetClipboardText` / `GetClipboardText`;
  - popups: `tkHost_CreatePopup` + `tkHost_PlacePopup`; modal dialogs: `tkHost_RunModal`.
- **There is no hover-poll timer and no WM_CHAR swallow.** The host guarantees the leave, and
  SDL never beeps.
- **Paint** goes through `TK_PAINT`. Its method names and conventions are vendor
  PsBufferPaint's: curvature is a DIAMETER, colours are `&hAARRGGBB`
  (`tkRGB` / `tkRGBA` / `tkColor_WithAlpha`). Text helpers work on UTF-8 byte offsets:
  `tkText_Width`, `tkText_Height`, `tkText_IndexToX`, `tkText_XToIndex`, `tkText_Wrap`,
  `tkText_LineSkip`.
- **Units follow vendor.** Defaults are scaled once at create with `tkHost_Scale`. Setters take
  raw pixels. On `TKM_SCALECHANGED`, every stored metric is multiplied by `fNew/fOld`.
  Thickness and pen widths are never scaled.
- **Fonts** are `TTF_Font ptr`, borrowed and never freed. With none set, measure with the
  host's `pDefaultFont`. Provide `SetFont` (and `SetGlyphFont` where vendor has one) and
  `ApplyFonts( h, fText, fGlyph )`.
- **Theme**:
  - provide `tkXxx_ThemeColors( t ) as TKXXX_COLORS`, with the same role mapping as vendor's
    `PsXxx_ThemeColors`;
  - provide `ApplyTheme` (skipped while pinned) and `UnpinColors`;
  - `SetColors` PINS;
  - at create, take `tkXxx_ThemeColors( tkTheme_Get() )`;
  - on `TKM_THEMECHANGED`, call `ApplyTheme( w, tkTheme_Get() )`.
- **Tooltips** go through `tkTipHost`:
  - embed a `TKTIPHOST_STATE`;
  - call `tkTipHost_Ensure( @st, w, @TextCallback )` at create;
  - for per-item tips, call `tkTipHost_SetToolIndex` from the mouse move;
  - call `tkTipHost_Destroy` on `TKM_DESTROY`;
  - map `SetHoverTime`/`AutoPop`/`Reshow` to `tkTipHost_SetDelay`;
  - map `GetPsTooltipHandle` to `tkXxx_GetTooltipHandle` (returns `TK_TIP ptr`).
- **Images**: `tkImageFile` (one decode, a texture per renderer) and `tkImage_Paint`.
- **Menus**: `tkPopupMenu`. Its key hook is the seam for a menu bar.

## Dropped as Win32-only (list them in PORT.md)

`FilterMessage`, the system tooltip backend (`SetTooltipMode`, `GetTooltipHandle` for
comctl32), `WM_*`/`SendMessage` doors, `WM_SETTEXT`/`GETTEXT`, `WM_GETDLGCODE`, `CS_DBLCLKS`
and the hot-poll timers, PsRegistry, HICON/HBITMAP paths.

## Tests: `tests/tk<Name>/`

- `tiko.toml`: copy `tests/tkPopupMenu/tiko.toml` and change the name. It needs a `selftest`
  target (plus `demo` where vendor has a demo) and
  `[dependencies] tkControls = { path = "../.." }`; import as `#import "tkControls/tk<Name>"`.
- `selftest.tiko` drives REAL SDL events through the host with the `tkTest` kit:
  - push helpers: `tkTest_Click`, `PushMotion`, `PushKey`, `PushText`, `PushWheel`,
    `PushWindowEvent`;
  - `tkTest_PumpFor` for real time;
  - `tkTest_TonesIn` / `PixelAt` / `HashRect` for pixels.
- It runs twice, at scale 1.0 and 1.75, and asserts:
  - geometry against the README's formulas;
  - gestures and keyboard;
  - silent setters vs notifying actions;
  - theme and pinning;
  - at least one pixel claim.
- **Exactly one A/B plant** per control: break one behaviour, see the matching checks fail,
  revert by inverse replace (never `git checkout`). Report it in the commit message.
- The demo mirrors the vendor demo's rows (`tiko-lang\examples\PsControls\Ps<Name>\`) and
  takes `--shot file.bmp`.

## Running

```bash
bash tools/run-all.sh tk<Name>
```

```bash
MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tkControls/tools/run-linux.sh tk<Name> --runs 3
```

Windows D3D11, X11 and Wayland must all be green; run Linux three times, because event races
show up as 1-in-N failures. The toolchain is `C:\dev\tiko-lang\toolchains\tiko-windows\tiko.exe`
(`tiko-linux/bin/tiko` in WSL). Fonts are Segoe UI and Segoe Fluent Icons from
`C:\Windows\Fonts` (`TK_TEST_FONTDIR`).

## Done means

1. Module + `PORT.md` (the Ps→tk name map, what was dropped and why, what was added, any
   vendor bug found).
2. A selftest green on all three backends, with its A/B plant reported.
3. The demo, with `--shot` working.
4. One commit per control, touching only your own `tk<Name>/` and `tests/tk<Name>/` folders.
   If you need a change in a shared module (`tkHost`, `tkPaint`, `tkTest`, …), make it a
   separate, minimal commit, say so in your report, and keep every existing suite green
   (`bash tools/run-all.sh`).

## Traps already paid for

- **Case-insensitive names**: a local `r` clashes with a procedure `R`, `px` with `Px`, `th`
  with `th`. A helper named `Paint` clashes with the `PAINT` keyword.
- **A forward `declare` must be `public declare`** for a public procedure, or the procedure is
  silently not exported.
- **Namespaces re-exported two levels deep are not visible**: `#import` `../tkHost` (and
  `../tkTheme`) directly in every module that uses them.
- **`private:` members** cannot be read by a module-level procedure in the same module.
- **tiko has no `format()`.**
- **SDL3 ends a `PollEvent` round at a sentinel**: always push and pump through `tkTest` /
  `tkHost_Pump`, never a bare `SDL_PollEvent` loop. To check for an event, use `SDL_HasEvent`.
- **X11 delivers real pointer events** to windows that map under the cursor. `tkTest_Init`
  parks the pointer; settle with `tkTest_PumpFor( h, 300 )` after showing a window.
- **A timer armed by the mouse must not act on a keyboard-set state** (the menu hover bug).
- **Never run the Windows and Linux batteries at the same time.** WSLg windows take the
  Windows focus, and the host's focus-loss rule then closes popups and tips mid-test.
  Measured: 2 Wayland tooltip failures and several tkDatePicker failures, all gone when
  each battery ran alone.
- Vendor bugs found while porting (fix in tk, note in PORT.md):
  - the scrollbar kept capture when auto-repeat had stopped (`tkScrollBar/PORT.md`).
