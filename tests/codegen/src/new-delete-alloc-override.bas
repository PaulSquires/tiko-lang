#include once "fbc-int/memory.bi"
#undef allocate
#undef callocate
#undef deallocate
dim shared as integer ac, cc, dc
function allocate( byval size as const uinteger ) as any ptr
	ac += 1 : return fbc.allocate( size )
end function
function callocate( byval number as const uinteger, byval size as const uinteger ) as any ptr
	cc += 1 : return fbc.callocate( number, size )
end function
sub deallocate( byval p as const any ptr )
	dc += 1 : fbc.deallocate( p )
end sub
var p = new integer : delete p
var q = new integer[10] : delete[] q
var r = new integer[10] {any} : delete[] r
print ac, cc, dc
