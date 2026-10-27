# tkImage: port notes (from vendor PsImage)

**Name map:** `PsImageFile` → `tkImageFile`; `PS_IMGFIT_*` → `TK_IMGFIT_*` (in tkPaint).

**Changed:**
- Decoding is SDL_image into a CPU surface. A texture is made per renderer on first draw and
  cached, so one image draws in any window; a destroyed renderer's textures are dropped
  through tkHost's hook.
- `Image()` → `Surface()` / `Texture( renderer )`.
- Draw with `tkImage_Paint( p, img, rc, fit )`.

**Dropped / replaced:** `LoadFromBitmap` (HBITMAP), `LoadFromIcon` (HICON) → `LoadFromSurface`,
`LoadFromPixels`.
