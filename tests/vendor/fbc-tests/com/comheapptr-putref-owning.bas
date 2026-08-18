' TEST_MODE : COMPILE_AND_RUN_FAIL

'' PutRef( ) on an owning ComHeapPtr raises, exactly as ComPtr.PutRef does and
'' for the same reason: handing out the address of a slot that already owns a
'' block leaks it, silently.
''
'' Its own module because the raise aborts.

#include once "fb/comptr.bi"
using FB

dim as ComHeapPtr( of ushort ) h
if( h.Alloc( 16 ) = FALSE ) then end 2
print "before"
dim as ushort ptr ptr slot = h.PutRef( )
print "unreachable"
