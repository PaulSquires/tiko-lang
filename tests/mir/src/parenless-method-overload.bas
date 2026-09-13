'' A METHOD NAMED WITHOUT PARENTHESES OVER AN OVERLOAD SET IS A CALL OF THE OVERLOAD THAT
'' TAKES NO ARGUMENT -- or whose every parameter has a default -- not of the chain's head.
'' fbc-modern prints, and tiko's build of this now prints too:
''
''     1  2         this.GetX              the zero-parameter GetX, not GetX( p )
''     70  30  40   this.GetX( @g2 )       the parenthesised call is overload resolution's
''     5  40        this.GetY              the all-defaulted GetY, not GetY( q )
''    take 1  2     TakeGD( this.GetX )    as an argument
''     8  9         T.SX                   a static member
''     1  2         GetX                   bare, inside a method
''     1  2         t1.GetX                through an instance
''
'' tiko typed the member from the chain's HEAD -- AfxNova's 'this.GetRawFormat' came out a
'' GpStatus where fbc calls 'GetRawFormat( ) as GUID' -- and refused the declaration
'' (TKO0738). PsCalendar reached exactly that.
type GD
    a as integer
    b as integer
end type
type T
    v as integer
    declare function GetX overload ( byval p as GD ptr ) as long
    declare function GetX ( ) as GD
    declare function GetY overload ( byval q as integer ) as long
    declare function GetY ( byval k as long = 5 ) as GD
    declare static function SX overload ( byval p as integer ) as long
    declare static function SX ( ) as GD
    declare sub Test( )
end type
function T.GetX( byval p as GD ptr ) as long
    p->a = 30 : p->b = 40
    return 70
end function
function T.GetX( ) as GD
    dim g as GD = ( 1, 2 )
    return g
end function
function T.GetY( byval q as integer ) as long
    return 99
end function
function T.GetY( byval k as long = 5 ) as GD
    dim g as GD = ( k, 40 )
    return g
end function
static function T.SX( byval p as integer ) as long
    return 11
end function
static function T.SX( ) as GD
    dim g as GD = ( 8, 9 )
    return g
end function
sub TakeGD( byref g as GD )
    print "take"; g.a; g.b
end sub
sub T.Test( )
    dim r as GD = this.GetX
    print r.a; r.b
    dim g2 as GD
    print this.GetX( @g2 ); g2.a; g2.b
    dim r2 as GD = this.GetY
    print r2.a; r2.b
    TakeGD( this.GetX )
    dim r3 as GD = T.SX
    print r3.a; r3.b
    dim r5 as GD = GetX
    print r5.a; r5.b
end sub
dim t1 as T
t1.Test( )
dim r4 as GD = t1.GetX
print r4.a; r4.b
