'' ALIAS REPLACES THE IDENTIFIER AND KEEPS ITS CASE. The mangler knew that; what it did
'' not know is that the alias is usually written on the DECLARE alone -- fbc accepts
''
''     declare sub plain alias "myPlainName"( byval i as integer )
''     sub plain( byval i as integer )
''
'' and emits 'void myPlainName( int64 )'. Reading the DEFINITION's own node found no
'' alias and emitted PLAIN, so every procedure bound to a foreign symbol this way went
'' out under the wrong name and the link failed on a name nobody wrote.
''
'' Measured, all four against fbc:
''
''     myPlainName                  an alias on the declare, not mangled further
''     _Z10lower_caseu7INTEGER      OVERLOAD mangles AROUND the alias
''     fx_c                         a function is no different from a sub
''     _ZN1T12myMemberNameEv        a member mangles around it too
declare sub plain alias "myPlainName" ( byval i as integer )

sub plain( byval i as integer )
end sub

declare sub ovl overload alias "lower_case" ( byval i as integer )

sub ovl( byval i as integer )
end sub

declare function fx alias "fx_c" ( ) as integer

function fx( ) as integer
    return 1
end function

type T
    as long x_    '' a TYPE with no field is fbc's error 256 (TKO0876)
    declare sub m alias "myMemberName" ( )
end type

sub T.m( )
end sub

'' AN ALIASED PROPERTY TAKES THE ALIAS ALONE -- no '__get__' or '__set__'. The suffix is
'' what fbc uses when it has to invent a name; an alias IS the name. Measured over
'' structs/obj_property_alias.bas: fbc emits ONE symbol, '_ZN3UDT4getvEv', for the
'' method and the property that aliases it.
type UDT
    as integer p_v
    declare sub      setv alias "setv"( byval new_v as integer )
    declare property v    alias "setv"( byval new_v as integer )
    declare function getv alias "getv"( ) as integer
    declare property v    alias "getv"( ) as integer
end type

function UDT.getv( ) as integer
    function = p_v
end function

sub UDT.setv( byval new_v as integer )
    p_v = new_v
end sub
