'' A STATIC-STORAGE INITIALISER MUST BE A CONSTANT over a type no constructor fills --
'' fbc-modern's error 11, "Expected constant", on every 'e' line, and on nothing else:
''
''     (74) error 11: Expected constant in 'dim shared as P e1 = mkp( 3 )'
''     (75) error 11: Expected constant in 'static as P e2 = mkp( 3 )'
''     ...                                  one per line through
''     (125) error 11: Expected constant in 'static as long e48 = len( hex( 1 ) )'
''
'' The accepted() lines are what fbc folds -- constants, an address, a builtin -- or run
'' a constructor (HC written, SS and TZ implicit), and the last two are not static.
'' tiko accepted every 'e' line and left the storage unwritten. See CheckStaticInitConst_.
type P
    a as long
    b as long
end type
type TD
    a as long
    declare destructor( )
end type
destructor TD( ) : end destructor
type HC
    a as long
    declare constructor( byval n as long )
end type
constructor HC( byval n as long ) : a = n : end constructor
type SS
    s as string
    n as long
end type
type TZ
    a as long = 7
end type
type TM
    a as long
    declare function mk( ) as P
end type
function TM.mk( ) as P
    dim as P r
    return r
end function

dim shared as long gx = 5
dim shared as P gp
dim shared as TM gm
dim shared as long garr(0 to 2)
const KK = 4
function mkp( byval n as long = 1 ) as P
    dim as P r
    r.a = n
    return r
end function
function f( ) as long
    return 3
end function
function makd( ) as TD
    dim as TD r
    return r
end function
function mkhc( ) as HC
    return HC( 1 )
end function
function mkss( ) as SS
    dim as SS r
    return r
end function
function mkz( ) as TZ
    dim as TZ r
    return r
end function
namespace ns
    dim as long nv = 1
end namespace

dim shared as P e1 = mkp( 3 )
static as P e2 = mkp( 3 )
var shared e3 = f( )
namespace ns2
    dim as P e4 = mkp( 3 )
end namespace
dim shared as string gstr
sub refused( )
    static as long e5 = f( )
    static as long e6 = f
    static as P e7 = gm.mk( )
    static as P e8 = gp
    static as P e9 = type<P>( gx, 2 )
    static as P e10 = ( 1, f( ) )
    static as long e11 = gx + 1
    static as long e12 = gp.a
    static as long e13 = garr( 1 )
    static as P e14 = *cast( P ptr, 0 )
    static as TD e15 = makd( )
    static as long e16(0 to 1) = { f( ), 2 }
    static as long e17 = ns.nv
    static as double e18 = f( ) * 1.5
    static as long e19 = -gx
    static as long e20 = iif( gx, 1, 2 )
    static as long e21 = iif( 1, gx, 2 )
    static as long e22 = iif( 0, 2, f( ) )
    static as long e23 = iif( KK, gx, f( ) )
    static as long e24 = cast( long, gx )
    static as long e25 = cint( gx )
    static as double e26 = cdbl( f( ) )
    static as zstring * 8 e27 = str( gx )
    static as zstring * 8 e28 = chr( gx )
    static as zstring * 8 e29 = left( "abc", gx )
    static as long e30 = len( gstr )
    static as long e31 = asc( str( gx ) )
    static as double e32 = sin( gx )
    static as long e33 = cast( long, iif( gx, 1, 2 ) )
    static as zstring * 8 e34 = hex( 255 )
    static as zstring * 8 e35 = oct( KK, 4 )
    static as zstring * 8 e36 = bin( 5, 8 )
    static as wstring * 8 e37 = whex( 255 )
    static as wstring * 8 e38 = woct( 8 )
    static as wstring * 8 e39 = wbin( 5 )
    static as double e40 = val( "12" )
    static as long e41 = valint( "0" )
    static as longint e42 = vallng( "12" )
    static as ulong e43 = valuint( "12" )
    static as ulongint e44 = valulng( "0" )
    static as long e45 = peek( long, @gx )
    static as long e46 = peek( integer, 0 ) + 1
    static as zstring * 8 e47 = "x" & hex( 1 )
    static as long e48 = len( hex( 1 ) )
end sub

sub accepted( )
    static as P k1 = type<P>( KK, 2 )
    static as long ptr k2 = @gx
    static as long k3 = len( f( ) ) + sizeof( mkp( 3 ) )
    static as double k4 = atn( 1 ) * 4 + sin( 1.0 ) + sqr( 2 )
    static as long k5 = asc( "A" ) + abs( -3 ) + cint( 2.5 ) + sgn( -2 )
    static as ulong k6 = rgb( 1, 2, 3 )
    static as zstring * 8 k7 = chr( 65 )
    static as long k8 = iif( 1, 2, 3 )
    static as HC k9 = mkhc( )
    static as SS k10 = mkss( )
    static as TZ k11 = mkz( )
    static as function( ) as long k12 = @f
    static as any ptr k13 = procptr( f )
    static as long k17 = iif( 0, gx, 2 ) + iif( 1, 2, gx )
    static as long k18 = cast( long, 2.5 ) + cint( 2.5 ) + cast( long, KK )
    static as long ptr k19 = cptr( long ptr, @gx )
    static as zstring * 8 k20 = str( 1 )
    static as long k21 = len( gx ) + sizeof( gx ) + lbound( garr ) + ubound( garr ) + offsetof( P, b )
    static as long k22 = sizeof( hex( 1 ) ) + sizeof( peek( long, @gx ) )
    dim as P k14 = mkp( 3 )
    static as P k15
end sub
dim as P k16 = mkp( 3 )
