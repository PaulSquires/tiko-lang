# libtkogfx

A graphics library for tiko, written in tiko, that is a **binary drop-in replacement** for
FreeBASIC's `libfbgfx`. Derived from `gfxlib2`; **LGPL-2.1-or-later with the static-linking
exception**, extended to this version.

Design docset: `C:\dev\docs\graphics\` — start at
[RFC-0001](../../../docs/graphics/RFC-0001-scope-and-abi.md) for the ABI contract and
[probe-results.md](../../../docs/graphics/probe-results.md) for what has actually been measured.

**Status: Phase 1, partial. No graphics code exists yet.** What is here is the runtime seam's
foundation.

---

## What is here

```
abi/rtlabi.bi             the FB mirrors of the runtime structs
abi/rtlctx.bi             reaching __fb_ctx.hooks / .exit_gfxlib2
abi/rtlctx-offsets.bi     GENERATED -- the two offsets, do not edit
abi/rtlseam.bi            runtime services we call INTO (TLS, lock, error)
core/hooks.bi             installing/clearing the console hook table
core/surface.bi           a drawable: pixels, pitch, bpp, clip box, dirty
core/dirty.bi             which scanlines changed since the last present
core/viewport.bi          VIEW, WINDOW, PMAP and the coordinate transform
core/mode.bi              the legacy SCREEN 1..21 mode table
core/palette.bi           PALETTE and PALETTE GET
core/palette-data.bi      GENERATED -- 2692 default palette entries
core/image.bi             IMAGECREATE / IMAGEINFO and the 32-byte header
raster/put.bi             the ten PUT blend modes, 32bpp
core/bsave.bi             the raw BSAVE / BLOAD block format
core/bmp.bi               BMP output for BSAVE (the abtest-bmp kernels)
entry/bmpio.bi            BLOAD / BSAVE: BMP in and out, screen and palette forms
core/control.bi           SCREENCONTROL getters and SCREENINFO
core/font-data.bi         GENERATED -- 9728 bytes of console font
core/vgaport.bi           the VGA DAC behind INP and OUT
core/cells.bi             the character-cell plane behind SCREEN()
core/lzw.bi               the 12-bit LZW codec (fb_hEncode / fb_hDecode)
core/events.bi            the event ring behind SCREENEVENT
core/keyboard.bi          the key ring behind INKEY/GETKEY/KEYHIT, and MULTIKEY
driver/window.bi          the Win32 window, its thread and message pump
driver/mouse.bi           the pointer state behind GETMOUSE and SETMOUSE
raster/text.bi            console text rendering on a graphics screen
raster/blit.bi            the 21 device blitters and their dispatch
raster/pixel.bi           PSET / POINT, 32bpp
raster/line.bi            LINE, 8/16/32bpp, with the 16-bit style mask
raster/box.bi             LINE B / BF, 8/16/32bpp, with the 16-bit style mask
raster/circle.bi          CIRCLE, 32bpp: ellipse, aspect, arcs, fill
raster/paint.bi           PAINT, 32bpp, solid and PATTERN fill
raster/draw.bi            DRAW, the turtle command language
raster/cls.bi             CLS, modes 0 and 1
raster/pixelfmt.bi        8 / 16 / 32 bpp pixel paths, monomorphised
raster/color.bi           COLOR, default branch, all three depths
raster/convert.bi         the row converters behind the blitter table
driver/driver.bi          the presenter interface and its registry
driver/mem.bi             NULL and MEM drivers (MEM records what it presents)
driver/gdi.bi             the Win32 GDI blit path
abi/offsets/win64.txt     checked-in golden layout, measured
abi/offsets/win32.txt     "
tools/probe-rtlabi.c      C probe -- measures the REAL runtime
tools/probe-fbabi.bas     FB probe -- measures OUR MIRROR
tools/probe-rtlctx.bas    behavioural check that the offsets are real
tools/probe-rtlseam.bas   behavioural check that we share gfxlib2's context
tools/probe-hooks.bas     end-to-end check of hook install + exit teardown
tools/gen-rtlctx.sh       regenerates abi/rtlctx-offsets.bi
tools/abtest-line.bas     34 LINE cases, pixel-compared to gfxlib2
tools/abtest-box.bas      42 B/BF cases, pixel-compared to gfxlib2
tools/abtest.sh           runs every abtest-* in all four configurations
tools/abtest-circle.bas   90 CIRCLE cases, pixel-compared to gfxlib2
tools/abtest-paint.bas    45 flood-fill scenes (incl. 30 pattern) vs gfxlib2
tools/abtest-draw.bas     87 DRAW command strings, pixel-compared to gfxlib2
tools/abtest-view.bas     369 transform + PMAP cases vs gfxlib2
tools/abtest-cls.bas      8 CLS cases vs gfxlib2
tools/abtest-bpp.bas      42 cases across 8 and 16 bpp vs gfxlib2
tools/abtest-color.bas    42 COLOR cases across 8/16/32 bpp vs gfxlib2
tools/abtest-mode.bas     106 checks over SCREEN 1..21 vs gfxlib2
tools/abtest-palette.bas  2872 PALETTE cases vs gfxlib2
tools/gen-palettes.bas    extracts the default palettes from gfxlib2
tools/abtest-convert.bas  9 row-converter cases vs IMAGECONVERTROW
tools/abtest-image.bas    144 CROSS-LIBRARY interchange checks vs gfxlib2
tools/abtest-put.bas      10 PUT blend-mode cases vs gfxlib2
tools/abtest-bsave.bas    28 FILE-format interchange checks vs gfxlib2
tools/abtest-putbpp.bas   8 PUT cases at 8 and 16 bpp vs gfxlib2
tools/abtest-bmp.bas      11 BMP byte-for-byte checks vs gfxlib2
tools/abtest-control.bas  164 SCREENCONTROL checks across 12 modes
tools/abtest-print.bas    42 text-rendering cases vs gfxlib2
tools/abtest-vgaport.bas  406 INP/OUT checks vs gfxlib2
tools/abtest-cells.bas    542 character-cell checks vs gfxlib2
tools/abtest-lzw.bas      807 LZW checks vs gfxlib2
tools/abtest-events.bas   59 event-ring checks vs gfxlib2
tools/abtest-blit.bas     170 blitter comparisons vs gfxlib2
tools/abtest-mouse.bas    65 pointer checks vs gfxlib2
tools/abtest-keyboard.bas 113 keyboard checks vs gfxlib2
tools/probe-window.bas    13 checks against a REAL window
tools/gen-fonts.bas       extracts the console fonts by rendering them
tools/abtest-dirty.bas    12 dirty-span cases vs gfxlib2's own array
tools/probe-driver.bas    registry + presentation unit test
tools/probe-gdi.bas       GDI blit verified against a memory DC
tools/bench.bas           throughput against gfxlib2
tools/gate-abi.sh         runs both and FAILS on any disagreement
tools/abrun-bloadsave.sh  BSAVE / BLOAD / SCREENLIST as whole programs, fbc vs tiko
```

The gate is two-sided. The C probe measures the runtime we have to match; the FB
probe measures the mirror we wrote; the gate diffs them. Four checks, all green:

```
gate-abi: win64 -- ok                              C probe vs golden
gate-abi: win32 -- ok
gate-abi: fb/win64 -- mirror matches the runtime   FB mirror vs C
gate-abi: fb/win32 -- mirror matches the runtime
gate-abi: rtlctx -- generated offsets are current  generated file not stale
gate-abi: rtlctx -- offsets address the real runtime fields (behavioural)
```

The last one is not a diff. A wrong offset compiles and reads something
plausible, so that check drives the **real gfxlib2** through three state changes
and watches the hook table follow:

| | hooks live |
| --- | --- |
| before any `SCREEN` | 0 / 28 |
| after `SCREENRES` | **27** / 28 |
| after `SCREEN 0` | 0 / 28 |

Garbage cannot produce that shape. Proven by shifting the offset 72 -> 80: the
`before` and `after SCREENRES` steps still looked right, and only the **`SCREEN 0`
clear** exposed it. One transition would not have caught it; three do.

**27, not 28.** gfxlib2 leaves `posteventproc` NULL under `GFX_NULL` -- there is
no event source. The installed count is driver-dependent, so do not write a test
that asserts all 28.

### The TLS seam

`abi/rtlseam.bi` claims the runtime's graphics TLS slot with
`fb_TlsGetCtx( FB_TLSKEY_GFX, sizeof( FB_GFXCTX ), @destructor )` -- the FB
spelling of gfxlib2's `FB_TLSGETCTX(GFX)`. It must hand back **the same block
gfxlib2 uses**, so the check opens a 320x200x32 screen, draws, and reads the
context back through our mirror:

| field | expected | why it proves something |
| --- | --- | --- |
| `target_bpp` | 4 | 32bpp screen |
| `view_w` / `view_h` | 320 / 200 | the screen's own geometry |
| `max_h` | 200 | " |

Run in **all four configurations** -- win64, win64-mt, win32, win32-mt -- because
the MT split is real: `fb_GraphicsLock` exists only in `libfbmt`.

Proven by setting the slot index to 5: the call still returns **non-NULL** and
yields `view_h = 4105`, `max_h = 1`. A null check alone would have passed it;
only reading known geometry catches it.

### Taking the console over, and giving it back

`core/hooks.bi` installs and clears the 28-entry table, and sets the
`exit_gfxlib2` teardown callback. Checked by consequence, not inspection:
install a table whose `printbuffproc` captures, then require that the captured
line **does not** reach stdout, the visible line **does**, and a sentinel file
written by the exit hook exists afterwards. All four configurations.

**The hook callbacks are CDECL, not STDCALL** -- the runtime's hook typedefs
carry no `FBCALL`, even though the `fb_PrintBuffer` that consults them does.
Confirmed against the shipped win32 `libfbgfx`: hook implementations are
undecorated (`_fb_GfxPrintBufferEx`), entry points are decorated
(`_fb_GfxLine@36`). Declaring these stdcall corrupts the stack on win32 only.

**No module-level code and no global destructors**, anywhere in this library.
Teardown goes through `exit_gfxlib2` because the win32 backends run the window
on a background thread, and a destructor or `atexit` handler runs under the
loader lock, where joining that thread deadlocks.

### Two bugs the gate had, and what they cost

Worth reading before trusting any check in here:

- **`set -e` made the gate abort at the first failure**, silently skipping the
  hook checks and reporting success. Removed; failures accumulate in `$status`.
- **A threshold is not a shape check.** The behavioural test asserted
  "at least 20 of 28 hooks live". Shifting the offset by one pointer slides the
  whole table down a slot -- the count stays 27 -- so offset 64 instead of 72
  produced a **false PASS**. It now asserts exactly 27 *and* that slot 0 is set
  while slot 27 is clear, which a shift in either direction breaks.

**Verified in both directions.** Changing one field type in the mirror
(`FB_GFXCTX.max_h` from `long` to `longint`) fails both FB checks and shows the
cascade into `target_bpp`. A gate that cannot fail is not a gate.

`libtkogfx` mirrors private rtlib and gfxlib2 structs in FreeBASIC. Those structs belong to a
runtime we do not own, so the mirror can rot silently and corrupt memory three functions away from
the cause. The gate re-measures on every build and treats any difference as a build failure.

```bash
sh tools/gate-abi.sh
```

`--accept` rewrites the goldens. A commit that accepts new goldens without saying why does not
land — the same rule `build/test.sh` uses.

## The layout, measured 2026-08-29

fbc-modern 1.20.0, clang 21.1.0.

| | win64 | win32 |
| --- | --- | --- |
| `FBSTRING` | 24 | 12 |
| `FBARRAY` | 72 | 36 |
| `FB_HOOKSTB` | 224 (28 × 8) | 112 (28 × 4) |
| `FB_GFXCTX` | 216 | 148 |
| `FBGFX` | 208 | 136 |
| `GFXDRIVER` | 120 (15 × 8) | 60 (15 × 4) |
| **`PUT_HEADER`** | **32** | **32** |
| **`EVENT`** | **20** | **20** |
| `GFX_CHAR_CELL` | 12 | 12 |
| `FB_RTLIB_CTX.hooks` | off 72 | off 36 |
| `FB_RTLIB_CTX.exit_gfxlib2` | off **20864** | off **16608** |
| `FB_TLSKEY_GFX` | 4 | 4 |

Three of these decided design points rather than merely confirming them:

- **`PUT_HEADER` is 32 bytes on both targets**, with `tex` at offset 20. `fbgfx.bi` declares
  twelve reserved bytes there and is wrong; offsets 20–23 are the OpenGL texture id. The binary
  image contract that D2 promises holds across targets — now measured, not assumed.
- **`exit_gfxlib2` sits at offset 20864**, behind a ~20 KB `FB_FILE` array. Mirroring
  `FB_RTLIB_CTX` byte-exactly would mean mirroring `FB_FILE`, which is large, volatile and
  irrelevant. Hence: mirror the small structs, and *generate* the two `FB_RTLIB_CTX` offsets.
- `FBSTRING` = 12 bytes / align 4 on win32 independently matches
  `docs/internals/win32-blast-radius.md`, which was measured by a different route.

## Coding rules specific to this tree

Both are enforced by `build/lint.sh` (extended to reach `lib/` on 2026-08-29 — it previously
scanned only `src` and `tools`, so none of the structural rules applied here at all).

**1. Hot loops use pointer-width `integer` counters, never `long`.** Measured: fbc's LLVM backend
widens a narrow induction variable through i32 -> `sext` i64 -> add -> `trunc` i32, and
ScalarEvolution cannot read that as an affine recurrence, so the loop does not vectorise. On win64,
where FB `long` is 32-bit and a pointer is 64-bit, that is the difference between **1.04x and
3.96x** of the equivalent C on a row-convert loop. `integer` is pointer-width on all three targets.
Enforced in `raster/`, `blit/` and `put/`; elsewhere a `long` counter is fine.

**2. Every source file carries a provenance header** — `Derived from: <gfxlib2 file>` or
`ORIGINAL WORK`. This is an LGPL attribution obligation, and it is also how you find the file to
re-check when upstream fbc fixes a rasterizer bug.

The `dim shared` allowlist has **not** yet been extended for this tree. It will need roughly eight
entries — the `__fb_gfx` state, the four memcpy/memset function pointers, the driver list — each
with a written justification of the kind the existing entries carry. That argument has to be made,
not assumed.

## What is owed

- **linux-x86_64 is not covered.** The probe must be run under WSL against the Linux rtlib. A
  green run of `gate-abi.sh` today means *two* targets, not three — the script says so in a
  comment, and it should not be read as three-target coverage.
- **The goldens are pinned to nothing.** They were measured against the fbc-modern working tree,
  not a pinned commit. `plan-D13` says tiko will link a *clang-built* `libfb` for
  `x86_64-pc-windows-msvc`, but **no such build recipe exists in this repo yet** — so the gate
  cannot yet be pinned to the runtime it is supposed to be guarding. Until it can, these numbers
  describe the MinGW-built runtime that the A/B harness actually links against, which is the right
  target for phases 1–5 and the wrong one thereafter.
- ~~The FB-side mirror does not exist yet.~~ **Done.** `abi/rtlabi.bi` mirrors `FBSTRING`,
  `FBARRAY`, `FBARRAYDIM`, `EVENT`, `PUT_HEADER`, `FB_HOOKSTB`, `FB_GFXCTX`, `FBGFX`,
  `GFXDRIVER` and `GFX_CHAR_CELL`, and is **byte-identical to the C on both targets** --
  136 lines of offsets and sizes, zero differences. Five fields are renamed because their C
  names are FB keywords (`data`, `ptr`, `exit`, `lock`, `unlock`); the FB probe prints the C
  name anyway, so the gate still compares names and the rename is not a hole in the check.
- **`build/lint.sh` does not reach `lib/`** — every scan in it is `find src …` or
  `find src tools …`. The 1500-line cap, the whitespace rules, the layer map and the `dim shared`
  allowlist do not apply to this tree today.

## A note on the probe

The rtlib headers identify Windows only via `__MINGW32__`, which a `-windows-msvc` clang does not
define, and they assume MinGW's `ssize_t`. The probe shims both. Neither is a hack for the probe's
benefit — both are things the eventual clang-built-runtime recipe will have to solve too.

---

## Phase 2 -- pixel exactness

`tools/gate-abi.sh` checks that we agree with the runtime about **memory**.
`tools/abtest.sh` checks that we agree with gfxlib2 about **pixels**.

No object substitution is needed for raster work: gfxlib2 draws into an
`IMAGECREATE` buffer, we draw into an identical one, and the digests are
compared. That means every primitive is verified from the day it is written
rather than after the library exists.

```
sh tools/abtest.sh
abtest: win64 -- abtest-line: PASS -- every case is pixel-identical
abtest: win64-mt -- ...
abtest: win32 -- ...
abtest: win32-mt -- ...
```

**34 LINE cases, all pixel-identical**: eight octants, both gradients, exact
45-degree diagonals, reversed endpoints, single points, axis-aligned lines,
every clip edge, both corners, fully-outside, and eight tie cases.

`raster/line.bi` follows `fb_GfxDrawLine` step for step rather than a textbook
Bresenham, because the formulations differ by a pixel on ties: `d` starts at
`(dx >= dy) ? dy*2 - dx : dy - dx*2`, `dx`/`dy` are captured *before* clipping,
and the loop ends one step *past* the endpoint. The 16-bit style mask (2026-10-06)
rotates per pixel exactly as gfxlib2's does; tests/codegen/gfx-line-style A/Bs it,
and dropping either the clip's `rot += skip` or the reverse-mask fails every case.

### The tie cases exist because a negative test lied

Perturbing the shallow tie-break from `d >= 0` to `d > 0` **passed all 26
original cases**. Not because the harness was broken -- a blunt one-pixel shift
failed 7 of them immediately -- but because `d` only reaches exactly 0 when `dx`
is even, and **not one of the 26 cases had an even dx**. Eight cases with even
`dx`/`dy` were added; the same perturbation now fails four of them.

A green A/B run says the cases you wrote agree. It does not say the cases you
wrote are the ones that discriminate. Perturb the code and watch the test fail
before believing it.

### Boxes

`raster/box.bi` covers `LINE B` and `LINE BF`, shared with `VIEW` as in gfxlib2.
**42 cases pass**, and the ones that matter are the per-edge gating: each edge is
drawn only if *its own* coordinate is in view, so a box hanging off the bottom
draws its top and sides and **no bottom** -- not a bottom clamped up to the clip
boundary. Replacing the gate with a clamp fails exactly 4 of the 42.

## First performance numbers

Measured from Phase 2, not deferred -- 32bpp, image target, win64.

| workload | gfxlib2 | libtkogfx | ratio |
| --- | --- | --- | --- |
| full-screen BF, 1024x768 x2000 | 1.275s | **0.165s** | **0.13x** |
| diagonal LINE, 1024x768 x20000 | 0.078s | 0.020s | 0.25x |
| horizontal LINE, 1024px x200000 | 0.164s | 0.022s | 0.13x |
| PSET x2,000,000 | 0.037s | 0.001s | 0.03x |

**libtkogfx is faster than the C**, and the reason is mechanical rather than
lucky. Verified in the disassembly:

| | SIMD instructions |
| --- | --- |
| our fill inner loop | **4** |
| gfxlib2 `fb_hPixelSet4` (x64) | **0** |

gfxlib2's hand-written SIMD is **MMX, and MMX is 32-bit-only** -- `obj/win64`
contains no `*_mmx.o` at all. Its x64 fill is scalar C reached through the
`ctx->pixel_set` function pointer, which blocks both inlining and vectorisation.
Ours is monomorphised, so `bpp` is a compile-time constant and the loop
vectorises. This is the payoff the design predicted for dropping runtime
per-bpp dispatch, and it only works because of the `getelementptr` emitter fix
and the pointer-width counter rule.

### How much of each row to believe

- **full-screen BF** -- 637us per call against maybe 1us of statement-layer
  overhead. The inner loop dominates; this row is a real throughput comparison.
- **horizontal LINE** -- 820ns per call, so gfxlib2's per-call overhead is a
  meaningful fraction. Treat the ratio as indicative, not exact.
- **PSET** -- entirely call overhead on gfxlib2's side against an inlined store
  on ours. This row says nothing about inner loops and is kept only because
  omitting it would flatter the others.

### The first version of this benchmark lied

It drew the *same* shape every iteration. gfxlib2's calls are opaque external
functions so nothing could be hoisted; ours are inlinable, so LLVM kept only the
last iteration and reported libtkogfx as **9x to 55x faster** -- nonsense. Every
loop now varies its arguments per iteration and a sink reads the buffer back.

A benchmark where your side is inlinable and the reference is not is not a
benchmark. Vary the inputs, keep the results alive, and check the ratio against
a mechanism you can point at in the disassembly.

## Dirty scanlines, and the driver

`core/dirty.bi` is a byte per scanline. Producers mark the row **range** a
primitive touched, once per primitive -- so it costs nothing in the inner loops
-- and the presenter blits first..last and clears.

Two details copied deliberately rather than improved on:

- **The gate is "am I drawing to the visible page", not "am I drawing".**
  gfxlib2's `SET_DIRTY` tests `__fb_gfx->framebuffer == ctx->line[0]`, so an
  image target marks nothing. `Surface.dirty` is NULL for exactly those cases.
- **The span is first..last, not a list of runs.** One rectangle covering every
  changed row, clean rows included. Matching that matters for the A/B, and one
  large blit beats several small ones anyway.

This one is **A/B-able against the real thing**: `__fb_gfx->dirty` is reachable
through `abi/rtlctx.bi`, so `abtest-dirty.bas` draws to the SCREEN with gfxlib2,
reads its span, then draws the same case through ours and compares. **12 cases,
spans identical**, including the case that proves an image target marks nothing.
Making the box mark one row instead of its full height fails exactly the three
box cases.

### The MEM driver exists so presentation is testable

`DriverNull` is gfxlib2's fallback -- opens, draws nowhere, always succeeds.
`DriverMem` is original: it presents into a buffer and **records what it
presented** (how many updates, and the span each time). That makes the
presentation path checkable with no window, no display server and no human:

| checked | why it matters |
| --- | --- |
| a present with nothing dirty blits **nothing** | otherwise every frame repaints everything |
| a present blits exactly the marked rows | under-blitting looks like a *drawing* bug |
| a second present immediately after is a no-op | the classic never-cleared-array bug, which still *looks* correct |
| an untracked surface never marks | the image-target gate again |

gfxlib2 has no equivalent, which is part of why its dirty handling is only
checkable by eye.

**Owed:** `driver/mem.bi` uses `dim shared` for the two driver records and the
present log. `build/lint.sh` rule 2 still scans only `src`, so it does not fire
here -- this is the allowlist debt already noted above, and these are the first
three entries it will need.

## The GDI presenter

`driver/gdi.bi` is split in two on purpose:

| | testable? |
| --- | --- |
| `GdiBlitSpan` -- pixels to an HDC. No window, no thread, no globals. | **yes**, against a memory DC |
| window class, background thread, message pump | no -- needs the author's pass |

Nearly everything that goes wrong in a GDI presenter goes wrong in the first
half, and that half can be checked by machine. `probe-gdi.bas` blits into a DIB
section and reads the pixels back:

| checked | the bug it catches |
| --- | --- |
| every pixel matches, source **asymmetric top to bottom** | top-down vs bottom-up |
| values round-trip byte-identical | red/blue channel swap at BI_RGB 32bpp |
| a partial span lands at y1, rows either side untouched | destination row offset |
| present clears dirty; re-present is a no-op | the never-cleared-array bug |

**`biHeight` is NEGATIVE.** A Windows DIB defaults to bottom-up; a framebuffer is
top-down. Getting it wrong mirrors the image vertically, which looks like a
coordinate bug in the *rasterizer* rather than a format bug in the *presenter*.
Flipping the sign fails 512 of 512 pixels and prints
`the destination matches the source REVERSED: biHeight sign is wrong`.

That diagnostic had to be fixed to fire at all -- it was written `flipped > bad`,
and a *full* flip makes those equal. A diagnostic that cannot fire is worse than
none, because it reads as evidence the case was considered.

## What Phase 2 does NOT cover

- **The window itself.** Creation, the background message pump, focus, resize,
  close, palette realisation. Untestable from here and owed to the author's
  interactive pass.
- **The X11 presenter.** Not started. It cannot be run, let alone verified, from
  this machine, and writing an untested presenter blind would be worse than
  leaving the slot empty -- the same reason `gate-abi.sh` still says
  linux-x86_64 is owed rather than pretending two targets are three.
- **Anything above 32bpp-only.** 8/16/24bpp surfaces, the palette model and the
  24-entry blitter table are Phase 3.

---

## Phase 3 -- CIRCLE

`raster/circle.bi` covers the full ellipse with aspect and fill. **62 cases pass**
across all four configurations: consecutive integer radii (which walk the
decision variable through every phase), fractional radii, off-centre and clipped
positions, and an aspect sweep covering both branches plus the exact 1.0
boundary. Arcs are not done -- see below.

### C truncates, FreeBASIC rounds

The trap that matters here. `x1 = x - a` with `a` a float assigns to an `int`:
C truncates toward zero, **FreeBASIC rounds to nearest**. Every such conversion
is wrapped in `fix()`.

Dropping those wrappers fails **8 of 62 cases** -- and only the fractional ones
(`r=12.3`, `aspect=3`). Integer radii pass either way, so a case set without
fractional radii would have called this correct.

gfxlib2 also computes `aq = a * a` and `r = a * bq` in **float** despite the
accumulators being 64-bit, so `a * bq` converts the 64-bit value back to single
precision first. That is lossy, and it is the behaviour to match rather than the
behaviour one would choose; `csng()` makes it explicit instead of accidental.

### One guard that is live but unverifiable

The `filled[]` array stops a scanline being filled twice as the two halves of
the ellipse converge. **Removing it changes no pixel** -- filling a row twice
with a solid colour is idempotent and the digest cannot see it.

It is not dead code either: instrumenting the loop counts **356 duplicate
scanline attempts across radii 1..30**. So it is doing real work, and it becomes
correctness-critical the moment a non-idempotent fill exists -- PAINT patterns,
or alpha.

Recorded as unverified rather than assumed correct. Distinguishing "the test
covers this" from "the test cannot see this" is the difference between a green
suite that means something and one that does not.

### Arcs, and a third rounding rule

Arcs are done: **90 cases pass**, 28 of them arcs -- start/end sweeps, negative
angles (which also draw a radius line), and wrap-around.

`get_arc_point` rounds through the runtime's `CINT` macro,
`(x > 0) ? (int)(x + 0.5) : (int)(x - 0.5)` -- round half **away from zero**,
built from truncation. FreeBASIC's own `cint()` is round half to **even**, so
calling it would be wrong for exactly the halfway cases. That makes **three
distinct conversion rules in one file** -- implicit truncation, `fix()`, and
this -- so each is spelled out at its use site.

**Precision must match C, not be better than it.** The loop bound
`end + (increment / 2)` is entirely float in C, because `2` is an int. Writing
`increment / 2.0` in FreeBASIC promotes to double -- `2.0` is a double literal --
making the bound very slightly larger and running **one extra iteration**. One
stray pixel at (59,21) on arc 0..0.5. Likewise `sqrt()` returns double in C and
the result is truncated into a float. The `!` suffix and an explicit
single-typed bound put the arithmetic back where C has it.

### gfxlib2 disagrees with itself across targets

Chasing that pixel turned up something worth stating plainly. For
`CIRCLE (40,32), 22, c, 0, 0.5`:

| | gfxlib2 | libtkogfx |
| --- | --- | --- |
| win64 | 14 points | 14 ✓ |
| win32 | **15 points** | 14 |

**Same source, same arguments, different output.** gfxlib2's win32 build
accumulates the arc angle in x87 registers at 80-bit precision rather than
rounding to single each step, so its loop runs one iteration longer. This is a
property of how the reference was *compiled*, not of the algorithm.

libtkogfx rounds to single on both targets: it matches gfxlib2 exactly on win64
and is **self-consistent**, which gfxlib2 is not. Reproducing the x87 behaviour
would mean matching a compilation artifact, and would make our two targets
disagree with each other to do it.

So **"pixel-exact" is target-specific for float-dependent primitives**, and D2
needs that qualification. The A/B suite reports this case by name --
`KNOWN win32 x87 divergence` -- rather than tolerating it silently. A suite that
hides a divergence is worse than one that fails on it.

## PAINT

`raster/paint.bi` is a span flood fill: extend left and right to the border,
record the run, queue the rows above and below. **15 scenes pass** -- concave
shapes, interior islands, nested boundaries, a circle boundary, a comb, a
one-pixel gap the fill must escape through, and the degenerate seeds.

**The flood tests the BORDER colour only** -- never the fill colour, never
"already visited". gfxlib2 collects every span first and fills them all at the
end, so painting cannot influence its own spread.

### Three negative tests, two of which I got wrong first

This primitive is where my own claims stopped matching my own coverage.

| claim | first attempt | outcome |
| --- | --- | --- |
| flood must ignore the fill colour | scene 4: a fill-coloured **island** | **did not discriminate** -- filling it or not gives identical pixels |
| " | perturb the **left** extension only | **did not discriminate** -- the flood routes around via the right extension and vertical scans |
| " | scene 10: a fill-coloured **full-width bar**, all four border tests blocked | catches it, and only it |
| dedup must be **exact-match**, not overlap | swap for an overlap test | **no change, and the claim was wrong** |
| dedup must exist at all | remove it | fails 12 of 15 |

The dedup one is worth stating plainly: I wrote in the header that exact-match
dedup matters and overlap dedup "terminates too early and leaves holes". That is
**false**. `add_span` always extends to the maximal run bounded by the border, so
two spans in one row are either identical or disjoint -- a partial overlap cannot
arise, and the two tests are the same test. The comment is corrected in place.

A plausible-sounding invariant in a comment is not evidence. Perturb it and watch
the suite fail, or write it down as unverified.

## DRAW

`raster/draw.bi` implements the turtle language: `B N C S A TA M P` and the eight
direction letters. **51 command strings pass**, covering the parser (redundant
signs like `R++5`, malformed input that must stop cleanly mid-string, lowercase),
the state machine, and the drawing.

Four behaviours copied because they are real, not because they are sensible:

- **Scale and angle persist between calls.** They are file-scope statics in
  gfxlib2, so `DRAW "S8"` then a separate `DRAW "R10"` draws a line of 20.
  Resetting them per call is tidier and wrong -- and fails the `persist` case.
- **`M` truncates; the letter commands round.** `M` passes `(int)x`,
  `U/D/L/R/E/F/G/H` pass `CINT(x)` (half away from zero). Two rounding rules in
  one statement.
- **The letter cases fall through to accumulate the angle** -- F/D add 90, then
  fall into G/L (180), then H/U (270), then E/R. So R=0, U=90, L=180, D=270.
- **A diagonal is not a rotated step.** `x2 = x + (dx + dy)`,
  `y2 = y + (dy - dx)` -- sqrt(2) longer than the axis step, not the same length
  at 45 degrees.

### The M-truncation claim needed six more cases

Making `M` use `CINT` like the letters **passed all 45 original cases**. Every
`M` in them landed on an integer coordinate, where truncation and rounding agree.
Six cases with fractional endpoints -- scale 1.5 at 45 degrees gives
`10 * 0.7071 * 1.5 = 10.6` -- now fail 5 of 51 under that perturbation.

That is the third time a documented invariant turned out to be untested by the
cases that appeared to cover it. The pattern is consistent enough to state as a
rule: **if a comment claims behaviour X matters, there must be a case that fails
when X is removed, and it has to be checked, not assumed.**

### A stale binary told me a convincing lie

Worth recording separately. A compile failed, `head` still exited 0, the `&&`
ran an **older executable left at the same path** from a previous negative test,
and it printed a plausible three-line failure about box dirty spans that had
nothing to do with the change. Two minutes went into investigating a regression
that did not exist.

Build products in these probes now get unique names per run. `[ -f exe ]` before
running it, rather than trusting a chained exit code.

## VIEW, WINDOW, PMAP

`core/viewport.bi`. **369 cases pass** -- nine VIEW/WINDOW combinations crossed
with a grid of logical coordinates, plus every PMAP function over ten probes.

Pixel placement and PMAP are checked **separately**, because they are observable
independently and because gfxlib2 does not keep them consistent:

> `fb_hTranslateCoord` scales by **`(view_w - 1)`**; `fb_GfxPMap` scales by
> **`view_w`**. So `PMAP(x, 0)` does not invert what `PSET x` does.

Both are reproduced as-is. Fixing either would disagree with gfxlib2 on
whichever statement was "fixed", and a harness that only checked round-trips
would have hidden the discrepancy entirely.

### Precision, again -- and in the opposite direction

PMAP returns its value directly, so unlike the transform there is no `CINT`
downstream to absorb rounding. Writing the arithmetic as one expression lets
FreeBASIC promote to double and gave results differing in the last digit from
C's all-float evaluation. Forcing a `single` intermediate at each step fixed
win64 exactly -- **and broke win32**, because there gfxlib2 keeps intermediates
in x87 80-bit registers, so the *less* precise version had been matching it.

Measured, same call, same arguments:

| | `pmap(0,3)` | `pmap(5,3)` |
| --- | --- | --- |
| gfxlib2 win64 | 9.722221 | 8.333334 |
| gfxlib2 win32 | 9.722222 | 8.333333 |

**Second independent instance of gfxlib2 disagreeing with itself across
targets**, after the CIRCLE arc. Same resolution: match win64, stay
self-consistent, name the divergence.

### The tolerance is bounded, and the bound was earned

43 win32 PMAP results are excused as x87 noise. The bound is **absolute
(1e-4), not relative**, and that distinction was forced by the data: `PMAP`
funcs 1 and 3 compute `view_h - 1 - coord` with `coord` around 53.7, so a 1-ULP
error in the intermediate survives as ~4e-6 of absolute error while the result
shrinks to 0.735. Relative to the result that is 64 ULP and looks like a bug;
relative to the intermediate it is one.

A first attempt with a relative bound flagged two of those as real failures.
The bound is verified to still catch genuine errors: swapping `view_w` for
`view_w - 1` in PMAP fails **76 of 369** on win32, far outside the band.

## CLS, and multi-bpp

`raster/cls.bi` -- **8 cases**. `raster/pixelfmt.bi` generates the 8, 16 and
32 bpp pixel paths from one macro -- **42 cases**.

**16bpp is a conversion, not a mask.** `fb_hFixColor` truncates for 8bpp
(a palette index) and 32bpp, but for 16bpp it converts RGB888 to RGB565:
`(b>>3) | ((g<<3) & 07E0) | ((r<<8) & F800)`. Assuming it truncated failed all
ten 16bpp cases *including colour 0*, which is what made it obvious the
difference was structural rather than an edge case.

**CLS stores a physical value in a logical field.** Modes 0 and 1 set
`last_x = view_x + view_w \ 2`, but `last_x` is the *logical* cursor everywhere
else, so a following `LINE -STEP` adds `view_x` a second time. With a viewport at
x=10 the cursor reads 45 and the next relative draw lands at 55. Reproduced.

## Two gfxlib2 defects the harness found

Neither is reproduced -- both are bugs rather than behaviour.

### 1. IMAGECREATE fills with the wrong element width

`gfx_image.c` does `context->pixel_set(data, color, (pitch * height) / bpp)`.
`pixel_set` is bound to the **last drawing target's** depth; the count is
computed from the **new image's** bpp. Create an image of a different depth than
the last thing you drew to and the fill is wrong:

| last target | imagecreate | result |
| --- | --- | --- |
| 8bpp | 16bpp | 173 of 1920 bytes left stale |
| 8bpp | 32bpp | 172 of 3840 bytes left stale |
| 16bpp | 32bpp | 13 of 3840 bytes left stale |
| 32bpp | 16bpp | **writes 3840 bytes into 1920** -- heap overrun; crashed once |

The under-fill is deterministic; the overrun's consequences are heap-layout
dependent, which is why it survives.

### 2. Stale target aliasing -- the worse one

`fb_hPrepareTarget` opens with

```c
if (target != context->last_target) { ...rebind bpp, pitch, dimensions... }
```

and `IMAGEDESTROY` never clears `last_target`. So: destroy an image, create one
of a **different depth** that the allocator places at the same address, draw to
it -- and the rebind is skipped entirely. It keeps the dead image's pixel width,
pitch and dimensions.

Measured: after an 8bpp pass, `PSET` of `&hABCDEF` into a 16bpp image wrote the
single byte `&hEF` at byte offsets (reading back as `00EF`/`EF00`) instead of the
RGB565 value `&hAE7D`. **350 of 960 pixels wrong.**

This is the first divergence taken **on purpose**. Everything else in this
library reproduces gfxlib2 exactly, including its inconsistencies; matching this
one would mean deliberately honouring a dangling pointer.

### The diagnosis took three wrong turns

Worth recording, because each looked convincing:

1. **"16bpp truncates like 8bpp."** Wrong -- it converts to RGB565.
2. **"IMAGECREATE under-fills, so the buffer starts dirty."** Right mechanism,
   but my first probe *disproved* it -- because the probe created its junk
   images at the same depth as the final one and never left non-zero data in the
   recycled block. A badly built probe refuted a correct hypothesis.
3. **"The explicit LINE BF clear fixes it."** It did not, and that is what
   finally pointed at the real cause: the clear was itself being written at the
   wrong width.

The thing that ended it was dumping the actual bytes -- `00EF` and `EF00` are
unmistakably one byte written into a two-byte slot, and no amount of reasoning
about masks would have produced that.

## COLOR

`raster/color.bi` -- **42 cases** across 8, 16 and 32 bpp. Two halves are checked
separately, because either can be wrong alone: the **return value** (the previous
pair) and **what was actually stored** (observed through the next return).

**The 16bpp return is not a simple unpack.** Storing a colour loses bits --
8:8:8 becomes 5:6:5 -- and COLOR has to hand something back. gfxlib2 replicates
each channel's high bits into the vacated low bits rather than shifting up, so
full-scale stays full-scale. Removing the replication makes white return
`&hFF0000F8` instead of `&hFF0000FF`, and fails 4 of 42.

So a COLOR/COLOR round trip at 16bpp is **not the identity**, and is not meant
to be. Anything assuming otherwise drifts.

**Only the default branch is implemented.** Legacy `SCREEN 1, 7, 8, 9` route
COLOR through the palette rather than the context, which needs the mode table.

### A harness note

FreeBASIC's `COLOR` *function* form rejects omitted arguments, so there is no way
to read the pair without also setting it. The omission cases therefore use the
*statement* form and observe its effect through the **next** return -- which is
the stronger check anyway, since it tests what was stored rather than what was
echoed back.

## The SCREEN mode table, and PALETTE

`core/mode.bi` -- **106 checks** over `SCREEN 1..21`, every row verified against
what `SCREEN n` actually opens (geometry from `SCREENINFO`, text dimensions from
`WIDTH`, and whether the mode opens at all).

**Modes 3, 4, 5 and 6 are holes, not omissions.** They are real QBasic modes
gfxlib2 does not implement, present as all-zero rows so mode numbers stay array
indices. A table that skipped them would shift every later mode by four. Filling
one in is caught.

`scanline_size` is **not a stride** -- it is a vertical doubling factor, so modes
2 and 8 are 640x200 buffers displayed at 640x400.

### PALETTE -- three things that look like bugs

`core/palette.bi` -- **180 cases across 6 modes**.

1. **Red is the LOW byte.** Entries are `r or (g shl 8) or (b shl 16)`, the
   opposite of the `&hRRGGBB` convention every other colour here uses. Storing
   them the "right" way round fails **144 of 180**, and would have produced
   plausible-looking output with red and blue swapped.
2. **The index is masked, not range-checked.** `index and (colors - 1)`, so on a
   16-colour mode `PALETTE 17` writes entry 1. Never an error, never out of
   bounds.
3. **The two GET forms disagree by a factor of four.** `PALETTE GET i, r, g, b`
   returns full 8-bit channels; `PALETTE GET i, v` returns
   `(c and &hFCFCFC) shr 2` -- three **6-bit** channels, the VGA DAC's native
   precision. Returning 8-bit there fails 66 of 180.

### The default palettes are generated, not transcribed

**2692 RGB triples.** Hand-copying that many is precisely the task that yields
one wrong entry nobody notices for a year, so `tools/gen-palettes.bas` opens each
mode and reads them back out of gfxlib2 through `PALETTE GET`. The generated
`core/palette-data.bi` is checked in so the build needs no extraction step, and
the A/B re-reads every entry from the reference on each run.

For the CGA and EGA modes the extracted table already has the mode's colour
association applied, which is the form the driver is handed -- so the
associations come along for free rather than needing separate transcription.

### A negative test that found a coverage hole, not a bug

Corrupting one of the 2692 generated entries **was not detected**. The data was
fine; the *test* only checked the six modes it sampled for set/get, so **11 of
17 modes' palette data was entirely unverified** while the suite reported green.
The corrupted entry happened to live in mode 16.

The defaults check now runs over every supported mode -- 2872 cases, up from 180
-- and the same corruption fails as `mode 16 DEFAULT entry 190`.

Generating data instead of transcribing it removes the transcription risk. It
does not remove the need to check that what you generated is what you are using,
across all of it.

### A keyword collision worth naming

`type Palette` does not compile. FreeBASIC is case-insensitive, so it parses as
the `PALETTE` statement. Renamed to `GfxPalette`. That is the fourth instance of
this trap in the library -- after `frac` (an intrinsic), `out` (port I/O), and
`h`/`H` colliding with a const. Any short, domain-obvious identifier is a
candidate.

## PAINT pattern mode

**45 scenes** now, 30 of them patterns. The tile is 8x8 and **anchored to the
surface origin, not to the shape** -- gfxlib2 picks the row with
`(y and 7) shl 3` -- so two identical shapes at different y values get
different-looking fills. That is correct, and anchoring to the span instead
fails 15 of 45.

The span is written in **three parts**: a leading partial run up to the next
multiple of 8, whole tiles, then a trailing partial. Plus a special case when
`x1` and `x2` fall in the **same 8-block**, where only the first part runs and
its length is the whole span. Dropping that case fails 5 of 45 -- precisely the
narrow boxes (`w=3`), which is what it exists for.

gfxlib2 also increments `x2` before the middle loop, making it exclusive there
and inclusive everywhere else. Reproduced rather than normalised, because the
loop bound `(x2 and not 7) shr 3` depends on it.

## The row converters

The 24-entry blitter table is internal and only observable through a window, but
**`IMAGECONVERTROW` exposes the same converters** as a public statement. So the
conversion logic is verified even though the blitter that dispatches it is not --
`raster/convert.bi`, **9 cases**.

**`isrgb` picks between a swap and a copy**, and both are called "32 to 32":

| | |
| --- | --- |
| `32to32` (isrgb) | `(c shr 16) or (c and &hFF00FF00) or (c shl 16)` -- **swaps r and b** |
| `32bgrto32` | a straight copy |

Choosing wrong leaves an image that looks right in greys and inverted in colour,
which survives a casual glance at a screenshot. Making the RGB path a plain copy
fails 1 of 9. The suite also asserts that `isrgb` *changes the output at all*, so
a source with symmetric red and blue cannot silently make the case vacuous --
the same trap as PAINT scene 4.

The 8-bit converters read the **device palette**, so the test sets one where
every channel differs per index. A default or greyscale palette would hide a
channel-order error.

`8to8` masks with `color_mask`, not `&hFF` -- on a mode with fewer than 256
colours the copy is not the identity.

## DRAW X -- executing a substring

`DRAW "X" + STR( VARPTR( s ) )` parses the number as an **FBSTRING descriptor
address** and recurses into it. That is why the parser accepts numbers far larger
than any coordinate: they are addresses. The `FBSTRING` mirrored back in Phase 1
is what makes reading one possible.

**The cursor and colour carry in and out.** Saving and restoring them around the
call -- which is the tidier-looking thing -- fails 12 of the 36 `X` cases, all of
them the ones whose substring *moves* rather than only drawing. A case set with
only drawing substrings would have called it correct.

**Second deliberate divergence: a recursion limit.** gfxlib2 has no depth check,
so a string containing its own address, or two strings referring to each other,
overflows the stack and takes the process down. There is nothing to be gained
from reproducing a crash, so this stops at `DRAW_MAX_DEPTH` (64) and returns.

### Still owed in Phase 3

Phase 3 is complete except for one item that **cannot be verified from here**:

- **The blitter dispatch.** `fb_hGetBlitter` selects one of 24 converters by
  (source depth class x device depth x RGB/BGR). The converters themselves are
  done and checked through `IMAGECONVERTROW`; what is not checked is the
  *selection*, which is only observable by looking at a real window. It belongs
  with the presenter work owed to the author's interactive pass.
- 8/16/24bpp surfaces, the palette and colour-association model
- the legacy `SCREEN 1..21` mode table
- the 24-combination blitter table
- `PAINT`, `DRAW`, `VIEW`/`WINDOW`/`PMAP`, `CLS`/`COLOR`/`PALETTE`

---

# Phase 4 -- images

## Cross-library buffer interchange

`core/image.bi` + `tools/abtest-image.bas`, **144 checks**. This is the test D2
exists for: everything else compares pixels drawn into two separate buffers,
this hands **one buffer between the two libraries**.

| direction | catches |
| --- | --- |
| 0. our pitch vs the pitch gfxlib2 picks | padding rule |
| 1. ours -> gfxlib2 PUTs it | wrong header field, wrong pixel offset |
| 2. gfxlib2's -> we read it | the same, in reverse |
| 3. gfxlib2's buffer, **we write**, they display | a pitch assumption true only of our own allocator |
| 4. IMAGEINFO agreement on our image | field-by-field |

**Pitch pads to 16 bytes, not 4.** Measured, after guessing 4:
`(w * bpp + 15) and not 15`. So a 17-wide 32bpp image has pitch 80, not 68.

## Two ways this test was silently vacuous

Both worth recording, because both produced a confident green.

### 1. Every consumer reads pitch from the header

The 4-vs-16 padding error passed **all 24** original checks. A reader takes the
pitch out of the header it is given, so a self-consistent wrong value works in
every direction. Only comparing our pitch against the one gfxlib2 *chooses* for
the same dimensions catches it -- which is now check 0, and fails 92 of 144 when
the rule is wrong.

### 2. `ImageCreate` is FreeBASIC's `IMAGECREATE`

The worse one. FreeBASIC is case-insensitive, so `ImageCreate`, `ImageInfo` and
`ImageDestroy` resolve to the **intrinsics**, not to the functions defined here.
Silently, with no warning, and with plausible results because the intrinsic does
something very similar.

**Every "our image" in the test was in fact a gfxlib2 image.** Both directions
trivially agreed. Two deliberate header corruptions went undetected. The test
reported 24/24 while exercising none of the code it was written for.

Found by perturbing the implementation and getting a pass -- then dumping the
raw header bytes and seeing `07` where a `00` had just been written. Renamed to
`TkoImageNew` / `TkoImageFree` / `TkoImageQuery` / `TkoImagePixels`; all three
perturbations now fail (the third by segfault, which the runner counts).

**Sixth instance of this trap**, after `frac`, `out`, `h`/`H`, `Palette` and
`base`. The others were compile errors and cost minutes. This one compiled, ran,
and passed. A name audit over all 103 public functions now reports clean.

## The PUT blend modes

`raster/put.bi` -- **10 cases**, both sides blending the *same* source into the
*same* destination content so the comparison is of the blend rather than of two
separately drawn scenes.

The modes are three families, not one:

| | |
| --- | --- |
| `PSET` | a pixel copy |
| `PRESET, AND, OR, XOR` | **bytewise** -- `w <<= bpp shr 1`, then bytes/shorts/ints. Identical at every depth, so one implementation covers all three |
| `TRANS, ALPHA, ADD, BLEND` | per-pixel arithmetic, one variant per depth |

**`TRANS` strips the alpha channel.** gfxlib2 computes `c = *s and &h00FFFFFF`
and writes **`c`, not `*s`** -- so it does not copy the source pixel, it copies
the source pixel with alpha forced to zero. `d[i] = s[i]` is the obvious reading
and is wrong.

It was caught because the test source carries **varied alpha**. A source with
alpha 0 or a uniform alpha would have passed. The same reasoning drove the rest
of the fixture: `ALPHA` over a flat destination hides an `(a)` vs `(a+1)` error,
`ADD` only saturates where the sum exceeds 255, and `AND`/`OR`/`XOR` are
indistinguishable on operands that are all-ones or all-zeros. A flat source and
destination would make most of these modes agree with each other, and the suite
would pass whichever one was implemented.

**`ALPHA` uses `(a + 1)`, not `a`** -- multiplier 1..256 rather than 0..255, so a
fully opaque source exactly replaces the destination instead of landing one part
in 255 short.

**`ADD` is branchlessly saturating**, transcribed as-is. The carry-mask sequence
is not obvious and rewriting it "clearly" is how the saturation boundary is lost.

### BLEND is not what its name suggests, and cannot be tested

The putter signature carries a blender pointer, so `BLEND` looks like the
callback mode. It is not -- `fb_hPutBlend4C` ignores that pointer entirely.
The actual trio is:

| | |
| --- | --- |
| `BLEND` | uniform alpha from the **argument**, transparent-colour aware |
| `ALPHA` | per-pixel alpha from the **source**, NOT transparent-colour aware |
| `CUSTOM` | the only mode that really calls out per pixel |

And `PUT ..., BLEND` is a **syntax error**. Measured across all ten: PSET,
PRESET, AND, OR, XOR, TRANS, ALPHA, ADD and CUSTOM parse; BLEND does not. fbc
never exposed it as a PUT mode keyword, so it is reachable only from inside the
library -- DRAW STRING passes a blender.

`PutBlend32` is therefore implemented and **marked UNVERIFIED in the source**,
rather than omitted or quietly counted as covered. It becomes testable when DRAW
STRING lands, which is the caller that reaches it.

`CUSTOM` is tested, and is the interesting one: gfxlib2 calls **our** function
from inside its own PUT, once per pixel. The blender is deliberately asymmetric
in src and dst so a swapped argument order shows up.

## BSAVE / BLOAD -- file-format interchange

`core/bsave.bi` -- **28 checks**. `abtest-image.bas` hands a buffer between the
libraries in memory; this does it through a **file**, which is the stronger
claim: a file written by one has to be readable by the other, and by a future
version of either.

Format: `0xFE`, then a **little-endian** 4-byte size, then the bytes. BLOAD
dispatches on the first byte -- `0xFE` is this format, `'B'` means rewind and
parse as BMP -- so the magic is a real discriminator and a bad one must be
rejected, which is checked.

**Direction 3 is byte-for-byte file comparison, and it is the one that earns its
place.** Writing *and* reading the size big-endian is self-consistent: our file
round-trips through our own loader perfectly. Directions 1 and 2 alone would both
pass. Only comparing our bytes against theirs catches it -- and it does, on the
very first case (`gfxlib2=&h01 tko=&h00` at byte 1).

That is the same shape as the pitch bug in `abtest-image.bas`: a self-consistent
wrong value is invisible to any test that only round-trips through itself.

**The BMP path landed 2026-09-21**, in `entry/bmpio.bi`: BLOAD of 1, 4, 8, 16, 24
and 32-bit BMPs (bitfields, top-down, OS/2 and V3 headers) onto screens, images
and bare buffers, the screen forms of both formats, and the caller's palette.
`tools/abrun-bloadsave.sh` compiles one program with fbc and with tiko and diffs
56 lines of file, framebuffer and palette hashes; see that file's header. LZW,
the legacy compressed GET/PUT array encoding, is still owed here.

## PUT at 8 and 16 bpp -- where modes become other modes

`tools/abtest-putbpp.bas`, **8 cases**. gfxlib2's per-mode dispatch tables are
indexed by bpp, and several entries point at a **different putter** rather than
at a narrow variant of the same one:

| statement | 8bpp | 16bpp | 32bpp |
| --- | --- | --- | --- |
| `PUT ..., ALPHA` | **PSET** (a plain copy) | **PSET** | real alpha blend |
| `PUT ..., ADD` | **OR** (bitwise) | 565 saturating add | 888 saturating add |
| `PUT ..., TRANS` | skips **index 0** | skips **565 magenta** | skips 888 magenta |

So `PUT ..., ALPHA` on an 8bpp image is a copy, and `PUT ..., ADD` on one is a
bitwise OR. Neither is documented as such, and neither is visible from the mode
name -- only from the dispatch table.

Implementing a narrow "alpha" or "add" at low depth is the reasonable thing to
do and disagrees with gfxlib2 on every pixel. Both fallbacks are negative-tested:
substituting the sensible guess (`TRANS` for 8bpp ALPHA, `PSET` for 8bpp ADD)
fails exactly the case it should.

The transparent value changing *kind* between depths matters too -- a palette
index at 8bpp, a packed 565 colour at 16bpp. The test sources contain each
depth's own transparent value, so a TRANS that checked the wrong constant would
be caught rather than silently copying everything.

## BMP output

`core/bmp.bi` -- **11 checks**, and they are **whole-file byte comparisons**, not
round trips. A round trip through our own reader passes on any self-consistent
layout; that hole hid the 4-vs-16 pitch bug and the big-endian BSAVE size. The
file matches gfxlib2's byte for byte or it does not.

Widths cover every residue mod 4, because an 8-bit BMP pads rows to
`(w + 3) and not 3` -- a writer that skipped the padding would produce the right
length only when `w` is already a multiple of 4.

**Rows are written BOTTOM-UP with a POSITIVE `biHeight`** -- the exact opposite
of the DIB the GDI presenter builds, where `biHeight` is negative. Two
conventions in one library, each correct for its purpose, and confusing them
flips the image.

**The format is chosen by FILENAME EXTENSION**, not by a flag or by the data. And
the asymmetry there is measured, not assumed: `BSAVE "x.bsv", img` with an image
and no size **writes nothing** -- gfxlib2 rejects `size == 0 && src`, but only
*after* opening the file, so a zero-length file is left behind. The raw path
needs an explicit size and a plain buffer; an image is effectively a BMP-only
argument. Both branches are checked.

### The Windows-path escape trap, hit in my own tooling

A patch script wrote `"\abtest_bmp_c.bsv"` into the test and the file ended up
containing `btest_bmp_c.bsv` -- `` consumed as BEL, taking the backslash
*and* the `a` with it. The test then wrote to a different directory and failed
two checks for a reason that had nothing to do with BMP.

It is in my own notes as a known trap and I hit it anyway. The tell was that
`grep` showed a plausible-looking string while an exact-match assertion on that
same string failed -- an invisible byte. Paths in generated code now use
`chr(92)` rather than an escape.

---

# Phase 5 -- console and control

## SCREENCONTROL

`core/control.bi` -- **164 checks across 12 modes**. SCREENCONTROL is a mapping
from selector number to state field, and a mapping is only tested by covering
every entry: one transposed pair is invisible until somebody uses the other one.
Transposing `depth` and `bpp` fails 20 of 164.

**The test is deliberately not circular.** Our side is driven from the mode table
and `SCREENINFO`, never from `__fb_gfx`. Reading gfxlib2's own global and
comparing it against gfxlib2's reading of that same global would prove nothing.

**`GET_VIEWPORT` reports inclusive CORNERS**, while the viewport is stored as
origin-plus-extent -- so a straight field copy is wrong by one on the second
pair. Returning the extent fails 12 of 164.

**A collision turned into a check.** Our selector constants clash with
`fbgfx.bi`'s, which FreeBASIC reports as an explicit ambiguity rather than
resolving silently. Rather than just qualifying the names, the suite now asserts
all sixteen numbers are equal to `fbgfx.bi`'s -- turning a transcription risk
into a verified fact.

**The driver selectors are declined, not guessed.** `GET_WINDOW_POS`,
`GET_WINDOW_HANDLE`, `GET_DESKTOP_SIZE` and `GET_DRIVER_NAME` go to the OS.
`ScreenControlGet` returns "unhandled" for them and the suite asserts that too --
claiming to answer them would be worse than declining.

### A bug only the four-config run could find

`X86_MMX_ENABLED` is **true on win32 and false on win64**. gfxlib2 sets it from a
runtime CPUID check, but its MMX code only exists on 32-bit -- `obj/win32` has
eleven `*_mmx.o` files, `obj/win64` has none, and the family is behind
`#ifdef HOST_X86`. So the flag is structurally always false on x64 and true on
any x86 CPU made since 1997.

