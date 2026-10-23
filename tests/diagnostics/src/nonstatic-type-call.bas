'' A NON-STATIC MEMBER CALLED THROUGH ITS TYPE -- fbc's error 214, "Member isn't static", on
'' lines 32 to 37 (fbc-modern 1.20). tiko called it on a zeroed temporary: the reported
'' 'print chrono.DateTime.ToLocaleDateString( chrono.lsLong )' segfaulted. Lines 39 to 43 are
'' accepted: a static member, the static overload of a mixed set, an object's call, and the
'' procedure addressed rather than called.
namespace N
    type T extends object
        as long v = 5
        declare function Get( byval k as long ) as long
        declare static function SGet( byval k as long ) as long
        declare static function Get2 overload ( byval k as long ) as long
        declare function Get2( byval k as string ) as long
    end type
    function T.Get( byval k as long ) as long
        return this.v + k
    end function
    function T.SGet( byval k as long ) as long
        return k
    end function
    function T.Get2( byval k as long ) as long
        return k
    end function
    function T.Get2( byval k as string ) as long
        return this.v
    end function
    type D extends T
        declare function Run( ) as long
    end type
end namespace

function N.D.Run( ) as long
    return T.Get( 1 )
end function
print N.T.Get( 1 )
dim as long q = N.T.Get( 2 )
print N.T.Get2( "a" )
N.T.Get( 3 )

print N.T.SGet( 1 )
print N.T.Get2( 1 )
dim as N.T x
print x.Get( 1 )
dim as any ptr p = procptr( N.T.Get )
