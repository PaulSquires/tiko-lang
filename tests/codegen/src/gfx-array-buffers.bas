'' GET into a dynamic array, and DRAW / LINE onto an element of a ubyte array: the buffer, not the descriptor or the byte
#include once "crt/string.bi"
#include once "fbgfx.bi"
const IMAGE_BUFFER_SIZE = sizeof(fb.Image) + 16*16*4
screenres 16, 16, 32, , fb.GFX_NULL
open cons for output as #9
line (0, 0) - (15, 15), rgb(0,255,0), bf
sub t()
	redim array(0 to IMAGE_BUFFER_SIZE-1) as ubyte
	get (0, 0) - (15, 15), array
	print #9, hex( point( 3, 3, @array(0) ) ), ubound( array )
	dim fixed(0 to IMAGE_BUFFER_SIZE-1) as ubyte
	memcpy( @fixed(0), @array(0), IMAGE_BUFFER_SIZE )
	line fixed(0), (0, 0) - (15, 15), rgb(0,0,255), bf
	print #9, hex( point( 3, 3, @fixed(0) ) )
	draw fixed(0), "BM 0,0 P " & rgb(255,0,0) & "," & rgb(255,255,255)
	print #9, hex( point( 3, 3, @fixed(0) ) )
end sub
t()
print #9, "done"
