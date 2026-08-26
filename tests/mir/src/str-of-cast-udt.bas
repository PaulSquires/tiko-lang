'' 'str( u )' OVER A UDT THAT CASTS TO A STRING is the CAST, and its type is the CAST'S
'' own: measured, '#print typeof( str( u ) )' over a type with 'operator cast( ) byref
'' as zstring' is ZSTRING, not STRING. fbc emits no conversion at all for the shape.
''
'' UNTYPED, IT WAS NOT MERELY THIS CALL THAT DECLINED. A concatenation is typed from its
'' LEFT TERM -- Check computes nothing for a '&' chain -- so 'str( u ) & ", "' had
'' nothing to classify and PRINT gave up on the whole item, while '", " & str( u )', the
'' same two terms the other way round, lowered. That asymmetry is what the corpus's
'' QT( ) macro walks into, and it is why the symptom looked like a PRINT bug.
''
'' The wide half is TYPED the same way -- 'wstr( u )' over this type is 'WSTRING * 1',
'' the length every argument it accepts gets -- but it is NOT LOWERED, and it declines
'' loudly rather than being approximated: converting a UDT whose cast yields a NARROW
'' string into a wide temporary is a route LowerWstrOf does not have, and inventing one
'' would put bytes where UTF-16 belongs. Typing it is still right on its own: the type
'' is what fbc reports, and the decline names the statement rather than the type.
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

#define QT(s) str("""" & str(s) & """")

dim x as U = "abc"

print str( x )
print str( x ) & ", "
print ", " & str( x )
print str( "q" & str( x ) )
print QT( x ) & ", " & QT( "abc" )
