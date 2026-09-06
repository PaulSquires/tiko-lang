'' gate-entry.bas -- the ENTRY LAYER, A/B'd against gfxlib2.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
'' exception).
''
'' THE SOURCE IS ROLE-NEUTRAL. There is not one #ifdef in this file and there
'' must never be one: it is compiled ONCE and LINKED TWICE -- against gfxlib2 to
'' get the reference answers, against libtkogfx to get ours. The BASIC
'' statements are identical, so what differs is only which library the names
'' fb_GfxLine, fb_GfxPset and the rest resolve to.
''
'' That is the substitution harness RFC-0001 section 6.1 wanted, reached by
'' LINKING rather than by archive surgery -- and it is the only way this seam can
'' be tested at all. Every abtest-*.bas links gfxlib2 for those same names, so
'' none of them can call one of ours; they compare INTERNALS. This compares the
'' public surface, which is where the argument decoding lives and where nothing
'' was checked before.
''
'' EACH CASE PRINTS ONE LINE, `name TAB digest`. tools/gate-entry.sh runs both
'' binaries and diffs the two streams. No recording is checked in, because none
'' is needed: both sides are built from this file on every run, so there is
'' nothing that can go stale.
''
'' THE DIGEST IS READ WITH POINT, not SCREENPTR. Reading the framebuffer
'' directly would need fb_GfxScreenPtr and fb_GfxScreenInfo32, which libtkogfx
'' does not export yet; POINT is a public entry point both libraries have, so
'' the readback is itself part of what is compared. It costs w*h calls per case,
'' which at 64x48 is nothing.
''
'' THE VIEWPORT IS RESET BEFORE EVERY DIGEST. POINT goes through the coordinate
'' transform, so a case that leaves a VIEW or WINDOW set would digest a
'' different space than the one it drew in.

#include once "fbgfx.bi"
#include once "windows.bi"
using FB

const W = 64
const H = 48

'' FNV-1a over the whole screen, through POINT.
function Digest( ) as ulongint
    view
    window
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to H - 1
        for x as integer = 0 to W - 1
            acc = (acc xor cast( ulong, point( x, y ) )) * 1099511628211ull
        next
    next
    return acc
end function

'' REPORTING IS BUFFERED UNTIL AFTER SCREEN 0, and that asymmetry is the point
'' rather than a nuisance: gfxlib2 INSTALLS CONSOLE HOOKS, so PRINT on a
'' graphics screen is drawn into the framebuffer and never reaches stdout. This
'' library does not install them yet, so its PRINT goes to the console. A
'' report printed while the screen is open therefore comes out on ONE side only
'' -- measured here as the reference emitting zero lines against the subject's
'' 43.
dim shared as string Log_

sub Emit( byref what as string, byval dig as ulongint )
    Log_ += hex( dig, 16 ) + chr( 9 ) + what + chr( 10 )
end sub

sub Report( byref what as string )
    Emit( what, Digest( ) )
end sub

'' A known ground state before every case, so a case cannot inherit the previous
'' one's pixels. CLS is not used: it is a runtime entry point rather than a
'' graphics one and is not part of what this file tests.
sub Blank( )
    view
    window
    line ( 0, 0 )-( W - 1, H - 1 ), 0, BF
end sub

screenres W, H, 32

'' ---- PSET and PRESET, including STEP ----
Blank( ) : pset ( 10, 10 ), &h334455 : Report( "pset" )
Blank( ) : pset ( 10, 10 ), &h334455 : pset step( 5, 5 ), &h667788 : Report( "pset step" )
Blank( ) : pset ( 10, 10 ), &h334455 : preset ( 10, 10 ) : Report( "preset over pset" )
Blank( ) : pset ( -5, -5 ), &h334455 : Report( "pset clipped negative" )
Blank( ) : pset ( W + 5, 3 ), &h334455 : Report( "pset clipped right" )

'' ---- LINE: the three box forms, STEP, and the relative first point ----
Blank( ) : line ( 2, 3 )-( 40, 30 ), &h112233 : Report( "line plain" )
Blank( ) : line ( 2, 3 )-( 40, 30 ), &h112233, B : Report( "line B" )
Blank( ) : line ( 2, 3 )-( 40, 30 ), &h112233, BF : Report( "line BF" )
Blank( ) : line ( 5, 5 )-step( 20, 10 ), &h445566 : Report( "line second point step" )
Blank( ) : pset ( 8, 8 ), &h010101 : line -( 30, 30 ), &h778899 : Report( "line from last point" )
Blank( ) : line ( -10, -10 )-( 80, 60 ), &hAABBCC : Report( "line clipped both ends" )
Blank( ) : line ( 40, 30 )-( 2, 3 ), &h112233 : Report( "line reversed" )

