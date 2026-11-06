'' Interfaces with a non-primary base (§8.4: IAmphibian to IWater loads the header word),
'' virtual implementers overridden further down (the thunk reaches Toad's), a UDT result
'' through a thunk (sret), an interface result, an array of references and a field.
type Vec
    as double x, y, z
end type
interface ILand
    function Walk( byval n as long ) as long
end interface
interface IWater
    function Swim( ) as string
    function Pos( ) as Vec
end interface
interface IAmphibian
    inherits ILand, IWater
    sub Croak( )
end interface
class Frog
    implements IAmphibian
    as long id
    declare virtual function Walk( byval n as long ) as long implements ILand.Walk
    declare function Swim( ) as string implements IWater.Swim
    declare virtual function Pos( ) as Vec implements IWater.Pos
    declare sub Croak( ) implements IAmphibian.Croak
end class
function Frog.Walk( byval n as long ) as long
    return n * 2 + id
end function
function Frog.Swim( ) as string
    return "frog swims"
end function
function Frog.Pos( ) as Vec
    dim as Vec v : v.x = 1 : v.y = 2 : v.z = id
    return v
end function
sub Frog.Croak( )
    print "croak"; id
end sub
class Toad
    inherits Frog
    declare function Walk( byval n as long ) as long override
    declare function Pos( ) as Vec override
end class
function Toad.Walk( byval n as long ) as long
    return n * 100
end function
function Toad.Pos( ) as Vec
    dim as Vec v : v.x = 9 : v.y = 9 : v.z = 9
    return v
end function
function Pick( byval f as Frog ptr ) as IAmphibian
    return f
end function
type Pond
    as IWater resident
end type
dim as Frog f : f.id = 5
dim as Toad t : t.id = 6
dim as IAmphibian am = Pick( @f )
am.Croak( )
print am.Walk( 3 ), am.Swim( )
dim as IWater w = am
print w.Swim( ), w.Pos( ).z
dim as ILand l = am
print l.Walk( 4 )
am = t
l = am
print l.Walk( 4 ), am.Pos( ).x
dim as IWater zoo( 0 to 1 )
zoo( 0 ) = @f : zoo( 1 ) = @t
for i as long = 0 to 1
    print zoo( i ).Pos( ).z
next
dim as Pond pd
pd.resident = am
print pd.resident.Swim( )
