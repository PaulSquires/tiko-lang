'' A TYPE NAMED LIKE AN INTRINSIC IS THAT TYPE. 'a.s = Str( "abc" )' over 'type Str' with
'' 'operator let( byref o as Str )': Check typed the call as the STR( ) intrinsic, so the
'' same-type let was missed, the temporary's LOADED bytes went where the reference belongs
'' ('call _ZN3STRaSERS_(%2, %4)' -- clang refused the module) and the temporary was never
'' destroyed. fbc: '_ZN3STRC1ERKc( &TMP, "abc" ); _ZN3STRaSERS_( &A, &TMP ); _ZN3STRD1Ev(
'' &TMP )'. A numeric argument is shadowed too: 'str( 7 )' is the integer constructor.
''
'' fbc prints: field: abc 1 / local: xyz 2 / numeric: 7 2 / after: 0
dim shared as long live

type Str
	p as zstring ptr
	declare constructor( )
	declare constructor( byref s as const zstring )
	declare constructor( byval n as integer )
	declare operator let( byref o as Str )
	declare destructor( )
end type
constructor Str( )
	p = callocate( 1 )
	live += 1
end constructor
constructor Str( byref s as const zstring )
	p = callocate( len( s ) + 1 )
	*p = s
	live += 1
end constructor
constructor Str( byval n as integer )
	p = callocate( 2 )
	p[0] = asc( "0" ) + n
	live += 1
end constructor
operator Str.let( byref o as Str )
	deallocate( p )
	p = callocate( len( *o.p ) + 1 )
	*p = *o.p
end operator
destructor Str( )
	deallocate( p )
	live -= 1
end destructor

type Holder
	s as Str
end type

sub Probe( )
	dim as Holder a
	a.s = Str( "abc" )
	print "field: "; *a.s.p; live

	dim as Str x
	x = Str( "xyz" )
	print "local: "; *x.p; live

	x = str( 7 )
	print "numeric: "; *x.p; live
end sub

Probe( )
print "after:"; live
