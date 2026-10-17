dim shared as zstring * 8 gz = "AB"
dim shared as wstring * 8 gw = "CD"
dim shared as long gl = -5
dim shared as longint gq = 77

type UZ
    as long v
    declare operator cast( ) as zstring ptr
end type
operator UZ.cast( ) as zstring ptr : print "[zs]"; : return @gz : end operator

type UW
    as long v
    declare operator cast( ) as wstring ptr
end type
operator UW.cast( ) as wstring ptr : print "[ws]"; : return @gw : end operator

type UB
    as long v
    declare operator cast( ) as byte ptr
end type
operator UB.cast( ) as byte ptr : print "[by]"; : return cast( byte ptr, @gz ) : end operator

type UU
    as long v
    declare operator cast( ) as ubyte ptr
end type
operator UU.cast( ) as ubyte ptr : print "[ub]"; : return cast( ubyte ptr, @gz ) : end operator

type UL
    as long v
    declare operator cast( ) as long ptr
end type
operator UL.cast( ) as long ptr : print "[lo]"; : return @gl : end operator

type UI
    as long v
    declare operator cast( ) as integer ptr
end type
operator UI.cast( ) as integer ptr : print "[in]"; : return cast( integer ptr, @gq ) : end operator

'' two casts: the closer pointee wins, and 'any ptr' beats every same-size one
type UZL
    as long v
    declare operator cast( ) as long ptr
    declare operator cast( ) as zstring ptr
end type
operator UZL.cast( ) as long ptr : print "[lo]"; : return @gl : end operator
operator UZL.cast( ) as zstring ptr : print "[zs]"; : return @gz : end operator

type UAZ
    as long v
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as any ptr
end type
operator UAZ.cast( ) as zstring ptr : print "[zs]"; : return @gz : end operator
operator UAZ.cast( ) as any ptr : print "[an]"; : return @gz : end operator

sub sb( byval p as byte ptr ) : print " sb"; p[0] : end sub
sub su( byval p as ubyte ptr ) : print " su"; p[1] : end sub
sub sh( byval p as short ptr ) : print " sh"; p[0] : end sub
sub sz( byval p as zstring ptr ) : print " sz "; *p : end sub
sub sw( byval p as ushort ptr ) : print " sw"; p[1] : end sub
sub sl( byval p as ulong ptr ) : print " sl"; *p : end sub
sub sq( byval p as longint ptr ) : print " sq"; *p : end sub

function ob overload( byval p as byte ptr ) as long : print " ob"; p[0]; : return 1 : end function
function ob overload( byval a as long, byval b as long ) as long : return 2 : end function
function oz overload( byval p as zstring ptr ) as long : print " oz "; *p; : return 1 : end function
function oz overload( byval a as long, byval b as long ) as long : return 2 : end function
function os overload( byval p as short ptr ) as long : print " os"; p[0]; : return 1 : end function
function os overload( byval a as long, byval b as long ) as long : return 2 : end function

dim as UZ z
dim as UW w
dim as UB b
dim as UU u
dim as UL l
dim as UI i
dim as UZL zl
dim as UAZ az

'' single procedures: every same-size pointee
sb( z )
su( z )
sh( w )
sw( w )
sz( b )
sz( u )
sl( l )
sq( i )
'' overload sets: what is not ranked first in the parameter's row
print ob( z )
print oz( b )
print os( w )
'' a pick among casts
sb( zl )
sb( az )
'' initialiser and assignment
dim as ubyte ptr pu = z : print " pu"; pu[0]
dim as zstring ptr pz : pz = b : print " pz "; *pz
'' a tie inside one overload only takes that overload out
type UBZ
    as long v
    declare operator cast( ) as byte ptr
    declare operator cast( ) as zstring ptr
end type
operator UBZ.cast( ) as byte ptr : print "[by]"; : return cast( byte ptr, @gz ) : end operator
operator UBZ.cast( ) as zstring ptr : print "[zs]"; : return @gz : end operator
type UBU
    as long v
    declare operator cast( ) as byte ptr
    declare operator cast( ) as ubyte ptr
end type
operator UBU.cast( ) as byte ptr : print "[by]"; : return cast( byte ptr, @gz ) : end operator
operator UBU.cast( ) as ubyte ptr : print "[ub]"; : return cast( ubyte ptr, @gz ) : end operator
function ta overload( byval p as any ptr ) as long : print " ta"; : return 1 : end function
function ta overload( byval p as zstring ptr ) as long : print " tz"; : return 2 : end function
function tb overload( byval p as zstring ptr ) as long : print " tz"; : return 1 : end function
function tb overload( byval p as byte ptr ) as long : print " tb"; : return 2 : end function
dim as UBZ bz
dim as UBU bu
print ta( bz )
print tb( bu )