Hardcoding it to 0 **passed on win64 and failed all twelve modes on win32**.
Running every suite on all four configurations is what caught it; a win64-only
run would have shipped it.

## Console text

`raster/text.bi` -- **42 cases** across all three font heights. The fonts are
**extracted by rendering**, not transcribed: `gen-fonts.bas` prints every
character and reads the bits back, 9728 bytes for 256 characters at 8, 14 and 16
rows.

Three things the glyph loop does that are easy to get backwards:

- **Bit 0 is the LEFTMOST pixel.** The C starts with mask 1 and shifts left, so
  the low bit is the left edge. Most bitmap fonts are MSB-first; packing this one
  that way mirrors every glyph.
- **PRINT is opaque** -- a clear bit draws the *background*, it is not skipped.
  Every case here prints over a pre-filled area, because on a black screen a
  transparent implementation looks identical.
- **The cell is the font's full box**, no kerning, no gap between characters.

### Four bugs, three of them mine

The first run failed all 48 cases. In order:

1. **`PSet32` on an 8bpp surface.** The glyph writer hardcoded the 32bpp path,
   writing four bytes per pixel -- glyphs came out with their columns four bytes
   apart. Now dispatches on surface depth.
2. **Characters 0..31 are control codes.** PRINT *interprets* them; they never
   reach the glyph renderer. Excluded, with the note that their font data is
   real and belongs to DRAW STRING, which does not interpret anything.
