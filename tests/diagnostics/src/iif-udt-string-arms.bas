'' WHAT fbc REFUSES BESIDE THE UDT ARM IT TAKES. A UDT that EXTENDS zstring or wstring
'' meets a character of that kind in 'iif' (tests/mir/iif-udt-extends-wstring); these two
'' are fbc error 24, measured, and say what the rule does NOT reach.
type P                                  '' casts to a wstring, extends nothing
    as wstring * 32 buf
    declare constructor( byref s as const wstring = "" )
    declare operator cast( ) byref as const wstring
end type
constructor P( byref s as const wstring = "" ) : buf = s : end constructor
operator P.cast( ) byref as const wstring : operator = buf : end operator

type W extends wstring                  '' extends WSTRING, met with a var-len STRING
    as wstring * 32 buf
    declare constructor( byref s as const wstring = "" )
end type
constructor W( byref s as const wstring = "" ) : buf = s : end constructor

dim as wstring * 32 wz = "abcdef"
dim as string s = "abcdef"
dim as long i = 2
dim as P a = iif( i > 3, P( "Z" ), mid( wz, i, 1 ) )  '' no string base
dim as W b = iif( i > 3, W( "Z" ), mid( s, i, 1 ) )   '' STRING is not WCHAR
