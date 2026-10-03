'' See ../ctor-arg-count-qualified.test.
namespace Geo
    type P
        as long v
        declare constructor( byval a as long )
    end type
    type R
        as long v
        declare constructor( byval a as long, byval b as long, byval c as long )
        declare constructor( byval a as long )
    end type
    namespace Inner
        type Q
            as long v
            declare constructor( byval a as long, byval b as long = 2 )
        end type
    end namespace
end namespace
constructor Geo.P( byval a as long ) : v = a : end constructor
constructor Geo.R( byval a as long, byval b as long, byval c as long ) : v = a + b + c : end constructor
constructor Geo.R( byval a as long ) : v = a : end constructor
constructor Geo.Inner.Q( byval a as long, byval b as long = 2 ) : v = a + b : end constructor
var a1 = Geo.P( 1, 2 )
dim a2 as Geo.P = Geo.P( 1, 2 )
var b1 = Geo.R( 1, 2 )
var c1 = Geo.Inner.Q( 1, 2, 3 )
var ok1 = Geo.P( 7 )
var ok2 = Geo.R( 1, 2, 3 )
var ok3 = Geo.Inner.Q( 4 )
print ok1.v; ok2.v; ok3.v
