'' dylib-parity.bas -- DYLIBLOAD / DYLIBSYMBOL / DYLIBFREE. Four entry points,
'' split by platform.
''
'' NEEDS-GEN-LLVM
''
'' IT LOADS A REAL LIBRARY AND CALLS THROUGH THE POINTER IT GETS BACK. A test
'' that only checked "handle is non-zero" would not notice a DylibSymbol that
'' returned the wrong address, and a test that only checked "symbol is non-zero"
'' would not notice one that returned a pointer to the wrong export.
''
'' THE LIBRARY IS THE C RUNTIME ITSELF, because it is the one shared object
'' guaranteed to be present, already loaded, and to export something with a
'' trivially checkable result. `strlen` is that something: the answer is a number
'' this test can compute independently.
''
'' THE NAME IS SPELLED PER PLATFORM and that is the point of the exercise -- the
'' Windows side hands over "msvcrt" and the POSIX side "c", and each platform's
'' own filename convention is applied by the runtime.
''
'' fb_hDynLoad and friends are NOT exercised here. They are the runtime's own
'' internal loader, reached only from members tiko-rt does not own (the gfx and
'' printer paths), and there is no way to call them from FreeBASIC source without
'' declaring them -- which the gate already does by linking every program in
'' fbc's suite against them.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - a NULL library handle means THIS EXECUTABLE, not "no library"
''   - a missing symbol is NULL, not a fault
''   - DylibSymbolByOrd is NULL on POSIX and real on Windows -- so the test
''     checks only that it does not fault and that a nonsense ordinal is NULL
''   - loading a library that does not exist gives NULL, not a crash
''   - DYLIBFREE of a handle that was never loaded must not take the process down

const TKORT_USLOTS = 4
dim shared as string spool( 0 to TKORT_USLOTS - 1 )
dim shared as integer sslot
function SS( byref txt as string ) as any ptr
	sslot = (sslot + 1) mod TKORT_USLOTS
	spool(sslot) = txt
	return @spool(sslot)
end function

extern "rtlib"
	declare function pLoad     alias "fb_DylibLoad"        ( byval l as any ptr ) as any ptr
	declare function pSymbol   alias "fb_DylibSymbol"      ( byval h as any ptr, byval s as any ptr ) as any ptr
	declare function pSymByOrd alias "fb_DylibSymbolByOrd" ( byval h as any ptr, byval o as short ) as any ptr
	declare sub      pFree     alias "fb_DylibFree"        ( byval h as any ptr )
end extern

type STRLENPROC as function cdecl ( byval s as zstring ptr ) as uinteger

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	dim as string libname = "msvcrt"
#else
	dim as string libname = "c"
#endif

dim as any ptr h = any, p = any

print "-- load the C runtime by its platform name"
h = pLoad( SS( libname ) )
print "  handle<>0="; iif( h <> 0, 1, 0 )

print "-- a symbol from it, called for real"
p = pSymbol( h, SS( "strlen" ) )
print "  symbol<>0="; iif( p <> 0, 1, 0 )
if( p <> 0 ) then
	dim as STRLENPROC f = cast( STRLENPROC, p )
	dim as string probe = "abcdefghij"
	print "  strlen('"; probe; "')="; f( strptr( probe ) ); " expected="; len( probe )
	print "  strlen('')="; f( @"" )
end if

print "-- a symbol that is not there"
print "  missing="; iif( pSymbol( h, SS( "tkort_no_such_symbol_98765" ) ) <> 0, 1, 0 )
print "  empty name="; iif( pSymbol( h, SS( "" ) ) <> 0, 1, 0 )

print "-- a NULL handle means THIS executable"
'' Every FB program links the runtime, so an rtlib entry point is always there.
print "  fb_StrDelete in self="; iif( pSymbol( 0, SS( "fb_StrDelete" ) ) <> 0, 1, 0 )
print "  nonsense in self="; iif( pSymbol( 0, SS( "tkort_definitely_not_here" ) ) <> 0, 1, 0 )

print "-- by ordinal"
'' Real on Windows, always NULL on POSIX; a nonsense ordinal is NULL on both, and
'' the only portable assertion is that neither faults.
print "  ordinal 32767="; iif( pSymByOrd( h, 32767 ) <> 0, 1, 0 )
print "  ordinal 32767 in self="; iif( pSymByOrd( 0, 32767 ) <> 0, 1, 0 )

print "-- a library that does not exist"
print "  handle="; iif( pLoad( SS( "tkort-no-such-library-98765" ) ) <> 0, 1, 0 )
print "  empty name="; iif( pLoad( SS( "" ) ) <> 0, 1, 0 )

print "-- free"
pFree( h )
print "  freed"

'' The handle is still resolvable after the free on both platforms, because the C
'' runtime is loaded by the process itself and this only dropped OUR reference.
'' That is not asserted -- it is a property of the library, not of the runtime.
print "-- reload works"
h = pLoad( SS( libname ) )
print "  handle<>0="; iif( h <> 0, 1, 0 )
pFree( h )

print "done"
