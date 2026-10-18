# PsImage

A small support class for loading a raster image — `.ico`, `.png`, `.bmp`, `.jpg`, or an existing
`HBITMAP`/`HICON` — so an owner-drawn control can show a **real picture in an icon slot** instead
of (or as well as) a Segoe Fluent Icons glyph.

It is not a control. It is a `TYPE` you construct, point at a file once, and keep alongside a
control for as long as that control needs the image. It does exactly three things — **load**
(decode once, at natural size), **measure** (report natural width/height), and hand out the
decoded image — and it does **not** draw. The drawing is [`PsBufferPaint.PaintImage`](#drawing),
which owns the paint surface's GDI+ graphics object. Load here, draw there.

PsImage is the loader that pairs with `PsBufferPaint`, in the same way `PsBufferPaint` is the
surface every Ps\* control paints through.

Repository: <https://github.com/PaulSquires/PsImage>

---

## Requirements

**Files to copy into your project:**

| File | Purpose |
|---|---|
| `PsImage.ti` | Declarations — the `PsImage` type |
| `PsImage.tiko` | Implementation |
| `PsBufferPaint.ti` / `.tiko` | The surface whose `PaintImage` actually draws the loaded image |

**tiko and its sys/win package are required.** PsImage decodes into `sys/win/gdiplus` objects
(`CGpBitmap`), and `PsBufferPaint` draws through the same package. None of these files imports a
package itself: your main file imports them before including PsImage (see *Include order*). Build with
`tiko build` in a folder whose `tiko.toml` defines `UNICODE`, as the demo's does:

```toml
[target.main]
main      = "main.tiko"
output    = "main.exe"

[target.main.defines]
UNICODE = "1"
```

`UNICODE` has to come from the manifest (or `-d UNICODE` on a `tiko` command line): a source
file cannot `#define` it ahead of `#import "sys/win"`, and without it every bare Win32 name —
`DrawText`, `SetWindowText`, `CreateFontIndirect` — binds its ANSI form.

`tiko build` (debug profile, `-g -exx`) or `tiko build --profile release` from PsImage's
folder writes `main.exe` there.

**Include order.** The package imports and `using` lines come first; after that the only rule
is that `PsImage.tiko` comes before anything that uses it:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"

using gui
using gdiplus

#include once "PsBufferPaint.tiko"
#include once "PsImage.tiko"
#include once "frmMain.tiko"        ' your own forms
```

**GDI+ must be running before the first load and must outlive the last image.** Decoding builds
GDI+ objects, so bracket your message loop — the same bracket `PsBufferPaint` already asks for:

```freebasic
dim as ULONG_PTR gdipToken = gdiplus.Init()
' ... create windows, load images, run the message loop ...
gdiplus.Uninit( gdipToken )      ' AFTER every PsImage has been destroyed
```

**There is no pump obligation.** PsImage owns no window and no timer — there is nothing to add to
your `GetMessage` loop, and no `FilterMessage` to call.

---

## Usage

Load once (e.g. when you create the control), then hand the decoded image to the buffer inside
your paint routine:

```freebasic
' --- once ---
dim as PsImage img
if img.Load( "C:\icons\save.png" ) then
    ' loaded
end if

' --- in WM_PAINT, into an icon-cell RECT you computed ---
if img.IsValid() then
    b.PaintImage( img.Image(), @rcIcon )        ' PS_IMGFIT_ASPECT by default
end if
```

An image loaded through the icon-bearing controls (`PsButton`, `PsIconPanel`, `PsToolbar`) is
handled for you — see their own docs for `PsButton_SetImageLeft`, `PsIconPanel_SetImage`,
`PsToolbar_SetItemImage` and friends. You only touch PsImage directly when you paint your own
surface.

---

## API

| Member | Returns | Description |
|---|---|---|
| `Load( wszPath as ustring )` | `long` | Decode a file. `.ico` / `.png` / `.bmp` / `.jpg` / `.jpeg` / `.gif` / `.tif`. Non-zero on success; 0 on failure (bad path, unsupported/corrupt file). A failed load clears any image previously held. |
| `LoadFromBitmap( hbm as HBITMAP )` | `long` | Wrap an existing `HBITMAP` (GDI+ takes a copy; you keep ownership of `hbm`). Non-zero on success. |
| `LoadFromIcon( hIcon as HICON )` | `long` | Wrap an existing `HICON` (GDI+ takes a copy; you still `DestroyIcon` it). Non-zero on success. |
| `IsValid()` | `long` | Non-zero once a load has succeeded and nothing has failed since. |
| `NaturalWidth()` | `long` | Decoded pixel width, or 0 when not valid. |
| `NaturalHeight()` | `long` | Decoded pixel height, or 0 when not valid. |
| `Image()` | `CGpImage ptr` | The decoded image, for `PsBufferPaint.PaintImage`. `NULL` when not valid. **The PsImage keeps ownership — do not delete it.** |

Notes:

- **Decode happens once, at natural size.** Scaling to a cell is done at draw time by
  `PaintImage`, with high-quality bicubic interpolation, so one PsImage can be drawn into cells
  of different sizes without reloading.
- **`.ico` uses a fast path** (`LoadImageW` → the `HICON` constructor) so the system picks the
  best-matching icon frame, then falls back to the generic file decoder if that fails.
- **Alpha is preserved.** A transparent `.png`/`.ico` composites over whatever the control has
  already painted into the cell, so fill the cell background first if you want one.

<a name="drawing"></a>
## Drawing — `PsBufferPaint.PaintImage`

```freebasic
b.PaintImage( pImage as CGpImage ptr, rc as RECT ptr, nFit as long = PS_IMGFIT_ASPECT )
```

| `nFit` | Placement |
|---|---|
| `PS_IMGFIT_ASPECT` (default) | Scale to fit inside `rc`, aspect preserved, then centre (letterbox). |
| `PS_IMGFIT_STRETCH` | Fill `rc` exactly, aspect ignored. |
| `PS_IMGFIT_CENTER` | Natural size, centred, clipped by `rc` if larger. No scaling. |

`PaintImage` lives on `PsBufferPaint` rather than on PsImage because it must draw through the
buffer's own GDI+ graphics — a control building a second graphics object on the same device
context would put two independently-batching GDI+ objects on one surface with nothing
coordinating them.

## Licence

[Mozilla Public License 2.0](LICENSE).

MPL-2.0 is file-level copyleft, chosen deliberately for a drop-in control:

- **You may use this in closed-source software**, commercial or otherwise.
  §3.2 permits static linking with no additional conditions.
- **If you modify these files, publish those files' changes.** The obligation is
  per-file — your own sources are unaffected however tightly they are combined
  with these.
- The Exhibit B "Incompatible With Secondary Licenses" notice is **not applied**,
  which keeps this GPL-compatible.