'' ---- CIRCLE: radius, aspect, arcs, fill ----
Blank( ) : circle ( 32, 24 ), 10, &h20C0FF : Report( "circle" )
Blank( ) : circle ( 32, 24 ), 10, &h20C0FF, , , , F : Report( "circle filled" )
Blank( ) : circle ( 32, 24 ), 15, &h20C0FF, , , 0.5 : Report( "circle aspect 0.5" )
Blank( ) : circle ( 32, 24 ), 15, &h20C0FF, , , 2.0 : Report( "circle aspect 2.0" )
Blank( ) : circle ( 32, 24 ), 18, &h20C0FF, 0.0, 1.57 : Report( "circle arc" )
Blank( ) : circle step( 0, 0 ), 8, &h20C0FF : Report( "circle step from origin" )

'' ---- PAINT ----
Blank( ) : line ( 8, 8 )-( 40, 30 ), &h00FF00, B : paint ( 20, 20 ), &hFF0000, &h00FF00 : Report( "paint inside a box" )
Blank( ) : line ( 8, 8 )-( 40, 30 ), &h00FF00, B : paint ( 2, 2 ), &hFF0000, &h00FF00 : Report( "paint outside a box" )

'' ---- POINT's own answers, folded into a digest so one line covers them ----
scope
    Blank( )
    pset ( 11, 12 ), &h123456
    dim as ulongint acc = 14695981039346656037ull
    acc = (acc xor cast( ulong, point( 11, 12 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( 0, 0 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( W - 1, H - 1 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( -1, 0 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( 0, H ) )) * 1099511628211ull
    Emit( "point returns", acc )
end scope

'' ---- VIEW and WINDOW: what they do to where a pixel LANDS ----
Blank( ) : view ( 10, 8 )-( 50, 40 ) : pset ( 0, 0 ), &hFF00FF : Report( "view then pset at its origin" )
Blank( ) : view ( 10, 8 )-( 50, 40 ) : line ( 0, 0 )-( 100, 100 ), &hFF00FF : Report( "view clips a line" )
Blank( ) : view screen ( 10, 8 )-( 50, 40 ) : pset ( 12, 10 ), &hFF00FF : Report( "view screen is absolute" )
Blank( ) : view ( 10, 8 )-( 50, 40 ) : window ( 0, 0 )-( 10, 10 ) : line ( 0, 0 )-( 10, 10 ), &hFF00FF : Report( "window maps the diagonal" )
Blank( ) : window ( -1, -1 )-( 1, 1 ) : pset ( 0, 0 ), &hFF00FF : Report( "window centred on the origin" )

'' ---- PMAP, folded the same way ----
scope
    view ( 10, 8 )-( 50, 40 )
    window ( -1, -1 )-( 1, 1 )
    dim as ulongint acc = 14695981039346656037ull
    for f as integer = 0 to 3
        for k as integer = -2 to 2
            dim as single v = pmap( k * 0.5, f )
            acc = (acc xor cast( ulongint, *cptr( ulong ptr, @v ) )) * 1099511628211ull
        next
    next
    view
    window
    Emit( "pmap", acc )
end scope

'' ---- IMAGECREATE, PUT and GET ----
scope
    dim as any ptr im = imagecreate( 12, 9, &h010203 )
    Blank( ) : put ( 20, 15 ), im, PSET : Report( "put PSET" )
    Blank( ) : put ( 20, 15 ), im, XOR : Report( "put XOR" )
    Blank( ) : put ( 20, 15 ), im, OR : Report( "put OR" )
    Blank( ) : put ( 20, 15 ), im, AND : Report( "put AND" )
    Blank( ) : put ( 20, 15 ), im, TRANS : Report( "put TRANS" )
    Blank( ) : put ( -4, -3 ), im, PSET : Report( "put clipped top-left" )
    Blank( ) : put ( W - 4, H - 3 ), im, PSET : Report( "put clipped bottom-right" )
    Blank( ) : put ( 20, 15 ), im, PSET : put step( 5, 5 ), im, PSET : Report( "put step" )
    imagedestroy( im )
end scope

scope
    dim as ubyte g(0 to 8191)
    Blank( )
    line ( 5, 5 )-( 20, 18 ), &h5588BB, BF
    line ( 8, 8 )-( 12, 12 ), &hBB8855, BF
    get ( 5, 5 )-( 20, 18 ), g(0)
    Blank( )
    put ( 30, 20 ), g(0), PSET
    Report( "get into a buffer then put it back" )
end scope

'' ---- IMAGECREATE's own pixels, read through an image target ----
scope
    dim as any ptr im = imagecreate( 6, 5, &h778899 )
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to 4
        for x as integer = 0 to 5
            acc = (acc xor cast( ulong, point( x, y, im ) )) * 1099511628211ull
        next
    next
    pset im, ( 2, 2 ), &h112233
    line im, ( 0, 0 )-( 5, 4 ), &h445566
    for y as integer = 0 to 4
        for x as integer = 0 to 5
            acc = (acc xor cast( ulong, point( x, y, im ) )) * 1099511628211ull
        next
    next
    imagedestroy( im )
    Emit( "drawing into an image target", acc )
end scope

'' ---- DRAW, including the state that persists between calls ----
Blank( ) : draw "C" & str( &hFF8040 ) & "BM20,20R10D10L10U10" : Report( "draw a box" )
Blank( ) : draw "C" & str( &hFF8040 ) & "BM20,20S8R10" : Report( "draw scaled" )
Blank( ) : draw "C" & str( &hFF8040 ) & "BM20,20TA45R15" : Report( "draw rotated" )
Blank( ) : draw "C" & str( &hFF8040 ) & "BM10,10S8" : draw "R10" : Report( "draw scale persists across calls" )

'' ---- DRAW STRING ----
Blank( ) : draw string ( 4, 16 ), "Ag~", &hFFFFFF : Report( "draw string" )
Blank( ) : draw string ( 4, 16 ), "Ag~", &hFFFFFF, , PSET : Report( "draw string PSET" )

'' ---------------------------------------------------------------- 8bpp
''
'' PALETTE IS COMPARED THROUGH THE VALUES IT RETURNS, NOT THROUGH PIXELS, and
'' the reason is a real limit rather than a shortcut.
''
'' libtkogfx's framebuffer is 32bpp whatever the mode says (RFC-0011 section 1).
'' On SCREEN 13 gfxlib2's POINT therefore answers a palette INDEX and ours
'' answers a 32-bit colour, so a framebuffer digest would differ on every case
'' for a reason that has nothing to do with PALETTE. Comparing pixels at 8bpp
'' needs an 8bpp framebuffer AND per-depth LINE, BOX, CIRCLE, PAINT, DRAW and
'' CLS, none of which exist -- raster/ is 32bpp above the pixel level.
''
'' What PALETTE actually promises is observable without any of that: PALETTE GET
'' and PALETTE GET USING read the table back, and those are entry points on both
'' sides. So this section drives all seven and digests their ANSWERS.
''
'' It covers the TABLE, not paletted rendering. Nothing here proves a pixel is
'' displayed in the right colour.
screen 13

'' ---- the mode's generated defaults, whole ----
''
'' One digest over every entry rather than one case per entry: 256 cases would
'' say nothing more, and a digest over the lot catches a single wrong entry just
'' as surely.
scope
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to 255
        dim as long r, g, b
        palette get i, r, g, b
        acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
    next
    Emit( "palette defaults, all 256 entries", acc )
end scope

'' ---- the packed one-argument GET, which is a different code path ----
scope
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to 255
        dim as long v
        palette get i, v
        acc = (acc xor cast( ulongint, cast( ulong, v ) )) * 1099511628211ull
    next
    Emit( "palette get packed, all 256", acc )
end scope

'' ---- SET, four-argument form, then read back ----
''
'' The values include both saturation ends and the midpoint, because the 6-bit
'' scale is (v * 255) \ 63 and a `shl 2` implementation round-trips
'' identically through GET -- only the stored RGB tells them apart.
scope
    dim as long rs(...) = { 0, 63, 255, 1, 2, 3, 128, 170, 85, 254, 7, 200 }
    dim as long gs(...) = { 0, 255, 63, 2, 3, 1, 64, 85, 170, 253, 8, 100 }
    dim as long bs(...) = { 0, 128, 31, 3, 1, 2, 32, 51, 204, 252, 9, 50 }
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to ubound( rs )
        palette i, rs(i), gs(i), bs(i)
        dim as long r, g, b
        palette get i, r, g, b
        acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
    next
    Emit( "palette set rgb then get", acc )
end scope

'' ---- SET, two-argument packed form ----
''
'' `PALETTE i, value` and `PALETTE i, r, g, b` reach the SAME entry point; the
'' second is told apart by -1 in g and b. On a 256-colour mode the value is
'' three 6-bit channels.
scope
    dim as long c6(0 to 6) = { 0, 1, 2, 31, 32, 62, 63 }
    dim as ulongint acc = 14695981039346656037ull
    for k as integer = 0 to 23
        dim as long v = c6(k mod 7) or (c6((k + 2) mod 7) shl 8) or (c6((k + 4) mod 7) shl 16)
        palette k, v
        dim as long r, g, b
        palette get k, r, g, b
        acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
    next
    Emit( "palette set packed then get", acc )
end scope

'' ---- out-of-range indices are MASKED, not errors ----
scope
    dim as long probes(...) = { 256, 257, 300, 511, 512, 1000, -1, -256 }
    dim as ulongint acc = 14695981039346656037ull
    for k as integer = 0 to ubound( probes )
        palette probes(k), 11, 22, 33
        dim as long r, g, b
        palette get probes(k), r, g, b
        acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
    next
    Emit( "palette wrapped indices", acc )
end scope

'' ---- USING and GET USING, both element widths ----
''
'' `dim as long` reaches fb_GfxPaletteUsing and `dim as integer` reaches
'' fb_GfxPaletteUsing64 -- a DIFFERENT SYMBOL, because integer is 64-bit on
'' win64 and fbc does not convert at the call site. Both are driven here, which
'' is the only thing that tells the two apart.
scope
    dim as long a(0 to 255)
    for i as integer = 0 to 255
        a(i) = (i and 63) or (((63 - (i and 63))) shl 8) or (((i * 5) and 63) shl 16)
    next
    palette using a(0)

    dim as long back(0 to 255)
    palette get using back(0)
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to 255
        acc = (acc xor cast( ulongint, cast( ulong, back(i) ) )) * 1099511628211ull
    next
    Emit( "palette using long, then get using", acc )
end scope

scope
    dim as integer b(0 to 255)
    for i as integer = 0 to 255
        b(i) = ((i * 3) and 63) or (((i * 7) and 63) shl 8) or (((i * 11) and 63) shl 16)
    next
    palette using b(0)

    dim as integer back(0 to 255)
    palette get using back(0)
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to 255
        acc = (acc xor cast( ulongint, back(i) )) * 1099511628211ull
    next
    Emit( "palette using integer, then get using", acc )
end scope

'' ---- a bare PALETTE restores the mode's defaults ----
''
'' Everything above has scribbled on the table, so this both tests the restore
'' and returns the state to the one the defaults case already digested -- the
'' two lines must therefore agree, which is a check in itself.
scope
    palette
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to 255
        dim as long r, g, b
        palette get i, r, g, b
        acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
    next
    Emit( "palette restored to defaults", acc )
end scope

'' ---- the other legacy palette sizes ----
''
'' 16 and 4 colours, where the table is shorter and the wrap is tighter. Mode 9
'' is 16-colour EGA, mode 1 is 4-colour CGA.
scope
    dim as long modes(...) = { 9, 1, 11, 18 }
    for mi as integer = 0 to ubound( modes )
        screen modes(mi)
        dim as ulongint acc = 14695981039346656037ull
        for i as integer = 0 to 255
            dim as long r, g, b
            palette get i, r, g, b
            acc = (acc xor cast( ulongint, (r shl 16) or (g shl 8) or b )) * 1099511628211ull
        next
        Emit( "palette defaults, mode" + str( modes(mi) ), acc )
    next
end scope

'' ---------------------------------------------- 8bpp, PIXEL BY PIXEL
''
'' NOW COMPARABLE, and it was not before. libtkogfx's framebuffer used to be
'' 32bpp whatever the mode said, so on a paletted screen gfxlib2's POINT
'' answered an INDEX and ours a 32-bit colour and nothing here could be
'' compared. The framebuffer follows the mode now, so both sides answer an
'' index and the same digest works.
''
'' This is what gates the 8bpp instances of the five templated rasterizers.
'' Until this section existed they compiled and nothing called them.
''
'' Colours are INDICES here, not RGB. 15 on 0 is what SCREENRES opens with.
screenres W, H, 8

Blank( ) : pset ( 10, 10 ), 9 : Report( "8bpp pset" )
Blank( ) : pset ( 10, 10 ), 9 : pset step( 5, 5 ), 12 : Report( "8bpp pset step" )
Blank( ) : pset ( 10, 10 ), 9 : preset ( 10, 10 ) : Report( "8bpp preset over pset" )
Blank( ) : pset ( -5, -5 ), 9 : Report( "8bpp pset clipped negative" )

Blank( ) : line ( 2, 3 )-( 40, 30 ), 4 : Report( "8bpp line plain" )
Blank( ) : line ( 2, 3 )-( 40, 30 ), 4, B : Report( "8bpp line B" )
Blank( ) : line ( 2, 3 )-( 40, 30 ), 4, BF : Report( "8bpp line BF" )
Blank( ) : line ( 5, 5 )-step( 20, 10 ), 7 : Report( "8bpp line step" )
Blank( ) : line ( -10, -10 )-( 80, 60 ), 7 : Report( "8bpp line clipped both ends" )
Blank( ) : line ( 3, 20 )-( 60, 22 ), 11 : Report( "8bpp line shallow" )
Blank( ) : line ( 20, 2 )-( 24, 44 ), 11 : Report( "8bpp line steep" )

Blank( ) : circle ( 32, 24 ), 10, 13 : Report( "8bpp circle" )
Blank( ) : circle ( 32, 24 ), 10, 13, , , , F : Report( "8bpp circle filled" )
Blank( ) : circle ( 32, 24 ), 15, 13, , , 0.5 : Report( "8bpp circle aspect" )
Blank( ) : circle ( 32, 24 ), 18, 13, 0.0, 1.57 : Report( "8bpp circle arc" )

Blank( ) : line ( 8, 8 )-( 40, 30 ), 2, B : paint ( 20, 20 ), 5, 2 : Report( "8bpp paint inside" )
Blank( ) : line ( 8, 8 )-( 40, 30 ), 2, B : paint ( 2, 2 ), 5, 2 : Report( "8bpp paint outside" )

Blank( ) : view ( 10, 8 )-( 50, 40 ) : pset ( 0, 0 ), 6 : Report( "8bpp view origin" )
Blank( ) : view ( 10, 8 )-( 50, 40 ) : line ( 0, 0 )-( 100, 100 ), 6 : Report( "8bpp view clips" )

Blank( ) : draw "C10BM20,20R10D10L10U10" : Report( "8bpp draw a box" )
Blank( ) : draw "C10BM20,20S8R10" : Report( "8bpp draw scaled" )

Blank( ) : draw string ( 4, 16 ), "Ag~", 14 : Report( "8bpp draw string" )

'' ---- images at 8bpp, and GET/PUT through them ----
scope
    dim as any ptr im = imagecreate( 12, 9, 3 )
    Blank( ) : put ( 20, 15 ), im, PSET : Report( "8bpp put PSET" )
    Blank( ) : put ( 20, 15 ), im, XOR : Report( "8bpp put XOR" )
    Blank( ) : put ( 20, 15 ), im, TRANS : Report( "8bpp put TRANS" )
    Blank( ) : put ( -4, -3 ), im, PSET : Report( "8bpp put clipped" )
    imagedestroy( im )
end scope

scope
    dim as ubyte g(0 to 8191)
    Blank( )
    line ( 5, 5 )-( 20, 18 ), 8, BF
    line ( 8, 8 )-( 12, 12 ), 1, BF
    get ( 5, 5 )-( 20, 18 ), g(0)
    Blank( )
    put ( 30, 20 ), g(0), PSET
    Report( "8bpp get then put round trip" )
end scope

'' ---- POINT's own answers at 8bpp ----
scope
    Blank( )
    pset ( 11, 12 ), 9
    dim as ulongint acc = 14695981039346656037ull
    acc = (acc xor cast( ulong, point( 11, 12 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( 0, 0 ) )) * 1099511628211ull
    acc = (acc xor cast( ulong, point( -1, 0 ) )) * 1099511628211ull
    Emit( "8bpp point returns", acc )
end scope

'' ------------------------------------ 8bpp PRESENTATION, off the real window
''
'' THE LAST UNGATED PIECE, and the only one that leaves the framebuffer.
'' Everything above compares what was WRITTEN; this compares what is DISPLAYED.
''
'' It matters because the two libraries present a paletted surface completely
'' differently. gfxlib2 hands GDI an 8bpp DIB with a 256-entry RGBQUAD colour
'' table. libtkogfx expands into a 32bpp mirror through a lookup table first
'' (GdiExpand8), because BITMAPINFO here has no room for the table. Those are
'' different code paths that must put the same colour on the glass, and nothing
'' compared them until this section.
''
'' READBACK IS FRAGILE BY NATURE -- probe-window says so at length. BitBlt from
'' a window DC captures whatever is actually on screen, so an occluding window,
'' a screen blank or DWM deciding not to redraw all produce a blank grab. So the
'' capture is RETRIED, and if it never yields a non-blank frame the case emits
'' CAPTURE-FAILED rather than a digest. gate-entry.sh treats that as a SKIP on
'' either side, which is the difference between an honest gap and a flaky gate.
scope
    screenres W, H, 8

    '' A palette where every index maps somewhere distinctive, so an expansion
    '' that dropped a channel or swapped R and B cannot come out equal. The
    '' default VGA table has too many greys near the bottom to discriminate.
    for i as integer = 0 to 255
        palette i, (i * 7) and 63, (i * 13) and 63, (i * 29) and 63
    next

    '' Something with structure. Flat fills would agree under a broken LUT as
    '' long as index 0 happened to match.
    line ( 0, 0 )-( W - 1, H - 1 ), 0, BF
    for y as integer = 0 to H - 1
        line ( 0, y )-( W - 1, y ), (y * 5 + 3) and &hFF
    next
    line ( 8, 8 )-( 40, 30 ), 200, B
    circle ( 32, 24 ), 9, 100, , , , F

    dim as long winh
    screencontrol GET_WINDOW_HANDLE, winh
    dim as HWND hw = cast( HWND, cast( any ptr, cast( uinteger, winh ) ) )

    if hw = 0 then
        Log_ += "CAPTURE-FAILED" + chr( 9 ) + "8bpp presentation" + chr( 10 )
    else
        SetWindowPos( hw, HWND_TOPMOST, 0, 0, 0, 0, _
                      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE )

        dim as ulongint dig = 0
        dim as long got = 0
        dim as long isblank = 1

        for attempt as integer = 1 to 40
            Sleep( 60 )

            dim as HDC src = GetDC( hw )
            if src <> 0 then
                dim as HDC mem = CreateCompatibleDC( src )
                if mem <> 0 then
                    dim as BITMAPINFO bmi
                    bmi.bmiHeader.biSize        = sizeof( BITMAPINFOHEADER )
                    bmi.bmiHeader.biWidth       = W
                    bmi.bmiHeader.biHeight      = -H       '' top-down
                    bmi.bmiHeader.biPlanes      = 1
                    bmi.bmiHeader.biBitCount    = 32
                    bmi.bmiHeader.biCompression = BI_RGB

                    dim as any ptr bits
                    dim as HBITMAP dib = CreateDIBSection( src, @bmi, DIB_RGB_COLORS, _
                                                           @bits, NULL, 0 )
                    if (dib <> 0) andalso (bits <> 0) then
                        dim as HGDIOBJ old_ = SelectObject( mem, dib )
                        if BitBlt( mem, 0, 0, W, H, src, 0, 0, SRCCOPY ) <> 0 then
                            '' FNV-1a over the visible pixels, ALPHA MASKED OFF:
                            '' GDI does not carry it through a BitBlt and the two
                            '' sides have no reason to agree on what it leaves.
                            dim as ulongint acc = 14695981039346656037ull
                            dim as long nonzero = 0
                            for y as integer = 0 to H - 1
                                dim as ulong ptr row = cptr( ulong ptr, _
                                    cptr( ubyte ptr, bits ) + y * (W * 4) )
                                for x as integer = 0 to W - 1
                                    dim as ulong c = row[x] and &hFFFFFF
                                    if c <> 0 then nonzero += 1
                                    acc = (acc xor c) * 1099511628211ull
                                next
                            next
                            '' THE DIGEST IS TAKEN EVEN IF THE FRAME IS BLACK,
                            '' and that distinction is the whole value of the
                            '' case. BitBlt succeeding means the CAPTURE worked;
                            '' what it captured is then a result, and a black
                            '' window where the reference has a picture is a
                            '' failure to report, not a frame to wait for.
                            ''
                            '' Treating black as "not captured yet" was the
                            '' first shape of this and it made the case
                            '' worthless: dropping the palette LUT rebuild --
                            '' which blanks the window completely -- came out as
                            '' a SKIP and the gate still passed. Measured.
                            ''
                            '' The retry stays, so a frame the compositor has
                            '' not drawn yet is given time; `blank` only decides
                            '' whether to keep waiting, never whether to report.
                            dig = acc
                            got = 1
                            if nonzero > 0 then isblank = 0
                        end if
                        SelectObject( mem, old_ )
                        DeleteObject( dib )
                    end if
                    DeleteDC( mem )
                end if
                ReleaseDC( hw, src )
            end if

            '' Keep retrying only while the frame is blank AND we have time;
            '' a non-blank frame is final.
            if got andalso (isblank = 0) then exit for
        next

        if got then
            Emit( "8bpp presentation", dig )
        else
            Log_ += "CAPTURE-FAILED" + chr( 9 ) + "8bpp presentation" + chr( 10 )
        end if
    end if
end scope

'' ------------------------------------------------ the CONSOLE HOOKS
''
'' PRINT ON A GRAPHICS SCREEN GOES TO THE FRAMEBUFFER, not to stdout, because
'' both libraries install a hook table when a screen opens. That is exactly why
'' this file buffers its report and prints after SCREEN 0 -- and it is what
'' makes these cases possible: the glyphs PRINT draws are ordinary pixels, so
'' the same POINT digest compares them.
''
'' THE OUTPUT OF THESE CASES IS THE SCREEN, NOT THE LOG. Nothing printed below
'' reaches the report; it is drawn, digested, and overwritten by the next case.
''
'' 64x48 with the 8x8 font is 8 columns by 6 rows, which is small on purpose:
'' wrapping and scrolling are two lines of text away rather than forty.
screenres W, H, 32

Blank( ) : locate 1, 1 : print "Hi"; : Report( "print a string" )
Blank( ) : locate 3, 2 : print "Ab"; : Report( "print after locate" )
Blank( ) : locate 1, 1 : print "AB" : print "CD"; : Report( "print with newline" )
Blank( ) : locate 1, 1 : print "ABCDEFGHIJ"; : Report( "print wraps at the margin" )
Blank( ) : locate 1, 1 : print "A" & chr(9) & "B"; : Report( "print with a tab" )
Blank( ) : locate 1, 1 : print "AB" & chr(8) & "C"; : Report( "print with a backspace" )
Blank( ) : locate 1, 1 : print "AB" & chr(13) & "C"; : Report( "print with a carriage return" )
Blank( ) : locate 2, 1 : print "A", "B"; : Report( "print with a comma pad" )

'' Scrolling: six rows exist, so eight lines forces two scrolls.
scope
    Blank( )
    locate 1, 1
    for i as integer = 1 to 8
        print chr( asc( "A" ) + i - 1 )
    next
    Report( "print scrolls the screen" )
end scope

'' COLOR must reach the text attributes, not just the drawing state.
Blank( ) : color 2, 5 : locate 2, 2 : print "Xy"; : Report( "print after color" )
Blank( ) : color 15, 0 : locate 1, 1 : print "Z"; : Report( "print after color reset" )

'' CLS on a graphics screen: 0 and 1 clear pixels, 2 clears the text view.
Blank( ) : locate 1, 1 : print "AAAA"; : cls : Report( "cls after print" )
Blank( ) : locate 1, 1 : print "AAAA"; : cls 2 : Report( "cls 2 clears the text" )

'' ---- THE TEXT CARET, which is a PRINT and therefore comparable ----
''
'' The caret a graphics screen shows is not an overlay drawn by the input loop:
'' it is a one-byte PRINT of chr(255), which the console-write path draws as a
'' row of foreground across the bottom of the cell instead of as the glyph for
'' 255. That makes the shape ordinary output, and ordinary output is A/B'd.
''
'' THE TEST IS PER WRITE, NOT PER PRINT, which these cases are what established:
'' the console layer gathers printable characters into a run, flushes it whenever
'' the cursor has to move, and splits it again at the right border, so the same
'' PRINT can be a glyph or a caret depending on where the pieces fall. Three of
'' these failed against a buffer-length rule, which is how that was learnt.
Blank( ) : locate 2, 2 : print chr( 255 ); : Report( "a lone chr(255) is a caret" )
Blank( ) : locate 2, 2 : print "A" + chr( 255 ); : Report( "chr(255) in a longer buffer is a glyph" )
Blank( ) : locate 2, 2 : print chr( 255 ) + chr( 255 ); : Report( "two carets are two glyphs" )

'' The caret takes the CURRENT foreground, and is drawn on top of whatever the
'' cell already had rather than clearing it -- the second case is what shows the
'' difference between drawing one row of pixels and repainting the cell.
Blank( ) : color 4, 1 : locate 2, 2 : print chr( 255 ); : Report( "the caret takes the colour" )
Blank( ) : locate 2, 2 : print "W"; : locate 2, 2 : print chr( 255 ); : Report( "a caret over a glyph" )

'' AND THE CELL STILL SAYS 255. Only the pixels are special-cased: the character
'' goes into the plane and the cursor advances, which is what SCREEN(r,c), POS
'' and CSRLIN report. Folded into one digest.
scope
    Blank( )
    dim as ulongint acc = 14695981039346656037ull
    locate 2, 2
    print chr( 255 );
    acc = (acc xor cast( ulongint, screen( 2, 2, 0 ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    Emit( "a caret is still a character cell", acc )
end scope

'' AT THE LAST COLUMN, where the console is 8 wide. "A" + chr(255) starting in
'' column 8 is one buffer of two but TWO WRITES OF ONE, so the second is a caret.
'' This is the case that answered it.
Blank( ) : locate 2, 8 : print chr( 255 ); : Report( "a caret in the last column" )
Blank( ) : locate 2, 8 : print "A" + chr( 255 ); : Report( "a caret that wraps with its buffer" )

'' A CONTROL CHARACTER ENDS THE RUN, which can leave a 255 alone that was not
'' written alone. Both orders, because the flush happens before the move in one
'' and after it in the other.
Blank( ) : locate 2, 2 : print chr( 13 ) + chr( 255 ); : Report( "a caret after a carriage return" )
Blank( ) : locate 2, 2 : print chr( 255 ) + chr( 13 ); : Report( "a caret before a carriage return" )
Blank( ) : locate 2, 3 : print chr( 8 ) + chr( 255 ); : Report( "a caret after a backspace" )
Blank( ) : locate 2, 1 : print chr( 9 ) + chr( 255 ); : Report( "a caret after a tab" )

'' ---- VIEW PRINT: the text region, and what it protects ----
''
'' THIS ONE IS A REAL A/B. VIEW PRINT is output only -- no keystroke has to be
'' injected -- so unlike the rest of the console INPUT half it can be compared
'' against gfxlib2 the same way every other case here is.
''
'' The console is 8 columns by 6 rows. Filling every row and then scrolling a
'' region in the middle is what shows the region is honoured: the rows outside
'' it must be untouched, and an implementation that scrolled the whole screen
'' would move them.
scope
    Blank( )
    locate 1, 1
    for r as integer = 1 to 6
        locate r, 1
        print chr( asc( "A" ) + r - 1 ); chr( asc( "A" ) + r - 1 );
    next
    view print 2 to 4
    locate 4, 1
    print "P" : print "Q";
    Report( "view print scrolls only its region" )
end scope

scope
    Blank( )
    locate 1, 1
    for r as integer = 1 to 6
        locate r, 1
        print chr( asc( "A" ) + r - 1 ); chr( asc( "A" ) + r - 1 );
    next
    view print 2 to 4
    view print
    locate 6, 1
    print "P" : print "Q";
    Report( "a bare view print restores the whole screen" )
end scope

'''' A `cls 2 clears only the view` case WAS here and is deliberately gone.
''''
'''' It could not be made to discriminate. Injecting a CLS 2 that ignored the
'''' region entirely did not move it, and neither did one that cleared the
'''' PIXELS as well -- which says the hook is not on the path `cls 2` takes at
'''' all, not that the case was written badly. The `cls 2 clears the text` case
'''' above is the one that covers CLS 2, and it does discriminate: it is what
'''' caught the divergence in RFC-0011 section 9.9.
''''
'''' Shipping a case that cannot fail is worse than shipping no case: it reads
'''' as coverage and is not.


scope
    '' VIEW PRINT moves the cursor to the top of the new region, which POS and
    '' CSRLIN report. Folded with the region's own bounds so one line covers it.
    Blank( )
    dim as ulongint acc = 14695981039346656037ull
    view print 2 to 4
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    view print
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    Emit( "view print moves the cursor", acc )
end scope

'' ---- what the console REPORTS, rather than what it draws ----
''
'' POS, CSRLIN, the WIDTH pair and SCREEN(r,c) all come back through hooks of
'' their own. Folded into one digest per group so the stream stays readable.
scope
    Blank( )
    dim as ulongint acc = 14695981039346656037ull
    locate 1, 1
    print "AB";
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    locate 3, 4
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    print "C";
    acc = (acc xor cast( ulongint, pos( ) )) * 1099511628211ull
    acc = (acc xor cast( ulongint, csrlin( ) )) * 1099511628211ull
    Emit( "pos and csrlin", acc )
end scope

scope
    dim as ulongint acc = 14695981039346656037ull
    acc = (acc xor cast( ulongint, cast( ulong, width( ) ) )) * 1099511628211ull
    Emit( "width reports the text geometry", acc )
end scope

'' SCREEN(r,c) reads the CELL PLANE back -- the character at 0 and the packed
'' attribute at 1. A console that drew the glyph but did not record the cell
'' passes every pixel case above and fails this one.
scope
    Blank( )
    color 2, 5
    locate 2, 2
    print "Qz";
    dim as ulongint acc = 14695981039346656037ull
    for r as integer = 1 to 3
        for c as integer = 1 to 4
            acc = (acc xor cast( ulongint, cast( ulong, screen( r, c, 0 ) ) )) * 1099511628211ull
            acc = (acc xor cast( ulongint, cast( ulong, screen( r, c, 1 ) ) )) * 1099511628211ull
        next
    next
    color 15, 0
    Emit( "screen(r,c) reads the cells back", acc )
end scope

screen 0

print Log_;
