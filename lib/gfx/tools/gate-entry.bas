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

screen 0

print Log_;
