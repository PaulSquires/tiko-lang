'' array-erase-parity.bas -- ERASE, REDIM and REDIM PRESERVE. Eighteen entry
'' points across twelve fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE DESCRIPTOR IS THE OBSERVABLE, not the contents. Every check below prints
'' LBOUND, UBOUND, the element count and -- where it matters -- whether the two
'' pointers moved, because a REDIM that produces the right elements with a wrong
'' `diff` indexes correctly at lbound 0 and wrongly everywhere else.
''
'' ALLOCATION COUNTS ARE PART OF THE CONTRACT. A var-len STRING array erased
'' through the wrong entry point leaks one allocation per element and produces
'' IDENTICAL output -- so the string cases below are driven hard enough that
'' alloc-count-parity, which runs in the same harness, can see the difference.

#include once "fbc-int/array.bi"

'' Variadic, so cdecl on every target -- stdcall cannot be variadic, and fbc's
'' win32 archive spells both undecorated.
extern "c"
	declare function pRedimEx alias "fb_ArrayRedimEx" _
		( byval a as FBC.FBARRAY ptr, byval element_len as uinteger, byval doclear as long, _
		  byval isvarlen as long, byval dimensions as uinteger, ... ) as long
	declare function pRedimPresvEx alias "fb_ArrayRedimPresvEx" _
		( byval a as FBC.FBARRAY ptr, byval element_len as uinteger, byval doclear as long, _
		  byval isvarlen as long, byval dimensions as uinteger, ... ) as long
end extern

'' Prints a descriptor's shape. `array()` parameters give the runtime the same
'' descriptor fbc's own code sees.
sub shape( byref label as string, a() as long )
	print "  "; label; ": lb="; lbound( a ); " ub="; ubound( a ); _
	      " n="; ubound( a ) - lbound( a ) + 1
end sub

print "-- ERASE on a dynamic array frees it"
'' DECLARED WITHOUT BOUNDS, THEN REDIMed. `dim as long d1( 1 to 10 )` is a
'' FIXED-LENGTH array and REDIM on it is a compile error -- which is also the
'' distinction the two ERASE paths below turn on.
dim as long d1()
redim d1( 1 to 10 )
shape( "before", d1() )
d1( 5 ) = 42
erase d1
'' UBOUND < LBOUND is how an unallocated dynamic array reports itself -- 0 and
'' -1 -- and it is what makes `for i = lbound to ubound` run zero times.
print "  after erase: lb="; lbound( d1 ); " ub="; ubound( d1 )
redim d1( 1 to 10 )
print "  after redim: lb="; lbound( d1 ); " ub="; ubound( d1 ); " d1(5)="; d1( 5 )

print "-- ERASE on a FIXED-LENGTH array only clears it"
'' A static array's storage is not the descriptor's, so ERASE must clear rather
'' than free -- and the bounds must survive.
static as long s1( 1 to 5 )
s1( 3 ) = 99
erase s1
print "  after erase: lb="; lbound( s1 ); " ub="; ubound( s1 ); " s1(3)="; s1( 3 )

print "-- ERASE on a var-len STRING array"
dim as string ds()
redim ds( 1 to 4 )
for i as integer = 1 to 4
	ds( i ) = "element-" + str( i ) + string( 40, "x" )
next
print "  before: ds(2)len="; len( ds( 2 ) )
erase ds
print "  after erase: lb="; lbound( ds ); " ub="; ubound( ds )
redim ds( 1 to 4 )
print "  after redim: ds(2)len="; len( ds( 2 ) ); " (empty="; ( ds(2) = "" ); ")"

print "-- ERASE on a FIXED-LENGTH var-len STRING array"
static as string ss( 1 to 3 )
for i as integer = 1 to 3
	ss( i ) = string( 50, asc( "a" ) + i )
next
erase ss
print "  bounds survive: lb="; lbound( ss ); " ub="; ubound( ss ); _
      " ss(2)len="; len( ss( 2 ) )

print "-- ERASE on a STRING*N array fills with SPACES, not NULs"
'' fb_ArrayFill, and this is the one place where clearing to zero would be a
'' plausible-looking wrong answer: the array would print the same and compare
'' differently.
static as string * 4 sn( 1 to 3 )
sn( 1 ) = "abcd"
sn( 2 ) = "efgh"
erase sn
print "  sn(1)=["; sn( 1 ); "] first byte="; asc( sn( 1 ), 1 ); _
      " equals-spaces="; ( sn( 1 ) = "    " )

'' ------------------------------------------------------------------ REDIM

print "-- REDIM clears, and the bounds are honoured"
dim as long r()
redim r( 3 to 7 )
print "  lb="; lbound( r ); " ub="; ubound( r ); " r(3)="; r( 3 ); " r(7)="; r( 7 )
for i as integer = 3 to 7
	r( i ) = i * 100
next
print "  filled: r(3)="; r( 3 ); " r(7)="; r( 7 )

'' A SECOND REDIM DOES NOT PRESERVE. Everything goes back to zero.
redim r( 3 to 7 )
print "  after plain redim: r(3)="; r( 3 ); " r(7)="; r( 7 )

print "-- REDIM with a NEGATIVE lower bound"
'' This is where `diff` earns its keep: index_ptr is base_ptr biased by the
'' lbound offset, and a wrong bias indexes correctly at zero and nowhere else.
redim r( -5 to 5 )
for i as integer = -5 to 5
	r( i ) = i
