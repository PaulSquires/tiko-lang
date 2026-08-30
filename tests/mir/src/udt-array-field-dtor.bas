'' A FIXED ARRAY OF STRINGS AS A UDT FIELD owns N descriptors, and NOTHING released
'' them. The generated destructor walked the field list, found a type that is neither a
'' string nor a dynamic array nor a UDT, and returned -- so every string in every element
'' leaked, in a destructor that verified and counted as lowered. Nothing declined and the
'' sweep said nothing; the runtime-call differential is what found it, as an
'' fb_ArrayDestructStr fbc emits and tiko-lang never did.
''
'' Measured: fbc builds a temporary descriptor over the field and hands it to
'' fb_ArrayDestructStr -- the same call it makes for a LOCAL fixed string array, which
'' tiko-lang already got right. The USTRING twin is fb_ArrayDestructUStr.
'' functions/bydesc.bas is one of these.
''
'' A 'zstring * N' element owns nothing and is left alone, exactly as a scalar field of
'' that type is.
type WithStrArray
    s( 0 to 9 ) as string
end type

type WithUStrArray
    u( 0 to 3 ) as ustring
end type

type WithFixedZ
    z( 0 to 3 ) as zstring * 8
end type

sub useStr( )
    dim a as WithStrArray
    a.s( 0 ) = "x"
end sub

sub useUStr( )
    dim b as WithUStrArray
    b.u( 0 ) = "y"
end sub

sub useZ( )
    dim d as WithFixedZ
    d.z( 0 ) = "z"
end sub

useStr
useUStr
useZ
