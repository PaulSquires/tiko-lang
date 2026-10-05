'' A UDT CASTING ONLY TO NUMBERS IS NOT A 'string'. Measured on fbc-modern: lines 11, 12, 16 and
'' 18 are errors 24, 181, 58 and 58; the fixed 'wstring * 8' and 'zstring * 8' on 13-14 compile.
type M
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator M.cast( ) as long : return 4 : end operator
operator M.cast( ) as double : return 4.5 : end operator
dim as M mv
dim as string st = mv
st = mv
dim as wstring * 8 ws = mv
dim as zstring * 8 zs = mv
sub ts( byval s as string ) : end sub
ts( mv )
sub tr( byref s as string ) : end sub
tr( mv )
