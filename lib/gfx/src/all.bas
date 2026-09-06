'' all.bas -- the whole of libtkogfx, as one translation unit.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception. This file contains no graphics code of its own -- it is the include
'' list -- but RFC-0001 D13 wants the provenance on every source in the tree, and
'' a file that names the whole library is a poor place to make an exception.
''
'' THE LIBRARY IS HEADER-ONLY AND EVERY ROUTINE IN IT IS `private`. That is
'' RFC-0001's rule, not an accident: the entry-point layer is meant to be the
'' only public surface, so the internals cannot be reached around. One TU is
'' therefore the natural shape -- there is nothing to link between modules --
'' and it lets clang see the whole library at once.
''
'' THE ORDER IS abi, core, driver, raster, AND IT MATTERS. abi/ mirrors the
'' runtime's own structs and everything else reads them; driver/ presents what
'' core/ owns; raster/ draws into surfaces core/ defines. Each group's headers
'' are #include once, so a wrong order shows up as a missing type rather than a
'' subtle one.
''
'' GENERATED, by build/build.sh's sibling in tools/. Adding a .bi to the tree
'' and forgetting this file would compile nothing and report success, so the
'' list is written out rather than globbed at build time.

'' ---- abi
#include once "../abi/rtlabi.bi"
#include once "../abi/rtlctx-offsets.bi"
#include once "../abi/rtlctx.bi"
#include once "../abi/rtlseam.bi"

'' ---- core
#include once "../core/bmp.bi"
#include once "../core/bsave.bi"
#include once "../core/cells.bi"
#include once "../core/control.bi"
#include once "../core/dirty.bi"
#include once "../core/events.bi"
#include once "../core/font-data.bi"
#include once "../core/hooks.bi"
#include once "../core/image.bi"
#include once "../core/keyboard.bi"
#include once "../core/lzw.bi"
#include once "../core/mode.bi"
#include once "../core/palette-data.bi"
#include once "../core/palette.bi"
#include once "../core/surface.bi"
#include once "../core/vgaport.bi"
#include once "../core/viewport.bi"

'' ---- driver
#include once "../driver/driver.bi"
#include once "../driver/gdi.bi"
#include once "../driver/mem.bi"
#include once "../driver/mouse.bi"
#include once "../driver/window.bi"

'' ---- raster
#include once "../raster/blit.bi"
#include once "../raster/box.bi"
#include once "../raster/circle.bi"
#include once "../raster/cls.bi"
#include once "../raster/color.bi"
#include once "../raster/convert.bi"
#include once "../raster/draw.bi"
#include once "../raster/line.bi"
#include once "../raster/paint.bi"
#include once "../raster/pixel.bi"
#include once "../raster/pixelfmt.bi"
#include once "../raster/put.bi"
#include once "../raster/text.bi"

'' ---- entry  (the public surface; MUST come last -- it references the
''              privates above, and it is what pulls them into the archive)
#include once "../entry/context.bi"
#include once "../entry/screen.bi"
#include once "../entry/putblend.bi"
#include once "../entry/draw2d.bi"
#include once "../entry/palette.bi"
