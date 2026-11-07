'' TRYCAST TO A TYPE POINTER FROM A CLASS POINTER, and FROM A CAST (docs/tiko-interfaces §5.5).
'' 'trycast( Dog ptr, a )' over a plain 'Animal ptr' -- an object with a vptr, no interface
'' in sight -- asks the object's RTTI (tkort_ObjTypeCast); it used to stop lowering with
'' TKO0994. 'trycast( IScalable, cast( IShape, t ) )' read t's first field as the object.
type Animal extends object
    as long legs = 4
end type
class Dog
    inherits Animal
    as string nm = "rex"
end class
type Cat extends Animal
end type
dim as Dog d
dim as Cat c
dim as Animal ptr a = @d
dim as Dog ptr dp = trycast( Dog ptr, a )
print cbool( dp <> 0 ); " "; dp->nm
a = @c
print cbool( trycast( Dog ptr, a ) = 0 )
a = 0
print cbool( trycast( Dog ptr, a ) = 0 )

interface IShape
    function Area( ) as double
end interface
interface IScalable
    sub Scale( byval k as double )
end interface
type Tri
    implements IShape
    as double b = 4, h = 3
    declare function Area( ) as double implements IShape.Area
end type
function Tri.Area( ) as double
    return b * h / 2
end function
type Sq
    implements IShape, IScalable
    as double s = 2
    declare function Area( ) as double implements IShape.Area
    declare sub Scale( byval k as double ) implements IScalable.Scale
end type
function Sq.Area( ) as double
    return s * s
end function
sub Sq.Scale( byval k as double )
    s *= k
end sub
dim as Tri t
dim as Sq q
print cbool( trycast( IScalable, cast( IShape, t ) ) = nullptr )
dim as IScalable sc = trycast( IScalable, cast( IShape, q ) )
sc.Scale( 3 )
print q.s
