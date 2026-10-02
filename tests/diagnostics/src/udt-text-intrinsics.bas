type V
    x as long
    declare operator cast( ) as ustring
end type
operator V.cast( ) as ustring
    return "(4)"
end operator
type S
    x as long
    declare operator cast( ) as string
end type
operator S.cast( ) as string
    return "12"
end operator
dim as V uv
dim as S sv
type W
    x as long
    declare operator cast( ) byref as wstring
    zz as wstring * 8
end type
operator W.cast( ) byref as wstring
    zz = "77"
    return zz
end operator
type N
    x as long
    declare operator cast( ) as double
end type
operator N.cast( ) as double
    return 2.5
end operator
dim as W wv
dim as N nv
print wstr( uv )
print val( uv )
print using "&"; uv
print wstr( sv )
print val( sv )
print using "&"; sv
print valint( uv )
print vallng( uv )
print wstr( wv )
print val( wv )
print using "&"; wv
print wstr( nv )
print val( nv )
print using "##.#"; nv
print using "&"; nv