3. **The legacy COLOR branch, found through PRINT.** On modes 7, 8 and 9 `COLOR`
   sets the foreground normally but routes the background into **palette entry
   0**, leaving `bg_color` at 0. So `COLOR 2, 5` then printing draws on
   background **0**, not 5. This was owed from Phase 3 and is now implemented --
   found because every mode-9 glyph had the right shape and the wrong
   background.
4. **The extractor did not clear the cell.** Fixed on suspicion that chr(255)
   drew nothing; it did not fix the failure, and the real behaviour turned out
   to be stranger.

### chr(255), unresolved and excluded

Measured on mode 13, `COLOR 2,5`, over a cell pre-filled with 3: gfxlib2 leaves
rows 0..6 as the **pre-fill** and draws row 7 in the foreground. Every other
character repaints the whole cell. So for this one character PRINT is
transparent rather than opaque.

The glyph data is right -- our bytes are `00 00 00 00 00 00 00 FF`, matching the
single bottom row drawn. Only the untouched background differs.

Excluded and **recorded as unexplained**, rather than worked around with a
special case in the renderer. Inventing a rule from one observation is how a
wrong rule gets baked in, and it is one character out of 224.

## The VGA DAC ports

`core/vgaport.bi` -- **406 checks**. On a graphics screen `INP` and `OUT` are
redirected into the library through the `inproc`/`outproc` hooks and emulate the
VGA colour DAC: `3C7`/`3C8` set the index, `3C9` carries R then G then B, `3DA`
returns 8 after waiting for vsync.

