'' resolvesize.bas -- the ARRAY SIZE LIMIT.
''
'' Split out of resolve.bas at the 1500-line lint cap and included from it, inside its
'' own namespace. Nothing in it changed in the move.

'' AN ARRAY MUST FIT IN A SIGNED 32-BIT BYTE COUNT -- fbc error 50, 'Array too big'.
'' The limit is on TOTAL BYTES, not on the element count, and it is 2147483647
'' EXACTLY. Measured on three element widths, each side of the boundary:
''
''     byte  t(0 to &h7FFFFFFE)   2147483647 bytes   accepted
''     byte  t(0 to &h7FFFFFFF)   2147483648         error 50
''     long  t(0 to 536870910)    2147483644         accepted
''     long  t(0 to 536870911)    2147483648         error 50
''     short t(0 to 1073741822)   2147483646         accepted
''     short t(0 to 1073741823)   2147483648         error 50
''
'' -- and the dimensions MULTIPLY: 'byte t(0 to 5, 0 to 400000000)' is error 50 too.
''
'' COMPUTED IN 64 BITS, which is the whole point. TypeContext.Layout returns a LONG
'' and multiplies the element size by the count, so the size of an array this big
'' has already overflowed by the time anyone could look at it -- the check cannot be
'' written in terms of the answer it is trying to reject.
''
'' An element whose own size is not known yet measures 0 and passes. Resolve runs
'' three times and UDT layouts are computed between the second and the third, so a
'' UDT-element array is only judged on the pass that can judge it -- and 0 is the
'' safe answer, because missing a rejection leaves tiko-lang where it already was.
private sub ArrayTooBig_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval at as Tko.NodeId, _
      byval nm as Tko.InternId )

    if t = Tko.TYPE_NONE then return
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return
    if c.types->IsDynArray( t ) then return
    dim as Tko.TypeId et = c.types->Inner( t )
    if et = Tko.TYPE_NONE then return
    dim as longint esz = cast( longint, c.types->Layout( et ).size )
    if esz <= 0 then return
    '' THE COUNT IS RECOMPUTED FROM THE BOUNDS, in 64 bits, and not read off the
    '' type. TypeRecord.elems is a LONG, so 'byte t(0 to &h7FFFFFFF)' -- 2147483648
    '' elements -- has already overflowed to a negative there, and the two shapes
    '' furthest over the limit were the two this check could not see.
    dim as long dims = c.types->types[cast( long, t )].dims
    if dims < 1 then return
    dim as long bfirst = c.types->types[cast( long, t )].first
    if c.types->types[cast( long, t )].count < dims * 2 then return
    dim as longint n = 1
    for d as long = 0 to dims - 1
        dim as longint lo = c.types->boundPool[bfirst + d * 2]
        dim as longint hi = c.types->boundPool[bfirst + d * 2 + 1]
        if hi < lo then return
        n *= (hi - lo + 1)
        '' A product that has run away is already over the limit; stop before it
        '' can wrap even in 64 bits.
        if n > 2147483647 then exit for
    next
    if n <= 0 then return
    if (esz * n) <= 2147483647 then return
    c.diags->Report( Tko.TKO0613, Tko.PointRange( c.ast->Loc( at ) ), _
                     c.names->Spelling( nm ) )
end sub
