enum E
    e0
    e1
end enum

type UL
    as long v
    declare operator cast( ) as long
end type
operator UL.cast( ) as long : print "[lo]"; : return 7 : end operator

type UBB
    as long v
    declare operator cast( ) as byte
    declare operator cast( ) as boolean
end type
operator UBB.cast( ) as byte : print "[by]"; : return 3 : end operator
operator UBB.cast( ) as boolean : print "[bo]"; : return true : end operator

type UBE
    as long v
    declare operator cast( ) as boolean
    declare operator cast( ) as E
end type
operator UBE.cast( ) as boolean : print "[bo]"; : return true : end operator
operator UBE.cast( ) as E : print "[en]"; : return E.e1 : end operator

type UBI
    as long v
    declare operator cast( ) as byte
    declare operator cast( ) as integer
end type
operator UBI.cast( ) as byte : print "[by]"; : return 3 : end operator
operator UBI.cast( ) as integer : print "[in]"; : return 9 : end operator

'' an exact cast is no match in a set: the converting overload takes it
function a1 overload( byval x as long ) as long : print " a1-long"; : return x : end function
function a1 overload( byval x as double ) as long : print " a1-double"; : return x : end function
'' one procedure takes the exact cast, and fbc picks the exact one of two
sub s1( byval x as boolean ) : print " s1"; x : end sub
'' an enum cast meets only its enum; the boolean one reaches 'long', not the exact 'boolean'
function a2 overload( byval x as long ) as long : print " a2-long"; : return 5 : end function
function a2 overload( byval x as boolean ) as long : print " a2-boolean"; : return 0 : end function
'' the closer cast for the converting overload; no number reaches a pointer
function a3 overload( byval p as zstring ptr ) as long : print " a3-zptr"; : return 0 : end function
function a3 overload( byval x as long ) as long : print " a3-long"; : return x : end function
'' one procedure taking an enum takes a number through its cast
sub s2( byval x as E ) : print " s2"; x : end sub

dim as UL l
dim as UBB bb
dim as UBE be
dim as UBI bi
print a1( l )
s1( bb )
print a2( be )
print a3( bi )
s2( l )
