'' entry-count.bas -- which str_core entry points does fbc's code actually call?
''
'' The allocation-count differential showed tiko-rt doing one malloc where fbc
'' does a thousand, with every behavioural differential still saying IDENTICAL.
'' Knowing HOW MANY allocations happen does not say WHICH entry point fbc's C
'' reached to cause them, and guessing that from the outside had already been
'' wrong twice.
''
'' Same mechanism as alloc-count.bas, pointed at the runtime instead of libc:
'' --wrap on an entry point redirects every call -- including the ones from
'' inside fbc's own str_concat.o and str_assign.o -- through a counter, and
'' works identically whether the definition comes from fbc's libfb.a or ours.
''
''   fbc tests/abi/entry-count.bas -p <lib> -Wl <the --wrap list below>
''
'' Diff the two outputs. A difference means fbc's C is taking a different route
'' through the runtime depending on which runtime it is linked against, which is
'' only possible if one of them returns something the other does not.

#include once "crt/stdlib.bi"

extern "rtlib"
	declare function __real_fb_hStrAlloc alias "__real_fb_hStrAlloc" _
		( byval s as any ptr, byval n as integer ) as any ptr
	declare function __real_fb_hStrRealloc alias "__real_fb_hStrRealloc" _
		( byval s as any ptr, byval n as integer, byval k as long ) as any ptr
	declare function __real_fb_hStrAllocTemp alias "__real_fb_hStrAllocTemp" _
		( byval s as any ptr, byval n as integer ) as any ptr
	declare function __real_fb_hStrDelTemp alias "__real_fb_hStrDelTemp" _
		( byval s as any ptr ) as long
	declare function __real_fb_hStrAllocTempDesc alias "__real_fb_hStrAllocTempDesc" ( ) as any ptr
	declare function __real_fb_hStrDelTempDesc alias "__real_fb_hStrDelTempDesc" _
		( byval s as any ptr ) as long
end extern

dim shared as longint nAlloc, nRealloc, nAllocTemp, nDelTemp, nAllocDesc, nDelDesc

extern "rtlib"
	function __wrap_fb_hStrAlloc alias "__wrap_fb_hStrAlloc" _
		( byval s as any ptr, byval n as integer ) as any ptr
		nAlloc += 1
		return __real_fb_hStrAlloc( s, n )
	end function

	function __wrap_fb_hStrRealloc alias "__wrap_fb_hStrRealloc" _
		( byval s as any ptr, byval n as integer, byval k as long ) as any ptr
		nRealloc += 1
		return __real_fb_hStrRealloc( s, n, k )
	end function

	function __wrap_fb_hStrAllocTemp alias "__wrap_fb_hStrAllocTemp" _
		( byval s as any ptr, byval n as integer ) as any ptr
		nAllocTemp += 1
		return __real_fb_hStrAllocTemp( s, n )
	end function

	function __wrap_fb_hStrDelTemp alias "__wrap_fb_hStrDelTemp" _
		( byval s as any ptr ) as long
		nDelTemp += 1
		return __real_fb_hStrDelTemp( s )
	end function

	function __wrap_fb_hStrAllocTempDesc alias "__wrap_fb_hStrAllocTempDesc" ( ) as any ptr
		nAllocDesc += 1
		return __real_fb_hStrAllocTempDesc( )
	end function

	function __wrap_fb_hStrDelTempDesc alias "__wrap_fb_hStrDelTempDesc" _
		( byval s as any ptr ) as long
		nDelDesc += 1
		return __real_fb_hStrDelTempDesc( s )
	end function
end extern

const N = 1000
const CASES = 3

dim shared as zstring * 24 caseName( 0 to CASES - 1 )
dim shared as longint r0( 0 to 5 ), rr( 0 to CASES - 1, 0 to 5 )
dim shared as integer nextCase

sub startCase( byval nm as zstring ptr )
	caseName( nextCase ) = *nm
	r0(0) = nAlloc : r0(1) = nRealloc : r0(2) = nAllocTemp
	r0(3) = nDelTemp : r0(4) = nAllocDesc : r0(5) = nDelDesc
end sub

sub endCase( )
	rr( nextCase, 0 ) = nAlloc     - r0(0)
	rr( nextCase, 1 ) = nRealloc   - r0(1)
	rr( nextCase, 2 ) = nAllocTemp - r0(2)
	rr( nextCase, 3 ) = nDelTemp   - r0(3)
	rr( nextCase, 4 ) = nAllocDesc - r0(4)
	rr( nextCase, 5 ) = nDelDesc   - r0(5)
	nextCase += 1
end sub

dim as string s, a, b, big1, big2
dim as integer guard = 0
a = "abcdefgh" : b = "12345678"
big1 = string( 200, "a" ) : big2 = string( 200, "b" )
s = string( 512, "x" )

startCase( @"temp_churn" )
for i as integer = 1 to N
	guard += len( a + b )
next
endCase( )

startCase( @"concat_two_fixed_400" )
for i as integer = 1 to N
	s = big1 + big2
next
endCase( )

startCase( @"assign_literal" )
for i as integer = 1 to N
	s = "0123456789"
next
endCase( )

print "str_core entry calls per "; N; " iterations"
print "case                      hAlloc hRealloc AllocTmp DelTemp AllocDsc DelDesc"
for k as integer = 0 to CASES - 1
	print caseName( k );
	for j as integer = 0 to 5
		print tab( 26 + j * 9 ); rr( k, j );
	next
	print
next
if( guard < 0 ) then print "impossible"
