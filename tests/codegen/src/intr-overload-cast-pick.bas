'' Which cast LEFT, RIGHT and VAL call over a type with two: fbc resolves them as overload sets
'' over const string / const wstring (/ const ustring), so a 'byref as zstring' cast beats 'as
'' string' and a 'byref as wstring' one beats 'as zstring ptr' (Check.IntrStrOvlPick).
dim shared as zstring * 8 zb = "7z"
dim shared as wstring * 8 wb
wb = wstr( "8w" )
type SZ
    as long n
    declare operator cast( ) as string
    declare operator cast( ) byref as zstring
end type
operator SZ.cast( ) as string : return "1s" : end operator
operator SZ.cast( ) byref as zstring : return zb : end operator
type ZW
    as long n
    declare operator cast( ) byref as zstring
    declare operator cast( ) byref as wstring
end type
operator ZW.cast( ) byref as zstring : return zb : end operator
operator ZW.cast( ) byref as wstring : return wb : end operator
type WP
    as long n
    declare operator cast( ) byref as wstring
    declare operator cast( ) as zstring ptr
end type
operator WP.cast( ) byref as wstring : return wb : end operator
operator WP.cast( ) as zstring ptr : return @zb : end operator
type US
    as long n
    declare operator cast( ) as ustring
    declare operator cast( ) as string
end type
operator US.cast( ) as ustring : return "3u" : end operator
operator US.cast( ) as string : return "4s" : end operator
dim as SZ a
dim as ZW b
dim as WP p
dim as US q
print left( a, 1 ), right( a, 1 ), val( a )
print left( b, 1 ), right( b, 1 ), val( b )
print left( p, 1 ), val( p )
print val( q )