Three things drive the design:

- **One state triple is shared by both directions.** `idx`, `shift` and `color`
  are file statics in the C, used by reads *and* writes. An `INP(&h3C9)` in the
  middle of a three-byte write does not read past it -- it consumes the shift
  the write needed. An implementation with separate read and write state passes
  every straightforward case and fails only the interleaving one, which is why
  that case exists.
- **Nothing resets it**, including `SCREEN`. Two bytes before a mode change and
  one after commit a colour built from both sides.
- **The shift sequence is 2, 10, 18**, not 0, 8, 16 -- the DAC is 6 bits per
  channel parked in the top six bits of each byte.

The two commit paths **disagree about scaling**, and that is the reference's
behaviour: the 256-colour path scales 6 bits to 8 as `(v * 255) \ 63`, the
low-colour path stores raw, which is `v shl 2`. Full intensity is 255 one way
and 252 the other. Both round-trip losslessly, so only comparing against the
reference finds it.

## Three reference bugs found on the way

Implementing the DAC forced a read of `fb_GfxPalette`, which turned up a
statement this library had never implemented and two memory bugs in gfxlib2.

### `PALETTE index, value` was missing entirely

Every one of the 2872 palette cases used the **four**-argument form. The
two-argument form is a different code path, and it is two statements wearing one
syntax:

