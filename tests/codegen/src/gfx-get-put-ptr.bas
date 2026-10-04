'' GET into a pointer passes its VALUE; PUT from an array element passes its ADDRESS
#include "fbgfx.bi"
open cons for output as #9
screenres 64, 64, 32, , FB.GFX_NULL
dim as any ptr img = imagecreate( 8, 8, rgb( 1, 2, 3 ) )
dim as integer before = cast( integer, img )
line ( 20, 20 )-( 27, 27 ), rgb( 10, 20, 30 ), bf
get ( 20, 20 )-( 27, 27 ), img
print #9, cast( integer, img ) = before
dim as FB.IMAGE ptr hp = img
print #9, hp->width, hp->height, hp->bpp, hp->pitch
dim as ulong buf( 200 )
get ( 20, 20 )-( 27, 27 ), buf( 0 )
put ( 40, 40 ), buf( 0 ), pset
print #9, hex( point( 42, 42 ) )
put ( 0, 0 ), img, pset
print #9, hex( point( 3, 3 ) )
imagedestroy( img )
