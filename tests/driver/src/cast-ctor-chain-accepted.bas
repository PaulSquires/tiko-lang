'' See tests/driver/cast-ctor-chain-accepted.test.
type E
    as long c
    declare constructor( )
    declare constructor( byval k as long )
    declare constructor( byval p as zstring ptr )
end type
constructor E( ) : end constructor
constructor E( byval k as long ) : c = k : end constructor
constructor E( byval p as zstring ptr ) : c = len( *p ) : end constructor
type L
    as long c
    declare constructor( )
    declare constructor( byval p as long ptr )
end type
constructor L( ) : end constructor
constructor L( byval p as long ptr ) : c = *p : end constructor
type S
    as long c
    declare constructor( )
    declare constructor( byref t as string )
end type
constructor S( ) : end constructor
constructor S( byref t as string ) : c = len( t ) : end constructor

dim shared as long cell = 41
dim shared as zstring * 8 text = "seven!!"
type QD : as long c : declare operator cast( ) as double : end type
operator QD.cast( ) as double : return 2.75 : end operator
type QU : as long c : declare operator cast( ) as ulong : end type
operator QU.cast( ) as ulong : return 9 : end operator
type QP : as long c : declare operator cast( ) as long ptr : end type
operator QP.cast( ) as long ptr : return @cell : end operator
type QZ : as long c : declare operator cast( ) as zstring ptr : end type
operator QZ.cast( ) as zstring ptr : return @text : end operator
type QS : as long c : declare operator cast( ) as string : end type
operator QS.cast( ) as string : return "four" : end operator

operator <> ( byref a as E, byref b as E ) as boolean : return a.c <> b.c : end operator
function TakeE( byref v as E ) as long : return v.c : end function
function TakeL( byval v as L ) as long : return v.c : end function
function TakeS( byref v as S ) as long : return v.c : end function
function MakeE( ) as E
    dim as QD q
    return q
end function

dim as QD d1 : dim as QU u1 : dim as QP p1 : dim as QZ z1 : dim as QS s1
dim as E e0 = E( 3 )
print "arg"; TakeE( d1 ); TakeE( u1 ); TakeL( p1 ); TakeE( z1 ); TakeS( s1 )
print "op"; e0 <> d1; e0 <> z1
dim as E e1 = u1
dim as L l1 = p1
print "init"; e1.c; l1.c
print "ctor"; TakeE( E( z1 ) ); TakeL( L( p1 ) )
print "ret"; MakeE( ).c
