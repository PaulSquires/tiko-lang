'' EVERY GRAPHICS ENTRY POINT THE PRELUDE DECLARES MUST LINK against libtkogfx.a.
'' Sixteen did not -- SCREENLOCK, SCREENINFO, SCREENSET, FLIP, SCREENSYNC,
'' WINDOWTITLE, SCREENEVENT, the INTEGER and STRING forms of SCREENCONTROL,
'' IMAGEINFO, IMAGECONVERTROW, GETJOYSTICK and SCREENGLPROC -- and SCREENPTR
'' before them, so a program using any one of them failed with lld-link's
'' "undefined symbol fb_Gfx...". This is built and never run: the link is the test.
'' fbgfx.bi is not included -- the test runner has no include path -- so the
'' SCREENCONTROL selectors are written as numbers and the event as its 20 bytes.
''   4 GET_SCREEN_SIZE, 1 GET_WINDOW_TITLE
dim as long lw, lh, ld, lb, lp, lr
dim as integer iw, ih, id, ib, ip, ir
dim as string drv
dim as any ptr px
screenres 32, 24, 32, 2
screenlock
screenunlock
dim as any ptr p = screenptr
screeninfo lw, lh, ld, lb, lp, lr, drv
screeninfo iw, ih, id, ib, ip, ir, drv
screenset 1, 0
flip
screencopy
screensync
windowtitle "links"
dim as long e(0 to 4)
dim as long got = screenevent( @e(0) )
screencontrol 4, lw, lh
screencontrol 4, iw, ih
screencontrol 1, drv
dim as any ptr img = imagecreate( 4, 4 )
dim as long r1 = imageinfo( img, lw, lh, lb, lp, px, ld )
dim as long r2 = imageinfo( img, iw, ih, ib, ip, px, id )
dim as ulong row(0 to 3)
imageconvertrow( img, 32, @row(0), 32, 4 )
dim as single a1
dim as long j = getjoystick( 0, ib, a1 )
dim as any ptr g = screenglproc( "glBegin" )
imagedestroy img