| | `value` means | result |
| --- | --- | --- |
| 256-colour modes | a packed colour, three **6-bit** channels | scaled up as `(v * 255) \ 63` |
| low-colour modes | a **register number** | the attribute is pointed at that register |

So `PALETTE 3, 5` sets a near-black colour on SCREEN 13 and makes attribute 3
magenta on SCREEN 9. Both measured.

This needed a third palette array we had never modelled -- `base()`, the
register file the indirection reads. It is invisible to `PALETTE GET`, so it is
extracted **through the indirection itself**: `PALETTE 0, j` copies `base[j]`
into attribute 0 without touching `base`. The default attribute-to-register
association is then recovered by **inverting** the two tables, with uniqueness
checked rather than assumed. The inversion reproduces the C's hardcoded EGA
table exactly -- `{0,1,2,3,4,5,20,7,56..63}` -- without transcribing it.

**The scale is `(v * 255) \ 63`, not `v shl 2`**, and a round-trip test cannot
tell them apart: the truncation error never reaches 4, so both survive
`PALETTE GET` unchanged. Only comparing the RGB discriminates. The negative test
for this initially *passed*, because the `sed` that was supposed to introduce
the bug matched nothing -- a scripted mutation that silently does nothing looks
exactly like a mutation the suite caught.

