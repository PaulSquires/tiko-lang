'' alloc-count.bas -- Gate 3's allocation-count parity, for real.
''
'' RFC-0004 section 4 has always required this and it was never built, which is
'' why Gate 4's first PASS could not be trusted: tiko-rt came out 5x faster on
'' one case, and counting only our own side cannot tell "faster" from "does
'' less". This counts BOTH sides, with the same mechanism.
''
'' HOW
''
'' GNU ld's --wrap redirects every unresolved reference to `malloc` -- including
'' the ones inside a static libfb.a -- to `__wrap_malloc`, and leaves the real
'' one reachable as `__real_malloc`. So the identical source, linked against
'' each runtime, reports that runtime's allocator traffic.
''
''   fbc tests/abi/alloc-count.bas -p <lib> \
''       -Wl --wrap=malloc,--wrap=free,--wrap=realloc,--wrap=calloc
''
'' Then diff the two outputs. Any difference is a difference in allocation
'' policy, and by RFC-0004 section 4's fairness rule it invalidates a benchmark
'' comparison in whichever direction it points.
''
'' WHAT IT CANNOT DO: attribute an allocation to a caller. It answers "how many",
'' not "from where". That has been enough every time so far.
''
'' Counting must not itself allocate, so every result is stashed and printed
'' only after the last workload has run.

#include once "crt/stdlib.bi"

extern "c"
	'' NON-FBCALL: linker-level interposition, not runtime entry points.
	declare function __real_malloc  cdecl alias "__real_malloc"  ( byval n as uinteger ) as any ptr
	declare function __real_calloc  cdecl alias "__real_calloc"  ( byval n as uinteger, byval sz as uinteger ) as any ptr
	declare function __real_realloc cdecl alias "__real_realloc" ( byval p as any ptr, byval n as uinteger ) as any ptr
	declare sub      __real_free    cdecl alias "__real_free"    ( byval p as any ptr )

	dim shared as longint nMalloc, nCalloc, nRealloc, nFree

	function __wrap_malloc cdecl alias "__wrap_malloc" ( byval n as uinteger ) as any ptr
		nMalloc += 1
		return __real_malloc( n )
	end function

	function __wrap_calloc cdecl alias "__wrap_calloc" ( byval n as uinteger, byval sz as uinteger ) as any ptr
		nCalloc += 1
		return __real_calloc( n, sz )
	end function

	function __wrap_realloc cdecl alias "__wrap_realloc" ( byval p as any ptr, byval n as uinteger ) as any ptr
		nRealloc += 1
		return __real_realloc( p, n )
	end function

	sub __wrap_free cdecl alias "__wrap_free" ( byval p as any ptr )
		nFree += 1
		__real_free( p )
	end sub
end extern

const N = 1000
const CASES = 6

dim shared as zstring * 24 caseName( 0 to CASES - 1 )
dim shared as longint cM( 0 to CASES - 1 ), cC( 0 to CASES - 1 )
dim shared as longint cR( 0 to CASES - 1 ), cF( 0 to CASES - 1 )
dim shared as integer nextCase

'' Snapshot the counters around a workload. No allocation in here.
dim shared as longint m0, c0, r0, f0

sub startCase( byval nm as zstring ptr )
	caseName( nextCase ) = *nm
	m0 = nMalloc : c0 = nCalloc : r0 = nRealloc : f0 = nFree
end sub

sub endCase( )
	cM( nextCase ) = nMalloc  - m0
	cC( nextCase ) = nCalloc  - c0
	cR( nextCase ) = nRealloc - r0
	cF( nextCase ) = nFree    - f0
	nextCase += 1
end sub

'' Everything the workloads touch is allocated BEFORE any counting starts, so
'' set-up traffic is not attributed to a case.
dim as string s, acc, piece, a, b, big1, big2
piece = "abcdefghijklmnop"
a = "abcdefgh"
b = "12345678"
big1 = string( 200, "a" )
big2 = string( 200, "b" )
s = string( 512, "x" )
acc = string( 512, "y" )
dim as integer guard = 0

startCase( @"assign_literal" )
for i as integer = 1 to N
	s = "0123456789"
next
endCase( )

startCase( @"assign_grow" )
for i as integer = 1 to N
	s = space( (i and 63) + 1 )
next
endCase( )

startCase( @"append" )
acc = ""
for i as integer = 1 to N
	acc &= "abcdefgh"
	if( (i and 511) = 0 ) then guard += len( acc ) : acc = ""
next
endCase( )

startCase( @"temp_churn" )
for i as integer = 1 to N
	guard += len( a + b )
next
endCase( )

startCase( @"concat_assign_growing" )
acc = ""
for i as integer = 1 to N
	acc = acc + piece
	if( (i mod 512) = 0 ) then guard += len( acc ) : acc = ""
next
endCase( )

startCase( @"concat_two_fixed_400" )
for i as integer = 1 to N
	s = big1 + big2
next
endCase( )

'' ---- reporting. Allocates freely; all measurement is finished.
print "allocations per "; N; " iterations"
print "case                       malloc   calloc  realloc     free"
for k as integer = 0 to CASES - 1
	print caseName( k ); tab( 26 ); cM( k ); tab( 35 ); cC( k ); tab( 44 ); cR( k ); tab( 53 ); cF( k )
next
if( guard < 0 ) then print "impossible"
