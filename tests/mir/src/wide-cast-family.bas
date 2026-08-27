'' A UDT THAT CASTS TO A WSTRING IS A WIDE OPERAND, and three call-family gates asked the
'' wrong question about it: they tested the OPERAND'S TYPE for a wide string, and a UDT is
'' not one. So 'asc( u )', 'str( u )' and 'mid( u, 2 ) = w' all declined, while 'w = u'
'' and 'dim w as wstring * 10 = u' beside them lowered -- WideOperand_ has known about the
'' cast all along. TermIsWide_ is the predicate that matches it.
''
'' 'str( <wide> )' IS A CONVERSION, not the identity: it answers a NARROW descriptor.
'' Measured -- 'fb_WstrToStr( (uint16*)vr )' -- and the entry point sat in the runtime
'' table with NO CALLER AT ALL, so every wide 'str' declined whatever its operand was.
''
'' A 'string * N' IS NOT ITS OWN DATA POINTER. It is SPACE-PADDED and carries no
'' terminator, so handing its buffer to anything that walks to a NUL reads past it --
'' which is why fbc borrows a temporary DESCRIPTOR first, with the tagged length, and
'' takes the pointer out of that. Refusing it left 'w = f' unlowered in both directions.
type WideCast extends wstring
    as wstring * 12 buf
    declare operator cast( ) byref as const wstring
end type

operator WideCast.cast( ) byref as const wstring
    return this.buf
end operator

sub s1( )
    dim u as WideCast
    u.buf = "hello"

    '' 'print asc( u )' lowers now too: the gate was not the PRINT classifier at all but
    '' CHECK, which read the argument's BUILTIN type to decide what the intrinsic
    '' family accepts -- and a UDT has none, so the call came out UNTYPED and PRINT had
    '' nothing to print. A UDT that casts to a string is now that string for the whole
    '' family. 'dim as string s = str( u )' still declines: see the note in HANDOFF.
    ''
    '' ASC IS ULONG, so its result ZERO-extends into an integer. Measured:
    '' 'uint32 vr$2 = fb_WstrAsc( ... ); K$0 = (int64)vr$2'. It sign-extended here
    '' while the call was untyped, which is what the earlier golden recorded.
    dim as integer k1 = asc( u )
    dim as integer k2 = asc( u, 2 )
    print k1, k2

    dim as wstring * 10 w = "abc"
    dim as string s2 = str( w )
    print s2

    dim as wstring * 6 rep = "ZZ"
    mid( u, 2 ) = rep
    print u.buf

    dim as string * 10 f = "abc"
    print (w = f), (f = w)
end sub

s1( )