### `color_association` is `malloc(16)`, indexed to 63

`gfx_screen.c:281-283` allocates `device_palette` and `palette` with 256 entries
each and `color_association` with **sixteen bytes**. `fb_hSetPaletteColor` masks
the attribute to `default_palette->colors - 1`, which is **63** on the EGA
modes, and writes `color_association[index]`.

So `PALETTE 35, 25` on SCREEN 9 writes far past the allocation. It does not
fault where it happens -- the corrupted heap is only touched at the next mode
change, so a loop of `SCREEN 9` / `PALETTE` / `SCREEN 0` dies after four to ten
iterations with the fault nowhere near the write. An early probe that repeated
the bad write *without* cycling the mode survived 200 times and cleared the
wrong suspect.

The default-restore path guards the same array with `if (i < (1 shl depth))`.
Only the explicit two-argument form is unguarded. We do not reproduce it:
`assoc()` is a fixed 256 entries. The suite stays inside `1 shl depth`, which is
the domain where the reference is trustworthy -- hence `ModeAttributeCount`,
which is **not** the same as `ModePaletteColors` (EGA has 64 registers and 16
attributes).

### The same array is read uninitialised

`malloc(16)` is never zeroed, and `fb_GfxPalette` fills it only for modes that
*have* an association table -- the CGA pair and the EGA trio. On SCREEN 10 and
11 it is read uninitialised.

Measured: on SCREEN 11, `OUT &h3C8,0` followed by three `OUT &h3C9` leaves
attribute 0 unchanged. Nothing matched the index, so the DAC write was silently
dropped. Those modes keep their port and depth checks and skip the palette
comparison -- there is nothing honest to compare against a reference reading its
own uninitialised heap.

## An unhandled port is not testable through INP

`rtlib/hook_ports.c` does not return the hook's answer:

```c
if (__fb_ctx.hooks.inproc) res = __fb_ctx.hooks.inproc(port);
if (res < 0) res = fb_hIn(port);      /* a REAL hardware port read */
```

`-1` from the hook means *not handled, fall through* -- not *the value is -1*.
Measured, `INP(&h3C0)` on a graphics screen gives **-8 on win32**, where
`win32/sys_portio.c` implements a real read, and **-1 on win64**, which has no
implementation. That is rtlib behaviour on hardware we do not replace, so the
unhandled-port case is asserted as a unit check against the documented contract
instead of compared.

`OUT`'s return value is likewise not compared: `fb_GfxOut` returns 0 or -1, but
FB's `OUT` is a **statement** and discards it, so no FB program can observe it.
Only its effect on the palette is comparable.

## The character-cell plane

`core/cells.bi` -- **542 checks**. A graphics screen keeps a parallel plane of
character cells, one per text position *per page*, recording what character was
printed and in what colours. It is not derivable from pixels: two characters can
paint identical pixels, and a cell survives being drawn over.

Four things are not what they look like:

- **`SCREEN(row, col)` reads the *work* page, not the visible one.** After
  `SCREENSET 1, 0` it reports the page being drawn to.
- **`WIDTH` returns the size it had *before* the call**, packed `w or (h shl 16)`
  -- the same packing a pure query returns, so the return value alone cannot
  distinguish "queried" from "changed".
- **`WIDTH` silently does nothing for an unsupported size.** The cell size is
  derived by *division* (`screen_w \ w`) and only 8x8, 8x14 and 8x16 exist. Any
  other quotient skips the whole body: no error, no change, and a return value
  identical to the successful case. `WIDTH 100, 25` on a 320-wide screen asks
  for 3-wide cells and is a no-op.
