#include "fbgfx.bi"
#include "crt/string.bi"
open cons for output as #9
screenres 64, 64, 32, , FB.GFX_NULL
dim as any ptr a = imagecreate( 16, 16, rgb(0,0,0) )
dim array(0 to 16*16*4+32-1) as ubyte
memcpy( @array(0), a, 16*16*4+32 )
line array, (0, 0) - (15, 15), rgb(255,0,0), bf
dim as ulong ptr px = cast( any ptr, @array(0) ) + 32
print #9, hex( px[0] ), hex( px[255] )
redim dyn(3 to 3+16*16*4+32-1) as ubyte
memcpy( @dyn(3), a, 16*16*4+32 )
line dyn, (0, 0) - (15, 15), rgb(0,0,255), bf
px = cast( any ptr, @dyn(3) ) + 32
print #9, hex( px[0] ), hex( px[255] )
dim lar(0 to (16*16*4+32)\8 - 1) as longint
memcpy( @lar(0), a, 16*16*4+32 )
line lar, (2, 2) - (3, 3), rgb(0,255,0), bf
px = cast( any ptr, @lar(0) ) + 32
print #9, hex( px[0] ), hex( px[2*16+2] )
pset array, (1, 1), rgb(1,2,3)
px = cast( any ptr, @array(0) ) + 32
print #9, hex( px[17] )
imagedestroy( a )
