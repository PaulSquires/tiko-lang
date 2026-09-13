'' A WIDE RVALUE FOR A 'byref as const wstring' CONSTRUCTOR PARAMETER IS ITS CHARACTER POINTER.
'' 'dim as DWS a = DWS( left( src, 1 ) )' had no address to pass, declined, and the constructor
'' never ran -- the object stayed empty. AfxNova's user Left builds its result exactly so.
''
'' fbc prints: ctor(wstring) / a=x / ctor(wstring) / b=xyz / ctor(wstring) / c=xy
type DWS
	as wstring * 32 buf
	declare constructor( byref s as string )
	declare constructor( byref w as const wstring )
end type
constructor DWS( byref s as string )
	print "ctor(string)"
	buf = s
end constructor
constructor DWS( byref w as const wstring )
	print "ctor(wstring)"
	buf = w
end constructor
dim as wstring * 32 src = "xyz"
dim as DWS a = DWS( left( src, 1 ) )
print "a="; a.buf
dim as DWS b = DWS( src )
print "b="; b.buf
function Mk( byref d as DWS ) as DWS
	return DWS( ..left( d.buf, 2 ) )
end function
dim as DWS c = Mk( b )
print "c="; c.buf
