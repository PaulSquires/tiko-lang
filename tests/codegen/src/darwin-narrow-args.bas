'' Narrow integer arguments and results -- see darwin-narrow-args-*.test.
extern "C"
declare sub c_take( byval a0 as any ptr, byval a1 as any ptr, byval a2 as any ptr, _
                    byval a3 as any ptr, byval a4 as any ptr, byval a5 as any ptr, _
                    byval a6 as any ptr, byval a7 as any ptr, byval b as boolean, _
                    byval k as ushort, byval c as byte, byval s as short, byval u as ubyte )
declare function c_ret( ) as ushort
end extern

function t_ret( byval x as longint ) as byte
    return cbyte( x )
end function

sub t_take( byval b as boolean, byval k as ushort, byval c as byte )
    c_take( 0, 0, 0, 0, 0, 0, 0, 0, b, k, c, -1, 200 )
end sub

dim fp as sub( byval b as boolean, byval k as ushort, byval c as byte ) = @t_take
fp( true, c_ret( ), t_ret( 509 ) )
