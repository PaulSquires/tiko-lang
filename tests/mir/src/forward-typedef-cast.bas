'' A TYPE ARGUMENT NAMING A TYPEDEF DECLARED LATER resolves once the typedef does.
'' win/windef.bi writes 'type LPARAM as LONG_PTR' seventeen lines before it includes
'' basetsd.bi, which declares LONG_PTR. 'cast( LPARAM, p )' was resolved on the first
'' pass, cached untyped, and the call it was an argument of came out as nothing: a void
'' call, and 'ret void' from AfxNova's AfxSetWindowIcon, which clang refused.
''
'' fbc-modern prints, and tiko now prints too:
''
''     42 42 7 8 2
type LP as LPTR
type LR as LPTR
type HX as HX_ ptr
type HX_ as long
type LPTR as longint
function f( byval l as LP ) as LR
    return l + 1
end function
function g( byval p as any ptr ) as LR
    return f( cast( LP, p ) )
end function
function h( byval p as any ptr ) as HX
    return cast( HX, f( cast( LP, p ) ) )
end function
dim as any ptr q = cast( any ptr, 41 )
dim as LP t = type<LP>( 7 )
print g( q ); cint( h( q ) ); t; sizeof( LP ); f( cast( LP, 1 ) )
