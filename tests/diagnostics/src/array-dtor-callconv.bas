'' An array of a type whose destructor is stdcall or pascal -- fbc's 172 for a REDIM (175 for a DIM).
type S
    as integer i
    declare destructor stdcall( )
end type
destructor S stdcall( )
end destructor
type C
    as integer i
    declare destructor cdecl( )
end type
destructor C cdecl( )
end destructor
redim as S r1(0 to 0)                          '' 172
dim as S s0                                    '' fine: a scalar
dim as S s1                                    '' fine: a scalar
dim as C d2(0 to 1)                            '' fine: cdecl written
