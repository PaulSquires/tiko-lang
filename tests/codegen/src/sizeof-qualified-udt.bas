'' sizeof( ns.Type ) folds, so a field array bounded by it is fixed-size
#include once "fbgfx.bi"
const IMAGE_BUFFER_SIZE = sizeof(fb.Image) + 16*16*4
scope
	type UDT
		array(0 to IMAGE_BUFFER_SIZE-1) as ubyte
	end type
	print sizeof(UDT), IMAGE_BUFFER_SIZE, sizeof(fb.Image)
end scope
type UDT2
	array(0 to IMAGE_BUFFER_SIZE-1) as ubyte
end type
print sizeof(UDT2)
