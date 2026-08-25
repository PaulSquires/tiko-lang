'' A BITFIELD IS READ AND WRITTEN THROUGH ITS UNIT, addressed at the UNIT's start.
''
'' 'c : 4 as long' packs at bit 8, so its byte offset is 1 -- and reading it at the
'' DECLARED width from there is a four-byte access one byte PAST this four-byte type.
'' Measured: fbc addresses the unit and shifts, '*(int32*)&X$ >> 8 & 15' with the write
'' masked '& -3841ll', where tiko-lang addressed byte 1 and shifted by 0.
type BF
    a : 3 as ulong
    b : 5 as ulong
    c : 4 as long
    d : 1 as ubyte
end type
dim shared as BF x
sub f( )
    x.a = 5
    x.b = 17
    x.c = -3
    x.d = 1
    print x.a, x.b, x.c, x.d
    x.a += 1
    print x.a
end sub
f( )