- **`PCOPY` copies two different regions.** Pixels only within the current
  `VIEW`; the character cells for the *whole* page regardless. A clipped `PCOPY`
  deliberately leaves the two planes disagreeing, and both are checked.

The initial state is uneven, and that is reproduced: `fb_hResetCharCells`
`calloc`s every page but clears only the work page to spaces, so a fresh
two-page screen reads `32` on page 0 and `0` on page 1.

### Three harness bugs, each of which made a check pass wrongly

1. **`SCREEN mode, , 0, 1` asks for ZERO pages.** The argument order is
   `mode, depth, num_pages, flags`, so what looked like "two pages, flag 1" was
   one page — and every multi-page check compared page 0 against itself. Now
   `SCREEN mode, , 2`, and the suite **probes whether two pages actually
   arrived** and fails loudly if no mode provided them, rather than skipping in
   silence.
2. **`WIDTH cols, rows` used as an expression returns 0.** Like `OUT` and
   `SCREENSET`, FB's statement form discards the runtime's return value; only
   `WIDTH()` yields it. The packed old value is asserted against the contract
   and the *effect* is what gets compared.
3. **No legacy mode is 16bpp.** Measured: modes 1-21 are 1, 2, 4, 8 or 32 bits
   deep and nothing else, so the depth-16 branch of `SCREEN(r,c,flag)` was
   written and never executed. A negative test that deleted its bit replication
   outright still passed. Reached now through `SCREENRES 320, 200, 16`, with
   colours chosen to have **non-zero low bits** — a shift-only expansion agrees
   on every colour whose low bits are clear. With the branch reachable, that
   same mutation fails 10 checks.

The other two claims are negatively verified too: reading the visible page
instead of the work page fails 10, and clearing every page instead of only the
work page fails 5.

## LZW

`core/lzw.bi` -- **807 checks**, and the streams are **byte-identical** to
gfxlib2's, not merely equivalent.

**What it is actually for.** Not a user feature, and no FB statement reaches it.
`fb_hDecode` has exactly one caller in the whole tree -- `gfx_data.c`, expanding
the built-in font and palette blob at startup -- and `fb_hEncode` has **none**;
it exists so that blob can be produced offline. We do not need the decoder for
our own data, which is extracted by rendering. It is here because a drop-in
library owes the exported symbols.

That also makes this the one suite that cannot drive its subject through a
statement. Both symbols are `FBCALL` exports, so they are **called directly**.
That is a weaker kind of A/B than the others -- it tests the symbol, not the
path a program takes to it -- and the suite says so rather than looking
equivalent.

Four comparisons per case: our encoder against theirs **byte for byte**, their
stream through our decoder, our stream through theirs (the one that matters --
their decoder is what expands the blob), and ours through ours, so a matched
pair of cancelling bugs still shows up.

### The packing is not byte-aligned

Codes are 12 bits emitted in pairs, two codes per three bytes. The even code
writes its low 8 bits and advances, then writes its high nibble into the next
byte **without advancing** -- leaving it pending for the odd code to OR into.
Advancing there instead loses the high nibble of every other code, and short
inputs that never reach a second code still decode correctly. That mutation
fails 307 checks.

### Coverage that had to be verified, not assumed

The "table-exhausting" case claims to fill the 4095-entry dictionary. Measured:
70000 bytes over a 64-symbol alphabet emits **44358 codes**, roughly ten times
the table. Stated because a case named for a limit it never reaches is exactly
the dead-branch problem from the cell work.

### A negative test that correctly did not fail

Replacing the hash probe step (`TABLE_SIZE - index`) with 1 produced
**byte-identical** streams. That is right, not a coverage hole: the probe decides
where an entry lands, never which code it gets -- codes come from `next_code` in
input order -- and lookups follow the same sequence, so collisions resolve to the
same entry either way. The step is reproduced because it is the reference's; it
affects clustering, not results.

### A negative test that hung instead of failing

Removing the encoder's table clear does not produce wrong output. With no `-1`
marker anywhere the probe **never terminates**, so the reference spins forever
and the negative test locked up the suite.

Two changes. The probe is now **bounded** by the table size -- unreachable in
valid use, since 4095 entries never fill 5021 slots -- turning a hang into a
reported error. And the suite encodes the same input **twice through the same
table**, so a missing clear surfaces as an ordinary mismatch. It now fails 127
checks instead of hanging.

### One deliberate divergence

The reference computes its decode limit as `out_buffer + *out_size` *after*
already advancing past the first byte, so the limit sits one byte beyond the
caller's buffer and a maximally-sized output overruns it. We bound at the true
capacity. The two differ only on a stream that exactly fills the buffer, so that
path is asserted against the contract rather than compared -- reproducing a
buffer overrun to match is not worth doing.

### FBCALL is not one calling convention

`FBCALL` is **cdecl on win64 and Linux and stdcall on win32**, where the
exported names carry a leading underscore *and* an argument-size suffix:
`_fb_hEncode@16`, verified with `nm` against the shipped archive. A cdecl
declaration builds and runs on win64 and fails to link on win32.

The two symbols failed **differently**, which is the useful part. The linker's
stdcall-fixup silently resolved `fb_hDecode` to `_fb_hDecode@16` with only a
warning, because `gfx_lzw.o` is already in the link -- `gfx_data.c` calls it.
`fb_hEncode` has no other caller anywhere, so `gfx_lzw_enc.o` is never pulled
from the archive and there is nothing to fix up to. Dead code is invisible until
you are the first to reference it.

One trap in the fix: the alias must be the **plain** name. The backend adds the
leading underscore itself and stdcall appends `@16`. Writing the underscore into
the alias yields `__fb_hEncode@16` -- and ld reports that as ``undefined
reference to `_fb_hEncode@16` ``, stripping one underscore, so the error names
exactly the symbol that *does* exist and the mistake reads as a missing library.
`nm` on our own object was what settled it.

## The window and the message pump

`driver/window.bi` -- the last large structural piece, and the first thing here
that cannot be A/B tested: gfxlib2's window and ours cannot coexist in one
process, both wanting the same framebuffer and the same focus. So
`probe-window.bas` verifies against **the real window instead** -- it opens one,
draws, and reads the pixels back off it with `BitBlt`. 13 checks, no skips.

**Four of the five load-bearing rules fail as a hang, not an error.**

- **The window is created on the thread that pumps it.** A window's messages go
  to the queue of the thread that *created* it, so creating it on the caller and
  pumping on the worker drains an empty queue forever while the window never
  repaints and never closes.
- **The ready handshake waits on the thread handle too.** `WaitForMultipleObjects`
  on *both* the ready event and the thread, where only the event means success.
  Waiting on the event alone leaves the caller blocked forever when
  `CreateWindowEx` fails -- an unopenable window becomes indistinguishable from
  a hung machine.
- **Teardown joins the thread and must not run under the loader lock.** This is
  why gfxlib2 tears down from `fb_End` rather than `atexit`, and why nothing in
  this library runs at module level.
- **The frame and the message dispatch share one lock**, so `SCREENLOCK` really
  does freeze presentation.
- **The client area is the requested size.** `AdjustWindowRect` converts the
  wanted client rectangle to an outer one; without it a 320x200 request yields a
  **314x171** client area and every present is clipped. Verified, and the
  mutation fails exactly those two checks.

DPI is deliberately *not* handled. gfxlib2 never marks the process DPI-aware, so
on a scaled display its window is stretched and ours must stretch identically.

### The probe had a false-pass path, and the negative test found it

The pixel checks originally retried the capture until the first row matched, and
**skipped** if it never did. With a bottom-up DIB the image comes back upside
down, row 0 never matches, every pixel check was skipped -- and the probe
reported **PASS**. The negative test for DIB orientation passed happily.

The two outcomes are now separated: `ReadBack` *failing* is a capture problem and
skips; `ReadBack` *succeeding* yields a frame whose contents are compared and can
fail. The retry can no longer swallow a wrong frame, and that mutation now fails
4 checks with the top and bottom rows exactly swapped.

A related one: the probe's own surface had **no dirty array** — `SurfaceInit`
leaves it null on purpose, since an offscreen image tracks nothing. Every pixel
check still passed, because `WM_PAINT` paints the whole surface. What caught it
was the frame counter staying at zero and the **positive** half of the dirty
test — "a marked row IS presented" — failing. The negative half passed for the
wrong reason: nothing was ever presented from the pump at all. **A negative check
needs its positive twin or it asserts nothing.**

## The event ring

`core/events.bi` -- **59 checks**, a genuine A/B: `fb_hPostEvent` is an exported
symbol, so events are pushed into gfxlib2's own ring and into ours in lockstep
and the reads compared.

Three behaviours are not the obvious ones:

- **The queue drops the oldest event, silently.** When full, a post advances the
  head as well as the tail. It never blocks and never reports overflow, so a
  program that stops polling loses its oldest input and is told nothing.
  "Refuse when full" is the natural guess; it fails 5 checks.
- **`SCREENEVENT` with no argument is a peek**, not a read -- the C only advances
  the head `if (event)`. An implementation that consumes on peek passes every
  ordinary FIFO test and fails 3 here.
- **Capacity is `MAX_EVENTS - 1`**, because a head-equals-tail ring cannot tell
  full from empty. The test pins the *exact* drop count: after `MAX_EVENTS + 10`
  posts the oldest survivor is post 11, not post 0.

## The blitter table

`raster/blit.bi` -- **170 comparisons**, all four configurations. A blitter
converts the whole framebuffer into a *device* format whose depth differs from
the mode's; it is the presenter's fallback, and on these three targets it rarely
runs, because every modern display is 32bpp.

The individual blitters are `static` in the C and unreachable by name, but
`fb_hGetBlitter` is exported and hands back a **function pointer** -- so the
reference's own blitter is fetched and *called*, and its bytes compared with
ours. That tests the dispatch and the conversion together: a correct blitter
reached through a wrong dispatch still fails.

**`device_depth` is a parameter, not the mode's depth.** That is what makes 15bpp
and 24bpp -- formats no machine here has -- testable at all.

### Two of the reference's blitters are broken, and we reproduce them

`8to15RGB` and `8to16RGB` are each wrong in two ways:

- **Missing parentheses.** The second pixel is written `... | (a | b | c << 16)`,
  and `<<` binds tighter than `|`, so only the *last* term reaches the high half
  — the other two land in the low half and corrupt the first pixel. Every other
  paired blitter parenthesises correctly, so this is a typo in exactly two
  functions, not a convention.
- **The wrong five bits of blue.** `8to15RGB` shifts by 6 where 9 is correct,
  taking the *bottom* five bits of the channel; `8to16RGB` shifts by 5 where 8 is
  correct.

Found by reading, then **confirmed by measurement**: correcting the parentheses
makes 18 of 170 cases differ, and correcting the blue shift makes 14 differ. That
is the proof the reference behaves this way — not the source listing.

Both are reproduced deliberately. A binary drop-in matches the output, not the
intent. And because the suite compares bytes, if the reference is ever fixed
these stop matching and the gate says so.

