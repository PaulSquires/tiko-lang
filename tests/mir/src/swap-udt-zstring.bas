'' 'swap str( u1 ), str( u2 )' OVER A UDT THAT CASTS TO A ZSTRING, which produced
'' nothing: a call has no address, so both operands answered nothing and the whole
'' statement declined. udt-zstring/swap.bas writes the shape twelve times.
''
'' Measured, and the lengths are the part that is not guessable:
''
''   vr$3 = _ZN1UcvcEv( &U2$0 );
''   vr$5 = _ZN1UcvcEv( &U1$0 );
''   fb_StrSwap( vr$5, 0ll, 0, vr$3, 0ll, 0 );
''
'' -- both sides through the operator, and LENGTH 0 for each where an addressable
'' 'zstring * 50' passes its own 50. Zero means "NUL-terminated, work it out", which is
'' the only thing a raw char* out of a cast can say.
''
'' 'str( u1 )' HAD TO BE UNWRAPPED FIRST. It is a CALL whose type is STRING, so asking
'' it for a user cast finds none -- the cast hangs off the UDT INSIDE it. fbc emits no
'' conversion for the shape at all: 'str' of a value that casts to zstring IS the cast.
''
'' This is the narrow twin of a wide case already here -- 'swap wstr( u1 ), wstr( u2 )'
'' over an 'operator cast( ) byref as wstring' -- and sits directly beside it.
type U extends zstring
    _data as zstring * 32
    declare constructor( byval s as const zstring const ptr )
    declare operator cast( ) byref as zstring
end type

constructor U( byval s as const zstring const ptr )
    *cast( zstring ptr, @_data ) = *s
end constructor

operator U.Cast( ) byref as zstring
    operator = *cast( zstring ptr, @_data )
end operator

dim u1 as U = "aaa"
dim u2 as U = "bbb"

swap str( u1 ), str( u2 )
print str( u1 ); str( u2 )

'' ...and the mixed spelling the same corpus file writes
swap str( u1 ), u2
print str( u1 ); str( u2 )
