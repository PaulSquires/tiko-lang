'' errthrow-parity.bas -- ON ERROR / RESUME and the -exx array checks.
''
'' NEEDS-GEN-LLVM
'' NEEDS-LANG-FBLITE -- ON ERROR GOTO and RESUME need the older dialect.
''
'' THESE PATHS END THE PROGRAM when they are not handled, so every case here
'' installs a handler. The unhandled path is exercised in a SEPARATE program
'' below the fold: it is compared by its exit code and its message, which is
'' the only way to observe fb_Die without dying in the middle of the suite.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - fb_ErrorSetHandler returns the OLD handler, so nesting works
''   - a throw with a NULL module name keeps the PREVIOUS name, not blank
''   - RESUME and RESUME NEXT each clear BOTH labels, so a second RESUME dies
''   - the bound checkers return NULL for "fine" and a handler for "error"
''   - the single-dimension checker takes its index UNSIGNED, so -1 is caught
option gosub

#include once "fbc-int/array.bi"

extern "c"
	declare function pThrowMsg alias "fb_ErrorThrowMsg" ( byval e as long, byval l as long, byval m as zstring ptr, byval msg as zstring ptr, byval r as any ptr, byval rn as any ptr ) as any ptr
	declare function pThrowEx alias "fb_ErrorThrowEx" ( byval e as long, byval l as long, byval m as zstring ptr, byval r as any ptr, byval rn as any ptr ) as any ptr
	declare function pThrowAt alias "fb_ErrorThrowAt" ( byval l as long, byval m as zstring ptr, byval r as any ptr, byval rn as any ptr ) as any ptr
	declare function pResume alias "fb_ErrorResume" ( ) as any ptr
	declare function pResumeNext alias "fb_ErrorResumeNext" ( ) as any ptr
end extern

extern "rtlib"
	declare function pSetHandler alias "fb_ErrorSetHandler" ( byval h as any ptr ) as any ptr
	declare function pDimChk alias "fb_ArrayDimensionChk" ( byval d as integer, byval a as any ptr, byval l as long, byval f as zstring ptr, byval v as zstring ptr ) as any ptr
	declare function pBoundEx alias "fb_ArrayBoundChkEx" ( byval i as integer, byval lb as integer, byval ub as integer, byval l as long, byval f as zstring ptr, byval v as zstring ptr ) as any ptr
	declare function pSngEx alias "fb_ArraySngBoundChkEx" ( byval i as uinteger, byval ub as uinteger, byval l as long, byval f as zstring ptr, byval v as zstring ptr ) as any ptr
	declare function pBound alias "fb_ArrayBoundChk" ( byval i as integer, byval lb as integer, byval ub as integer, byval l as long, byval f as zstring ptr ) as any ptr
	declare function pSng alias "fb_ArraySngBoundChk" ( byval i as uinteger, byval ub as uinteger, byval l as long, byval f as zstring ptr ) as any ptr
	declare function pErrGet alias "fb_ErrorGetNum" ( ) as long
	declare function pErrSet alias "fb_ErrorSetNum" ( byval n as long ) as long
	declare function pLineGet alias "fb_ErrorGetLineNum" ( ) as long
	declare function pModGet alias "fb_ErrorGetModName" ( ) as zstring ptr
end extern

sub dummy_handler( )
end sub
sub dummy_handler2( )
end sub

'' Every value is captured before printing: PRINT clears the error number, and
'' reading ERR after a PRINT reports 0 for a path that did in fact set it.
dim as long e1 = any, e2 = any, e3 = any, e4 = any, l1 = any, l2 = any
dim as any ptr h0 = any, h1 = any, h2 = any, h3 = any
dim as any ptr r1 = any, r2 = any, r3 = any, r4 = any, r5 = any, r6 = any

print "-- fb_ErrorSetHandler returns the OLD handler"
h0 = pSetHandler( @dummy_handler )
h1 = pSetHandler( @dummy_handler2 )
h2 = pSetHandler( h1 )
h3 = pSetHandler( h0 )
print "  first-old-was-null="; iif( h0 = 0, 1, 0 );
print " second="; iif( h1 = cast( any ptr, @dummy_handler ), 1, 0 );
print " third="; iif( h2 = cast( any ptr, @dummy_handler2 ), 1, 0 );
print " fourth="; iif( h3 = cast( any ptr, @dummy_handler ), 1, 0 )

