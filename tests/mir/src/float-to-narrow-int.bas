'' A float stored into a narrow integer, at a DIM and at an assignment.
sub narrow( byval s as single, byval d as double )
    dim as ulong    ul = s
    dim as ushort   uw = s
    dim as ubyte    ub = s
    dim as short    sw = s
    dim as byte     sb = s
    dim as long     sl = s
    dim as ulongint uq = d
    ul = d
    uw = d
    ub = d
    sw = d
    sb = d
    sl = d
    uq = s
end sub
narrow( 3e9, 3e9 )
