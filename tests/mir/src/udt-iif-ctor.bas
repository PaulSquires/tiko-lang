type UW
    as wstring * 64 d
    declare constructor( )
    declare constructor( byval p as const wstring ptr )
    declare operator cast( ) byref as wstring
end type
constructor UW( )
end constructor
constructor UW( byval p as const wstring ptr )
    d = *p
end constructor
operator UW.cast( ) byref as wstring
    return d
end operator
sub S( byval expr as long )
    dim u2 as UW = wstr( "b" )
    dim a as UW = iif( expr, wstr( "a" ), u2 )
    dim b as UW = iif( expr, u2, wstr( "a" ) )
    dim r as wstring * 50 = a
    print r
end sub
S( 1 )