print "-- with a handler installed, the throwers return it and do not die"
pSetHandler( @dummy_handler )
r1 = pThrowMsg( 6, 42, @"modA", @"a message", cast( any ptr, 111 ), cast( any ptr, 222 ) )
e1 = pErrGet( ) : l1 = pLineGet( )
r2 = pThrowEx( 7, 43, @"modB", cast( any ptr, 333 ), cast( any ptr, 444 ) )
e2 = pErrGet( ) : l2 = pLineGet( )
'' A NULL module name must LEAVE the previous one in place.
r3 = pThrowMsg( 8, 44, 0, 0, cast( any ptr, 555 ), cast( any ptr, 666 ) )
e3 = pErrGet( )
dim as zstring ptr mn = pModGet( )
'' ThrowAt rethrows whatever is already in the context.
r4 = pThrowAt( 45, @"modC", cast( any ptr, 777 ), cast( any ptr, 888 ) )
e4 = pErrGet( )

print "  msg  ret-is-handler="; iif( r1 = cast( any ptr, @dummy_handler ), 1, 0 ); " err="; e1; " line="; l1
print "  ex   ret-is-handler="; iif( r2 = cast( any ptr, @dummy_handler ), 1, 0 ); " err="; e2; " line="; l2
print "  null-mod err="; e3; " modname='"; *mn; "'"
print "  at   err="; e4

print "-- RESUME returns the label, and clears BOTH"
pThrowMsg( 6, 1, @"m", 0, cast( any ptr, 1001 ), cast( any ptr, 2002 ) )
r5 = pResume( )
print "  resume gave 1001="; iif( r5 = cast( any ptr, 1001 ), 1, 0 )
'' A SECOND resume with no intervening throw would die, so it is not called
'' here -- that path is what the die-probe below covers.
pThrowMsg( 6, 1, @"m", 0, cast( any ptr, 1001 ), cast( any ptr, 2002 ) )
r6 = pResumeNext( )
print "  resumenext gave 2002="; iif( r6 = cast( any ptr, 2002 ), 1, 0 )

print "-- the bound checkers: NULL means fine"
dim as long fine = 0, caught = 0
dim as long idxs(0 to 7) = { 0, 1, 5, 10, -1, 11, -100, 2147483647 }
for e1 = 0 to 7
    if( pBoundEx( idxs(e1), 1, 10, 7, @"f.bas", @"arr" ) = 0 ) then fine += 1 else caught += 1
next
print "  BoundChkEx 1..10 fine="; fine; " caught="; caught
fine = 0 : caught = 0
for e1 = 0 to 7
    if( pSngEx( idxs(e1), 10, 7, @"f.bas", @"arr" ) = 0 ) then fine += 1 else caught += 1
next
print "  SngBoundChkEx ub=10 fine="; fine; " caught="; caught
fine = 0 : caught = 0
for e1 = 0 to 7
    if( pBound( idxs(e1), 1, 10, 7, @"f.bas" ) = 0 ) then fine += 1 else caught += 1
next
print "  legacy BoundChk fine="; fine; " caught="; caught
fine = 0 : caught = 0
for e1 = 0 to 7
    if( pSng( idxs(e1), 10, 7, @"f.bas" ) = 0 ) then fine += 1 else caught += 1
next
print "  legacy SngBoundChk fine="; fine; " caught="; caught

print "-- DimensionChk over real descriptors and a NULL"
dim as long fixed2(1 to 3, 1 to 4)
redim as long dyn1(1 to 5)
dim as any ptr d2 = FBC.ArrayDescriptorPtr( fixed2() )
dim as any ptr d1 = FBC.ArrayDescriptorPtr( dyn1() )
erase dyn1
dim as any ptr d1e = FBC.ArrayDescriptorPtr( dyn1() )
print "  2d asked 2="; iif( pDimChk( 2, d2, 9, @"f", @"v" ) = 0, 1, 0 );
print " asked 1="; iif( pDimChk( 1, d2, 9, @"f", @"v" ) = 0, 1, 0 );
print " asked 3="; iif( pDimChk( 3, d2, 9, @"f", @"v" ) = 0, 1, 0 )
print "  erased asked 1="; iif( pDimChk( 1, d1e, 9, @"f", @"v" ) = 0, 1, 0 );
print " null desc="; iif( pDimChk( 1, 0, 9, @"f", @"v" ) = 0, 1, 0 );
print " null varname="; iif( pDimChk( 1, 0, 9, @"f", 0 ) = 0, 1, 0 )

pSetHandler( 0 )
print "done"
