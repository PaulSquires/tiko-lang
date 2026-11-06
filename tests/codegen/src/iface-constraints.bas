'' CONSTRAINTS (docs/tiko-interfaces §11.6). 'of T as IComparable( of T )' names its own parameter;
'' 'of E as { IComparable( of E ), IShow }' lists two. The body calls the concrete type's methods
'' directly -- monomorphised, no interface value. A derived class satisfies a constraint through
'' its base, and an interface argument satisfies one it inherits.
interface IComparable( of T )
    function CompareTo( byref o as T ) as long
end interface
interface IShow
    function Show( ) as string
end interface
class Num
    implements IComparable( of Num ), IShow
    dim as long n
    declare function CompareTo( byref o as Num ) as long implements IComparable( of Num ).CompareTo
    declare function Show( ) as string implements IShow.Show
end class
function Num.CompareTo( byref o as Num ) as long
    return n - o.n
end function
function Num.Show( ) as string
    return "#" & n
end function

function Max( of T as IComparable( of T ) )( byref a as T, byref b as T ) as T
    if a.CompareTo( b ) >= 0 then return a
    return b
end function

type Shelf( of E as { IComparable( of E ), IShow } )
    as E best
    declare sub Offer( byref x as E )
end type
sub Shelf( of E ).Offer( byref x as E )
    if x.CompareTo( best ) > 0 then best = x
    print "best "; best.Show( )
end sub

dim as Num a, b
a.n = 3 : b.n = 9
print Max( a, b ).n
dim as Shelf( of Num ) s
s.Offer( a ) : s.Offer( b ) : s.Offer( a )

class Big
    inherits Num
end class
dim as Big g1, g2
g1.n = 5 : g2.n = 4
print Max( cast( Num, g1 ), cast( Num, g2 ) ).n

interface IShowMore
    inherits IShow
end interface
function Label( of T as IShow )( byref x as T ) as string
    return "[" & x.Show( ) & "]"
end function
class Tag
    implements IShowMore
    declare function Show( ) as string implements IShow.Show
end class
function Tag.Show( ) as string : return "tag" : end function
dim as Tag t
dim as IShowMore sm = @t
print Label( t ), Label( sm ), Label( b ), Label( g1 )