A third oddity is recorded without interpretation: `8to15RGB` puts red in the low
bits and blue in the high, while `32to15RGB` does the opposite. The two disagree
about what "RGB" means.

### Three harness bugs, each of which compared the wrong thing

1. **The dirty array must be the reference's own.** Passing null and letting our
   frame loop treat that as "all dirty" made **40 of 50** cases fail with the
   reference having written *nothing* — its array was clear, so it skipped every
   row while we blitted every row. The comparison was between two different
   questions. The real array is now reached through the ABI seam.
2. **The palette must be the reference's own.** `PALETTE GET` *masks* its index
   to the mode's palette size, so on a 2-colour mode it answers for index 200 as
   though it were index 0. The blitter does **not** mask — it indexes
   `device_palette` directly with whatever byte is in the framebuffer, and
   entries past the palette size are zero. Rebuilding the array through
   `PALETTE GET` disagreed for every out-of-range index.
3. **The presenter thread clears the dirty array every 10ms.** Both blitters read
   it, so between the reference's call and ours a row could be cleared and our
   side would skip it. Three failures in fifty, at different rows each run —
   the signature of a race, not a conversion bug. Both calls now run under
   `SCREENLOCK`, which takes the same critical section the presenter does.

   That was not quite enough. Setting the dirty pattern under *one* lock and
   consuming it under *another* left the same window: the pattern could vanish
   between them, both sides would then skip everything and **agree**, and the
   win32 divergence count moved between runs (145/25, then 144/26). A flaky
   count in a suite that still reports PASS is worse than a failure. The pattern
   is now written inside the same lock scope that runs the comparison, and the
   count is stable across repeated runs.

### Coverage that is asserted, not assumed

The legacy `SCREEN` modes only reach depth 8 and are all 320 or 640 wide, so the
16bpp and 32bpp blitters and **every tail path** were unreached by the first
version of the suite. `SCREENRES` supplies arbitrary widths and depths; widths
320–323 give `w mod 4` of 0, 1, 2 and 3, which is what `16to24` needs — it packs
four pixels into three dwords and then has a two-pixel and a one-pixel tail
written in a different byte order from the packed path.

The suite now **counts** how many width variants ran at each source depth and
**fails** if any depth ran none, rather than quietly testing 8bpp while claiming
three. It reports `8/16/32 ran 4/4/4`.

### win32 selects MMX blitters, and they disagree with the C ones

`fb_hGetBlitter` switches to a block of hand-written MMX blitters when the host
is 32-bit **and** `scanline_size` is 1 **and** the width is a multiple of four.

Measured: win64 matches all 170 cases exactly; win32 takes the MMX path in **76**
of them and differs in **26** — with the 24bpp RGB and BGR results coming back
*swapped*. So gfxlib2 disagrees with **itself** across the two targets, the same
way it does for CIRCLE arcs and PMAP under x87 excess precision.

tiko rejects inline asm by policy (`TKO0407`) and `obj/win64` ships no `*_mmx.o`
at all, so there is no MMX path to match. Those 26 are counted as a **known
target divergence**, exactly as the win32 PMAP results are — and every case
*outside* the MMX condition must still match win32 exactly, which is what stops
this becoming a blanket excuse. The suite also **fails** if no case ever takes
the MMX path, so the exemption cannot go stale and silently cover everything.

## The pointer

`driver/mouse.bi` -- **65 checks**, by moving the **real cursor** with
`SetCursorPos` and reading it back through both implementations.

The two sides cannot run at once — only one window can be under the pointer — so
they are driven **sequentially over the identical protocol** and the recorded
sequences compared. Client-relative coordinates are what make that legitimate:
where each window sits on the desktop cancels out.

**`GETMOUSE` is a cache, not a query.** It reports what the window procedure
stored the last time a message arrived; it never calls `GetCursorPos` itself. An
implementation that queries live looks identical in a slow interactive test and
diverges under automation — which is exactly where it gets used. That mutation
fails 12 of 65.

Three more details, each with a mutation that catches it:

- **Coordinates are the *unsigned* low words of `lParam`.** Windows' own
  `GET_X_LPARAM` sign-extends, because a captured drag reports negative
  coordinates once the pointer leaves to the left or above; the reference does
  not, so those become ~65535. Sign-extending fails 1 check.
- **The wheel is a running total**, not a per-read delta — it is only reset when
  the mode is set. Treating it as a delta fails 2.
- **Failure writes `-1` to every output**, and means the window is inactive *or*
  the pointer is outside it.

### The bug this found in our own window

Our side first reported *success* from outside the window. Once the pointer
leaves, **no message arrives**, so the cached "is the cursor inside" flag kept
its last value — the reference gets a `WM_MOUSELEAVE` because it arms
`TrackMouseEvent`, and we did not. Measured: ours answered `(0,199)` and "ok"
where the reference answered `-1`. Arming it (and re-arming after each leave,
since the notification is one-shot) fixed it, and removing it again fails 6.

### What is deliberately not covered

Buttons and the wheel would need synthesised input — `mouse_event` or
`SendInput` — which clicks on whatever is under the pointer and can act on
unrelated windows. That is a real risk to the desktop, so it is left to the
author's interactive pass and **stated** rather than faked with a stub that
passes. The button and wheel *state machine* is still verified from synthetic
messages, which costs nothing and catches the bit twiddling.

The suite also asserts the reference produced **both** outcomes — at least one
point inside and one outside — so a run where every point failed cannot satisfy
the comparison by accident.

### That assertion earned its place on the first suite run

Run by hand the test passed; run *inside* the suite it failed 37 of 65, and the
discrimination check named the cause: `reference saw at least one point INSIDE`.
The reference's window never became **active**, so `GETMOUSE` failed at every
point. Windows refuses a bare `SetForegroundWindow` from a process that is not
already in the foreground.

Both windows are now forced foreground through the documented
`AttachThreadInput` route, and the result is **waited for and checked** rather
than assumed. If focus never arrives the suite fails with a message naming the
cause — treating "could not focus" as a skip would turn an environment problem
into a green run.

### And focus was still not enough

Even with focus confirmed, the suite failed on **one configuration in roughly one
run in four** — 19 of 65 checks, all of them the reference reporting `-1` while
ours reported a position. Focus arriving is not the same as `GETMOUSE` working:
the driver only marks the window active once its pump has processed
`WM_ACTIVATE`, and it only recomputes "pointer inside" when a message arrives. A
fixed sleep is a guess, and the guess was wrong often enough to matter.

Two fixes, both replacing an assumption with a check:

- **Poll the reference at a mid-client point until it answers**, then start
  comparing. If it never answers, fail saying so rather than comparing against a
  window that is not yet live.
- **Verify every `SetCursorPos`.** It can be clamped to the visible desktop or
  refused, and a move that did not happen generates no `WM_MOUSEMOVE` — so the
  window keeps reporting the *previous* position and the comparison drifts
  silently. The cursor position is read back and the move retried.

## The keyboard

`core/keyboard.bi` -- **113 checks**, a real A/B: `fb_hPostKey` is exported and
is exactly what the driver calls when a key arrives, so keys go into gfxlib2's
own ring and ours in lockstep.

**Nothing here injects keystrokes, and that is deliberate.** `SendInput` and
`keybd_event` deliver to whatever window has focus — and focus moves, because
these suites open and close windows — so injected keys would land in whatever
the author has open. Posting to the library's own buffer exercises the same code
path the driver drives without ever touching the desktop.

### Two mechanisms that answer different questions

| | what it is | who reads it |
| --- | --- | --- |
| the **key ring** | 16 entries of key *codes*, in order | `INKEY`, `GETKEY`, `KEYHIT` |
| the **key table** | 128 booleans by *scancode*, refreshed wholesale each frame | `MULTIKEY` |

A key held for a second appears **once** in the ring and stays true in the table
the whole time. Neither can answer the other's question.

### INKEY's encoding is just the 16-bit value, little-endian

Measured, not assumed:

| code | result |
| --- | --- |
| ≤ 255 | one character, `chr(code)` |
| > 255 | **two** characters, low byte first |

There is no "extended key" flag. The familiar `chr(255)` prefix appears only
because extended keys are posted as `(scancode shl 8) or 255`, so the low byte —
emitted first — happens to be 255. Special-casing 255 instead of emitting the low
byte agrees on **every real extended key** and differs at 256 and 300; that
mutation fails 20 checks, big-endian fails 22, and moving the boundary from 255
to 256 fails exactly 1.

The ring drops the oldest like the event queue — 16 slots, so **15** usable,
measured by posting twenty and reading back fifteen. "Refuse when full" fails 17.

### What is not covered

**`MULTIKEY`'s live state.** The table is refreshed from `GetKeyboardState` in
the driver's frame loop, so making it report true means physically holding a key.
What *is* compared is the bounds behaviour — 0–127 from the table, anything
outside **false** rather than an error (accepting >127 fails 3) — and the
all-clear case across all 128 scancodes, which is what the reference gives when
nothing is held. Actual key-down reporting belongs to the author's interactive
pass.

---

## Build, 2026-09-05

```
build/build.sh [Debug|Release|RelWithDebInfo]      windows-x86_64 only
```

**windows-x86_64 is the only target and that is the point.** tiko emits the Microsoft ABI on Windows
(`TARGET_WINDOWS_X86_64`), and there is no MSVC `libfbgfx` to fall back to — fbc's is MinGW, so it
cannot go into an MSVC binary at all. That absence is why `lib/rt/build/gatemsvc.sh` excludes
`gfx/` and `fbc-int/gfx`, and why 22 of the 26 unresolved symbols in its first full link were
`fb_Gfx*`.

**The status line above is out of date in one direction and right in the other.** There IS graphics
code — 7,781 lines across 39 headers, compiling to **108 functions**, and the whole tree builds
clean for `x86_64-pc-windows-msvc`. What does not exist is the **entry-point layer**.

**And until it does, the archive holds no code.** Every routine here is `private`, nothing public
references them, so clang discards all 108 and `libtkogfx.a` comes out at 902 bytes carrying
`@feat.00` and `__fbctinf`. That is the structure working as designed — RFC-0001 makes the entry
points the only public surface — but it means the build proves the tree COMPILES for MSVC and
nothing more. `build.sh` says so on every run rather than reporting the IR count as if it were the
archive's.

### The surface that is owed, measured

`tiko-lang/src/mir/rtl.bi` names **32 `RTL_GFX` entry points with full signatures** — that table
IS the ABI this library owes, and it is narrower than fbc's 172 exports. `fb_GfxScreen( l, l, l, l,
l ) as l` is the one a `SCREEN` statement reaches, and it is what a graphics program fails on
today:

```
test2.exe.1.o : error LNK2019: unresolved external symbol fb_GfxScreen
```

The pieces it needs exist — `driver/window.bi`'s `WindowOpen`/`WindowClose`, `core/mode.bi`'s
`ModeTable` and `ModeSupported`, `core/surface.bi`, `core/hooks.bi`'s install/clear — so this is
integration rather than new invention. **No entry point is stubbed.** One that links and does
nothing turns a loud failure into a silent one, which is the harder bug of the two.
