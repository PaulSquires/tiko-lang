'' A private default constructor and a factory: 'var a = T.Factory( 3 )' builds through the
'' public copy constructor. fbc-modern 1.20 compiles it and prints 3; tiko said TKO0633
'' (by-example BUG-objects-3).
type T
    n as long
    declare static function Factory( byval n as long ) as T
    declare constructor( byref o as const T )
    private:
    declare constructor( )
end type
constructor T( )
end constructor
constructor T( byref o as const T )
    n = o.n
end constructor
function T.Factory( byval n as long ) as T
    dim as T r
    r.n = n
    return r
end function
var a = T.Factory( 3 )
print a.n
