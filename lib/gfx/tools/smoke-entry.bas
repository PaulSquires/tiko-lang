'' smoke-entry.bas -- the ENTRY LAYER, driven the way a real program drives it.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
'' exception).
''
'' NOT AN A/B TEST, and that is the point. Every abtest-*.bas compares an
'' INTERNAL routine against gfxlib2 -- nothing there calls fb_GfxLine. This
'' does: it is compiled by fbc, linked against libtkogfx and tiko-rt's MSVC
'' archive, and it reaches the rasterizers ONLY through the public symbols,
'' which is the one thing the abtests structurally cannot do because they link
'' gfxlib2 for the same names.
''
'' So it checks a different claim. Not "our line matches theirs" -- that is what
'' the abtests are for -- but "our fb_GfxLine reaches our line at all, with the
'' arguments decoded right". It asserts pixels through POINT, because the values
'' it can assert are the ones it just wrote.
''
'' IT FOUND THE INVERTED WindowOpen TEST ON ITS FIRST RUN. WindowOpen returns 1
'' on success; entry/screen.bi tested it for non-zero and treated success as
'' failure, so SCREEN had NEVER opened a screen and every drawing call answered
'' -1. Nothing else in the project could have caught it: the abtests never call
'' an entry point, and the archive linked and exported all 39 symbols happily.
''
'' Run by tools/smoke.sh.

#include once "fbgfx.bi"
using FB

dim shared as long fails

'' FAILURES ARE BUFFERED UNTIL AFTER SCREEN 0, and this is not cosmetic. Once
'' the console hooks are installed PRINT on a graphics screen draws into the
'' FRAMEBUFFER, so a failure reported mid-run is written to a window nobody
'' reads and the program exits non-zero with no message. This test only ever
'' printed on failure, so it passed either way and the trap stayed invisible.
dim shared as string Log_

sub chk( byref what as string, byval want as long, byval got as long )
    if want <> got then
        Log_ += "  FAIL " + what + " -- want " + str( want ) + " got " + str( got ) + chr( 10 )
        fails += 1
    end if
end sub

screenres 64, 48, 32

'' ---- the screen target ----
chk( "point on a fresh screen", 0, point( 5, 5 ) )
pset ( 5, 5 ), &hFF3366
chk( "pset then point", &hFF3366, point( 5, 5 ) )

line ( 0, 0 )-( 10, 0 ), &h112233
chk( "line", &h112233, point( 7, 0 ) )

line ( 20, 20 )-( 30, 30 ), &h445566, BF
chk( "line BF", &h445566, point( 25, 25 ) )

circle ( 40, 20 ), 6, &h778899
chk( "circle", &h778899, point( 46, 20 ) )

'' ---- an image target ----
''
'' Exercises the OTHER half of ContextFor: a target that is not the screen, and
'' therefore the per-image context cache.
dim as any ptr im = imagecreate( 8, 8, &h010203 )
chk( "imagecreate fill", &h010203, point( 3, 3, im ) )
pset im, ( 1, 1 ), &h0A0B0C
chk( "pset into an image", &h0A0B0C, point( 1, 1, im ) )

put ( 50, 30 ), im, PSET
chk( "put PSET", &h010203, point( 53, 33 ) )
chk( "put carried the drawn pixel", &h0A0B0C, point( 51, 31 ) )

'' ---- GET into a plain buffer, then PUT it back ----
''
'' The round trip is what checks GET's header: a PUT that reads it back wrong
'' draws nothing or draws garbage, and either way the pixel below is not the one
'' that went in.
dim as ubyte g(0 to 4095)
get ( 20, 20 )-( 27, 27 ), g(0)
put ( 0, 40 ), g(0), PSET
chk( "get then put round trip", &h445566, point( 3, 43 ) )

'' ---- DRAW STRING ----
''
'' Only that it drew SOMETHING in the cell. Which pixels are the built-in font's
'' business and tools/abtest-print.bas compares those against gfxlib2; what is
'' new here is that the entry point reaches them.
draw string ( 2, 20 ), "A", &hFFFFFF
dim as long lit
for y as integer = 20 to 27
    for x as integer = 2 to 9
        if point( x, y ) = &hFFFFFF then lit += 1
    next
next
chk( "draw string put pixels down", 1, iif( lit > 0, 1, 0 ) )

imagedestroy( im )
screen 0

print Log_;
if fails = 0 then
    print "smoke: PASS -- the entry layer answers"
    end 0
else
    print "smoke: FAIL -- "; fails; " check(s)"
    end 1
end if