next
dim as long ok = -1
for i as integer = -5 to 5
	if( r( i ) <> i ) then ok = 0
next
print "  lb="; lbound( r ); " ub="; ubound( r ); " every element reads back="; ok

print "-- REDIM, two dimensions"
dim as long r2()
redim r2( 1 to 3, 2 to 4 )
for i as integer = 1 to 3
	for j as integer = 2 to 4
		r2( i, j ) = i * 10 + j
	next
next
print "  lb1="; lbound( r2, 1 ); " ub1="; ubound( r2, 1 ); _
      " lb2="; lbound( r2, 2 ); " ub2="; ubound( r2, 2 )
print "  r2(1,2)="; r2( 1, 2 ); " r2(3,4)="; r2( 3, 4 )

'' ------------------------------------------------------- the runtime, direct
''
'' THE REDIM STATEMENT DOES NOT SET ERR. Written as
''
''     redim bad_( 5 to 1 ) : print err
''
'' this printed ZERO on both runtimes -- the same class of trap as the OPEN
'' statement in devfile-parity, and it would have passed against any return
'' value at all. fb_ArrayRedimEx RETURNS the code, so the three rejection paths
'' are checked through it on a descriptor of this program's own.
print "-- the three rejections, through fb_ArrayRedimEx"

dim as FBC.FBARRAY desc
desc.index_ptr = 0 : desc.base_ptr = 0 : desc.size = 0
desc.element_len = 0 : desc.dimensions = 0 : desc.flags = 0

'' A first REDIM on a descriptor whose dimension count is still 0 fixes it.
print "  redim(1 to 3), 1 dim      -> "; _
      pRedimEx( @desc, 4, -1, 0, 1, cast( integer, 1 ), cast( integer, 3 ) ); _
      "  ub="; desc.dimTb(0).ubound

'' lbound above ubound.
print "  redim(5 to 1)             -> "; _
      pRedimEx( @desc, 4, -1, 0, 1, cast( integer, 5 ), cast( integer, 1 ) )

'' A DIFFERENT DIMENSION COUNT on a descriptor that already has one. This is
'' unreachable from FreeBASIC source -- fbc rejects it at compile time -- so it
'' can only be tested here.
print "  redim, 2 dims on a 1-dim  -> "; _
      pRedimEx( @desc, 4, -1, 0, 2, cast( integer, 1 ), cast( integer, 3 ), _
                cast( integer, 1 ), cast( integer, 3 ) )

'' AND ON A FIXED-LENGTH DESCRIPTOR, which is the flag ERASE also turns on.
dim as FBC.FBARRAY fixed_
fixed_.index_ptr = 0 : fixed_.base_ptr = 0 : fixed_.size = 0
fixed_.element_len = 0 : fixed_.dimensions = 0
fixed_.flags = FBC.FBARRAY_FLAGS_FIXED_LEN
print "  redim on FIXED_LEN        -> "; _
      pRedimEx( @fixed_, 4, -1, 0, 1, cast( integer, 1 ), cast( integer, 3 ) )
print "  redim preserve on FIXED_LEN-> "; _
      pRedimPresvEx( @fixed_, 4, -1, 0, 1, cast( integer, 1 ), cast( integer, 3 ) )

'' ------------------------------------------------------------ REDIM PRESERVE

print "-- REDIM PRESERVE, growing"
dim as long p()
redim p( 1 to 4 )
for i as integer = 1 to 4
	p( i ) = i * 11
next
redim preserve p( 1 to 8 )
dim as string kept = ""
for i as integer = 1 to 8
	kept += str( p( i ) ) + " "
next
print "  lb="; lbound( p ); " ub="; ubound( p )
print "  values: "; kept

print "-- REDIM PRESERVE, shrinking"
redim preserve p( 1 to 3 )
kept = ""
for i as integer = 1 to 3
	kept += str( p( i ) ) + " "
next
print "  lb="; lbound( p ); " ub="; ubound( p ); "  values: "; kept

print "-- REDIM PRESERVE on a never-allocated array is a plain REDIM"
'' realloc(NULL) is the path str/core.bas was bitten by at -O2, so it is kept
'' off this one entirely.
dim as long fresh_()
redim preserve fresh_( 2 to 6 )
print "  lb="; lbound( fresh_ ); " ub="; ubound( fresh_ ); _
      " fresh_(2)="; fresh_( 2 ); " fresh_(6)="; fresh_( 6 )

print "-- REDIM PRESERVE on a STRING array, shrinking"
'' The shrink destroys the tail elements through an FB_DTORMULT with a non-zero
'' keep_idx. Getting that wrong leaks one allocation per dropped element and
'' produces exactly this output either way.
dim as string ps()
redim ps( 1 to 6 )
for i as integer = 1 to 6
	ps( i ) = string( 60, asc( "A" ) + i )
next
redim preserve ps( 1 to 2 )
print "  lb="; lbound( ps ); " ub="; ubound( ps ); _
      " ps(1)len="; len( ps( 1 ) ); " ps(2)len="; len( ps( 2 ) )

redim preserve ps( 1 to 5 )
print "  grown back: ps(1)len="; len( ps( 1 ) ); _
      " ps(4) empty="; ( ps( 4 ) = "" )

print "-- ERASE twice in a row is not an error"
dim as long twice_( 1 to 3 )
erase twice_
erase twice_
print "  err="; err; " lb="; lbound( twice_ ); " ub="; ubound( twice_ )

print "done"
