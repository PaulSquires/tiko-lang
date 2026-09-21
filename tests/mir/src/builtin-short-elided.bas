'' THE SHORT AND ELIDED FORMS of four builtins, from the FreeBASIC help's own examples
'' (bload_1, bload_3, screenlist). The deployed compiler dropped every one of these
'' lines with no diagnostic. Measured from fbc-modern's C:
''
''   bload f                 fb_GfxBload( &F, (void*)0ull, (void*)0ull )
''   bload f, , @pal(0)      fb_GfxBload( &F, (void*)0ull, (void*)PAL$0 )
''   screenlist( )           fb_GfxScreenList( 0 )
''   pcopy , 1               fb_PageCopy( -1, 1 )
''   width( , 25 )           fb_Width( -1, 25 )
dim pal(0 to 255) as integer
if pal(0) <> 0 then
    bload "picture.bmp"
    bload "picture.bmp", , @pal(0)
end if
dim as long m = screenlist( )
pcopy , 1
dim as long w = width( , 25 )
