'' STR( ) AND WSTR( ) OVER A UDT WITH 'operator cast' TO A STRING, both directions.
''
'' The cast operator's MANGLED NAME drops the result's byref-ness and its top-level
'' const -- '_ZN1WcvwEv', not 'cvKw' -- which is what makes any of this link.
''
'' Measured against fbc, one type with each cast:
''
''     str( zv )    CONST ZSTRING    the identity, no conversion emitted
''     str( wv )    STRING           a real conversion: fb_WstrToStr
''     wstr( zv )   WSTRING * 1      fb_StrToWstr over the cast's char*
''     wstr( wv )   CONST WSTRING    the identity
''
'' -- so STR( ) of a WIDE cast is narrow whatever it was handed. Typing it wide sent
'' every narrow destination through the wide-to-narrow transfer path, which has no
'' wide source to offer, and both 'dim s as string = str( wv )' and 'print str( wv )'
'' declined while the assignment form beside them lowered.
type Z extends zstring
    _pad as byte
    declare operator cast( ) byref as const zstring
end type
type W extends wstring
    _pad as byte
    declare operator cast( ) byref as const wstring
end type
dim shared gz as zstring * 4
dim shared gw as wstring * 4
operator Z.cast( ) byref as const zstring
    operator = gz
end operator
operator W.cast( ) byref as const wstring
    operator = gw
end operator

dim zv as Z
dim wv as W

'' The narrow side: the cast's char* through fb_StrToWstr, into a temporary the
'' caller deletes.
dim a as wstring * 10 = wstr( zv )
dim b as string = str( zv )

'' The wide side.
dim d as string = str( wv )
dim e as zstring * 10 = str( wv )
print str( wv )
dim f as wstring * 10 = wstr( wv )
