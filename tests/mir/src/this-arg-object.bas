'' 'this' as an argument is the OBJECT, not the pointer it is held in. See
'' tests/mir/this-arg-object.test.

type pt
    as single x, y, z
end type

type T
    as long v
    as pt p( any )
    as pt ctr
    declare constructor( )
    declare sub m( )
end type

function byr( byref s as T ) as long : return s.v + 1 : end function
function byv( byval s as T ) as long : return s.v + 2 : end function
function dflt( s as T ) as long : return s.v + 3 : end function
function ovl overload ( byref s as T ) as long : return 10 : end function
function ovl overload ( byval q as T ptr ) as long : return 20 : end function
function getctr( s as T ) as pt : return type( ubound( s.p ) + 1, 2, 3 ) : end function

'' starshine.bas's UnknownCraft constructor.
constructor T( )
    this.ctr = getctr( this )
end constructor

sub T.m( )
    dim as long a = byr( this ), b = byv( this ), c = dflt( This )
    dim as long d = ovl( this ), e = ovl( @this )
    print a, b, c, d, e, ctr.x, ctr.y, ctr.z
end sub

'' A TRIVIAL type byval takes the other path: the object's bytes, loaded through 'this'.
type U
    as long w
    declare sub mu( )
end type
function byvU( byval q as U ) as long : return q.w * 2 : end function
sub U.mu( )
    print byvU( this )
end sub

dim as T x
x.v = 5
x.m( )
dim as U y
y.w = 21
y.mu( )
