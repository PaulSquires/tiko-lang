# tkTheme: port notes (from vendor PsTheme)

**Name map:** `PSTHEME_COLORS` → `TKTHEME_COLORS`; `PsTheme_Dark/Light/System/SystemIsDark/
Equal` → `tkTheme_*`. The roles and preset values are identical.

**Added:**
- the process-wide current theme: `tkTheme_Get`, plus `tkTheme_Apply` (broadcasts
  `TKM_THEMECHANGED` to every widget on every surface; an equal theme is a no-op);
- `SystemIsDark` via `SDL_GetSystemTheme`.

**Dropped:** `ApplyTitleBar` / `ApplyCaptionOf` (DWM caption colour; SDL draws no caption).
